//
//  first.c
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#include "first.h"
#include "alluse.h"


void CalendarPrintFirst(){
    int i,j,k;
    int week;
    int days;
    int year = 2017;
    
    // 计算当年的1月1日是周几的公式
    week = GetWeek(year,1);
    
    for(i = 0; i < 12; i++)
    {
       
        printf("\n");
        
        
        MonthPrintf(i + 1);
        
        printf("\n");
        
        printf("---------------------------\n");
        
        printf("Sun Mon Tue Wed Thu Fri Sat\n");
        
        for(k = 0; k < week; k++){
            printf("    "); // 每月一号对齐它的星期数
        }
        
        // 这个月的每一天和星期对齐输出
        days = GetDays(year, i + 1);
        for(j = 1; j <= days; j++)
        {
            printf("%3d ", j);
            
            if(++week >= 7)
            {
                printf("\n");
                week = week % 7;
            }
        }
        printf("\n");
    }
    
}
