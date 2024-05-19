#include <stdio.h>
#include <conio.h>
#include <string.h>
#include "ascon.h"

const uint8_t Key[KEY_LEN] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6};
const uint8_t Nonce[NONCE_LEN] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6};
const char associated_data[] = "ASCON";
const char plain_data[] = "ascon";

int main() {
    //Initialization
    uint8_t IV[IV_LEN];
    uint8_t S[S_LEN];

    // Tạo IV dựa trên thông số k, r, a, và b cho Ascon-128
    Init_IV(IV, 128, 12, 8, 6);

    // Tạo S từ IV, Key, và Nonce
    Init_S(S, IV, Key, Nonce);
    printf("S:");
    print_HEX(S, S_LEN);
    permutation(S, 8);

    for (size_t i = 0; i < KEY_LEN; i++) {
        S[S_LEN - KEY_LEN + i] ^= Key[i];
    }

    //Processing Associated Data Ascon
    process_associated_data(S, associated_data, sizeof(associated_data), 6, 12);
    printf("associated_data:");
    print_HEX(associated_data, 5); //4153434f4e
    printf("plaintext: ");
    print_HEX(plain_data, 5);   // 6173636f6e

    //Processing Plaintext Ascon
    size_t ciphertext_length = calculate_text_length(sizeof(plain_data), 12);
    uint8_t C[ciphertext_length];
    encrypt_plaintext(S, plain_data, sizeof(plain_data) - 1, C, 6, 12);
    printf("ciphertext: ");
    print_HEX(C, 5);        //efd226f075
    
    //Finalization
    uint8_t calculated_tag[TAG_LEN];
    Init_tag(S, Key, calculated_tag, 8, 12);
    //******************************************************

    // Tạo lại S từ IV, Key, và Nonce
    Init_S(S, IV, Key, Nonce);
    permutation(S, 8);

    for (size_t i = 0; i < KEY_LEN; i++) {
        S[S_LEN - KEY_LEN + i] ^= Key[i];
    }

    //Processing Associated Data Ascon
    process_associated_data(S, associated_data, sizeof(associated_data), 6, 12);

    //Processing Ciphertext Ascon
    size_t plaintext_length = calculate_text_length(sizeof(plain_data), 12);
    uint8_t P[plaintext_length];
    decrypt_ciphertext(S, C, sizeof(C), P, 6, 12);

    //Finalization
    uint8_t calculated_tag_new[TAG_LEN];
    Init_tag(S, Key, calculated_tag_new, 8, 12);
    //*******************************************************
    
    if(memcmp(calculated_tag, calculated_tag_new, TAG_LEN) == 0){
        // print_HEX(calculated_tag, TAG_LEN);
        // print_HEX(calculated_tag_new, TAG_LEN);
        printf("Tag is correct!\n");
    } else {
        printf("Tag is incorrect!\n");
    }
    printf("Plaintext: ");
    print_HEX(plain_data, sizeof(plain_data));
    printf("Plaintext_decrypted: ");
    print_HEX(P, sizeof(P));
    return 0;
}