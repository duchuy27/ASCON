#include <stdio.h>
#include <conio.h>
#include <string.h>
#include "ascon.h"

const uint8_t Key[KEY_LEN] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6};
const uint8_t Nonce[NONCE_LEN] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6};
const char Associated_data[] = "ASCON123456789123456789";
const char Plain_data[] = "Hello, Huy";

int main() {
    
    //******************************MÃ HÓA******************************
    uint8_t Cipher_data[sizeof(Plain_data)];
    uint8_t Tag[TAG_LEN];
    encrypt(Key, Nonce, Associated_data, sizeof(Associated_data), Plain_data, sizeof(Plain_data), Cipher_data, Tag);
    //******************************GIẢI MÃ******************************
    uint8_t Plain_data_receive[sizeof(Cipher_data)];
    uint8_t Tag_receive[TAG_LEN];
    decrypt(Key, Nonce, Associated_data, sizeof(Associated_data), Cipher_data, sizeof(Cipher_data), Plain_data_receive, Tag_receive);
    //******************************IN GIÁ TRỊ******************************

    print_HEX("Key", Key, KEY_LEN);
    print_HEX("Nonce", Nonce, NONCE_LEN);
    print_HEX("ass.data", Associated_data, sizeof(Associated_data));
    print_HEX("Plaintext", Plain_data, sizeof(Plain_data));
    print_HEX("ciphertext", Cipher_data, sizeof(Cipher_data));
    print_HEX("tag", Tag, TAG_LEN);
    print_HEX("plaint.rec", Plain_data_receive, sizeof(Plain_data_receive));
    print_HEX("tag.rec", Tag, TAG_LEN);

    if(memcmp(Tag_receive, Tag, TAG_LEN) == 0)
        printf("Tag is correct!\n");
    else printf("Tag is incorrect!\n");

    return 0;
}