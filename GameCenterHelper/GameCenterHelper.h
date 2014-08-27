//
//  GameCenterHelper.h
//  DemoForGameCenter
//
//  Created by darklinden on 14-8-25.
//  Copyright (c) 2014年 darklinden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterHelper : NSObject

+ (void)auth;
+ (BOOL)isAuthenticated;

//score only support int type and high to low sort

+ (void)loadTopScoreWithIds:(NSArray *)ids
                 completion:(void(^)(NSDictionary *scores, NSDictionary *errors))completionHandle;

+ (void)uploadScoreWithIds:(NSDictionary *)scores
                 completion:(void(^)(NSError *error))completionHandle;

+ (void)showList;

+ (int64_t)localTopScoreWithId:(NSString *)identifier;

+ (void)saveLocalTopScoreWithId:(NSString *)identifier value:(int64_t)value;

@end
