//
//  F_String.c
//  Calendar
//
//  Created by qiuShan on 2017/11/6.
//  Copyright © 2017年 Fly. All rights reserved.
//

#include "F_String.h"

void StringInit(FYString*ptr)
{
    ptr ->buf[0] = 0;
    ptr ->length = 0;
}

void StringSet(FYString* pStr, char* pBuf)
{
    int i = 0;
    while (*pBuf!= 0) {
        pStr ->buf[i++] = *pBuf++;
    }
    pStr->buf[i] = 0;
    pStr->length = i;
}

char * StringGet(FYString * pStr)
{
    return pStr->buf;
}

void StringCopy(FYString * pStr,FYString * sStr)
{
    StringSet(pStr, sStr->buf);
}

void StringAppending(FYString *pStr,char *sBuf)
{
    int i = pStr->length;
    while (*sBuf != 0) {
        pStr->buf[i++] = *sBuf++;
    }
    pStr->buf[i] = 0;
    pStr->length = i;
}

