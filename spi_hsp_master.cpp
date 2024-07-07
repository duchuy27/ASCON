#include <iostream>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

#define FPGA_BASE_ADDR 0xC0000000  // Địa chỉ cơ sở của module SPI Master trên Avalon-MM
#define SPI_MASTER_ADDR_OFFSET 0x10000  // Offset cho module SPI Master

#define TX_BYTE_OFFSET 0x00  // Offset cho thanh ghi TX Byte
#define TX_DV_OFFSET 0x04    // Offset cho thanh ghi TX Data Valid
#define TX_READY_OFFSET 0x08 // Offset cho thanh ghi TX Ready
#define RX_DV_OFFSET 0x0C    // Offset cho thanh ghi RX Data Valid
#define RX_BYTE_OFFSET 0x10  // Offset cho thanh ghi RX Byte

#define MAP_SIZE 4096UL
#define MAP_MASK (MAP_SIZE - 1)

volatile unsigned long *spi_base;

void writeRegister(unsigned int offset, unsigned int value) {
    *(spi_base + offset / sizeof(unsigned int)) = value;
}

unsigned int readRegister(unsigned int offset) {
    return *(spi_base + offset / sizeof(unsigned int));
}

int main() {
    int fd;
    void *map_base;

    // Mở /dev/mem
    if ((fd = open("/dev/mem", O_RDWR | O_SYNC)) == -1) {
        std::cerr << "Error opening /dev/mem" << std::endl;
        return 1;
    }

    // Ánh xạ bộ nhớ của module SPI Master
    map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, FPGA_BASE_ADDR & ~MAP_MASK);
    if (map_base == (void *)-1) {
        std::cerr << "Error mapping memory" << std::endl;
        close(fd);
        return 1;
    }

    spi_base = (volatile unsigned long *)((char *)map_base + (FPGA_BASE_ADDR & MAP_MASK) + SPI_MASTER_ADDR_OFFSET);

    // Gửi một byte dữ liệu qua SPI đến module LoRa
    writeRegister(TX_BYTE_OFFSET, 0xA5);  // Gửi byte 0xA5
    writeRegister(TX_DV_OFFSET, 1);       // Kích hoạt Data Valid

    // Chờ cho đến khi TX Ready
    while (readRegister(TX_READY_OFFSET) == 0);

    // Nhận một byte dữ liệu từ module LoRa qua SPI
    while (readRegister(RX_DV_OFFSET) == 0);
    unsigned int receivedByte = readRegister(RX_BYTE_OFFSET);
    std::cout << "Received Byte: " << std::hex << receivedByte << std::endl;

    // Giải ánh xạ bộ nhớ và đóng /dev/mem
    if (munmap(map_base, MAP_SIZE) == -1) {
        std::cerr << "Error unmapping memory" << std::endl;
    }
    close(fd);

    return 0;
}
