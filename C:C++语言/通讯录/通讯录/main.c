//
//  main.c
//  通讯录
//
//  Created by walg on 2017/4/18.
//  Copyright © 2017年 walg. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "Record.h"
#include "ListNode.h"

void CreatRecord(void);
void SearchRecord(void);
void CleanScreen(void);
void SaveRecord(Record* pR);
void FindRecord(void);


int main(int argc, const char * argv[]) {
    ListInit();
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
                exit(1);
                break;
            case 1:
                // 新增
                CreatRecord();
                break;
            case 2:
                // 查询
                FindRecord();
                break;
            default:
                break;
        }
        
        CleanScreen();
    }
    
    
    return 0;
}

void CreatRecord()
{
    int loop = 1;
    char str[50];
    int t;
    
    while (loop) {
        gets(str);
        CleanScreen();
        Record * pR;
        RecordInit(&pR);
     
        printf("----开始录入-----\n");
        printf("输入姓名：");
        gets(str);
        RecordSetName(pR, str);
        printf("\n");
        
        printf("电话：");
        gets(str);
        RecordSetTel(pR, str);
        printf("\n");
        
        printf("备注：");
        gets(str);
        RecordSetPs(pR, str);
        printf("\n");
        
        printf("-------------------\n");
        printf("输入的内容：\n");
        printf("-------------------\n");
        printf("姓名：%s\n", StringGet(pR->_pStrName));
        printf("电话：%s\n", StringGet(pR->_pStrTel));
        printf("备注：%s\n", StringGet(pR->_pStrPs));
        
        printf("\n下一步\n");
        printf("是否保存？Y/N\n");
       
        if (getchar() == 'Y') {
            //保存
            SaveRecord(pR);
        }else{
            //放弃
        }
        printf("\n");
        
        ListTraverShow();
        
        printf("----------------\n");
        printf("1.继续录入\n");
        printf("0.结束\n");
        printf("----------------\n");
        printf("请输入要使用的功能：");
        
        scanf("%d",&t);
        if (t != 1) {
            loop = 0;
        }
    }
}

void SaveRecord(Record* pR)
{
    ListAdd(pR);
}

void FindRecord()
{
    char str[50];
    
    gets(str); // Remove '\t'
    CleanScreen();
    
    printf("==== 查找记录 ====\n\n");
    
    printf("请输入需要查找的姓名：\n");
    printf("姓名：");
    
    gets(str);
    
    Record* pRecord = ListFind(str);
    
    if (pRecord == NULL)
    {
        printf("未找到%s的资料。\n", str);
    }
    else
    {
        PrintRecord(pRecord);
    }
    
    system("pause");
}

void CleanScreen()
{
    system("cls");
}
