//
//  alluse.h
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#ifndef alluse_h
#define alluse_h

#include <stdio.h>

/**
 月份名字[]首地址

 @param num 月份
 @return char[] 首地址
 */
char * MonthName(int num);

int IsLeapYear(int year);

int GetWeek(int year);

int GetWeekWithMonth(int year,int month);

int GetDays(int year,int month);

void MonthPrintf(int month);



#endif /* alluse_h */
