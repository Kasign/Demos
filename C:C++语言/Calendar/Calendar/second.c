//
//  second.c
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#include "second.h"
#include "alluse.h"
#include "Month.h"

FYMonth month[12];

void CalendarPrintSecond(){
    
    int year = 2017;
    
    FYMonth * purMonth;
    FYString str;
    char * pChar;
    
    int week = GetWeekWithMonth(year, 1);
    
    for (int i = 1; i <= 12; i++) {
        
        purMonth = &month[i];
        
        pChar = MonthName(i);
        
        SetMonthName(purMonth, pChar);
        
        StringInit(&str);
        for (int j = 0; j<week; j++) {
            sprintf(pChar, "    ");
            StringAppending(&str, pChar);
        }
        
        int days = GetDays(year, i);
        
        for (int k = 1; k <= days; k++) {
            sprintf(pChar,"%3d ",k);
            StringAppending(&str, pChar);
            
            if (++week >= 7) {
                AddDaysLine(purMonth, &str);
                week = week%7;
                StringInit(&str);
            }
        }
        AddDaysLine(purMonth, &str);
    }
    
    for (int i = 1; i<=12; i++) {
        
        FYMonth leftMonth = month[i];
        FYMonth rightMonth = month[++i];
        
        PrintTwoMonth(&leftMonth, &rightMonth);
        printf("\n");
    }
    
    
    
}
