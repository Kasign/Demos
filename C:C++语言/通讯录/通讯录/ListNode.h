//
//  ListNode.h
//  通讯录
//
//  Created by qiuShan on 2017/11/13.
//  Copyright © 2017年 walg. All rights reserved.
//

#ifndef ListNode_h
#define ListNode_h

#include <stdio.h>
#include <stdlib.h>
#include "Record.h"

typedef struct _tagListNode{
    Record* _pR;
    struct _tagListNode* _pPre;
    struct _tagListNode* _pNext;
}ListNode;



void ListInit(void);
void ListDestroy(void);
void ListAdd(Record* pR);
void ListDel(ListNode* pNode);
Record* ListFind(char* pStrName);

int ListCount(void);

void ListTraverShow(void);

#endif /* ListNode_h */
