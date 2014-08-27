//
//  V_loading.m
//  iSafeBox4iPhone
//
//  Created by William.zhou on 18/05/2012.
//  Copyright (c) 2012 darklinden.com. All rights reserved.
//

#import "V_loading.h"
#import <QuartzCore/QuartzCore.h>
#import "O_weak_list.h"
#import "SimpleConstraint.h"

//#warning for contact manager only
//#import "VC_upgrade.h"

#define titleFont                   [UIFont fontWithName:@"Helvetica" size:12.f]
#define messageFont                 [UIFont fontWithName:@"Helvetica" size:15.f]
#define CGFloat_MaxLine_Width       280.0f
#define CGFloat_MaxLine_Height      748.f
#define CGFloat_MinLine_Width       120.0f
#define CGFloat_TitleLine_Height    65.0f

#pragma mark - V_loading private property

@interface V_loading ()

@property (strong, nonatomic) UIView        *pV_content;
@property (unsafe_unretained) LoadingBlock  block_loading;

- (void)doRunBlock;

@end

#pragma mark - O_loading_mgr private property

@interface O_loading_mgr : NSObject
@property (strong, nonatomic) NSTimer       *pTmr_gc;
@property (strong, nonatomic) O_weak_list   *pList_loading;

+ (O_loading_mgr *)shared_mgr;

- (void)showLoadingView:(UIView *)aView
                    tag:(NSInteger)tag
                  title:(NSString *)title
                message:(NSString *)message
               viewType:(LoadingViewType)type;

- (void)removeLoadingView:(UIView *)aView;

- (void)showLoadingView:(UIView *)aView
                  title:(NSString *)title
                message:(NSString *)message;

- (void)removeLoading;

- (void)loadingInView:(UIView *)aView
                title:(NSString *)title
              message:(NSString *)message
         loadingBlock:(LoadingBlock)workingBlock;

- (void)start_gc;
- (void)check_gc;

@end

#pragma mark - O_loading_mgr private property

@implementation O_loading_mgr

- (CGSize)messageSize:(NSString *)message
                 font:(UIFont *)font {
    if (!message) {
        return CGSizeMake(0.0, 0.0);
    }
    
    CGSize oneLineSize = [message sizeWithAttributes:@{NSFontAttributeName:font}];
    if (oneLineSize.width <= CGFloat_MinLine_Width) {
        return CGSizeMake(CGFloat_MinLine_Width, oneLineSize.height);
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect textRect = [message boundingRectWithSize:CGSizeMake(CGFloat_MaxLine_Width, CGFloat_MaxLine_Height)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle}
                                            context:nil];
    
    return textRect.size;
//    return [message sizeWithFont:font
//               constrainedToSize:CGSizeMake(CGFloat_MaxLine_Width, CGFloat_MaxLine_Height)
//                   lineBreakMode:NSLineBreakByWordWrapping];
}

- (UIView *)loadingInView:(UIView *)aView
                    title:(NSString *)title
                  message:(NSString *)message {
    
    NSString *stringForMessage = nil;
    if (message) {
        stringForMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    CGSize loadingSize;
    
    //Indicator view
    UIActivityIndicatorView *pV_indicator = nil;
    UILabel *pLb_title = nil;
    UILabel *pLb_message = nil;
    
    //Title
    if (title && ![title isEqualToString:@""]) {
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
        pLb_title = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, size.width, size.height)];
        [pLb_title setText:title];
        [pLb_title setFont:titleFont];
        [pLb_title setBackgroundColor:[UIColor clearColor]];
        [pLb_title setTextColor:[UIColor whiteColor]];
        
        if (message && ![message isEqualToString:@""]) {
            pV_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [pV_indicator startAnimating];
            
            CGSize messageSize = [self messageSize:message font:messageFont];
            
            if (CGFloat_TitleLine_Height + pLb_title.frame.size.width < CGFloat_MinLine_Width
                && messageSize.width < CGFloat_MinLine_Width) {
                loadingSize.width = CGFloat_MinLine_Width;
            }
            else {
                loadingSize.width = CGFloat_MaxLine_Width;
            }
            
            pLb_message = [[UILabel alloc] initWithFrame:CGRectMake(0, CGFloat_TitleLine_Height, loadingSize.width, messageSize.height)];
            [pLb_message setText:stringForMessage];
            pLb_message.numberOfLines = 0;
            [pLb_message setFont:messageFont];
            [pLb_message setTextAlignment:NSTextAlignmentCenter];
            [pLb_message setBackgroundColor:[UIColor clearColor]];
            [pLb_message setTextColor:[UIColor whiteColor]];
            
            loadingSize.height = CGFloat_TitleLine_Height + pLb_message.frame.size.height;
            
            CGRect indicatorFrame = pV_indicator.frame;
            indicatorFrame.origin.x = (loadingSize.width - pLb_title.frame.size.width - CGFloat_TitleLine_Height) / 2 + ((CGFloat_TitleLine_Height - indicatorFrame.size.width) / 2);
            indicatorFrame.origin.y = (CGFloat_TitleLine_Height - indicatorFrame.size.height) / 2;
            pV_indicator.frame = indicatorFrame;
            
            CGRect titleFrame = pLb_title.frame;
            titleFrame.origin.x = (loadingSize.width - pLb_title.frame.size.width - CGFloat_TitleLine_Height) / 2 + CGFloat_TitleLine_Height;
            titleFrame.origin.y = (CGFloat_TitleLine_Height - titleFrame.size.height) / 2;
            pLb_title.frame = titleFrame;
            
            CGRect messageFrame = pLb_message.frame;
            messageFrame.origin.x = 0.f;
            //wangzhipeng Update Start
            //            messageFrame.origin.y = CGFloat_TitleLine_Height;
            messageFrame.origin.y = CGFloat_TitleLine_Height-10;
            //wangzhipeng Update End
            pLb_message.frame = messageFrame;
        }
        else {
            pV_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [pV_indicator startAnimating];
            
            if (CGFloat_TitleLine_Height + pLb_title.frame.size.width < CGFloat_MinLine_Width) {
                loadingSize.width = CGFloat_MinLine_Width;
            }
            else {
                loadingSize.width = CGFloat_MaxLine_Width;
            }
            loadingSize.height = CGFloat_TitleLine_Height;
            
            CGRect indicatorFrame = pV_indicator.frame;
            indicatorFrame.origin.x = (loadingSize.width - pLb_title.frame.size.width - CGFloat_TitleLine_Height) / 2 + ((CGFloat_TitleLine_Height - indicatorFrame.size.width) / 2);
            indicatorFrame.origin.y = (CGFloat_TitleLine_Height - indicatorFrame.size.height) / 2;
            pV_indicator.frame = indicatorFrame;
            
            CGRect titleFrame = pLb_title.frame;
            titleFrame.origin.x = (loadingSize.width - pLb_title.frame.size.width - CGFloat_TitleLine_Height) / 2 + CGFloat_TitleLine_Height - 8.f;
            titleFrame.origin.y = (CGFloat_TitleLine_Height - titleFrame.size.height) / 2;
            pLb_title.frame = titleFrame;
        }
    }
    else {
        if (message && ![message isEqualToString:@""]) {
            pV_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [pV_indicator startAnimating];
            
            CGSize messageSize = [message sizeWithAttributes:@{NSFontAttributeName:messageFont}];
            if (messageSize.width < CGFloat_MinLine_Width) {
                loadingSize.width = CGFloat_MinLine_Width;
            }
            else {
                loadingSize.width = CGFloat_MaxLine_Width;
            }
            
            pLb_message = [[UILabel alloc] initWithFrame:CGRectMake(0, CGFloat_TitleLine_Height, loadingSize.width, messageSize.height)];
            [pLb_message setText:stringForMessage];
            pLb_message.numberOfLines = 0;
            [pLb_message setFont:messageFont];
            [pLb_message setTextAlignment:NSTextAlignmentCenter];
            [pLb_message setBackgroundColor:[UIColor clearColor]];
            [pLb_message setTextColor:[UIColor whiteColor]];
            
            loadingSize.height = CGFloat_TitleLine_Height + pLb_message.frame.size.height;
            
            CGRect indicatorFrame = pV_indicator.frame;
            indicatorFrame.origin.x = (loadingSize.width - indicatorFrame.size.width) / 2;
            indicatorFrame.origin.y = (CGFloat_TitleLine_Height - indicatorFrame.size.height) / 2;
            pV_indicator.frame = indicatorFrame;
            
            CGRect messageFrame = pLb_message.frame;
            messageFrame.origin.x = 0.f;
            messageFrame.origin.y = CGFloat_TitleLine_Height - 5.f;
            pLb_message.frame = messageFrame;
        }
        else {
            pV_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [pV_indicator startAnimating];
            
            loadingSize.width = CGFloat_MinLine_Width;
            loadingSize.height = CGFloat_TitleLine_Height;
            
            CGRect indicatorFrame = pV_indicator.frame;
            indicatorFrame.origin.x = (loadingSize.width - indicatorFrame.size.width) / 2;
            indicatorFrame.origin.y = (CGFloat_TitleLine_Height - indicatorFrame.size.height) / 2;
            pV_indicator.frame = indicatorFrame;
        }
    }
    
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, loadingSize.width, loadingSize.height)];
    loadingView.layer.cornerRadius = 10.0f;
    loadingView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.75];
    if (pV_indicator) {
        [loadingView addSubview:pV_indicator];
    }
    if (pLb_title) {
        [loadingView addSubview:pLb_title];
    }
    if (pLb_message) {
        [loadingView addSubview:pLb_message];
    }
    return loadingView;
}

+ (O_loading_mgr *)shared_mgr
{
    __strong static O_loading_mgr *pO_loading_mgr = nil;
    if (!pO_loading_mgr) {
        pO_loading_mgr = [[O_loading_mgr alloc] init];
    }
    return pO_loading_mgr;
}

- (O_weak_list *)pList_loading
{
    if (!_pList_loading) {
        _pList_loading = [O_weak_list list];
    }
    return _pList_loading;
}

- (void)showLoadingWithDictionary:(NSDictionary *)dict
{
    UIView *aView = [dict objectForKey:@"aView"];
    NSString *title = [dict objectForKey:@"title"];
    NSString *message = [dict objectForKey:@"message"];
    [self showLoadingInView:aView
                      title:title
                    message:message];
}

- (void)showLoadingWithDictionaryAndBlock:(NSDictionary *)dict
{
    UIView *aView = [dict objectForKey:@"aView"];
    NSString *title = [dict objectForKey:@"title"];
    NSString *message = [dict objectForKey:@"message"];
    void(^workingBlock)() = [dict objectForKey:@"workingBlock"];
    V_loading *pV_loading = [self showLoadingInView:aView
                                              title:title
                                            message:message];
    pV_loading.block_loading = workingBlock;
    [pV_loading performSelector:@selector(doRunBlock)
                     withObject:nil
                     afterDelay:0.1f];
}

- (V_loading *)showLoadingInView:(UIView *)aView
                           title:(NSString *)title
                         message:(NSString *)message
{
    [self removeLoadingView];
    
    UIView *parentView = aView;
    if (!parentView) parentView = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: titleFont}];
    if (size.width + CGFloat_TitleLine_Height > CGFloat_MaxLine_Width) {
        [[NSException exceptionWithName:@"title too long." reason:@"title length too long to fix one line." userInfo:nil] raise];
    }
    
    size = [self messageSize:message font:messageFont];
    if (size.height + CGFloat_TitleLine_Height > parentView.bounds.size.height) {
        [[NSException exceptionWithName:@"message too long." reason:@"message length too long to fix view height." userInfo:nil] raise];
    }
    
    V_loading *pV_loading = [[V_loading alloc] init];
    pV_loading.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3f];
    
    if (pV_loading) {
        [parentView addSubview:pV_loading];
        [SimpleConstraint constraintCustomView:pV_loading matchInView:parentView];
        
        UIView *loading = [self loadingInView:nil title:title message:message];
        CGRect frame = loading.frame;
        frame.origin.x = (CGFloat_MaxLine_Width - frame.size.width) / 2;
        frame.origin.y = (CGFloat_MaxLine_Height - frame.size.height) / 2;
        loading.frame = frame;
        pV_loading.pV_content = loading;
        [pV_loading addSubview:loading];
        [SimpleConstraint constraintCustomView:loading centerInView:pV_loading];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    [self.pList_loading addObj:pV_loading];
    [self start_gc];
    return pV_loading;
}

- (void)start_gc
{
    [self.pTmr_gc invalidate];
    self.pTmr_gc = nil;
    
    self.pTmr_gc = [NSTimer scheduledTimerWithTimeInterval:15.f
                                           target:self
                                         selector:@selector(check_gc)
                                         userInfo:nil
                                          repeats:NO];
}

- (void)check_gc
{
    [self.pTmr_gc invalidate];
    self.pTmr_gc = nil;
    
//#warning for contact manager only
//    
//    if (![VC_upgrade inheritedObject]) {
//        [self removeLoadingView];
//    }
    
    if ([self.pList_loading allObjs].count) {
        [self start_gc];
    }
}

- (void)removeLoadingView
{
    NSArray *pArr_loading = [self.pList_loading allObjs];

    for (V_loading *pV_loading in pArr_loading) {
        if (pV_loading.superview) {
            [SimpleConstraint removeConstraintForCustomView:pV_loading
                                          fromView:pV_loading.superview];
            [pV_loading removeFromSuperview];
        }
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)removeLoadingView:(UIView *)aView
{
    [self removeLoadingView];
}

#pragma mark - pass function call

- (void)showLoadingView:(UIView *)aView
                    tag:(NSInteger)tag
                  title:(NSString *)title
                message:(NSString *)message
               viewType:(LoadingViewType)type
{
    [self showLoadingView:aView
                    title:title
                  message:message];
}

- (void)showLoadingView:(UIView *)aView
                  title:(NSString *)title
                message:(NSString *)message
{
    if ([NSThread isMainThread]) {
        [self showLoadingInView:aView
                         title:title
                       message:message];
    }
    else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (aView) {
            [dict setObject:aView forKey:@"aView"];
        }
        
        if (title) {
            [dict setObject:title forKey:@"title"];
        }
        
        if (message) {
            [dict setObject:message forKey:@"message"];
        }
        
        if ([NSThread isMainThread]) {
            [self showLoadingWithDictionary:dict];
        }
        else {
            [self performSelectorOnMainThread:@selector(showLoadingWithDictionary:)
                                  withObject:dict
                               waitUntilDone:NO];
        }
    }
}

- (void)removeLoading
{
    if ([NSThread isMainThread]) {
        [self removeLoadingView];
    }
    else {
        [self performSelectorOnMainThread:@selector(removeLoadingView)
                              withObject:nil
                           waitUntilDone:YES];
    }
}

- (void)loadingInView:(UIView *)aView
                title:(NSString *)title
              message:(NSString *)message
         loadingBlock:(LoadingBlock)workingBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (aView) {
        [dict setObject:aView forKey:@"aView"];
    }
    
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    
    if (message) {
        [dict setObject:message forKey:@"message"];
    }
    
    if (workingBlock) {
        void (^handlerCopy)(NSURLResponse*, NSData*, NSError*) = [workingBlock copy];
        [dict setObject:handlerCopy forKey:@"workingBlock"];
    }
    
    if ([NSThread isMainThread]) {
        [self showLoadingWithDictionaryAndBlock:dict];
    }
    else {
        [self performSelectorOnMainThread:@selector(showLoadingWithDictionaryAndBlock:)
                              withObject:dict
                           waitUntilDone:YES];
    }
}

@end

@implementation V_loading {
    LoadingBlock _block_loading;
}

- (void)setBlock_loading:(LoadingBlock)block_loading
{
    _block_loading = block_loading;
}

- (LoadingBlock)block_loading
{
    return _block_loading;
}

- (void)doRunBlock
{
    if (_block_loading) {
        _block_loading();
    }
    
    [self performSelector:@selector(loadingDidEnd)
               withObject:nil
               afterDelay:0.1f];
}

- (void)loadingDidEnd
{
    _block_loading = nil;
    [[self class] removeLoadingView:self.superview];
}

+ (void)showLoadingView:(UIView *)aView
                        tag:(NSInteger)tag
                      title:(NSString *)title
                    message:(NSString *)message
                   viewType:(LoadingViewType)type
{
    O_loading_mgr *mgr = [O_loading_mgr shared_mgr];
    [mgr showLoadingView:aView
                     tag:tag
                   title:title
                 message:message
                viewType:type];
}

+ (void)showLoadingView:(UIView *)aView
                  title:(NSString *)title
                message:(NSString *)message
{
    O_loading_mgr *mgr = [O_loading_mgr shared_mgr];
    [mgr showLoadingView:aView
                   title:title
                 message:message];
}

+ (void)removeLoadingView:(UIView *)aView
{
    O_loading_mgr *mgr = [O_loading_mgr shared_mgr];
    [mgr removeLoadingView:aView];
}

+ (void)removeLoading
{
    O_loading_mgr *mgr = [O_loading_mgr shared_mgr];
    [mgr removeLoading];
}

+ (void)loadingInView:(UIView *)aView
                title:(NSString *)title
              message:(NSString *)message
         loadingBlock:(LoadingBlock)workingBlock
{
    O_loading_mgr *mgr = [O_loading_mgr shared_mgr];
    [mgr loadingInView:aView
                 title:title
               message:message
          loadingBlock:workingBlock];
}

@end


