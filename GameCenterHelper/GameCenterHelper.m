//
//  GameCenterHelper.m
//  DemoForGameCenter
//
//  Created by darklinden on 14-8-25.
//  Copyright (c) 2014年 darklinden. All rights reserved.
//

#import "GameCenterHelper.h"
#import <GameKit/GameKit.h>

@interface GameCenterHelper () <GKGameCenterControllerDelegate>

@end

@implementation GameCenterHelper

+ (void)auth
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    [localPlayer setAuthenticateHandler:(^(UIViewController *viewController, NSError *error){
        if (!error && viewController)
        {
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:viewController animated:YES completion:nil];
        }
        else
        {
            
        }
    })];
}

+ (BOOL)isAuthenticated
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    return localPlayer.isAuthenticated;
}

+ (void)loadTopScoleWithIds:(NSArray *)ids
                 completion:(void(^)(NSDictionary *scoles, NSDictionary *errors))completionHandle
{
    if (![self isAuthenticated]) {
        if (completionHandle) {
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            for (NSString *identifier in ids) {
                GKScore *s = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
                s.value = [self localTopScoleWithId:identifier];
                [dict setObject:@[s] forKey:identifier];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandle(dict, nil);
            });
        }
        return;
    }
    
    __block NSInteger count = 0;
    __block NSMutableDictionary *dict_result = [NSMutableDictionary dictionary];
    __block NSMutableDictionary *dict_err = [NSMutableDictionary dictionary];
    
    void(^allComplete)(NSArray *scoles, NSString *category, NSError *error) =
    ^(NSArray *scoles, NSString *category, NSError *err)
    {
        count++;
        
        if (scoles && category) {
            [dict_result setObject:scoles forKey:category];
        }
        
        if (err && category) {
            [dict_err setObject:err forKey:category];
        }
        
        if (count == ids.count) {
            if (completionHandle) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandle(dict_result, dict_err);
                });
            }
        }
    };
    
    for (NSString *identifier in ids) {
        [self loadTopScoleWithId:identifier completion:allComplete];
    }
}

+ (void)loadTopScoleWithId:(NSString *)identifier
                completion:(void(^)(NSArray *scole, NSString *category, NSError *error))completionHandle
{
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
	GKLeaderboard* leaderBoard = [[GKLeaderboard alloc] initWithPlayerIDs:@[player.playerID]];
	leaderBoard.identifier = identifier;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error)
     {
         GKScore *s = [scores firstObject];
         [self saveLocalScoleWithId:identifier value:s.value];
         
         if (completionHandle) {
             dispatch_async(dispatch_get_main_queue(), ^(void)
             {
                 completionHandle(scores, identifier, error);
             });
         }
     }];
}

+ (void)uploadScoleWithIds:(NSDictionary *)scoles
                completion:(void(^)(NSError *error))completionHandle
{
    for (NSString *identifier in scoles.allKeys) {
        NSNumber *num = scoles[identifier];
        [self saveLocalTopScoleWithId:identifier value:num.longLongValue];
    }
    
    if (![self isAuthenticated]) {
        if (completionHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandle(nil);
            });
        }
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *identifier in scoles.allKeys) {
        NSNumber *num = scoles[identifier];
        
        GKScore *scoreObj = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
        scoreObj.value = num.longLongValue;
        [array addObject:scoreObj];
    }
    
	[GKScore reportScores:array withCompletionHandler:^(NSError *err)
    {
        if (completionHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandle(err);
            });
        }
    }];
}

+ (void)saveLocalTopScoleWithId:(NSString *)identifier value:(int64_t)value
{
    int64_t s = [self localTopScoleWithId:identifier];
    
    s = MAX(value, s);
    
    [self saveLocalScoleWithId:identifier value:s];
}

+ (void)saveLocalScoleWithId:(NSString *)identifier value:(int64_t)value
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:@(value) forKey:identifier];
    [df synchronize];
}

+ (int64_t)localTopScoleWithId:(NSString *)identifier
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [df objectForKey:identifier];
    int64_t s = num.longLongValue;
    return s;
}

+ (void)showList
{
    GKGameCenterViewController *leaderboardController = [[GKGameCenterViewController alloc] init];
	if (leaderboardController)
	{
//		leaderboardController.leaderboardIdentifier = kEasyLeaderboardID; //self.currentLeaderBoard;
        //		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.gameCenterDelegate = [self sharedGameCenterDelegate];
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if (root.presentedViewController || root.presentingViewController) {
            [root dismissViewControllerAnimated:NO completion:nil];
        }
		[root presentViewController:leaderboardController animated:YES completion:nil];
	}
}

+ (GameCenterHelper *)sharedGameCenterDelegate
{
    __strong static GameCenterHelper *helper = nil;
    if (!helper) {
        helper = [[GameCenterHelper alloc] init];
    }
    return helper;
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (root.presentedViewController || root.presentingViewController) {
        [root dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
