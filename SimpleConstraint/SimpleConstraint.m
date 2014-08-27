//
//  BaseLib.m
//  DemoForBaseLib
//
//  Created by DarkLinden on A/26/2013.
//  Copyright (c) 2013 darklinden. All rights reserved.
//

#import "SimpleConstraint.h"

@implementation SimpleConstraint

+ (void)removeConstraintForCustomView:(UIView *)customView
                             fromView:(UIView *)superView
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    
    NSMutableArray *pArr_constraint = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in superView.constraints) {
        if (constraint.firstItem == customView
            || constraint.secondItem == customView) {
            [pArr_constraint addObject:constraint];
        }
    }
    [superView removeConstraints:pArr_constraint];
    pArr_constraint = nil;
}

//使用VisualFormat添加AutoLayout限定
+ (void)constraintsVisualFormat:(NSString*)visualString
                    toSuperView:(UIView *)superView
                      withViews:(NSDictionary*)views
{
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualString
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
    [superView addConstraints:constraints];
}

//customView完全匹配superView的大小
+ (void)constraintCustomView:(UIView *)customView
                 matchInView:(UIView *)superView
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    customView.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *dict_views = NSDictionaryOfVariableBindings(customView);
    
    [self constraintsVisualFormat:@"|[customView]|"
                      toSuperView:superView
                        withViews:dict_views];
    [self constraintsVisualFormat:@"V:|[customView]|"
                      toSuperView:superView
                        withViews:dict_views];
}

//customView在super中心
+ (void)constraintCustomView:(UIView *)customView
                centerInView:(UIView *)superView
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint_x_l = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.f
                                                                       constant:2.f];
    [superView addConstraint:constraint_x_l];
    
    NSLayoutConstraint *constraint_x_g = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.f
                                                                       constant:-2.f];
    [superView addConstraint:constraint_x_g];
    
    NSLayoutConstraint *constraint_y_l = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.f
                                                                       constant:2.f];
    [superView addConstraint:constraint_y_l];
    
    NSLayoutConstraint *constraint_y_g = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.f
                                                                       constant:-2.f];
    [superView addConstraint:constraint_y_g];
    
    NSLayoutConstraint *constraint_width = [NSLayoutConstraint constraintWithItem:customView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:0.f
                                                                         constant:customView.frame.size.width];
    [superView addConstraint:constraint_width];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:0.f
                                                                          constant:customView.frame.size.height];
    [superView addConstraint:constraint_height];
}

//customView以topleft定位, 横屏大小跟随superView, 竖屏大小跟随superView和top
+ (void)constraintCustomView:(UIView *)customView
                   matchView:(UIView *)superView
                     topLeft:(CGPoint)topLeft
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_top = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.f
                                                                       constant:topLeft.y];
    [superView addConstraint:constraint_top];
    
    NSLayoutConstraint *constraint_left = [NSLayoutConstraint constraintWithItem:customView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:superView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.f
                                                                        constant:topLeft.x];
    [superView addConstraint:constraint_left];
    
    NSLayoutConstraint *constraint_width = [NSLayoutConstraint constraintWithItem:customView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:superView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:1.f
                                                                         constant:0.f];
    [superView addConstraint:constraint_width];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:1.f
                                                                          constant:-topLeft.y];
    [superView addConstraint:constraint_height];
}

//customView以rect定位, 大小固定
+ (void)constraintCustomView:(UIView *)customView
                   superView:(UIView *)superView
                   matchRect:(CGRect)rect
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_top = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.f
                                                                       constant:rect.origin.y];
    [superView addConstraint:constraint_top];
    
    NSLayoutConstraint *constraint_left = [NSLayoutConstraint constraintWithItem:customView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:superView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.f
                                                                        constant:rect.origin.x];
    [superView addConstraint:constraint_left];
    
    NSLayoutConstraint *constraint_width = [NSLayoutConstraint constraintWithItem:customView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:0.f
                                                                         constant:rect.size.width];
    [superView addConstraint:constraint_width];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:0.f
                                                                          constant:rect.size.height];
    [superView addConstraint:constraint_height];
}

//customView以topleft定位, 大小固定
+ (void)constraintCustomView:(UIView *)customView
          matchTopLeftOfView:(UIView *)superView
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_top = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.f
                                                                       constant:customView.frame.origin.y];
    [superView addConstraint:constraint_top];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:0.f
                                                                          constant:customView.frame.size.height];
    [superView addConstraint:constraint_height];
    
    NSLayoutConstraint *constraint_left = [NSLayoutConstraint constraintWithItem:customView
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:superView
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.f
                                                                        constant:customView.frame.origin.x];
    [superView addConstraint:constraint_left];
    
    NSLayoutConstraint *constraint_width = [NSLayoutConstraint constraintWithItem:customView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:superView
                                                                        attribute:NSLayoutAttributeWidth
                                                                       multiplier:0.f
                                                                         constant:customView.frame.size.width];
    [superView addConstraint:constraint_width];
}

//customView以topright定位, 大小固定
+ (void)constraintCustomView:(UIView *)customView
         matchTopRightOfView:(UIView *)superView
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_top = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.f
                                                                       constant:customView.frame.origin.y];
    [superView addConstraint:constraint_top];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:0.f
                                                                          constant:customView.frame.size.height];
    [superView addConstraint:constraint_height];
    
    NSLayoutConstraint *constraint_right = [NSLayoutConstraint constraintWithItem:customView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:superView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.f
                                                                        constant:-superView.frame.size.width + (customView.frame.origin.x + customView.frame.size.width)];
    [superView addConstraint:constraint_right];
    
    NSLayoutConstraint *constraint_width = [NSLayoutConstraint constraintWithItem:customView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:0.f
                                                                         constant:customView.frame.size.width];
    [superView addConstraint:constraint_width];
}

//customView以center定位, 大小固定
+ (void)constraintCustomView:(UIView *)customView
           matchCenterOfView:(UIView *)superView
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_center_y = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.f
                                                                       constant:0.f];
    [superView addConstraint:constraint_center_y];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:0.f
                                                                          constant:customView.frame.size.height];
    [superView addConstraint:constraint_height];
    
    NSLayoutConstraint *constraint_center_x = [NSLayoutConstraint constraintWithItem:customView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:superView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1.f
                                                                        constant:0.f];
    [superView addConstraint:constraint_center_x];
    
    NSLayoutConstraint *constraint_width = [NSLayoutConstraint constraintWithItem:customView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:0.f
                                                                         constant:customView.frame.size.width];
    [superView addConstraint:constraint_width];
}

//customView以x轴center定位, 高和大小固定
+ (void)constraintCustomView:(UIView *)customView
      matchWidthCenterOfView:(UIView *)superView
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_top = [NSLayoutConstraint constraintWithItem:customView
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:superView
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.f
                                                                            constant:customView.frame.origin.y];
    [superView addConstraint:constraint_top];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:0.f
                                                                          constant:customView.frame.size.height];
    [superView addConstraint:constraint_height];
    
    NSLayoutConstraint *constraint_center_x = [NSLayoutConstraint constraintWithItem:customView
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:superView
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1.f
                                                                            constant:0.f];
    [superView addConstraint:constraint_center_x];
    
    NSLayoutConstraint *constraint_width = [NSLayoutConstraint constraintWithItem:customView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:0.f
                                                                         constant:customView.frame.size.width];
    [superView addConstraint:constraint_width];
}

//customView以前一view定位, 主要用于toolbar按钮
+ (void)constraintCustomView:(UIView *)customView
      matchWidthPreviousView:(UIView *)previousView
                   superView:(UIView *)superView
                    boxCount:(NSUInteger)boxCount
                    boxIndex:(int)boxIndex
{
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (boxIndex == 0) {
        NSDictionary *dict_views = NSDictionaryOfVariableBindings(customView);
        [self constraintsVisualFormat:@"|[customView]"
                          toSuperView:superView
                            withViews:dict_views];
    }
    else if (boxIndex == boxCount - 1) {
        NSDictionary *dict_views = NSDictionaryOfVariableBindings(customView, previousView);
        [self constraintsVisualFormat:@"[previousView]-[customView(==previousView)]|"
                          toSuperView:superView
                            withViews:dict_views];
    }
    else {
        NSDictionary *dict_views = NSDictionaryOfVariableBindings(customView, previousView);
        [self constraintsVisualFormat:@"[previousView]-[customView(==previousView)]"
                          toSuperView:superView
                            withViews:dict_views];
    }
    NSDictionary *dict_views = NSDictionaryOfVariableBindings(customView);
    NSString *visualString = [NSString stringWithFormat:@"V:|-%f-[customView(%f)]", customView.frame.origin.y, customView.frame.size.height];
    [self constraintsVisualFormat:visualString
                      toSuperView:superView
                        withViews:dict_views];
}

//customView以x轴percent定位, 高固定
+ (void)constraintCustomView:(UIView *)customView
     matchWidthPercentOfView:(UIView *)superView
                    boxCount:(int)boxCount
                    boxIndex:(int)boxIndex
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_top = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.f
                                                                       constant:customView.frame.origin.y];
    [superView addConstraint:constraint_top];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:0.f
                                                                          constant:customView.frame.size.height];
    [superView addConstraint:constraint_height];
    
    if (boxCount == 1) {
        NSDictionary *dict_views = NSDictionaryOfVariableBindings(customView);
        [self constraintsVisualFormat:@"|[customView]|"
                          toSuperView:superView
                            withViews:dict_views];
    }
    else {
        if (boxIndex == 0) {
            NSLayoutConstraint *constraint_left = [NSLayoutConstraint constraintWithItem:customView
                                                                               attribute:NSLayoutAttributeLeading
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:superView
                                                                               attribute:NSLayoutAttributeLeading
                                                                              multiplier:1.f
                                                                                constant:0.f];
            [superView addConstraint:constraint_left];
            
            NSLayoutConstraint *constraint_width_h = [NSLayoutConstraint constraintWithItem:customView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                     toItem:superView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:(2.f / (CGFloat)(2 * boxCount + 1))
                                                                                   constant:5.f];
            [superView addConstraint:constraint_width_h];
            
            NSLayoutConstraint *constraint_width_l = [NSLayoutConstraint constraintWithItem:customView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:superView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:(2.f / (CGFloat)(2 * boxCount + 1))
                                                                                   constant:-5.f];
            [superView addConstraint:constraint_width_l];
        }
        else if (boxIndex == boxCount - 1) {
            NSLayoutConstraint *constraint_right = [NSLayoutConstraint constraintWithItem:customView
                                                                                attribute:NSLayoutAttributeTrailing
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:superView
                                                                                attribute:NSLayoutAttributeTrailing
                                                                               multiplier:1.f
                                                                                 constant:0.f];
            [superView addConstraint:constraint_right];
            
            NSLayoutConstraint *constraint_width_h = [NSLayoutConstraint constraintWithItem:customView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                     toItem:superView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:(2.f / (CGFloat)(2 * boxCount + 1))
                                                                                   constant:5.f];
            [superView addConstraint:constraint_width_h];
            
            NSLayoutConstraint *constraint_width_l = [NSLayoutConstraint constraintWithItem:customView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:superView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:(2.f / (CGFloat)(2 * boxCount + 1))
                                                                                   constant:-5.f];
            [superView addConstraint:constraint_width_l];
        }
        else {
            NSLayoutConstraint *constraint_percent_x_l = [NSLayoutConstraint constraintWithItem:customView
                                                                                      attribute:NSLayoutAttributeCenterX
                                                                                      relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                         toItem:superView
                                                                                      attribute:NSLayoutAttributeCenterX
                                                                                     multiplier:(((CGFloat)(2 * boxIndex + 1)) / (CGFloat)boxCount)
                                                                                       constant:3.f];
            [superView addConstraint:constraint_percent_x_l];
            
            NSLayoutConstraint *constraint_percent_x_g = [NSLayoutConstraint constraintWithItem:customView
                                                                                      attribute:NSLayoutAttributeCenterX
                                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                         toItem:superView
                                                                                      attribute:NSLayoutAttributeCenterX
                                                                                     multiplier:(((CGFloat)(2 * boxIndex + 1)) / (CGFloat)boxCount)
                                                                                       constant:-3.f];
            [superView addConstraint:constraint_percent_x_g];
            
            NSLayoutConstraint *constraint_width_h = [NSLayoutConstraint constraintWithItem:customView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                                     toItem:superView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:(2.f / (CGFloat)(2 * boxCount + 1))
                                                                                   constant:5.f];
            [superView addConstraint:constraint_width_h];
            
            NSLayoutConstraint *constraint_width_l = [NSLayoutConstraint constraintWithItem:customView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                                     toItem:superView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:(2.f / (CGFloat)(2 * boxCount + 1))
                                                                                   constant:-5.f];
            [superView addConstraint:constraint_width_l];
        }
    }
}

//customView匹配superView的宽度, 顶部对齐, 高度为height
+ (void)constraintCustomView:(UIView *)customView
            matchWidthOfView:(UIView *)superView
                     withTop:(CGFloat)top
                  withHeight:(CGFloat)height
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_top = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.f
                                                                       constant:top];
    [superView addConstraint:constraint_top];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:0.f
                                                                          constant:height];
    [superView addConstraint:constraint_height];

    NSDictionary *dict_views = NSDictionaryOfVariableBindings(customView);
    [self constraintsVisualFormat:@"|[customView]|"
                      toSuperView:superView
                        withViews:dict_views];
}

//customView匹配superView的宽度, 底部对齐, 高度为height
+ (void)constraintCustomView:(UIView *)customView
      matchBottomWidthOfView:(UIView *)superView
                  withHeight:(CGFloat)height
{
    if (!customView) {
        NSLog(@"customView is null");
        return;
    }
    if (!superView) {
        NSLog(@"superView is null");
        return;
    }
    [self removeConstraintForCustomView:customView fromView:superView];
    
    customView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *constraint_bottom = [NSLayoutConstraint constraintWithItem:customView
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:superView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.f
                                                                       constant:0.f];
    [superView addConstraint:constraint_bottom];
    
    NSLayoutConstraint *constraint_height = [NSLayoutConstraint constraintWithItem:customView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:superView
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:0.f
                                                                          constant:height];
    [superView addConstraint:constraint_height];
    
    NSDictionary *dict_views = NSDictionaryOfVariableBindings(customView);
    [self constraintsVisualFormat:@"|[customView]|"
                      toSuperView:superView
                        withViews:dict_views];
}

@end
