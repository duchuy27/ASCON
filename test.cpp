#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

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
//void ascon_finalize(uint64_t S[5], uint8_t *tag, const uint8_t *key);
void ascon_finalize(uint64_t *S, const uint8_t *key, uint8_t *tag);
void print_hex(const char *label, const uint8_t *data, size_t len);

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
    print_hex("associated data",ad,adlen);
    ascon_process_plaintext(S, ciphertext, plaintext, len);
    print_hex("ciphertext",ciphertext,len);
    //ascon_finalize(S, tag, key);
    ascon_finalize(S, key, tag);
    print_hex("tag",tag,16);
    
}

int ascon_decrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *ad, size_t adlen, const uint8_t *ciphertext, size_t len, const uint8_t *tag, uint8_t *plaintext) {
    uint64_t S[5] = {0};
    uint8_t check_tag[16];

    ascon_initialize(S, key, nonce);
    ascon_process_associated_data(S, ad, adlen);
    ascon_process_ciphertext(S, plaintext, ciphertext, len);
    print_hex("plaintext_receive",plaintext,16);
   // ascon_finalize(S, check_tag, key);
    ascon_finalize(S, key, check_tag);
    print_hex("tag",check_tag,16);
    return memcmp(tag, check_tag, 16) == 0;
    
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

void ascon_process_associated_data(uint64_t *S, int b, int rate, const uint8_t *associateddata, size_t ad_len) {
    if (ad_len > 0) {
        // == padding == //
        size_t ad_lastlen = ad_len % rate;  // length of last block in the raw associated data (before padding)
        size_t ad_zero_bytes = rate - (ad_lastlen % rate) - 1;  // calculate how many zero bytes needed for padding

        uint8_t *ad_padding = (uint8_t*)malloc(ad_zero_bytes + 1);
        ad_padding[0] = 0x80;  // padding starts with 0x80
        memset(ad_padding + 1, 0x00, ad_zero_bytes);  // followed by zeros

        size_t ad_padded_len = ad_len + ad_zero_bytes + 1;
        uint8_t *ad_padded = (uint8_t*)malloc(ad_padded_len);
        memcpy(ad_padded, associateddata, ad_len);
        memcpy(ad_padded + ad_len, ad_padding, ad_zero_bytes + 1);
        free(ad_padding);

        // == absorption of associated data == //
        // XOR padded associated data with the rate, then permute
        for (size_t block = 0; block < ad_padded_len; block += rate) {
            uint64_t ad_block = 0;
            memcpy(&ad_block, ad_padded + block, 8);  // assuming rate is 8 bytes
            S[0] ^= ad_block;
            ascon_permutation(S, b);
        }

        free(ad_padded);
    }

    // state is XORed with 1 for domain separation --> S ^ (0**319 || 1)
    // we only need to XOR 1 with the last row because the first 4 rows will remain unchanged
    S[4] ^= 1;
}
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

    S[0] ^= c;

    uint64_t p = S[0];
    for (size_t i = 0; i < last_block_len; ++i) {
        plaintext[blocks * RATE + i] = (p >> (56 - i * 8)) & 0xFF;
    }
}

void ascon_finalize(uint64_t *S, const uint8_t *key, uint8_t *tag) {
    assert(key != NULL);
    assert(tag != NULL);

    uint64_t key_part1 = 0;
    uint64_t key_part2 = 0;

    memcpy(&key_part1, key, 8);
    memcpy(&key_part2, key + 8, 8);
    
    S[1] ^= key_part1;
    S[2] ^= key_part2;

    ascon_permutation(S, A);

    S[3] ^= key_part1;
    S[4] ^= key_part2;

    memcpy(tag, &S[3], 8);
    memcpy(tag + 8, &S[4], 8);
}
// void ascon_finalize(uint64_t *S, const uint8_t *key, uint8_t *tag) {
//     // uint64_t num1 = 0;
//     // uint64_t num2 = 0;
//     // // Xử lý 8 byte đầu tiên của key
//     // for (int i = 0; i < 8; i++) {
//     //     num1 = (num1 << 8) | key[i];
//     // }
//     // S[1] ^= num1;

//     // // Xử lý các byte từ 8 đến 15 của key
//     // for (int i = 8; i < 16; i++) {
//     //     num2 = (num2 << 8) | key[i];
//     // }
//     // S[2] ^= num2;
//     unsigned long key_part1 = 0 , key_part2 = 0;
//     memcpy(&key_part1, key, 8);
//     memcpy(&key_part2, key + 8, 8);

//     S[1] ^= key_part1;
//     S[2] ^= key_part2;
//     ascon_permutation(S, A);

//     // for (int i = 0; i < 8; i++) {
//     //     num1 = (num1 << 8) | key[i];
//     // }
//     // S[3] ^= num1;
//     // for (int i = 0; i < 8; i++) {
//     //     num2 = (num2 << 8) | key[i];
//     // }
//     // S[4] ^= num2;
//     memcpy(&key_part1, key, 8);
//     memcpy(&key_part2, key + 8, 8);
//     S[3] ^= key_part1;
//     S[4] ^= key_part2;
//     memcpy(tag, &S[3], 8);
//     memcpy(tag + 8, &S[4], 8);
// }
// void ascon_finalize(uint64_t S[5], uint8_t *tag, const uint8_t *key) {
//     uint8_t key_block[40] = {0};
//     memcpy(key_block + 24, key, 16);
//     uint64_t key_state[5];
//     bytes_to_state(key_state, key_block);

//     for (int i = 0; i < 5; ++i) {
//         S[i] ^= key_state[i];
//     }

//     ascon_permutation(S, A);

//     for (int i = 0; i < 5; ++i) {
//         S[i] ^= key_state[i];
//     }

//     for (int i = 0; i < 16; ++i) {
//         tag[i] = (S[i / 8] >> (56 - 8 * (i % 8))) & 0xFF;
//     }
// }
int main() {
    uint8_t key[16] = {0xea, 0xa9, 0x11, 0x9a, 0xa3, 0xa9, 0xbd, 0x5e, 0x50, 0xbc, 0xcd, 0xa4, 0xe1, 0x3d, 0x1c, 0x03};
    uint8_t nonce[16] = {0x1a, 0x65, 0x27, 0xa3, 0x66, 0x45, 0xdd, 0xb9, 0x49, 0x06, 0x71, 0xdc, 0x5d, 0x1e, 0x1e, 0xbb};
    uint8_t associateddata[] = "just having fun";
    uint8_t plaintext[] = "ASCON";
    uint8_t ciphertext[sizeof(plaintext) + 16];
    uint8_t tag[16];

    print_hex("key",key,16);
    print_hex("nonce", nonce, 16);
    print_hex("plaintext", plaintext, 5);

    ascon_encrypt(key, nonce, associateddata, sizeof(associateddata) - 1, plaintext, sizeof(plaintext) - 1, ciphertext, tag);

    uint8_t decrypted[sizeof(plaintext) - 1];
    int result = ascon_decrypt(key, nonce, associateddata, sizeof(associateddata) - 1, ciphertext, sizeof(plaintext) - 1, tag, decrypted);
    if (result == 0) {
        printf("Decryption successful\n");
    } else {
        printf("Decryption failed\n");
    }

    return 0;
}
