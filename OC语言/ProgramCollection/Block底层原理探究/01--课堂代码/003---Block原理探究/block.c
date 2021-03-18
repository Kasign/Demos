#include "stdio.h"

int main(){
    
    __block int a = 20;
    void(^block)(int) = ^(int b){
        printf("Log - %d %d", b, a);
    };
    
    block(6);
    return 0;
}
