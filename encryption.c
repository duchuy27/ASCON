#include <stdio.h>
#include <conio.h>
#include <string.h>
#include "ascon.h"

const uint8_t Key[KEY_LEN] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6};
const uint8_t Nonce[NONCE_LEN] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6};
const char Associated_data[] = "ASCON";
const char plain_data[] = "Hello, Huy";

int main() {
    //Initialization
    uint8_t S[S_LEN];

    //******************************MÃ HÓA******************************
    // Tạo S từ IV, Key, và Nonce
    Init_S(S, IV, Key, Nonce);
    permutation(S, A);

    for (size_t i = 0; i < KEY_LEN; i++) {
        S[S_LEN - KEY_LEN + i] ^= Key[i];
    }

    //Processing Associated Data Ascon với rate = 8(64/8) và b = 6 
    process_associated_data(S, Associated_data, sizeof(Associated_data));

    //Processing Plaintext Ascon
    uint8_t C[sizeof(plain_data)];
    encrypt_plaintext(S, plain_data, sizeof(plain_data), C);
    
    //Finalization
    uint8_t Tag[TAG_LEN];
    Init_tag(S, Key, Tag);

    //******************************GIẢI MÃ******************************
    // Tạo lại S từ IV, Key, và Nonce
    Init_S(S, IV, Key, Nonce);
    permutation(S, A);

    for (size_t i = 0; i < KEY_LEN; i++) {
        S[S_LEN - KEY_LEN + i] ^= Key[i];
    }

    //Processing Associated Data Ascon
    process_associated_data(S, Associated_data, sizeof(Associated_data));

    //Processing Ciphertext Ascon
    uint8_t P[sizeof(C)];
    decrypt_ciphertext(S, C, sizeof(C), P);

    //Finalization
    uint8_t Tag_received[TAG_LEN];
    Init_tag(S, Key, Tag_received);

    //******************************IN GIÁ TRỊ******************************

    print_HEX("Key", Key, KEY_LEN);
    print_HEX("Nonce", Nonce, NONCE_LEN);
    print_HEX("Plaintext", plain_data, sizeof(plain_data));
    print_HEX("ass.data", Associated_data, sizeof(Associated_data));
    print_HEX("ciphertext", C, sizeof(C));
    print_HEX("tag", Tag, TAG_LEN);
    print_HEX("received", P, sizeof(P));

    if(memcmp(Tag_received, Tag, TAG_LEN) == 0)
        printf("Tag is correct!\n");
    else printf("Tag is incorrect!\n");

    return 0;
}