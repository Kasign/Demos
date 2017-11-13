//
//  F_String.h
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#ifndef F_String_h
#define F_String_h

#include <stdio.h>

typedef struct _tagString{
    char buf[100];
    int  length;
}FYString;

void StringInit(FYString *ptr);

void StringSet(FYString *pStr, char *pBuf);

char * StringGet(FYString *pStr);

void StringCopy(FYString *pStr,FYString *sStr);

void StringAppending(FYString *pStr,char *sBuf);


#endif /* F_String_h */
