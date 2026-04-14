#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

typedef int (*fptr)(int, int);

int main() {
    char op[6];
    int num1, num2;

    while(scanf("%5s %d %d", op, &num1, &num2) == 3){ 
        char libpath[20];
        snprintf(libpath, sizeof(libpath), "./lib%s.so", op);

        void* handle = dlopen(libpath, RTLD_LAZY);

        fptr func = dlsym(handle, op);

        if (func == NULL) {
            printf("Error: Operation not found.\n");
            if (handle) dlclose(handle);
            continue;
        }

        printf("%d\n", func(num1, num2));

        dlclose(handle);
    }

    return 0;
}