//
//  support.cpp
//  String_test
//
//  Created by walg on 2017/8/25.
//  Copyright © 2017年 walg. All rights reserved.
//

#include <stdio.h>
#include <iostream>

extern int count;

void write_cpp(void){
    std::cout << count<<std::endl;
};

void exchange_point(int *x,int *y){
    int temp;
    temp = *x;	/* 保存地址 x 的值 */
    *x = *y;		/* 把 y 赋值给 x */
    *y = temp;	/* 把 x 赋值给 y */
};

void exchange_value(int x,int y){
    int temp;
    temp = x; /* 保存地址 x 的值 */
    x = y;    /* 把 y 赋值给 x */
    y = temp; /* 把 x 赋值给 y  */
    
};

void exchange_int(int &x,int &y){
    int temp;
    temp = x; /* 保存地址 x 的值 */
    x = y;    /* 把 y 赋值给 x */
    y = temp; /* 把 x 赋值给 y  */
    
};
