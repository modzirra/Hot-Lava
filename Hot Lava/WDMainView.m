//
//  WDViewController.m
//  Hot Lava
//
//  Created by Aimee on 9/12/13.
//  Copyright (c) 2013 Web Diggity. All rights reserved.
//

#import "WDMainView.h"
#import "WDBehaviorController.h"
#import "WDSubBehaviorController.h"
#import "WDParentBubbleView.h"
#import "WDChildBubbleView.h"


@interface WDMainView (){
    NSArray *masterArray;
    NSArray *subBubbleArray;
    
    UIDynamicAnimator* animator;
    WDBehaviorController* behavior;
    WDBehaviorController* subBehavior;
    
    UIDynamicAnimator* subAnimator;
    
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

    //for each view in subview do...
    for( UIView *view in self.view.subviews ) {
        //check for parent bubble view
        if( [view isKindOfClass:[WDParentBubbleView class]] ) {
            
            //add to changeable array
            [parentContainerArray addObject:view];

            //create 5 sub items
            for( NSInteger i = 0; i < 4; i++ ) {
                CGRect frame;
                frame.origin.x = 55+(i*4);
                frame.origin.y = 55+(i*7);
                frame.size.width = 25;
                frame.size.height = 25;
                
                WDChildBubbleView *v = [[WDChildBubbleView alloc] initWithFrame:frame];
                v.backgroundColor = [UIColor redColor];
                
                [view addSubview:v];
                
                //add items to sub containter array
                [subContainerArray addObject:v];
            }
            
            
            //replace original sub array with new contents of objects in sub container
            subBubbleArray=[NSArray arrayWithArray:subContainerArray];
            //animate!
            subAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:view];
            
            //talk about behavior!  boo doesn't work.
            subBehavior = [[WDBehaviorController alloc] initSubWithItems:subBubbleArray
                           getYAxis:&(CurrentXAxis)];
            [subAnimator addBehavior: subBehavior];
        }
    }
    masterArray = [NSArray arrayWithArray:subBubbleArray];
    
    for( WDParentBubbleView *v in masterArray ) {
        NSLog( @"%@", NSStringFromCGRect( v.frame ) );
    }
    
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
    
    CurrentYAxis= acceleration.y;
    CurrentXAxis =acceleration.x;
    
    if(CurrentYAxis < 0 && CurrentXAxis < 0 ){
        //MyCGVector = x,y
        //if y is -1, gravity is 1 - correct gravity
        
        CGVector MyCGVector={-1.0, 1.0 };
        behavior.g.gravityDirection=MyCGVector;
       
    }else if (CurrentYAxis > 0 && CurrentXAxis < 0 ){
        //MyCGVector = x,y
        //if y is 1, gravity is -1 - reverse gravity
        CGVector MyCGVector={-1.0,-1.0 };
        behavior.g.gravityDirection=MyCGVector;
        
    }else if (CurrentYAxis < 0 && CurrentXAxis > 0 ){
        //MyCGVector = x,y
        //if y is -1, gravity is 1 - correct gravity
        CGVector MyCGVector={1.0, 1.0 };
        behavior.g.gravityDirection=MyCGVector;
      
    }else if (CurrentYAxis > 0 && CurrentXAxis > 0 ){
        //MyCGVector = x,y
        //if y is 1, gravity is -1 - reverse gravity
        CGVector MyCGVector={1.0,-1.0 };
        behavior.g.gravityDirection=MyCGVector;
        
    }
    
    
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
