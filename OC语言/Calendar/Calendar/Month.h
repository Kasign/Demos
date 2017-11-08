//
//  Month.h
//  Calendar
//
//  Created by qiuShan on 2017/11/7.
//  Copyright © 2017年 Fly. All rights reserved.
//

#ifndef Month_h
#define Month_h

#include <stdio.h>
#include "F_String.h"

typedef struct _month{
    FYString  monthName;
    FYString  _arrayDays[6];
    int       _lineCount;
}FYMonth;

void SetMonthName(FYMonth* pMonth, char* pBuf);

void AddDaysLine(FYMonth* pMonth, FYString* pStr);

char* GetMonthName(FYMonth* pMonth);

FYString* GetDaysArray(FYMonth* pMonth);

int GetDaysArraySize(FYMonth* pMonth);

void PrintMonth(FYMonth* pMonth);


#endif /* Month_h */
