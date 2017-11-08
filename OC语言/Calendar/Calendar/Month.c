//
//  Month.c
//  Calendar
//
//  Created by qiuShan on 2017/11/7.
//  Copyright © 2017年 Fly. All rights reserved.
//

#include "Month.h"

void PrintMonth(FYMonth* pMonth)
{
    int i;
    
    // 打印月名
    printf("%27s\n", pMonth->monthName.buf);
    // 打印分割线
    printf("----------------------------\n");
    // 打印星期列表
    printf("Sun Mon Tue Wed Thu Fri Sat\n");
    // 打印每行日期列表
    for (i = 0; i < pMonth->_lineCount; i++)
    {
        printf("%27s\n", pMonth->_arrayDays[i].buf);
    }
}

void SetMonthName(FYMonth* pMonth, char* pBuf)
{
    StringSet(&pMonth->monthName, pBuf);
}

// 在Month的_arrayDays中添加一行新字符串
void AddDaysLine(FYMonth* pMonth, FYString* pStr)
{
    StringAppending(pStr, "                             ");
    
    pStr->buf[27] = 0;
    pStr->length = 27;
    
    StringCopy(&pMonth->_arrayDays[pMonth->_lineCount++], pStr);
}

char* GetMonthName(FYMonth* pMonth)
{
    return pMonth->monthName.buf;
}

// 返回日期列表的字符串数组
FYString* GetDaysArray(FYMonth* pMonth)
{
    return pMonth->_arrayDays;
}

// 返回日期列表的行数
int GetDaysArraySize(FYMonth* pMonth)
{
    return pMonth->_lineCount;
}


