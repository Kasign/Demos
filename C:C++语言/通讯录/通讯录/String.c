//
//  String.c
//  通讯录
//
//  Created by qiuShan on 2017/11/8.
//  Copyright © 2017年 walg. All rights reserved.
//

#include "String.h"

String * StringCreat()
{
    String * ptr = (String*)malloc(sizeof(String));
    ptr->buf = (char*)malloc(100*sizeof(char));
    ptr->buf[0] = '\0';
    ptr->length = 0;
    return ptr;
}

void StringDestory(String *ptr)
{
    
    if (ptr == NULL) {
        return;
    }
    if (ptr->buf != NULL) {
        free(ptr->buf);
        ptr->buf = NULL;
        ptr->length = 0;
    }
}

void StringInit(String *ptr)
{
    ptr ->buf[0] = 0;
    ptr ->length = 0;
}

void StringSet(String* pStr, char* pBuf)
{
    int i = 0;
    while (*pBuf!= 0) {
        pStr ->buf[i++] = *pBuf++;
    }
    pStr->buf[i] = 0;
    pStr->length = i;
}

char * StringGet(String * pStr)
{
    return pStr->buf;
}

void StringCopy(String * pStr,String * sStr)
{
    StringSet(pStr, sStr->buf);
}

void StringAppending(String *pStr,char *sBuf)
{
    int i = pStr->length;
    while (*sBuf != 0) {
        pStr->buf[i++] = *sBuf++;
    }
    pStr->buf[i] = 0;
    pStr->length = i;
}
