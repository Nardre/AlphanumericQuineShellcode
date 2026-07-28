#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s shellcode\n", argv[0]);
        return 1;
    }

    size_t shellcode_size = strlen(argv[1]);
    void *memory = mmap(0, shellcode_size, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
    if (memory == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }
    memcpy(memory, argv[1], shellcode_size);

    int (*shellcode)(char*) = memory;
    int status = shellcode(argv[1]);

    munmap(memory, shellcode_size);
    return status;
}
