//
//  Record.h
//  通讯录
//
//  Created by qiuShan on 2017/11/8.
//  Copyright © 2017年 walg. All rights reserved.
//

#ifndef Record_h
#define Record_h

#include <stdio.h>
#include <stdlib.h>

#include "String.h"

typedef struct _tagRecord{
    String * _pStrName;
    String * _pStrTel;
    String * _pStrPs;
}Record;

void RecordInit(Record ** pR);
void RecordDestory(Record * pR);

void RecordSetName(Record*pR,char *pBuf);
void RecordSetTel(Record *pR,char *pBuf);
void RecordSetPs(Record *pR,char *pBuf);

void PrintRecord(Record * pR);

#endif /* Record_h */
