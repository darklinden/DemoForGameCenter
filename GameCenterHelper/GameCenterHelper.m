//
//  GameCenterHelper.m
//  DemoForGameCenter
//
//  Created by darklinden on 14-8-25.
//  Copyright (c) 2014年 darklinden. All rights reserved.
//

#import "GameCenterHelper.h"
#import "V_loading.h"

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

+ (void)loadTopScoreWithIds:(NSArray *)ids
                 completion:(void(^)(NSDictionary *scores, NSDictionary *errors))completionHandle
{
    __block NSInteger count = 0;
    __block NSMutableDictionary *dict_result = [NSMutableDictionary dictionary];
    __block NSMutableDictionary *dict_err = [NSMutableDictionary dictionary];
    
    for (NSString *identifier in ids) {
        GKScore *s = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
        s.value = [self localTopScoreWithId:identifier];
        [dict_result setObject:@[s] forKey:identifier];
    }
    
    if (![self isAuthenticated]) {
        if (completionHandle) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandle(dict_result, nil);
            });
        }
        return;
    }
    
    void(^allComplete)(NSArray *scores, NSString *category, NSError *error) =
    ^(NSArray *scores, NSString *category, NSError *err)
    {
        count++;
        
        if (scores && category) {
            [dict_result setObject:scores forKey:category];
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
        [self loadTopScoreWithId:identifier completion:allComplete];
    }
}

+ (void)loadTopScoreWithId:(NSString *)identifier
                completion:(void(^)(NSArray *score, NSString *category, NSError *error))completionHandle
{
    GKLocalPlayer *player = [GKLocalPlayer localPlayer];
	GKLeaderboard* leaderBoard = [[GKLeaderboard alloc] initWithPlayerIDs:@[player.playerID]];
	leaderBoard.identifier = identifier;
	leaderBoard.timeScope= GKLeaderboardTimeScopeAllTime;
	leaderBoard.range= NSMakeRange(1, 1);
	
	[leaderBoard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error)
     {
         GKScore *s = [scores firstObject];
         [self saveLocalScoreWithId:identifier value:s.value];
         
         if (completionHandle) {
             dispatch_async(dispatch_get_main_queue(), ^(void)
             {
                 completionHandle(scores, identifier, error);
             });
         }
     }];
}

+ (void)uploadScoreWithIds:(NSDictionary *)scores
                completion:(void(^)(NSError *error))completionHandle
{
    for (NSString *identifier in scores.allKeys) {
        NSNumber *num = scores[identifier];
        [self saveLocalTopScoreWithId:identifier value:num.longLongValue];
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
    
    for (NSString *identifier in scores.allKeys) {
        NSNumber *num = scores[identifier];
        
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

+ (void)saveLocalTopScoreWithId:(NSString *)identifier value:(int64_t)value
{
    int64_t s = [self localTopScoreWithId:identifier];
    
    s = MAX(value, s);
    
    [self saveLocalScoreWithId:identifier value:s];
}

+ (void)saveLocalScoreWithId:(NSString *)identifier value:(int64_t)value
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setObject:@(value) forKey:identifier];
    [df synchronize];
}

+ (int64_t)localTopScoreWithId:(NSString *)identifier
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
		leaderboardController.gameCenterDelegate = [self sharedGameCenterDelegate];
        UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if (root.presentedViewController || root.presentingViewController) {
            [root dismissViewControllerAnimated:NO completion:nil];
        }
        [V_loading showLoadingView:nil title:nil message:nil];
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
    [V_loading removeLoading];
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (root.presentedViewController || root.presentingViewController) {
        [root dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
