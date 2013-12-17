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
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //加入返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backbtnClick)];
    
    [ImageHelper setToolBarBtn:backButton];    //加入返回按钮
    self.navigationItem.leftBarButtonItem = backButton;
}
- (void)backbtnClick {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
