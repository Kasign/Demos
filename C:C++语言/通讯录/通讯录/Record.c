//
//  Record.c
//  通讯录
//
//  Created by qiuShan on 2017/11/8.
//  Copyright © 2017年 walg. All rights reserved.
//

#include "Record.h"

void RecordInit(Record ** pR)
{
    *pR = (Record*)malloc(sizeof(Record));
    (*pR)->_pStrName = StringCreat();
    (*pR)->_pStrPs = StringCreat();
    (*pR)->_pStrTel = StringCreat();
}

void RecordDestory(Record * pR)
{
    if (pR != NULL) {
        StringDestory(pR->_pStrName);
        StringDestory(pR->_pStrPs);
        StringDestory(pR->_pStrTel);
        free(pR);
        pR = NULL;
    }
}

void RecordSetName(Record*pR,char *pBuf)
{
    StringSet(pR->_pStrName, pBuf);
}
void RecordSetTel(Record *pR,char *pBuf)
{
    StringSet(pR->_pStrTel, pBuf);
}
void RecordSetPs(Record *pR,char *pBuf)
{
    StringSet(pR->_pStrPs, pBuf);
}

void PrintRecord(Record * pR)
{
    printf("========================\n");
    printf("通讯录\n");
    printf("姓名：%s\n",StringGet(pR->_pStrName));
    printf("电话：%s\n",StringGet(pR->_pStrTel));
    printf("备注：%s\n",StringGet(pR->_pStrPs));
    printf("========================\n");
}
