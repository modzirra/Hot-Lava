//
//  WDChildBubbleView.m
//  Hot Lava
//
//  Created by Aimee on 9/14/13.
//  Copyright (c) 2013 Web Diggity. All rights reserved.
//

#import "WDParentBubbleView.h"
#import "WDChildBubbleView.h"

@implementation WDChildBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
