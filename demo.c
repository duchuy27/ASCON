#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "ascon.h" // Import your header file

int main() {
    // Khởi tạo trạng thái S và các hằng số cho vòng lặp
    uint8_t S[40] = {
        0x3d, 0x1d, 0x6c, 0xe8, 0x29, 0xb0, 0x32, 0xeb,
        0xc8, 0xca, 0xe7, 0x46, 0xe8, 0xe5, 0xe3, 0xe5,
        0x1f, 0x67, 0xbd, 0xa9, 0x5b, 0xf0, 0xf3, 0x23,
        0x28, 0x64, 0xc6, 0x78, 0xb4, 0xc5, 0x61, 0x71,
        0xa7, 0xae, 0xa2, 0x54, 0xaa, 0x32, 0x1b, 0xc9
    };
    const int num_rounds = 6; // Số lần lặp
    const int block_size = 8; // Kích thước block là 8 byte

    // Thực hiện vòng lặp permutation
    permutation(S, num_rounds);

    // In kết quả
    printf("Final state after permutation:\n");
    print_HEX(S, 40);

    return 0;
}
