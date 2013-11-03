//
//  UICombox.m
//  creditcard
//
//  Created by Apple on 13-10-18.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "UICombox.h"

@implementation UICombox
@synthesize delegateForItemSelected;
@synthesize items;
@synthesize selectedIndex;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
            selectedIndex = -1;
    }
    return self;
}
-(void) didMoveToWindow {
    UIWindow* appWindow = [self window];
    if (appWindow != nil) {
        [self initComponents];
    }
}
- (void)initComponents{
    if(action != nil) return;
    //Create UIDatePicker with UIToolbar.
    action = [[UIActionSheet alloc] initWithTitle:@""
                                         delegate:nil
                                cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                                otherButtonTitles:nil];
    //创建PickView
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    
    //顶部工具条
    UIToolbar *datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    datePickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [datePickerToolbar sizeToFit];
    
    //定义两个按钮
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                         target:self action:nil];
    [barItems addObject:btnFlexibleSpace];
    
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                  target:self
                                  action:@selector(doCancelClick:)];
 
    [barItems addObject:btnCancel];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self
                                action:@selector(doDoneClick:)];

    [barItems addObject:btnDone];
 
    [datePickerToolbar setItems:barItems animated:YES];
    
    
    [action addSubview: datePickerToolbar];
    [action addSubview: picker];
    
}
- (void)doCancelClick:(id)sender{
    [action dismissWithClickedButtonIndex:0  animated:YES];
}
- (void)doDoneClick:(id)sender{
    [action dismissWithClickedButtonIndex:1  animated:YES];
    NSInteger index = [picker selectedRowInComponent:0];
    selectedIndex = index;
    //设置输入框内容
    [self setText:[items objectAtIndex:index]];
    if(delegateForItemSelected!=nil){
        [delegateForItemSelected onItemSelected:self Index:index];
    }
}
-(void)setSelectedIndex:(NSUInteger)_selectedIndex
{
    NSLog(@"UICombox-setSelectedIndex %i ",selectedIndex);
    [picker selectRow:selectedIndex inComponent:0 animated:NO];
    selectedIndex = _selectedIndex;
         //设置输入框内容
    [self setText:[items objectAtIndex:_selectedIndex]];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)becomeFirstResponder {
    if(action == nil)
        [self initComponents];
    if(action != nil){
        UIWindow* appWindow = [self window];
        [action showInView: appWindow];
        [action setBounds:CGRectMake(0, 0, 320, 500)];
        //如果当前输入框内有内容
        if (self.text.length > 0) {
            //将横条定位于当前选项
            [picker selectRow:[items indexOfObject:self.text] inComponent:0 animated:NO];
        }
    }
    return YES;
}
#pragma mark PickViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [items count];
}

#pragma mark PickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [items objectAtIndex:row];
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
