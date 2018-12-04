//
//  Header.h
//  DiyCollectionView
//
//  Created by 66-admin-qs. on 2018/12/3.
//  Copyright © 2018 Fly. All rights reserved.
//

#ifndef Header_h
#define Header_h

#ifdef DEBUG
#define FlyLog(FORMAT, ...) fprintf(stderr, "\n%s\n",[[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define FlyLog(FORMAT, ...) nil
#endif

#endif /* Header_h */
