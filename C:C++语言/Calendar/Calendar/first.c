//
//  first.c
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#include "first.h"
#include "alluse.h"
#include "Month.h"

FYMonth g_Month[12];

void CalendarPrintFirst(){
    int i, j, k;
    int week;
    int days;
    int year = 2017;
    char* pStr;
    
    FYMonth * pCurMonth;
    FYString * str;
    
    str = (FYString*)malloc(sizeof(str));
    
    // 计算当年的1月1日是周几的公式，同时在输出过程中随时表示每一天是星期几
    week = GetWeek(year);
    
    for (i = 0; i < 12; i++)
    {
        // pCurMonth指向当前的月份
        pCurMonth = &g_Month[i];
        
        // 填写月份名称
        char *name = MonthName(i + 1);
        pStr = name;
        SetMonthName(pCurMonth, pStr);
        
        StringInit(str);
        for (k = 0; k < week; k++)
        {
            sprintf(pStr, "    ");
            StringAppending(str, pStr);
        }
        
        // 这个月的每一天和星期对齐输出
        days = GetDays(year, i + 1);
        for (j = 1; j <= days; j++)
        {
            sprintf(pStr, "%3d ", j);
            StringAppending(str, pStr);
            
            if (++week >= 7)
            {
                AddDaysLine(pCurMonth, str);
                week = week % 7;
                
                StringInit(str);
            }
        }
        
        // 填写一行日期字符串
        AddDaysLine(pCurMonth, str);
    }
    
    // 打印12个月的日历
    for (i = 0; i < 12; i++)
    {
        PrintMonth(&g_Month[i]);
        printf("\n");
    }
}
