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
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 240, 320, 460)];
        _pickerView.delegate = self;
        _pickerView.dataSource =self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.hidden = YES;
        [self.view addSubview:_pickerView];
    }
    
    //加入关于按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered target:self action:@selector(backbtnClick)];
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
      _pickerView.hidden = NO;
    NSLog(@"textfieldTouchUpInside");
}
//返回pickerview的组件数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

//返回每个组件上的行数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerData count];
}

//设置每行显示的内容
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerData objectAtIndex:row];
    
}

//当你选中pickerview的某行时会调用该函数。

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"You select row %d",row);
    NSString* temp = [NSString stringWithFormat:@"%@",[_pickerData  objectAtIndex:row]];
    [btnSelectIntegral setTitle:temp forState:UIControlStateNormal];

    _pickerView.hidden = YES;
}
-(IBAction)textfieldTouchUpOutside:(id)sender{
    NSLog(@"textfieldTouchUpOutside");
     [txtTitle resignFirstResponder];
}
@end
