//
//  WDBehaviorController.h
//  Hot Lava
//
//  Created by Aimee on 9/13/13.
//  Copyright (c) 2013 Web Diggity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDBehaviorController : UIDynamicBehavior

-(instancetype)initWithItems:(NSArray*)items getYAxis:(CGFloat *)value;
@property (strong, nonatomic) UIGravityBehavior*   g;
@end
