//
//  main.c
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#include <stdio.h>
#include "first.h"
#include "second.h"
#include "Month.h"

int main(int argc, const char * argv[]) {
    
//    CalendarPrintFirst();
    
//    CalendarPrintSecond();
    FYMonth month[12];
    
    int i;
    for (i = 0; i < 12; i++)
    {
        PrintMonth(&month[i]);
        printf("\n");
    }
    
    
    return 0;
}
