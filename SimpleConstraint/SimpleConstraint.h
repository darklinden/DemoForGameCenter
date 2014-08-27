//
//  BaseLib.h
//  DemoForBaseLib
//
//  Created by DarkLinden on A/26/2013.
//  Copyright (c) 2013 darklinden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleConstraint : NSObject

//清除superView上对于customView的constraint
+ (void)removeConstraintForCustomView:(UIView *)customView
                             fromView:(UIView *)superView;

//使用VisualFormat添加AutoLayout限定
+ (void)constraintsVisualFormat:(NSString*)visualString
                    toSuperView:(UIView *)superView
                      withViews:(NSDictionary*)views;

//customView完全匹配superView的大小
+ (void)constraintCustomView:(UIView *)customView
                 matchInView:(UIView *)superView;

//customView在super中心
+ (void)constraintCustomView:(UIView *)customView
                centerInView:(UIView *)superView;

//customView以topleft定位, 横屏大小跟随superView, 竖屏大小跟随superView和top
+ (void)constraintCustomView:(UIView *)customView
                   matchView:(UIView *)superView
                     topLeft:(CGPoint)topLeft;

//customView以rect定位, 大小固定
+ (void)constraintCustomView:(UIView *)customView
                   superView:(UIView *)superView
                   matchRect:(CGRect)rect;

//customView以topleft定位, 大小固定
+ (void)constraintCustomView:(UIView *)customView
          matchTopLeftOfView:(UIView *)superView;

//customView以topright定位, 大小固定
+ (void)constraintCustomView:(UIView *)customView
         matchTopRightOfView:(UIView *)superView;

//customView以center定位, 大小固定
+ (void)constraintCustomView:(UIView *)customView
           matchCenterOfView:(UIView *)superView;

//customView以x轴center定位, 高和大小固定
+ (void)constraintCustomView:(UIView *)customView
      matchWidthCenterOfView:(UIView *)superView;

//customView以前一view定位, 主要用于toolbar按钮
+ (void)constraintCustomView:(UIView *)customView
      matchWidthPreviousView:(UIView *)previousView
                   superView:(UIView *)superView
                    boxCount:(NSUInteger)boxCount
                    boxIndex:(int)boxIndex;

//customView以x轴份数定位, 高固定
+ (void)constraintCustomView:(UIView *)customView
     matchWidthPercentOfView:(UIView *)superView
                    boxCount:(int)boxCount
                    boxIndex:(int)boxIndex;

//customView匹配superView的宽度, 顶部top, 高度为height
+ (void)constraintCustomView:(UIView *)customView
            matchWidthOfView:(UIView *)superView
                     withTop:(CGFloat)top
                  withHeight:(CGFloat)height;

//customView匹配superView的宽度, 底部对齐, 高度为height
+ (void)constraintCustomView:(UIView *)customView
      matchBottomWidthOfView:(UIView *)superView
                  withHeight:(CGFloat)height;

@end
