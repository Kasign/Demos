//
//  String.h
//  通讯录
//
//  Created by qiuShan on 2017/11/8.
//  Copyright © 2017年 walg. All rights reserved.
//

#ifndef String_h
#define String_h

#include <stdio.h>
#include <stdlib.h>

typedef struct _tagString{
    char * buf;
    int  length;
}String;

String * StringCreat();

void StringDestory(String *ptr);

void StringSet(String *pStr, char *pBuf);

char * StringGet(String *pStr);

void StringCopy(String *pStr,String *sStr);

void StringAppending(String *pStr,char *sBuf);

#endif /* String_h */
