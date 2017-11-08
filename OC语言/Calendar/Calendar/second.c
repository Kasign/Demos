//
//  second.c
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#include "second.h"
#include "alluse.h"

void CalendarPrintSecond(){
    
    int year = 2017;
    
    int week1,week2;
    
    
    
    
    
    for (int i = 0; i < 12; i=i+2 ) {
        
        int k2 = 0;
        
        MonthPrintf(i+1);
        printf("                        ");
        MonthPrintf(i+2);
        printf("\n---------------------------       ---------------------------\n");
        
        printf("Sun Mon Tue Wed Thu Fri Sat");
        printf("       ");
        printf("Sun Mon Tue Wed Thu Fri Sat");
        
        printf("\n");
        
        int days1 =  GetDays(year, i+1);
        int days2 =  GetDays(year, i+2);
        
        week1 = GetWeek(year, i+1);
        week2 = GetWeek(year, i+2);
        
        for (int j = 0; j<week1; j++) {
            printf("    ");
        }
        
        
        for (int k1 = 0; k1 < days1; k1++) {
            
            printf("%3d ",k1+1);
            week1++;
            if (week1 >= 7) {
                printf("      ");
                week1 = week1%7;
                
                for ( ; k2 < days2; k2++) {
                    
                    if (k2 == 0) {
                        for (int j = 0; j<week2; j++) {
                            printf("    ");
                        }
                    }
                    printf("%3d ",k2+1);
                    week2++;
                    if (week2 >= 7) {
                        printf("\n");
                        week2 = week2%7;
                        break;
                    }
                }
                
            }
            
        }
        
        
        printf("\n");
        printf("\n");
    }
    
}
