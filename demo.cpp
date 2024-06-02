#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#define KEY_LEN 16U             // Length of key is 128 bits (16 bytes)
#define NONCE_LEN 16U           // Length of nonce is 128 bits (16 bytes)
#define IV_LEN 8U               // Length of IV is 320-128*2 = 64 bits (8 bytes)
#define S_LEN 40U               // Length of State is 320 bits (40 bytes)
#define REG_SIZE 8U             // Size of Register is 64 bits (8 bytes) (320/5 = 64 bits)
#define TAG_LEN 16U             // Length of TAG is 128 bits (16 bytes)

// Thông số sủa Ascon-128

#define RATE 8
#define A 12
#define B 6

void bytes_to_state(uint64_t S[5], const uint8_t *bytes);
void ascon_permutation(uint64_t S[5], int rounds);
uint64_t rotr(uint64_t val, int r);
void ascon_initialize(uint64_t S[5], const uint8_t *key, const uint8_t *nonce);
void ascon_process_associated_data(uint64_t S[5], const uint8_t *ad, size_t adlen);
void ascon_process_plaintext(uint64_t S[5], uint8_t *ciphertext, const uint8_t *plaintext, size_t len);
void ascon_process_ciphertext(uint64_t S[5], uint8_t *plaintext, const uint8_t *ciphertext, size_t len);
void ascon_finalize(uint64_t *S, const uint8_t *key, uint8_t *tag);
void print_hex(const char *label, const uint8_t *data, size_t len);

void print_hex_64(const char *label, const uint64_t *data, int len){
    printf("%s: ", label);
    for (int i = 0; i < 5; i++) {
        printf("%016llx\t", (unsigned long long)*(data+i));
    }
    printf("\n");
}

uint64_t bytes_to_uint64(const uint8_t *bytes) {
    uint64_t value = 0;
    for (int i = 0; i < 8; i++) {
        value <<= 8;
        value |= bytes[i];
    }
    return value;
}

// Helper function to convert a uint64_t to a byte array
void uint64_to_bytes(uint64_t value, uint8_t *bytes) {
    for (int i = 7; i >= 0; i--) {
        bytes[i] = (uint8_t)(value & 0xFF);
        value >>= 8;
    }
}


void print_hex(const char *label, const uint8_t *data, size_t len) {
    printf("%s:", label);
    for (size_t i = 0; i < len; i++) {
        printf(" %02x", data[i]);
    }
    printf(" (%d bytes)\n", len);
}

void ascon_encrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *ad, size_t adlen, const uint8_t *plaintext, size_t len, uint8_t *ciphertext, uint8_t *tag) {
    uint64_t S[5] = {0};

    ascon_initialize(S, key, nonce);
    ascon_process_associated_data(S, ad, adlen);
    ascon_process_plaintext(S, ciphertext, plaintext, len);
    print_hex("ciphertext",ciphertext,len);
    ascon_finalize(S, key, tag);
}

int ascon_decrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *ad, size_t adlen, const uint8_t *ciphertext, size_t len, const uint8_t *tag, uint8_t *plaintext) {
    uint64_t S[5] = {0};
    uint8_t check_tag[16];
    ascon_initialize(S, key, nonce);
    ascon_process_associated_data(S, ad, adlen);
    
    ascon_process_ciphertext(S, plaintext, ciphertext, len);
    
    print_hex("plaintext_receive",plaintext,len);
    ascon_finalize(S, key, check_tag);
    print_hex("check_tag",check_tag,16);
    print_hex("tag",tag,16);
    if(memcmp(tag, check_tag, 16) == 0)
    {
        return 0;
    }
    else
    {
        return -1;
        
    }

}

void bytes_to_state(uint64_t S[5], const uint8_t *bytes) {
    for (int i = 0; i < 5; ++i) {
        S[i] = 0;
        for (int j = 0; j < 8; ++j) {
            S[i] |= ((uint64_t)bytes[i * 8 + j]) << (56 - j * 8);
        }
    }
}

void ascon_permutation(uint64_t S[5], int rounds) {
    static const uint8_t constants[12] = {
        0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87, 0x78, 0x69, 0x5a, 0x4b
    };

    for (int r = 12 - rounds; r < 12; ++r) {
        S[2] ^= constants[r];

        // Substitution layer
        S[0] ^= S[4];
        S[4] ^= S[3];
        S[2] ^= S[1];
        uint64_t T[5];
        for (int i = 0; i < 5; ++i) {
            T[i] = S[i] ^ (~S[(i + 1) % 5] & S[(i + 2) % 5]);
        }
        for (int i = 0; i < 5; ++i) {
            S[i] = T[i];
        }
        S[1] ^= S[0];
        S[0] ^= S[4];
        S[3] ^= S[2];
        S[2] = ~S[2];

        // Linear diffusion layer
        S[0] ^= rotr(S[0], 19) ^ rotr(S[0], 28);
        S[1] ^= rotr(S[1], 61) ^ rotr(S[1], 39);
        S[2] ^= rotr(S[2], 1) ^ rotr(S[2], 6);
        S[3] ^= rotr(S[3], 10) ^ rotr(S[3], 17);
        S[4] ^= rotr(S[4], 7) ^ rotr(S[4], 41);
    }
}

uint64_t rotr(uint64_t val, int r) {
    return (val >> r) | (val << (64 - r));
}

uint64_t reverse_bytes(uint64_t val) {
    val = ((val & 0x00000000000000FFULL) << 56) |
          ((val & 0x000000000000FF00ULL) << 40) |
          ((val & 0x0000000000FF0000ULL) << 24) |
          ((val & 0x00000000FF000000ULL) << 8)  |
          ((val & 0x000000FF00000000ULL) >> 8)  |
          ((val & 0x0000FF0000000000ULL) >> 24) |
          ((val & 0x00FF000000000000ULL) >> 40) |
          ((val & 0xFF00000000000000ULL) >> 56);
    return val;
}

void ascon_initialize(uint64_t S[5], const uint8_t *key, const uint8_t *nonce) {
    static const uint8_t iv[8] = {0x80, 0x40, 0x0c, 0x06, 0x00, 0x00, 0x00, 0x00};

    uint8_t state[40];
    memcpy(state, iv, 8);
    memcpy(state + 8, key, 16);
    memcpy(state + 24, nonce, 16);

    bytes_to_state(S, state);
    
    ascon_permutation(S, A);

    uint8_t zero_key[40] = {0};
    memcpy(zero_key + 24, key, 16);
    uint64_t zero_key_state[5];
    bytes_to_state(zero_key_state, zero_key);

    for (int i = 0; i < 5; ++i) {
        S[i] ^= zero_key_state[i];
    }
}

// void ascon_process_associated_data(uint64_t *S, int b, int rate, const uint8_t *associateddata, size_t ad_len) {
//     if (ad_len > 0) {
//         // == padding == //
//         size_t ad_lastlen = ad_len % rate;  // length of last block in the raw associated data (before padding)
//         size_t ad_zero_bytes = rate - (ad_lastlen % rate) - 1;  // calculate how many zero bytes needed for padding

//         uint8_t *ad_padding = (uint8_t*)malloc(ad_zero_bytes + 1);
//         ad_padding[0] = 0x80;  // padding starts with 0x80
//         memset(ad_padding + 1, 0x00, ad_zero_bytes);  // followed by zeros

//         size_t ad_padded_len = ad_len + ad_zero_bytes + 1;
//         uint8_t *ad_padded = (uint8_t*)malloc(ad_padded_len);
//         memcpy(ad_padded, associateddata, ad_len);
//         memcpy(ad_padded + ad_len, ad_padding, ad_zero_bytes + 1);
//         free(ad_padding);

//         // == absorption of associated data == //
//         // XOR padded associated data with the rate, then permute
//         for (size_t block = 0; block < ad_padded_len; block += rate) {
//             uint64_t ad_block = 0;
//             memcpy(&ad_block, ad_padded + block, 8);  // assuming rate is 8 bytes
//             S[0] ^= ad_block;
//             ascon_permutation(S, b);
//         }

//         free(ad_padded);
//     }

//     // state is XORed with 1 for domain separation --> S ^ (0**319 || 1)
//     // we only need to XOR 1 with the last row because the first 4 rows will remain unchanged
//     S[4] ^= 1;
// }
void ascon_process_associated_data(uint64_t S[5], const uint8_t *ad, size_t adlen) {
    if (adlen > 0) {
        size_t blocks = adlen / RATE;
        size_t last_block_len = adlen % RATE;

        for (size_t i = 0; i < blocks; ++i) {
            S[0] ^= ((uint64_t)ad[i * RATE] << 56) |
                    ((uint64_t)ad[i * RATE + 1] << 48) |
                    ((uint64_t)ad[i * RATE + 2] << 40) |
                    ((uint64_t)ad[i * RATE + 3] << 32) |
                    ((uint64_t)ad[i * RATE + 4] << 24) |
                    ((uint64_t)ad[i * RATE + 5] << 16) |
                    ((uint64_t)ad[i * RATE + 6] << 8) |
                    (uint64_t)ad[i * RATE + 7];
            ascon_permutation(S, B);
        }

        uint8_t last_block[8] = {0};
        memcpy(last_block, ad + blocks * RATE, last_block_len);
        last_block[last_block_len] = 0x80;

        S[0] ^= ((uint64_t)last_block[0] << 56) |
                ((uint64_t)last_block[1] << 48) |
                ((uint64_t)last_block[2] << 40) |
                ((uint64_t)last_block[3] << 32) |
                ((uint64_t)last_block[4] << 24) |
                ((uint64_t)last_block[5] << 16) |
                ((uint64_t)last_block[6] << 8) |
                (uint64_t)last_block[7];

        ascon_permutation(S, B);
    }
    S[4] ^= 1;
}

void ascon_process_plaintext(uint64_t S[5], uint8_t *ciphertext, const uint8_t *plaintext, size_t len) {
    size_t blocks = len / RATE;
    size_t last_block_len = len % RATE;

    for (size_t i = 0; i < blocks; ++i) {
        S[0] ^= ((uint64_t)plaintext[i * RATE] << 56) |
                ((uint64_t)plaintext[i * RATE + 1] << 48) |
                ((uint64_t)plaintext[i * RATE + 2] << 40) |
                ((uint64_t)plaintext[i * RATE + 3] << 32) |
                ((uint64_t)plaintext[i * RATE + 4] << 24) |
                ((uint64_t)plaintext[i * RATE + 5] << 16) |
                ((uint64_t)plaintext[i * RATE + 6] << 8) |
                (uint64_t)plaintext[i * RATE + 7];

        uint64_t c = S[0];
        ciphertext[i * RATE] = (c >> 56) & 0xFF;
        ciphertext[i * RATE + 1] = (c >> 48) & 0xFF;
        ciphertext[i * RATE + 2] = (c >> 40) & 0xFF;
        ciphertext[i * RATE + 3] = (c >> 32) & 0xFF;
        ciphertext[i * RATE + 4] = (c >> 24) & 0xFF;
        ciphertext[i * RATE + 5] = (c >> 16) & 0xFF;
        ciphertext[i * RATE + 6] = (c >> 8) & 0xFF;
        ciphertext[i * RATE + 7] = c & 0xFF;

        ascon_permutation(S, B);
    }

    uint8_t last_block[8] = {0};
    memcpy(last_block, plaintext + blocks * RATE, last_block_len);
    last_block[last_block_len] = 0x80;

    S[0] ^= ((uint64_t)last_block[0] << 56) |
            ((uint64_t)last_block[1] << 48) |
            ((uint64_t)last_block[2] << 40) |
            ((uint64_t)last_block[3] << 32) |
            ((uint64_t)last_block[4] << 24) |
            ((uint64_t)last_block[5] << 16) |
            ((uint64_t)last_block[6] << 8) |
            (uint64_t)last_block[7];

    uint64_t c = S[0];
    for (size_t i = 0; i < last_block_len; ++i) {
        ciphertext[blocks * RATE + i] = (c >> (56 - i * 8)) & 0xFF;
    }
}

void ascon_process_ciphertext(uint64_t S[5], uint8_t *plaintext, const uint8_t *ciphertext, size_t len) {
    size_t blocks = len / RATE;
    size_t last_block_len = len % RATE;

    for (size_t i = 0; i < blocks; ++i) {
        uint64_t c = ((uint64_t)ciphertext[i * RATE] << 56) |
                     ((uint64_t)ciphertext[i * RATE + 1] << 48) |
                     ((uint64_t)ciphertext[i * RATE + 2] << 40) |
                     ((uint64_t)ciphertext[i * RATE + 3] << 32) |
                     ((uint64_t)ciphertext[i * RATE + 4] << 24) |
                     ((uint64_t)ciphertext[i * RATE + 5] << 16) |
                     ((uint64_t)ciphertext[i * RATE + 6] << 8) |
                     (uint64_t)ciphertext[i * RATE + 7];

        S[0] ^= c;

        uint64_t p = S[0];
        plaintext[i * RATE] = (p >> 56) & 0xFF;
        plaintext[i * RATE + 1] = (p >> 48) & 0xFF;
        plaintext[i * RATE + 2] = (p >> 40) & 0xFF;
        plaintext[i * RATE + 3] = (p >> 32) & 0xFF;
        plaintext[i * RATE + 4] = (p >> 24) & 0xFF;
        plaintext[i * RATE + 5] = (p >> 16) & 0xFF;
        plaintext[i * RATE + 6] = (p >> 8) & 0xFF;
        plaintext[i * RATE + 7] = p & 0xFF;

        S[0] = c;

        ascon_permutation(S, B);
    }
    
    uint8_t last_block[8] = {0};
    memcpy(last_block, ciphertext + blocks * RATE, last_block_len);

    uint64_t c = ((uint64_t)last_block[0] << 56) |
                 ((uint64_t)last_block[1] << 48) |
                 ((uint64_t)last_block[2] << 40) |
                 ((uint64_t)last_block[3] << 32) |
                 ((uint64_t)last_block[4] << 24) |
                 ((uint64_t)last_block[5] << 16) |
                 ((uint64_t)last_block[6] << 8) |
                 (uint64_t)last_block[7];
    
    uint64_t p;
    p = S[0] ^ c;

    for (size_t i = 0; i < last_block_len; ++i) {
        plaintext[blocks * RATE + i] = (p >> (56 - i * 8)) & 0xFF;
    }

    uint8_t Pt_padded[RATE];
    memset(Pt_padded, 0x00, RATE);
    memcpy(Pt_padded, plaintext + (len - last_block_len), last_block_len);
    Pt_padded[last_block_len] = 0x80;

    uint64_t pt = ((uint64_t)Pt_padded[0] << 56) |
                 ((uint64_t)Pt_padded[1] << 48) |
                 ((uint64_t)Pt_padded[2] << 40) |
                 ((uint64_t)Pt_padded[3] << 32) |
                 ((uint64_t)Pt_padded[4] << 24) |
                 ((uint64_t)Pt_padded[5] << 16) |
                 ((uint64_t)Pt_padded[6] << 8) |
                 (uint64_t)Pt_padded[7];
        
    S[0] ^= pt;
}
void ascon_finalize(uint64_t *S, const uint8_t *key, uint8_t *tag) {
    // Ensure the key length is 16 bytes
    assert(key != NULL);

    // Step 1: XOR the key with the state (only the 2nd and 3rd rows)
    uint64_t k1, k2;
    k1 = ((uint64_t)key[0] << 56) | ((uint64_t)key[1] << 48) | ((uint64_t)key[2] << 40) | ((uint64_t)key[3] << 32) |
         ((uint64_t)key[4] << 24) | ((uint64_t)key[5] << 16) | ((uint64_t)key[6] << 8) | ((uint64_t)key[7]);
    k2 = ((uint64_t)key[8] << 56) | ((uint64_t)key[9] << 48) | ((uint64_t)key[10] << 40) | ((uint64_t)key[11] << 32) |
         ((uint64_t)key[12] << 24) | ((uint64_t)key[13] << 16) | ((uint64_t)key[14] << 8) | ((uint64_t)key[15]);

    S[1] ^= k1;
    S[2] ^= k2;

    // Apply the permutation function
    ascon_permutation(S, A);

    // Step 2: XOR the key with the 4th and 5th rows and produce the tag
    S[3] ^= k1;
    S[4] ^= k2;

    // Convert the result to bytes and store in the tag
    for (int i = 0; i < 8; i++) {
        tag[i] = (S[3] >> (56 - 8 * i)) & 0xFF;
        tag[i + 8] = (S[4] >> (56 - 8 * i)) & 0xFF;
    }
}
int main() {
    uint8_t key[16] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6};
    uint8_t nonce[16] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6};
    uint8_t associateddata[] = "ASCON123456789123456789";
    uint8_t plaintext[] = "Hello, Huy";
    uint8_t ciphertext[sizeof(plaintext) + 16];
    uint8_t tag[16];

    print_hex("key",key,16);
    print_hex("nonce", nonce, 16);
    print_hex("plaintext", plaintext, sizeof(plaintext));

    ascon_encrypt(key, nonce, associateddata, sizeof(associateddata), plaintext, sizeof(plaintext), ciphertext, tag);    
    uint8_t decrypted[sizeof(plaintext)];
    int result = ascon_decrypt(key, nonce, associateddata, sizeof(associateddata), ciphertext, sizeof(plaintext), tag, decrypted);
    if (result == 0) {
        printf("Decryption successful\n");
    } else {
        printf("Decryption failed\n");
    }
     
    return 0;
}
