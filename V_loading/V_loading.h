//
//  V_loading.h
//  iSafeBox4iPhone
//
//  Created by William.zhou on 18/05/2012.
//  Copyright (c) 2012 darklinden.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LoadingViewType_Default = 0,
    LoadingViewType_Top = 1,
    LoadingViewType_Center = 2,
    LoadingViewType_Bottom = 3,
    LoadingViewType_iPadFormSheet = 4
} LoadingViewType;

typedef void(^LoadingBlock)(void);

@interface V_loading : UIView

//old function
+ (void)showLoadingView:(UIView *)aView
                    tag:(NSInteger)tag
                  title:(NSString *)title
                message:(NSString *)message
               viewType:(LoadingViewType)type;

//old function
+ (void)removeLoadingView:(UIView *)aView;

+ (void)showLoadingView:(UIView *)aView
                  title:(NSString *)title
                message:(NSString *)message;

+ (void)removeLoading;

+ (void)loadingInView:(UIView *)aView
                title:(NSString *)title
              message:(NSString *)message
         loadingBlock:(LoadingBlock)workingBlock;

@end
