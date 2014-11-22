//
//  AppMacro.h
//  iOS_News
//
//  Created by Master on 2014/11/20.
//  Copyright (c) 2014年 net.masuhara. All rights reserved.
//

#ifndef iOS_News_AppMacro_h
#define iOS_News_AppMacro_h

#define SHOW_LOG 1 // ログを表示する:SHOW_LOG 1 ログを表示しない：SHOW_LOG 0
#define LOG(A, ...) if (SHOW_LOG) NSLog(@"DEBUG: %s:%d:%@", __PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:A, ## __VA_ARGS__]);

// Pastel White
#define BASE_COLOR    [UIColor colorWithRed:247/255.0f green:246/255.0f blue:252/255.0f alpha:1.0]

// Sakura Color
#define CONSEPT_COLOR    [UIColor colorWithRed:248/255.0f green:235/255.0f blue:245/255.0f alpha:1.0]

// Red
#define ACCENT_COLOR    [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0]




#endif
