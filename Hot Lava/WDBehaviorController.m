//
//  WDBehaviorController.m
//  Hot Lava
//
//  Created by Aimee on 9/13/13.
//  Copyright (c) 2013 Web Diggity. All rights reserved.
//
#import "WDBehaviorController.h"

@implementation WDBehaviorController

-(instancetype)initWithItems:(NSArray*)items getYAxis:(CGFloat *)value {
    if (self=[super init]) {
        _g = [[UIGravityBehavior alloc] initWithItems:items];
        UICollisionBehavior* c = [[UICollisionBehavior alloc] initWithItems:items];
        c.translatesReferenceBoundsIntoBoundary = TRUE;
        [self addChildBehavior:_g];
        [self addChildBehavior:c];
    }
    return self;
}


-(instancetype)initSubViewWithItems:(NSArray*)items getYAxis:(CGFloat *)value {
    if (self=[super init]) {
        _g = [[UIGravityBehavior alloc] initWithItems:items];
        UICollisionBehavior* c = [[UICollisionBehavior alloc] initWithItems:items];
        c.translatesReferenceBoundsIntoBoundary = TRUE;
        [self addChildBehavior:_g];
        [self addChildBehavior:c];
    }
    return self;
}
@end
