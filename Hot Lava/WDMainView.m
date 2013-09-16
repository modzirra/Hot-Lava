//
//  WDViewController.m
//  Hot Lava
//
//  Created by Aimee on 9/12/13.
//  Copyright (c) 2013 Web Diggity. All rights reserved.
//

#import "WDMainView.h"
#import "WDBehaviorController.h"
#import "WDParentBubbleView.h"
#import "WDChildBubbleView.h"
#import "WDHiddenView.h"

@interface WDMainView (){
    NSArray *masterArray;
    NSArray *subBubbleArray;
    
    UIDynamicAnimator* animator;
    WDBehaviorController* behavior;

    UIDynamicAnimator* subAnimator;
    WDBehaviorController* subBehavior;
    
    CGFloat CurrentYAxis;
    CGFloat CurrentXAxis;
}

@end

@implementation WDMainView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CurrentYAxis =0;
    
    //make containers for arrays of bubble objects, parent and children
    NSMutableArray *parentContainerArray = [NSMutableArray new];
    NSMutableArray *subContainerArray = [NSMutableArray new];

    //create parent bubble
    for( NSInteger x = 0; x<1; x++ ) {
        
        CGRect outerbubbleFrame;
        outerbubbleFrame.origin.x = x * 10;
        outerbubbleFrame.origin.y = x * 10;
        outerbubbleFrame.size.width = 200;
        outerbubbleFrame.size.height = 200;
        
        WDParentBubbleView*outerBubbleView = [[WDParentBubbleView alloc] initWithFrame:outerbubbleFrame];
        
        
        //outer bubble image
        outerBubbleView.backgroundColor = [UIColor clearColor];
        UIImageView* outerBubbleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        outerBubbleImage.image = [UIImage imageNamed:@"bubble1.png"];
        outerBubbleImage.contentMode=UIViewContentModeScaleAspectFit;
        [outerBubbleView addSubview:outerBubbleImage];
        [self.view addSubview:outerBubbleView];
        
        
        
        //container for bubbles
        CGRect containerFrame;
        containerFrame.origin.x = 34;
        containerFrame.origin.y = 51;
        containerFrame.size.width = 132;
        containerFrame.size.height = 111;
        
        
        WDHiddenView *containerView = [[WDHiddenView alloc] initWithFrame:containerFrame];
        containerView.backgroundColor = [UIColor clearColor];
        [outerBubbleView addSubview:containerView];
        
        
        
        //loop for creating inner bubbles
        for( NSInteger i = 0; i < 4; i++ ) {
            CGRect frame;
            frame.origin.x = 55+(i*4);
            frame.origin.y = 55+(i*7);
            frame.size.width = 25;
            frame.size.height = 25;
            WDChildBubbleView*v = [[WDChildBubbleView alloc] initWithFrame:frame];
            v.backgroundColor = [UIColor clearColor];
            
            //inner bubble image
            UIImageView* backBubbleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            backBubbleImage.image = [UIImage imageNamed:@"bubble2.png"];
            backBubbleImage.contentMode=UIViewContentModeScaleAspectFit;
            [v addSubview:backBubbleImage];
            
            //add inner bubbles into physics array andbubble object into continer view
            [subContainerArray addObject:v];
            [containerView addSubview:v];
        }
        
        //main physics non mutable arrays for sub bubbles
        subBubbleArray = [NSArray arrayWithArray:subContainerArray];
        
        //inner bubble physics animator
        subAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:containerView];
        subBehavior = [[WDBehaviorController alloc] initSubViewWithItems:subBubbleArray
                                                                getYAxis:&(CurrentYAxis)];
        [subAnimator addBehavior:subBehavior];
        
        [parentContainerArray addObject:outerBubbleView];
    }
    
    ////main physics non mutable arrays for outer bubbles
    masterArray = [NSArray arrayWithArray:parentContainerArray];
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    behavior = [[WDBehaviorController alloc] initWithItems:masterArray getYAxis:&(CurrentYAxis)];
    [animator addBehavior:behavior];
   
    //core motion info
    
    
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)resetMaxValues:(id)sender{
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    currentMaxAccelZ = 0;
    
    currentMaxRotX = 0;
    currentMaxRotY = 0;
    currentMaxRotZ = 0;
    
}


-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    //gravity
    CurrentYAxis= acceleration.y;
    CurrentXAxis =acceleration.x;
    
    if(CurrentYAxis < 0 && CurrentXAxis < 0 ){
        //MyCGVector = x,y
        //if y is -1, gravity is 1 - correct gravity
        
        CGVector MyCGVector={-1.0, 1.0 };
        CGVector MySubBubbleCGVector={.10, -.10 };
        subBehavior.g2.gravityDirection=MySubBubbleCGVector;
        behavior.g.gravityDirection=MyCGVector;
       
    }else if (CurrentYAxis > 0 && CurrentXAxis < 0 ){
        //MyCGVector = x,y
        //if y is 1, gravity is -1 - reverse gravity
        CGVector MyCGVector={-1.0,-1.0 };
        CGVector MySubBubbleCGVector={.10, .10 };
        subBehavior.g2.gravityDirection=MySubBubbleCGVector;
        behavior.g.gravityDirection=MyCGVector;
        
    }else if (CurrentYAxis < 0 && CurrentXAxis > 0 ){
        //MyCGVector = x,y
        //if y is -1, gravity is 1 - correct gravity
        CGVector MyCGVector={1.0, 1.0 };
        CGVector MySubBubbleCGVector={-.10, -.10 };
        subBehavior.g2.gravityDirection=MySubBubbleCGVector;
        behavior.g.gravityDirection=MyCGVector;
      
    }else if (CurrentYAxis > 0 && CurrentXAxis > 0 ){
        //MyCGVector = x,y
        //if y is 1, gravity is -1 - reverse gravity
        CGVector MyCGVector={1.0,-1.0 };
        CGVector MySubBubbleCGVector={-.10, .10 };
        subBehavior.g2.gravityDirection=MySubBubbleCGVector;
        behavior.g.gravityDirection=MyCGVector;
    }
    
    
    //monitor accelerometer
    
    self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
    self.accZ.text = [NSString stringWithFormat:@" %.2fg",acceleration.z];
    if(fabs(acceleration.z) > fabs(currentMaxAccelZ))
    {
        currentMaxAccelZ = acceleration.z;
    }
    
    self.maxAccX.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelX];
    self.maxAccY.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelY];
    self.maxAccZ.text = [NSString stringWithFormat:@" %.2f",currentMaxAccelZ];
    
}

-(void)outputRotationData:(CMRotationRate)rotation
{
    self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    if(fabs(rotation.x) > fabs(currentMaxRotX))
    {
        currentMaxRotX = rotation.x;
    }
    self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    if(fabs(rotation.y) > fabs(currentMaxRotY))
    {
        currentMaxRotY = rotation.y;
    }
    self.rotZ.text = [NSString stringWithFormat:@" %.2fr/s",rotation.z];
    if(fabs(rotation.z) > fabs(currentMaxRotZ))
    {
        currentMaxRotZ = rotation.z;
    }
    
    self.maxRotX.text = [NSString stringWithFormat:@" %.2f",currentMaxRotX];
    self.maxRotY.text = [NSString stringWithFormat:@" %.2f",currentMaxRotY];
    self.maxRotZ.text = [NSString stringWithFormat:@" %.2f",currentMaxRotZ];
}

@end
