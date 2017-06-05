//
//  main.c
//  杨辉三角
//
//  Created by walg on 2017/4/13.
//  Copyright © 2017年 walg. All rights reserved.
//

#include <stdio.h>

#define MAX 10

int main(int argc, const char * argv[]) {
    int i, j, n = MAX;
    int array[MAX][MAX] = { 0 };
    
    for (i = 0; i < n; i++)
    {
        array[i][0] = 1;
        
        for (j = 1; j <= i; j++)
            array[i][j] = array[i - 1][j - 1] + array[i - 1][j];
    }
    
    // 打印二维数组中的三角形
    for (i = 0; i < n; i++)
    {
        for (j = 0; j <= i; j++)
            printf("%5d", array[i][j]);
        
        printf("\n");
    }
    
    return 0;
}
