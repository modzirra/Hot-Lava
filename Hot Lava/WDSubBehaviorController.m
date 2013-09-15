//
//  WDSubBehaviorController.m
//  Hot Lava
//
//  Created by Aimee on 9/14/13.
//  Copyright (c) 2013 Web Diggity. All rights reserved.
//

#import "WDSubBehaviorController.h"

@implementation WDSubBehaviorController

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

@end
