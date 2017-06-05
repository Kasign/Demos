//
//  main.c
//  通讯录
//
//  Created by walg on 2017/4/18.
//  Copyright © 2017年 walg. All rights reserved.
//

#include <stdio.h>


void CleanScreen();


int main(int argc, const char * argv[]) {
    
    int nMenu = 0;
    
    while (1)
    {
        printf("==== 通讯录 ====\n");
        printf("1. 录入\n");
        printf("2. 查询\n");
        printf("0. 退出\n");
        printf("----------------\n");
        printf("请输入要使用的功能：");
        
        scanf("%d", &nMenu);
        
        switch (nMenu)
        {
            case 0:
                // 退出
                break;
            case 1:
                // 新增
                break;
            case 2:
                // 查询
                break;
            default:
                break;
        }
        
        CleanScreen();
    }
    
    
    return 0;
}

void CleanScreen()
{
    system("cls");
}
