//
//  ListNode.c
//  通讯录
//
//  Created by qiuShan on 2017/11/13.
//  Copyright © 2017年 walg. All rights reserved.
//

#include "ListNode.h"

ListNode* g_pL;
ListNode* g_pCur;
int g_ListCount;

void ListInit()
{
    g_pL = (ListNode*)malloc(sizeof(ListNode));
    g_pCur = g_pL;
    
    g_pCur->_pR = NULL;
    g_pCur->_pPre = NULL;
    g_pCur->_pNext = NULL;
    g_ListCount = 0;
}

void ListDestroy()
{
    for (g_pCur = g_pL; g_pCur !=NULL; ) {
        RecordDestory(g_pCur->_pR);
        g_pL = g_pCur->_pNext;
        free(g_pCur);
        g_pCur = g_pL;
    }
    g_ListCount = 0;
}

void ListAdd(Record* pR)
{
    
    g_pCur->_pR = pR;
    
    ListNode* pNode = (ListNode*)malloc(sizeof(ListNode));
    
    g_pCur->_pNext = pNode;
    pNode->_pNext = NULL;
    pNode->_pPre = g_pCur;
    g_pCur = g_pCur->_pNext;
    
    g_pCur->_pR = NULL;
    g_pCur->_pNext = NULL;
    
    g_ListCount++;

}

void ListDel(ListNode* pNode)
{
    if (g_ListCount<1) {
        return;
    }
    if (pNode->_pPre == NULL){
        g_pL = g_pL->_pNext;
        g_pL->_pPre = NULL;
    }else if (pNode->_pNext == NULL){
        pNode->_pPre->_pNext = NULL;
    }else{
        pNode->_pPre->_pNext = pNode->_pNext;
        pNode->_pNext->_pPre = pNode->_pPre;
    }
    RecordDestory(pNode->_pR);
    free(pNode);
    g_ListCount--;
}

int ListCount()
{
    return g_ListCount;
}

Record* ListFind(char* pStrName)
{
    ListNode* pNode;
    for (pNode = g_pL; pNode->_pR != NULL; pNode = pNode->_pNext)
    {
        int result = strcmp((const char*)pNode->_pR->_pStrName->buf,(const char*)pStrName);
        if (result == 0)
        {
            return pNode->_pR;
        }
    }
    
    return NULL;
}

void ListTraverShow()
{
    ListNode* pNode;
    for (pNode = g_pL; pNode->_pR != NULL; pNode = pNode->_pNext) {
        PrintRecord(pNode->_pR);
    }
}
