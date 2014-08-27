//
//  O_weak_list.h
//  ContactsManager
//
//  Created by DarkLinden on S/9/2013.
//  Copyright (c) 2013 darklinden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface O_weak_list : NSObject

+ (id)list;

- (void)addObj:(id)obj;

- (void)removeObj:(id)obj;

- (NSArray *)allObjs;

@end
