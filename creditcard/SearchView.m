//
//  SearchView.m
//  creditcard
//
//  Created by Apple on 13-10-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "SearchView.h"
#import "SVProgressHUD.h"
@interface SearchView ()

@end

@implementation UserEntity
@synthesize title;
@synthesize maxIntegral;
@synthesize minIntegral;
@end
typedef NS_ENUM(NSInteger, Test1) {
    //以下是枚举成员
    VALUE1_999 = 0,
    VALUE1000_1999 = 1,
    VALUE2000_2999 = 2,
    VALUE3000_3999 = 3,
    VALUE4000_4999 = 4,
    VALUE5000_10000 = 5,
    VALUE10000MORE = 6
};
@implementation SearchView
@synthesize txtTitle;
@synthesize txtIntegral;
@synthesize txtMaxIntegral;
@synthesize txtMinIntegral;

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
    if([txtTitle.text isEqual:@""] ||
       [txtIntegral.text isEqual:@""]
       ){
        [SVProgressHUD showErrorWithStatus:@"输入不能为空"];
        return;
    }
    
    if(!_otherIntegralView.hidden){
        if ([txtMaxIntegral.text isEqual:@""] ||
            [txtMinIntegral.text isEqual:@""]) {
           [SVProgressHUD showErrorWithStatus:@"输入不能为空"];
            return;
        }
        maxIntegral = txtMaxIntegral.text.integerValue;
        minIntegral = txtMinIntegral.text.integerValue;
    }
    if( _delegate !=nil){
        UserEntity* value = [[UserEntity alloc] init];
        value.title = txtTitle.text;
        value.maxIntegral = maxIntegral;
        value.minIntegral = minIntegral;
        [_delegate passValue:value];
        [[self navigationController] popViewControllerAnimated:YES];
    }
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
    switch (index) {
        case VALUE1_999:
            maxIntegral = 999;
            minIntegral = 1;
            break;
        case VALUE1000_1999:
            maxIntegral = 1999;
            minIntegral = 1000;
            break;
        case VALUE2000_2999:
            maxIntegral = 2999;
            minIntegral = 2000;
            break;
        case VALUE3000_3999:
            maxIntegral = 3999;
            minIntegral = 3000;
            break;
        case VALUE4000_4999:
            maxIntegral = 4999;
            minIntegral = 4000;
            break;
        case VALUE5000_10000:
            maxIntegral = 10000;
            minIntegral = 5000;
            break;
        case VALUE10000MORE:
            minIntegral = 10000;
            maxIntegral = 1000000;
            break;
        default:
            break;
    }
}
@end
