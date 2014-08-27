//
//  O_weak_list.m
//  ContactsManager
//
//  Created by DarkLinden on S/9/2013.
//  Copyright (c) 2013 darklinden. All rights reserved.
//

#import "O_weak_list.h"

@interface O_weak_list_item : NSObject
@property (nonatomic,   weak) id obj;
@end

@implementation O_weak_list_item

- (NSString *)description
{
    return [NSString stringWithFormat:@"<weak_list_item = %@>", self.obj];
}

@end

@interface O_weak_list ()
@property (nonatomic, strong) NSMutableArray *pArr_list;
@end

@implementation O_weak_list

+ (id)list
{
   __autoreleasing O_weak_list *pO_weak_list = [[O_weak_list alloc] init];
    return pO_weak_list;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.pArr_list = [NSMutableArray array];
    }
    return self;
}

- (void)refresh
{
    NSMutableArray *pArr_tmp = [NSMutableArray array];
    for (O_weak_list_item *item in self.pArr_list) {
        if (!item.obj) {
            [pArr_tmp addObject:item];
        }
    }
    [self.pArr_list removeObjectsInArray:pArr_tmp];
}

- (NSArray *)allObjs
{
    NSMutableArray *pArr_tmp = [NSMutableArray array];
    for (O_weak_list_item *item in self.pArr_list) {
        if (item.obj) {
            [pArr_tmp addObject:item.obj];
        }
    }
    return pArr_tmp;
}

- (void)addObj:(id)obj
{
    if (obj) {
        NSMutableArray *pArr_tmp = [NSMutableArray array];
        BOOL hasContained = NO;
        for (O_weak_list_item *item in self.pArr_list) {
            if (!item.obj) {
                [pArr_tmp addObject:item];
            }
            
            if (item.obj == obj) {
                hasContained = YES;
            }
        }
        
        [self.pArr_list removeObjectsInArray:pArr_tmp];
        
        if (!hasContained) {
            O_weak_list_item *item = [[O_weak_list_item alloc] init];
            item.obj = obj;
            [self.pArr_list addObject:item];
        }
    }
    else {
        NSLog(@"%s add nil obj", __FUNCTION__);
    }
}

- (void)removeObj:(id)obj
{
    if (obj) {
        NSMutableArray *pArr_tmp = [NSMutableArray array];
        for (O_weak_list_item *item in self.pArr_list) {
            if (!item.obj) {
                [pArr_tmp addObject:item];
            }
            
            if (item.obj == obj) {
                [pArr_tmp addObject:item];
            }
        }
        [self.pArr_list removeObjectsInArray:pArr_tmp];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<weak_list: \n%@\n>", self.pArr_list.description];
}

@end
