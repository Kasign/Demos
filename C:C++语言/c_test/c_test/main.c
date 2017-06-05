//
//  main.c
//  c_test
//
//  Created by walg on 2017/4/12.
//  Copyright © 2017年 walg. All rights reserved.
//

#include <stdio.h>

#define LINE 15


int main(int argc, const char * argv[]) {
    
    for ( int i = 0; i < LINE; i++) //列
    {
      
        if (i<=LINE/2) {
            for (int j = 0; j < (LINE/2 - i); j++)
            {
                printf("  ");
            }
            for (int j = 0; j < 2 * i + 1; j++) //行
            {
                printf("* ");
            }
        }else{
            for (int j =0; j <(i-LINE/2); j++)
            {
                printf("  ");
            }
            for (int j = 0; j <2 * (LINE - i) -1; j++) //行
            {
                printf("* ");
            }
        }
        printf("\n");
    }
   
    
    printf("\n");
    return 0;
}
