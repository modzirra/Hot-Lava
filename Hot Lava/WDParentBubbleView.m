//
//  WDParentBubbleView.m
//  Hot Lava
//
//  Created by Aimee on 9/13/13.
//  Copyright (c) 2013 Web Diggity. All rights reserved.
//

#import "WDParentBubbleView.h"
#import "WDChildBubbleView.h"

@implementation WDParentBubbleView

-(void) awakeFromNib
{
    [super awakeFromNib];
    for( NSInteger i = 0; i < 4; i++ ) {
        CGRect frame;
        frame.origin.x = -10.*i;
        frame.origin.y = -10.*i;
        frame.size.width = 10.;
        frame.size.height = 10.;
        WDChildBubbleView *v = [[WDChildBubbleView alloc] initWithFrame:frame];

    [self addSubview:v];
    }
}
@end
