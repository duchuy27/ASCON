#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Define constants
#define RATE 8
#define A 12
#define B 6

// Function declarations
void ascon_permutation(uint64_t *S, int rounds);
void ascon_initialize(uint64_t *S, int a, const uint8_t *key, const uint8_t *nonce);
void ascon_process_associated_data(uint64_t *S, int b, size_t rate, const uint8_t *associateddata, size_t ad_len);
uint8_t *ascon_process_plaintext(uint64_t *S, int b, size_t rate, const uint8_t *plaintext, size_t pt_len, size_t *ct_len);
uint8_t *ascon_process_ciphertext(uint64_t *S, int b, size_t rate, const uint8_t *ciphertext, size_t ct_len, size_t *pt_len);
uint8_t *ascon_finalize(uint64_t *S, int a, const uint8_t *key);
void bytes_to_state(const uint8_t *bytes, uint64_t *state);
uint64_t rotr(uint64_t val, int r);
void print_hex(const char *label, const uint8_t *data, size_t len);
uint8_t *get_random_bytes(size_t num);

uint8_t *ascon_encrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *associateddata, size_t ad_len, const uint8_t *plaintext, size_t pt_len, size_t *ct_len) {
    // Ensure key and nonce sizes are correct
    if (strlen((const char *)key) != 16 || strlen((const char *)nonce) != 16) {
        return NULL;
    }

    // Parameters
    uint64_t S[5] = {0};

    // Process
    ascon_initialize(S, A, key, nonce);
    ascon_process_associated_data(S, B, RATE, associateddata, ad_len);
    uint8_t *ciphertext = ascon_process_plaintext(S, B, RATE, plaintext, pt_len, ct_len);
    uint8_t *tag = ascon_finalize(S, A, key);

    // Append tag to ciphertext
    *ct_len += 16;
    ciphertext = realloc(ciphertext, *ct_len);
    memcpy(ciphertext + *ct_len - 16, tag, 16);

    free(tag);
    return ciphertext;
}

uint8_t *ascon_decrypt(const uint8_t *key, const uint8_t *nonce, const uint8_t *associateddata, size_t ad_len, const uint8_t *ciphertext, size_t ct_len, size_t *pt_len) {
    // Ensure key, nonce, and ciphertext sizes are correct
    if (strlen((const char *)key) != 16 || strlen((const char *)nonce) != 16 || ct_len < 16) {
        return NULL;
    }

    // Parameters
    uint64_t S[5] = {0};

    // Process
    ascon_initialize(S, A, key, nonce);
    ascon_process_associated_data(S, B, RATE, associateddata, ad_len);
    uint8_t *plaintext = ascon_process_ciphertext(S, B, RATE, ciphertext, ct_len - 16, pt_len);  // ignore the tag (last 16 bytes)
    uint8_t *tag = ascon_finalize(S, A, key);

    // Verify the tag
    if (memcmp(tag, ciphertext + ct_len - 16, 16) != 0) {
        free(plaintext);
        free(tag);
        return NULL; // Tag verification failed
    }

    free(tag);
    return plaintext; // Tag verification succeeded
}

void ascon_initialize(uint64_t *S, int a, const uint8_t *key, const uint8_t *nonce) {
    uint8_t iv[8] = {0x80, 0x40, 0x0c, 0x06, 0x00, 0x00, 0x00, 0x00};
    uint8_t initial_state[40];

    // Initial state = IV || key || nonce
    memcpy(initial_state, iv, 8);
    memcpy(initial_state + 8, key, 16);
    memcpy(initial_state + 24, nonce, 16);

    bytes_to_state(initial_state, S);

    // Initial permutation of the state
    ascon_permutation(S, a);

    // Zero_key = 0* || key
    uint8_t zero_key[40] = {0};
    memcpy(zero_key + 24, key, 16);

    uint64_t zero_key_state[5];
    bytes_to_state(zero_key, zero_key_state);

    // XOR the state with the zero_key
    for (int i = 0; i < 5; i++) {
        S[i] ^= zero_key_state[i];
    }
}

void ascon_process_associated_data(uint64_t *S, int b, size_t rate, const uint8_t *associateddata, size_t ad_len) {
    if (ad_len > 0) {
        // Padding
        size_t ad_lastlen = ad_len % rate;
        size_t ad_zero_bytes = rate - ad_lastlen - 1;
        uint8_t ad_padding[rate];
        ad_padding[0] = 0x80;
        memset(ad_padding + 1, 0, ad_zero_bytes);

        size_t ad_padded_len = ad_len + ad_zero_bytes + 1;
        uint8_t *ad_padded = malloc(ad_padded_len);
        memcpy(ad_padded, associateddata, ad_len);
        memcpy(ad_padded + ad_len, ad_padding, ad_zero_bytes + 1);

        // Absorption of associated data
        for (size_t block = 0; block < ad_padded_len; block += rate) {
            uint64_t temp = 0;
            memcpy(&temp, ad_padded + block, rate);
            S[0] ^= temp;
            ascon_permutation(S, b);
        }

        free(ad_padded);
    }

    // Domain separation
    S[4] ^= 1;
}

uint8_t *ascon_process_plaintext(uint64_t *S, int b, size_t rate, const uint8_t *plaintext, size_t pt_len, size_t *ct_len) {
    // Padding
    size_t p_lastlen = pt_len % rate;
    size_t p_zero_bytes = rate - p_lastlen - 1;
    uint8_t p_padding[rate];
    p_padding[0] = 0x80;
    memset(p_padding + 1, 0, p_zero_bytes);

    size_t p_padded_len = pt_len + p_zero_bytes + 1;
    uint8_t *p_padded = malloc(p_padded_len);
    memcpy(p_padded, plaintext, pt_len);
    memcpy(p_padded + pt_len, p_padding, p_zero_bytes + 1);

    // Absorption of plaintext & squeezing of ciphertext
    *ct_len = pt_len;
    uint8_t *ciphertext = malloc(*ct_len);
    size_t blocks = p_padded_len - rate;

    for (size_t block = 0; block < blocks; block += rate) {
        uint64_t temp = 0;
        memcpy(&temp, p_padded + block, rate);
        S[0] ^= temp;
        memcpy(ciphertext + block, &S[0], rate);
        ascon_permutation(S, b);
    }

    // Processing of the last block
    uint64_t p_last = 0;
    memcpy(&p_last, p_padded + blocks, rate);
    S[0] ^= p_last;
    memcpy(ciphertext + blocks, &S[0], p_lastlen);

    free(p_padded);
    return ciphertext;
}

uint8_t *ascon_process_ciphertext(uint64_t *S, int b, size_t rate, const uint8_t *ciphertext, size_t ct_len, size_t *pt_len) {
    // Padding
    size_t c_lastlen = ct_len % rate;
    size_t c_zero_bytes = rate - c_lastlen - 1;
    uint8_t c_padding[rate];
    c_padding[0] = 0x80;
    memset(c_padding + 1, 0, c_zero_bytes);

    size_t c_padded_len = ct_len + c_zero_bytes + 1;
    uint8_t *c_padded = malloc(c_padded_len);
    memcpy(c_padded, ciphertext, ct_len);
    memcpy(c_padded + ct_len, c_padding, c_zero_bytes + 1);

    // Absorption of ciphertext & squeezing of plaintext
    *pt_len = ct_len;
    uint8_t *plaintext = malloc(*pt_len);
    size_t blocks = c_padded_len - rate;

    for (size_t block = 0; block < blocks; block += rate) {
        uint64_t Ci = 0;
        memcpy(&Ci, c_padded + block, rate);
        uint64_t temp = S[0] ^ Ci;
        memcpy(plaintext + block, &temp, rate);
        S[0] = Ci;
        ascon_permutation(S, b);
    }

    // Processing of the last block
    uint64_t c_last = 0;
    memcpy(&c_last, c_padded + blocks, rate);
    uint64_t temp = c_last ^ S[0];
    memcpy(plaintext + blocks, &temp, c_lastlen);

    uint64_t padded_plaintext = 0;
    memcpy(&padded_plaintext, plaintext + blocks, rate);
    S[0] ^= padded_plaintext;

    free(c_padded);
    return plaintext;
}

uint8_t *ascon_finalize(uint64_t *S, int a, const uint8_t *key) {
    uint8_t *tag = malloc(16);

    // Step 1
    uint64_t K1 = 0, K2 = 0;
    memcpy(&K1, key, 8);
    memcpy(&K2, key + 8, 8);

    S[1] ^= K1;
    S[2] ^= K2;
    ascon_permutation(S, a);

    // Step 2
    S[3] ^= K1;
    S[4] ^= K2;
    memcpy(tag, &S[3], 8);
    memcpy(tag + 8, &S[4], 8);

    return tag;
}

void ascon_permutation(uint64_t *S, int rounds) {
    static const uint64_t RC[12] = {
        0x0f0e0d0c0b0a0908, 0x1f1e1d1c1b1a1918, 0x2f2e2d2c2b2a2928,
        0x3f3e3d3c3b3a3938, 0x4f4e4d4c4b4a4948, 0x5f5e5d5c5b5a5958,
        0x6f6e6d6c6b6a6968, 0x7f7e7d7c7b7a7978, 0x8f8e8d8c8b8a8988,
        0x9f9e9d9c9b9a9998, 0xafaeadaacabaaa9a, 0xbfbeadbacab9b8b8
    };

    for (int r = 12 - rounds; r < 12; r++) {
        // Step 1: Add round constants
        S[2] ^= RC[r];

        // Step 2: Substitution layer
        uint64_t T[5];
        S[0] ^= S[4];
        S[4] ^= S[3];
        S[2] ^= S[1];

        for (int i = 0; i < 5; i++) {
            T[i] = (~S[i]) & S[(i + 1) % 5];
        }

        for (int i = 0; i < 5; i++) {
            S[i] ^= T[(i + 1) % 5];
        }

        S[1] ^= S[0];
        S[0] ^= S[4];
        S[3] ^= S[2];
        S[2] ^= ~0ULL;

        // Step 3: Linear diffusion layer
        S[0] ^= rotr(S[0], 19) ^ rotr(S[0], 28);
        S[1] ^= rotr(S[1], 61) ^ rotr(S[1], 39);
        S[2] ^= rotr(S[2], 1) ^ rotr(S[2], 6);
        S[3] ^= rotr(S[3], 10) ^ rotr(S[3], 17);
        S[4] ^= rotr(S[4], 7) ^ rotr(S[4], 41);
    }
}

void bytes_to_state(const uint8_t *bytes, uint64_t *state) {
    for (int i = 0; i < 5; i++) {
        state[i] = 0;
        for (int j = 0; j < 8; j++) {
            state[i] |= (uint64_t)bytes[i * 8 + j] << (56 - j * 8);
        }
    }
}

uint64_t rotr(uint64_t val, int r) {
    return (val >> r) | (val << (64 - r));
}

void print_hex(const char *label, const uint8_t *data, size_t len) {
    printf("%s: ", label);
    for (size_t i = 0; i < len; i++) {
        printf("%02x", data[i]);
    }
    printf("\n");
}

uint8_t *get_random_bytes(size_t num) {
    uint8_t *bytes = malloc(num);
    if (!bytes) {
        perror("malloc");
        exit(EXIT_FAILURE);
    }
    FILE *urandom = fopen("/dev/urandom", "rb");
    if (!urandom) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }
    if (fread(bytes, 1, num, urandom) != num) {
        perror("fread");
        exit(EXIT_FAILURE);
    }
    fclose(urandom);
    return bytes;
}

// Demo function
void demo_aead() {
    const char *demo = "=== demo encryption/decryption using Ascon-128 ===";
    const uint8_t associateddata[] = "just having fun";
    const uint8_t plaintext[] = "ASCON";
    size_t pt_len = sizeof(plaintext) - 1;
    size_t ad_len = sizeof(associateddata) - 1;
    uint8_t key[16] = {0xea, 0xa9, 0x11, 0x9a, 0xa3, 0xa9, 0xbd, 0x5e, 0x50, 0xbc, 0xcd, 0xa4, 0xe1, 0x3d, 0x1c, 0x03};
    uint8_t nonce[16] = {0x1a, 0x65, 0x27, 0xa3, 0x66, 0x45, 0xdd, 0xb9, 0x49, 0x06, 0x71, 0xdc, 0x5d, 0x1e, 0x1e, 0xbb};

    size_t ct_len;
    uint8_t *ciphertext = ascon_encrypt(key, nonce, associateddata, ad_len, plaintext, pt_len, &ct_len);
    if (!ciphertext) {
        fprintf(stderr, "Encryption failed\n");
        return;
    }

    size_t pt_out_len;
    uint8_t *receivedplaintext = ascon_decrypt(key, nonce, associateddata, ad_len, ciphertext, ct_len, &pt_out_len);
    if (!receivedplaintext) {
        fprintf(stderr, "Decryption failed\n");
        free(ciphertext);
        return;
    }

    printf("%s\n", demo);
    printf("associated data:    %s\n", associateddata);
    printf("plaintext:          %s\n", plaintext);
    print_hex("key", key, 16);
    print_hex("nonce", nonce, 16);
    print_hex("ciphertext", ciphertext, ct_len - 16);
    print_hex("tag", ciphertext + ct_len - 16, 16);
    printf("received plaintext: %s\n", receivedplaintext);

    free(ciphertext);
    free(receivedplaintext);
}

int main() {
    demo_aead();
    return 0;
}
