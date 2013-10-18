//
//  SearchView.m
//  creditcard
//
//  Created by Apple on 13-10-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()

@end

@implementation SearchView

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
    _otherIntegralView.hidden = YES;
	// Do any additional setup after loading the view.
    NSArray *array = [[NSArray alloc] initWithObjects:@"1-999",
                                                      @"1000-1999",
                                                      @"2000-2999",
                                                      @"3000-3999",
                                                      @"4000-4999",
                                                      @"5000-10000",
                                                      @">10000",
                                                      @"其它",nil];
    _pickerData = array;
    _dataPicker.items = _pickerData;
    _dataPicker.delegateForItemSelected = self;
    //加入返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStylePlain target:self action:@selector(backbtnClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //加入筛选按钮
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"查询"style:UIBarButtonItemStyleBordered target:self action:@selector(searchbtnClick)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textfieldTouchUpOutside:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backbtnClick {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (void)searchbtnClick {
    
}
-(IBAction)IntegralSelect:(id)sender{
   // pickview_integral set
    NSLog(@"textfieldTouchUpInside");
}
 


 -(IBAction)textfieldTouchUpOutside:(id)sender{
    NSLog(@"textfieldTouchUpOutside");
     [txtTitle resignFirstResponder];
}

-(void)onItemSelected:(UICombox*) uiCombox Index:(NSInteger) index;{
    NSLog(@"onItemSelected %i",index);
    if (_pickerData.count == (index+1)) {
        _otherIntegralView.hidden = NO;
    }else{
        _otherIntegralView.hidden = YES;
    }
}
@end
