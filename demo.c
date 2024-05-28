#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define REG_SIZE 8

void pS(uint8_t *S) {
    uint64_t *x0 = (uint64_t *)(S + 0 * REG_SIZE);
    uint64_t *x1 = (uint64_t *)(S + 1 * REG_SIZE);
    uint64_t *x2 = (uint64_t *)(S + 2 * REG_SIZE);
    uint64_t *x3 = (uint64_t *)(S + 3 * REG_SIZE);
    uint16_t *x4 = (uint16_t *)(S + 4 * REG_SIZE);

    *x0 ^= *x4;
    *x4 ^= *x3;
    *x2 ^= *x1;
    
    uint64_t T[5];
    T[0] = ((*x0 ^ 0xFFFFFFFFFFFFFFFFULL) & *x1);
    T[1] = ((*x1 ^ 0xFFFFFFFFFFFFFFFFULL) & *x2);
    T[2] = ((*x2 ^ 0xFFFFFFFFFFFFFFFFULL) & *x3);
    T[3] = ((*x3 ^ 0xFFFFFFFFFFFFFFFFULL) & *x4);
    T[4] = ((*x4 ^ 0xFFFFFFFFFFFFFFFFULL) & *x0);

    *x0 ^= T[1];
    *x1 ^= T[2];
    *x2 ^= T[3];
    *x3 ^= T[4];
    *x4 ^= T[0];
    
    *x1 ^= *x0;
    *x0 ^= *x4;
    *x3 ^= *x2;
    *x2 ^= 0xFFFFFFFFFFFFFFFFULL;
    }

int main() {
    uint8_t S[40] = {
        0x80, 0x40, 0x0c, 0x06, 0x00, 0x00, 0x00, 0x00,
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x09, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0xf6,
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
        0x09, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06
    };

    // Gọi hàm pS
    pS(S);

    // In ra mảng S sau khi biến đổi
    for (int i = 0; i < 40; i++) {
        printf("S[%d] = %02x\n", i, S[i]);
    }

    // In ra giá trị x0, x1, x2, x3, x4
    uint64_t *x0 = (uint64_t *)(S + 0 * REG_SIZE);
    uint64_t *x1 = (uint64_t *)(S + 1 * REG_SIZE);
    uint64_t *x2 = (uint64_t *)(S + 2 * REG_SIZE);
    uint64_t *x3 = (uint64_t *)(S + 3 * REG_SIZE);
    uint16_t x4 = *(uint16_t *)(S + 4 * REG_SIZE);

    printf("x0 = %016llx\n", *x0);
    printf("x1 = %016llx\n", *x1);
    printf("x2 = %016llx\n", *x2);
    printf("x3 = %016llx\n", *x3);
    printf("x4 = %04x\n", x4);

    return 0;
}
