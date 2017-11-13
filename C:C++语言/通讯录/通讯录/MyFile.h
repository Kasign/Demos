//
//  MyFile.h
//  通讯录
//
//  Created by qiuShan on 2017/11/13.
//  Copyright © 2017年 walg. All rights reserved.
//

#ifndef MyFile_h
#define MyFile_h

#include <stdio.h>

#define FOR_READ        0
#define FOR_WRITE        1

FILE* fp;

extern int OpenFile(char* pFileName, int nOperate);
extern void CloseFile(void);

extern char* ReadLine(void);
extern int WriteLine(char* pLine);

#endif /* MyFile_h */
