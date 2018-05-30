//
//  SpeLog.h
//  JZH_BASE
//
//  Created by Points on 13-11-22.
//  Copyright (c) 2013年 Points. All rights reserved.
//


#ifdef DEBUG
#define SpeLog(frmt, ...)  LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#else
#define SpeLog(frmt, ...)  LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#endif


#ifdef DEBUG
#define SpeAssert(e) assert(e)
#else
#define SpeAssert(e)
#endif

