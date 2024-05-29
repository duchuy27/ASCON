#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

#define RATE 8

void bytes_to_state(const uint8_t *bytes, uint64_t *S);
void print_HEX(uint8_t vari[], int len);
void ascon_permutation(uint64_t *S, int rounds);
uint64_t rotr(uint64_t val, int r);
void ascon_initialize(uint64_t *S, int a, const uint8_t *key, const uint8_t *nonce);
void ascon_process_associated_data(uint64_t *S, int b, int rate, const uint8_t *associateddata, int adlen);
void ascon_process_plaintext(uint64_t *S, int b, int rate, const uint8_t *plaintext, int ptlen, uint8_t *ciphertext);
void ascon_process_ciphertext(uint64_t *S, int b, int rate, const uint8_t *ciphertext, int ctlen, uint8_t *plaintext);
void ascon_finalize(uint64_t *S, int a, const uint8_t *key, uint8_t *tag);
void get_random_bytes(uint8_t *buffer, int num);

void ascon_encrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *associateddata, int adlen, const uint8_t *plaintext, int ptlen, uint8_t *ciphertext);
int ascon_decrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *associateddata, int adlen, const uint8_t *ciphertext, int ctlen, uint8_t *plaintext);

void demo_aead();

int main() {
    demo_aead();
    return 0;
}
//Hàm chuyển đổi mảng byte thành trạng thái 5 phần tử
void bytes_to_state(const uint8_t *bytes, uint64_t *S) {
    for (int i = 0; i < 5; ++i) {
        S[i] = 0;
        for (int j = 0; j < 8; ++j) {
            S[i] = (S[i] << 8) | bytes[i * 8 + j];
        }
    }
}

void print_HEX(uint8_t vari[], int len){
    for (int i = 0; i < len; i++) {
        if(i%8 == 0){
            printf("\t");
        }
        printf("%02x", vari[i]); // In ra mỗi byte của IV dưới dạng HEX
    }
    printf("\n");
}

uint64_t rotr(uint64_t val, int r) {
    return (val >> r) | (val << (64 - r));
}

void ascon_permutation(uint64_t *S, int rounds) {
    static const uint8_t round_constants[12] = {
        0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87, 0x78, 0x69, 0x5a, 0x4b
    };

    for (int r = 12 - rounds; r < 12; ++r) {
        S[2] ^= round_constants[r];

        uint64_t T[5];
        S[0] ^= S[4];
        S[4] ^= S[3];
        S[2] ^= S[1];

        for (int i = 0; i < 5; ++i) {
            T[i] = (~S[i]) & S[(i + 1) % 5];
        }
        for (int i = 0; i < 5; ++i) {
            S[i] ^= T[(i + 1) % 5];
        }
        S[1] ^= S[0];
        S[0] ^= S[4];
        S[3] ^= S[2];
        S[2] ^= ~0ULL;

        S[0] ^= rotr(S[0], 19) ^ rotr(S[0], 28);
        S[1] ^= rotr(S[1], 61) ^ rotr(S[1], 39);
        S[2] ^= rotr(S[2], 1) ^ rotr(S[2], 6);
        S[3] ^= rotr(S[3], 10) ^ rotr(S[3], 17);
        S[4] ^= rotr(S[4], 7) ^ rotr(S[4], 41);
    }
}

void ascon_initialize(uint64_t *S, int a, const uint8_t *key, const uint8_t *nonce) {
    static const uint8_t iv[8] = {0x80, 0x40, 0x0C, 0x06, 0x00, 0x00, 0x00, 0x00};

    uint8_t initial_state[40];
    memcpy(initial_state, iv, 8);
    memcpy(initial_state + 8, key, 16);
    memcpy(initial_state + 24, nonce, 16);

    bytes_to_state(initial_state, S);

    ascon_permutation(S, a);

    uint64_t zero_key[5] = {0};
    bytes_to_state((uint8_t *)zero_key, zero_key);
    for (int i = 0; i < 2; ++i) {
        zero_key[i + 1] = 0;
    }
    memcpy((uint8_t *)(zero_key + 1) + 24, key, 16);

    for (int i = 0; i < 5; ++i) {
        S[i] ^= zero_key[i];
    }
}

void ascon_process_associated_data(uint64_t *S, int b, int rate, const uint8_t *associateddata, int adlen) {
    if (adlen > 0) {
        int ad_lastlen = adlen % rate;
        int ad_zero_bytes = rate - ad_lastlen - 1;
        uint8_t ad_padding[rate];
        ad_padding[0] = 0x80;
        memset(ad_padding + 1, 0, ad_zero_bytes);

        uint8_t ad_padded[adlen + rate];
        memcpy(ad_padded, associateddata, adlen);
        memcpy(ad_padded + adlen, ad_padding, ad_zero_bytes + 1);

        for (int block = 0; block < adlen + ad_zero_bytes + 1; block += rate) {
            uint64_t ad_block = 0;
            for (int j = 0; j < 8; ++j) {
                ad_block = (ad_block << 8) | ad_padded[block + j];
            }
            S[0] ^= ad_block;
            ascon_permutation(S, b);
        }
    }
    S[4] ^= 1;
}

void ascon_process_plaintext(uint64_t *S, int b, int rate, const uint8_t *plaintext, int ptlen, uint8_t *ciphertext) {
    int p_lastlen = ptlen % rate;
    int p_zero_bytes = rate - p_lastlen - 1;
    uint8_t p_padding[rate];
    p_padding[0] = 0x80;
    memset(p_padding + 1, 0, p_zero_bytes);

    uint8_t p_padded[ptlen + rate];
    memcpy(p_padded, plaintext, ptlen);
    memcpy(p_padded + ptlen, p_padding, p_zero_bytes + 1);

    for (int block = 0; block < ptlen; block += rate) {
        uint64_t pt_block = 0;
        for (int j = 0; j < 8; ++j) {
            pt_block = (pt_block << 8) | p_padded[block + j];
        }
        S[0] ^= pt_block;
        for (int j = 0; j < 8; ++j) {
            ciphertext[block + j] = (S[0] >> (56 - 8 * j)) & 0xFF;
        }
        ascon_permutation(S, b);
    }
    uint64_t last_block = 0;
    for (int j = 0; j < 8; ++j) {
        last_block = (last_block << 8) | p_padded[ptlen + j];
    }
    S[0] ^= last_block;
    for (int j = 0; j < p_lastlen; ++j) {
        ciphertext[ptlen + j] = (S[0] >> (56 - 8 * j)) & 0xFF;
    }
}

void ascon_process_ciphertext(uint64_t *S, int b, int rate, const uint8_t *ciphertext, int ctlen, uint8_t *plaintext) {
    int c_lastlen = ctlen % rate;
    int c_zero_bytes = rate - c_lastlen - 1;
    uint8_t c_padding[rate];
    c_padding[0] = 0x80;
    memset(c_padding + 1, 0, c_zero_bytes);

    uint8_t c_padded[ctlen + rate];
    memcpy(c_padded, ciphertext, ctlen);
    memcpy(c_padded + ctlen, c_padding, c_zero_bytes + 1);

    for (int block = 0; block < ctlen; block += rate) {
        uint64_t ct_block = 0;
        for (int j = 0; j < 8; ++j) {
            ct_block = (ct_block << 8) | c_padded[block + j];
        }
        uint64_t pt_block = S[0] ^ ct_block;
        for (int j = 0; j < 8; ++j) {
            plaintext[block + j] = (pt_block >> (56 - 8 * j)) & 0xFF;
        }
        S[0] = ct_block;
        ascon_permutation(S, b);
    }
    uint64_t last_block = 0;
    for (int j = 0; j < 8; ++j) {
        last_block = (last_block << 8) | c_padded[ctlen + j];
    }
    uint64_t pt_block = S[0] ^ last_block;
    for (int j = 0; j < c_lastlen; ++j) {
        plaintext[ctlen + j] = (pt_block >> (56 - 8 * j)) & 0xFF;
    }
    uint64_t padded_plaintext = 0;
    for (int j = 0; j < rate; ++j) {
        padded_plaintext = (padded_plaintext << 8) | c_padded[ctlen + j];
    }
    S[0] ^= padded_plaintext;
}

void ascon_finalize(uint64_t *S, int a, const uint8_t *key, uint8_t *tag) {
    uint64_t K0 = 0, K1 = 0;
    for (int i = 0; i < 8; ++i) {
        K0 = (K0 << 8) | key[i];
        K1 = (K1 << 8) | key[i + 8];
    }

    S[1] ^= K0;
    S[2] ^= K1;

    ascon_permutation(S, a);

    S[3] ^= K0;
    S[4] ^= K1;

    for (int i = 0; i < 8; ++i) {
        tag[i] = (S[3] >> (56 - 8 * i)) & 0xFF;
        tag[i + 8] = (S[4] >> (56 - 8 * i)) & 0xFF;
    }
}

void get_random_bytes(uint8_t *buffer, int num) {
    srand((unsigned)time(NULL));
    for (int i = 0; i < num; ++i) {
        buffer[i] = rand() % 256;
    }
}

void ascon_encrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *associateddata, int adlen, const uint8_t *plaintext, int ptlen, uint8_t *ciphertext) {
    uint64_t S[5] = {0};
    int a = 12, b = 6;

    ascon_initialize(S, a, key, nonce);
    ascon_process_associated_data(S, b, RATE, associateddata, adlen);
    ascon_process_plaintext(S, b, RATE, plaintext, ptlen, ciphertext);

    uint8_t tag[16];
    ascon_finalize(S, a, key, tag);

    memcpy(ciphertext + ptlen, tag, 16);
}

int ascon_decrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *associateddata, int adlen, const uint8_t *ciphertext, int ctlen, uint8_t *plaintext) {
    if (ctlen < 16) return -1;

    uint64_t S[5] = {0};
    int a = 12, b = 6;
    int ptlen = ctlen - 16;

    ascon_initialize(S, a, key, nonce);
    ascon_process_associated_data(S, b, RATE, associateddata, adlen);
    ascon_process_ciphertext(S, b, RATE, ciphertext, ptlen, plaintext);

    uint8_t computed_tag[16];
    ascon_finalize(S, a, key, computed_tag);

    return (memcmp(computed_tag, ciphertext + ptlen, 16) == 0) ? 0 : -1;
}

void demo_aead() {
    const char demo[] = "=== demo encryption/decryption using Ascon-128 ===";
    const uint8_t associateddata[] = "just having fun";
    const uint8_t plaintext[] = "ASCON";
    uint8_t key[16];
    uint8_t nonce[16];
    get_random_bytes(key, 16);
    get_random_bytes(nonce, 16);

    int ptlen = strlen((char *)plaintext);
    int adlen = strlen((char *)associateddata);
    uint8_t ciphertext[ptlen + 16];
    uint8_t receivedplaintext[ptlen];

    ascon_encrypt(key, nonce, associateddata, adlen, plaintext, ptlen, ciphertext);

    if (ascon_decrypt(key, nonce, associateddata, adlen, ciphertext, ptlen + 16, receivedplaintext) == 0) {
        printf("%s\n", demo);
        printf("associated data:    %s\n", associateddata);
        printf("plaintext:          %s\n", plaintext);

        printf("key:                ");
        for (int i = 0; i < 16; ++i) {
            printf("%02x", key[i]);
        }
        printf("\nnonce:              ");
        for (int i = 0; i < 16; ++i) {
            printf("%02x", nonce[i]);
        }
        printf("\nciphertext:         ");
        for (int i = 0; i < ptlen; ++i) {
            printf("%02x", ciphertext[i]);
        }
        printf("\ntag:                ");
        for (int i = ptlen; i < ptlen + 16; ++i) {
            printf("%02x", ciphertext[i]);
        }
        printf("\nreceived plaintext: %s\n", receivedplaintext);
    } else {
        printf("verification failed!\n");
    }
}
