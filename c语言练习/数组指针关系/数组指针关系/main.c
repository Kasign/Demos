//
//  main.c
//  打印日历
//
//  Created by walg on 2017/4/13.
//  Copyright © 2017年 walg. All rights reserved.
//

#include <stdio.h>

char g_month[12][10] = {"January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"};

int g_days[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

// 通过月份数字打印月份名称
void PrintMonth(int month)
{
    printf("%s", g_month[month - 1]);
}

// 判断闰年，是闰年返回1，是平年返回0
int IsLeapYear(int year)
{
    if((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0))
        return 1;
    else
        return 0;
}

// 返回输入年份的1月1日是周几
int GetWeek(int year)
{
    return (35 + year + year / 4 - year / 100 + year / 400) % 7;
}

// 返回输入的年份中输入的月份天数
int GetDays(int year, int month)
{
    if (month == 2 && IsLeapYear(year))
    {
        return g_days[month - 1] + 1;
    }
    else
    {
        return g_days[month - 1];
    }
}

int main(int argc, const char * argv[]) {

    int i, j, k;
    int week;
    int days;
    int year = 2017;
    
    // 计算当年的1月1日是周几的公式
    week = GetWeek(year);
    
    for(i = 0; i < 12; i++)
    {
        printf("\n");
        
        PrintMonth(i + 1);
        
        printf("\n");
        
        printf("---------------------------\n");
        printf("Sun Mon Tue Wed Thu Fri Sat\n");
        
        for(k = 0; k < week; k++)
            printf("       "); // 每月一号对齐它的星期数
        
        // 这个月的每一天和星期对齐输出
        days = GetDays(year, i + 1);
        for(j = 1; j <= days; j++)
        {
            printf("%4d ", j);
            if(++week >= 7)
            {
                printf("\n");
                week = week % 7;
            }
        }
        printf("\n");
    }
    return 0;
}
