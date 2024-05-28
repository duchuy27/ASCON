#include <stdio.h>
#include <stdint.h>

// Hàm hiển thị giá trị hex của mảng
void print_HEX(uint8_t *arr, size_t len) {
    for (size_t i = 0; i < len; i++) {
        printf("%02x ", arr[i]);
    }
    printf("\n");
}

uint64_t rotr(uint64_t val, int r) {
    return (val >> r) | ((val & ((1ULL << r) - 1)) << (64 - r));
}

void pL(uint8_t *S) {
    uint64_t *x0 = (uint64_t *)(S + 0 * 8); // Assume REG_SIZE is 8 bytes
    uint64_t *x1 = (uint64_t *)(S + 1 * 8);
    uint64_t *x2 = (uint64_t *)(S + 2 * 8);
    uint64_t *x3 = (uint64_t *)(S + 3 * 8);
    uint64_t *x4 = (uint64_t *)(S + 4 * 8);

    *x0 = rotr(*x0, 19);

    // In ra giá trị của mảng S sau khi áp dụng phép xoay
    printf("Result after rotation: ");
    print_HEX(S, 40); // Assume S_LEN is 40 bytes
}

int main() {
    // Example input
    uint8_t S[40] = {
        0x89, 0x40, 0x0d, 0x00, 0x03, 0x04, 0x05, 0xf6,
        0x81, 0x42, 0x0f, 0x02, 0x05, 0x06, 0x07, 0xf8,
        0xff, 0xfd, 0xfd, 0xfb, 0xfb, 0xfd, 0xfd, 0xfd,
        0x07, 0x80, 0x40, 0x0c, 0x00, 0x00, 0x00, 0xf0,
        0x08, 0x00, 0x00, 0x06, 0x02, 0x00, 0x00, 0x06
    };

    // Gọi hàm pL để thực hiện phép xoay và hiển thị kết quả
    pL(S);

    return 0;
}
