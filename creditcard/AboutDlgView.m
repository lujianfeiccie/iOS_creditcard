//
//  AboutDlgView.m
//  creditcard
//
//  Created by Apple on 13-12-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "AboutDlgView.h"

@interface AboutDlgView ()

@end

@implementation AboutDlgView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    [self MyLog:@"initWithNibName"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        [self MyLog:@"viewDidLoad"];
    //加入返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backbtnClick)];
    
    [ImageHelper setToolBarBtn:backButton];    //加入返回按钮
    self.navigationItem.leftBarButtonItem = backButton;
    
   
    [ImageHelper setToCircle:self.img_head];
    
    self.view.backgroundColor = [UIColor blackColor];
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateLabelColor) userInfo:nil repeats:YES];

    red = 1;
    green = 1;
    blue = 1;
    alpha = 0;
    show = NO;
    count = 0;
}
-(void) viewWillAppear:(BOOL)animated{
    [self MyLog:@"viewWillAppear"];
   
}
-(void) viewDidLayoutSubviews{
    [self MyLog:@"viewDidLayoutSubviews"];
    for (id obj in self.view.subviews)  {
        [ImageHelper setRect:obj];
    }
}
-(void) viewDidAppear:(BOOL)animated{
    [self MyLog:@"viewDidAppear"];
   // [self MyLog:[NSString stringWithFormat:@"%f,%f",self.img_head.frame.origin.x,self.img_head.frame.origin.y]];
  
}
-(void) updateLabelColor{
    [self MyLog:@"updateLabelColor"];
    self.label_line1.textColor = [UIColor colorWithRed:red green:green blue:blue  alpha:alpha];
    self.label_line2.textColor = [UIColor colorWithRed:red green:green blue:blue  alpha:1-alpha];
    if(alpha>1){
        show = YES;
    }else if(alpha<0){
        show = NO;
    }
    if(show==YES){
     alpha -=0.1;
    }else{
     alpha +=0.1;
    }
    count +=1;
    if(count>50){
        [updateTimer invalidate];
        self.label_line1.textColor = [UIColor colorWithRed:red green:green blue:blue  alpha:1];
        self.label_line2.textColor = [UIColor colorWithRed:red green:green blue:blue  alpha:1];
         }
}
- (void)backbtnClick {
    if(updateTimer!=nil){
    [updateTimer invalidate];
    updateTimer = nil;
    }
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) MyLog: (NSString*) msg{
#if defined(LOG_DEBUG)
    NSLog(@"%@ %@",NSStringFromClass([self class]),msg);
#endif
}
@end
