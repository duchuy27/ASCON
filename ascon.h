#include <stdint.h>

#define KEY_LEN 16U             // Length of key is 128 bits (16 bytes)
#define NONCE_LEN 16U           // Length of nonce is 128 bits (16 bytes)
#define IV_LEN 8U               // Length of IV is 320-128*2 = 64 bits (8 bytes)
#define S_LEN 40U               // Length of State is 320 bits (40 bytes)
#define REG_SIZE 8U             // Size of Register is 64 bits (8 bytes) (320/5 = 64 bits)
#define TAG_LEN 16U             // Length of TAG is 128 bits (16 bytes)

// Thông số sủa Ascon-128
#define K 128
#define RATE 8
#define A 12
#define B 6

const uint8_t round_constants[12] = {0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87, 0x78, 0x69, 0x5a, 0x4b};
const uint8_t s_box[32] = {0x4, 0xb, 0x1f, 0x14, 0x1a, 0x15, 0x9, 0x2, 0x1b, 0x5, 0x8, 0x12, 0x1d, 0x3, 0x6, 0x1c,
                            0x1e, 0x13, 0x7, 0xe, 0x0, 0xd, 0x11, 0x18, 0x10, 0xc, 0x1, 0x19, 0x16, 0xa, 0xf, 0x17};

//In giá trị ra
void print_HEX(const char *label, const uint8_t vari[], int len){
    printf("%s: ", label);
    for (int i = 0; i < len; i++) {
        if(i%8 == 0){
            printf("\t");
        }
        printf("%02x", vari[i]); // In ra mỗi byte của IV dưới dạng HEX
    }
    printf("\n");
}

// Hàm đảo ngược byte của một giá trị uint64_t
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

void Init_IV(uint8_t *IV, uint8_t k, uint8_t r, uint8_t a, uint8_t b) {
    // Create a IV with k, r, a and b
    if (k == K && r == (RATE * 8) && a == A && b == B) {
        // IV for Ascon-128
        memset(IV, 0x00, IV_LEN);
        IV[0] = 0x80;
        IV[1] = 0x40;
        IV[2] = 0x0c;
        IV[3] = 0x06;
    } else if (k == K && r == (RATE * 8) && a == A && b == B) {
        // IV for Ascon-128a
        memset(IV, 0x00, IV_LEN);
        IV[0] = 0x80;
        IV[1] = 0x80;
        IV[2] = 0x0c;
        IV[3] = 0x08;
    } else if (k == 80) {
        // IV for Ascon-80pq
        memset(IV, 0x00, IV_LEN);
        IV[0] = 0xa0;
        IV[1] = 0x40;
        IV[2] = 0x0c;
        IV[3] = 0x06;
    } else {
        printf("Unsupported parameters for IV.\n");
    }
}

void Init_S(uint8_t *S, const uint8_t *Key, const uint8_t *Nonce) {
    uint8_t IV[IV_LEN];
    Init_IV(IV, K, RATE*8, A, B);
    // S = IV || K || N
    memcpy(S, IV, IV_LEN);
    memcpy(S + IV_LEN, Key, KEY_LEN);
    memcpy(S + IV_LEN + KEY_LEN, Nonce, NONCE_LEN);
}

// Hàm pC - Addition of Constants
void pC(uint8_t* S, const uint64_t round_constant) {
    S[3*REG_SIZE-1] ^= round_constant;
}

// Hàm pS - Substitution Layer
void pS_lookup_table(uint8_t *S) {
    int temp_array_size = 8 * S_LEN / 5;
    uint8_t temp_array[temp_array_size];
    int bit_position = 0;
    for (size_t i = 0; i < temp_array_size; ++i) {
        // Lấy 5 bit từ vị trí hiện tại
        int byte_index = bit_position / 8;
        int bit_offset = bit_position % 8;
        uint8_t value;
        
        if (bit_offset <= 3) value = (S[byte_index] >> (3 - bit_offset)) & 0x1F;
        else value = ((S[byte_index] << (bit_offset - 3)) & 0x1F) | (S[byte_index + 1] >> (11 - bit_offset));
        
        // Áp dụng S-box
        temp_array[i] = s_box[value];
        // Di chuyển đến 5 bit tiếp theo
        bit_position += 5;
    }

    // Kết hợp lại thành các phần tử 8-bit trong output_array
    for (size_t i = 0; i < S_LEN; ++i) {
        S[i] = 0;
        for (int bit = 0; bit < 8; ++bit) {
            int total_bit_position = i * 8 + bit;
            int temp_index = total_bit_position / 5;
            int bit_in_temp = total_bit_position % 5;

            S[i] |= ((temp_array[temp_index] >> (4 - bit_in_temp)) & 1) << (7 - bit);
        }
    }
}

void pS(uint8_t *S) {
    uint64_t *x0 = (uint64_t *)(S + 0 * REG_SIZE);
    uint64_t *x1 = (uint64_t *)(S + 1 * REG_SIZE);
    uint64_t *x2 = (uint64_t *)(S + 2 * REG_SIZE);
    uint64_t *x3 = (uint64_t *)(S + 3 * REG_SIZE);
    uint64_t *x4 = (uint64_t *)(S + 4 * REG_SIZE);

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

uint64_t rotr(uint64_t val, int r) {
    return (val >> r) | (val << (64 - r));
}

// Hàm pL - Linear Diffusion Layer
void pL(uint8_t *S) {
    uint64_t *x0 = (uint64_t *)(S + 0 * REG_SIZE);
    uint64_t *x1 = (uint64_t *)(S + 1 * REG_SIZE);
    uint64_t *x2 = (uint64_t *)(S + 2 * REG_SIZE);
    uint64_t *x3 = (uint64_t *)(S + 3 * REG_SIZE);
    uint64_t *x4 = (uint64_t *)(S + 4 * REG_SIZE);

    //Đảo lại để dịch bits
    *x0 = reverse_bytes(*x0);
    *x1 = reverse_bytes(*x1);
    *x2 = reverse_bytes(*x2);
    *x3 = reverse_bytes(*x3);
    *x4 = reverse_bytes(*x4);

    *x0 ^= rotr(*x0, 19) ^ rotr(*x0, 28);
    *x1 ^= rotr(*x1, 61) ^ rotr(*x1, 39);
    *x2 ^= rotr(*x2, 1) ^ rotr(*x2, 6);
    *x3 ^= rotr(*x3, 10) ^ rotr(*x3, 17);
    *x4 ^= rotr(*x4, 7) ^ rotr(*x4, 41);

    //Đảo lại để đúng thứ tự
    *x0 = reverse_bytes(*x0);
    *x1 = reverse_bytes(*x1);
    *x2 = reverse_bytes(*x2);
    *x3 = reverse_bytes(*x3);
    *x4 = reverse_bytes(*x4);
}

// Hàm hoán vị permutation
void permutation(uint8_t *S, const int num_rounds) {
    for (int i = 12 - num_rounds; i < 12; i++) {
        // Bước pC - thêm hằng số vòng vào từ x2
        pC(S, round_constants[i]);;
        // Bước pS - cập nhật trạng thái với S-box
        //pS_lookup_table(S);
        pS(S);
        // Bước pL - cung cấp sự phân tán tuyến tính cho mỗi từ xi
        pL(S);
    }
}

// Hàm chuyển đổi bytes thành số nguyên
uint64_t bytes_to_int(const uint8_t *bytes) {
    return ((uint64_t)bytes[0] << 56) |
           ((uint64_t)bytes[1] << 48) |
           ((uint64_t)bytes[2] << 40) |
           ((uint64_t)bytes[3] << 32) |
           ((uint64_t)bytes[4] << 24) |
           ((uint64_t)bytes[5] << 16) |
           ((uint64_t)bytes[6] << 8)  |
           ((uint64_t)bytes[7]);
}

// Hàm xử lý dữ liệu liên kết
void process_associated_data(uint8_t *S, const uint8_t *Associated_data, int A_LEN) {
    if (A_LEN > 0) {
        // thêm 1|0(63 bits) vào associated_data cho đủ bội số của 8
        int PADDED_LEN = A_LEN + (RATE - (A_LEN % RATE));
        uint8_t padded[PADDED_LEN];
        memset(padded, 0x00, PADDED_LEN);
        memcpy(padded, Associated_data, A_LEN);
        padded[A_LEN] = 0x80;

        for (int i = 0; i < PADDED_LEN; i += RATE){
            for (int j = 0; j < RATE; j++){
                 S[j] ^= padded[j + i];
            }
            permutation(S, B);
        }
        
        S[39] ^= 0x01;
    }
}

// Hàm mã hóa plaintext thành ciphertext
void encrypt_plaintext(uint8_t *S, const uint8_t *Plain_data, size_t P_LEN, uint8_t *C) {
    int P_LAST_LEN = P_LEN % RATE;
    int PADDED_LEN = P_LEN + (RATE - P_LAST_LEN);
    uint8_t padded[PADDED_LEN];
    memset(padded, 0x00, PADDED_LEN);
    memcpy(padded, Plain_data, P_LEN);
    padded[P_LEN] = 0x80;
    
    //block 1 đến t-1
    for (int i = 0; i < PADDED_LEN - RATE; i += RATE){
        for (int j = 0; j < RATE; j++){
            S[j] ^= padded[j + i];
        }
        memcpy(C + i, S, RATE);
        permutation(S, B);
    }
    
    //block cuối
    for (int i = 0; i < RATE; i++){
        S[i] ^= padded[i + (PADDED_LEN - RATE)];
    }
    memcpy(C + (PADDED_LEN - RATE), S, P_LAST_LEN);
}

// Hàm để tạo tag cho plaintext và key đã mã hóa
void Init_tag(uint8_t *S, const uint8_t *Key, uint8_t *tag) {
    // XOR internal state với key 0^r||K||0^(360-r-k)
    for (size_t i = RATE; i < (KEY_LEN + RATE); i++) {
        S[i] ^= Key[i - RATE];
    }
    permutation(S, A);
    //XOR S and Key
    for (size_t i = S_LEN - TAG_LEN; i < S_LEN; i++) {
        S[i] ^= Key[i - (S_LEN - TAG_LEN)];
    }
    // Sao chép 128 bits cuối cùng của trạng thái S vào tag
    memcpy(tag, S + S_LEN - TAG_LEN, TAG_LEN);
}

//Hàm giải mã ciphertext thành plaintext
void decrypt_ciphertext(uint8_t *S, uint8_t *Cipher_data, size_t C_LEN, uint8_t *P) {
    int C_LAST_LEN = C_LEN % RATE;
    int PADDED_LEN = C_LEN + (RATE - C_LAST_LEN);
    uint8_t padded[PADDED_LEN];
    memset(padded, 0x00, PADDED_LEN);
    memcpy(padded, Cipher_data, C_LEN);

    //block 1 đến t-1
    for (int i = 0; i < PADDED_LEN - RATE; i += RATE){
        for (int j = 0; j < RATE; j++){
            P[j + i] = S[j] ^ Cipher_data[j + i];
            S[j] = Cipher_data[j + i];
        }
        permutation(S, B);
    }
    
    //block cuối
    for (int i = 0; i < C_LAST_LEN; i++){
        P[i + (C_LEN - C_LAST_LEN)] = S[i] ^ Cipher_data[i + (C_LEN - C_LAST_LEN)];
    }

    uint8_t Pt_padded[RATE];
    memset(Pt_padded, 0x00, RATE);
    memcpy(Pt_padded, P + (C_LEN - C_LAST_LEN), C_LAST_LEN);
    Pt_padded[C_LAST_LEN] = 0x80;

    for (int i = 0; i < RATE; i++){
        S[i] ^= Pt_padded[i];
    }
}