//
//  GameCenterHelper.h
//  DemoForGameCenter
//
//  Created by darklinden on 14-8-25.
//  Copyright (c) 2014年 darklinden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCenterHelper : NSObject

+ (void)auth;
+ (BOOL)isAuthenticated;

//scole only support int type and high to low sort

+ (void)loadTopScoleWithIds:(NSArray *)ids
                 completion:(void(^)(NSDictionary *scoles, NSDictionary *errors))completionHandle;

+ (void)uploadScoleWithIds:(NSDictionary *)scoles
                 completion:(void(^)(NSError *error))completionHandle;

+ (void)showList;

+ (int64_t)localTopScoleWithId:(NSString *)identifier;

+ (void)saveLocalTopScoleWithId:(NSString *)identifier value:(int64_t)value;

@end
