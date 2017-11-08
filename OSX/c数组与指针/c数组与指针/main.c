//
//  main.c
//  c数组与指针
//
//  Created by qiuShan on 2017/10/26.
//  Copyright © 2017年 秋山. All rights reserved.
//

#include <stdio.h>

const int MAX = 4;

int main(int argc, const char * argv[]) {
    
    int  var[] = {10, 100, 200, 300};
    int i, *ptr[MAX];
    
    for ( i = 0; i < MAX; i++)
    {
        ptr[i] = &var[i]; /* 赋值为整数的地址 */
    }
    for ( i = 0; i < MAX; i++)
    {
        printf("Value of  var[%d] a.= %p  value =  %d\n", i, ptr[i],*ptr[i] );
    }
    
    char name;
    char *names[] ={
        "Z",
        "H",
        "J",
        "B"
    };
//    char *names[] ={
//        "Zara Ali",
//        "Hini Ali",
//        "Jini Ali",
//        "Bini Ali"
//    };
    
    for (int i = 0; i < MAX; i++) {
        printf("Value of names[%d] = %c %s\n",i,*names[i],names[i]);
    }
    
    return 0;
}
