//
//  UICombox.h
//  creditcard
//
//  Created by Apple on 13-10-18.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UICombox;

//定义回调接口
@protocol UIComboxDelegate<NSObject>
@required
-(void)onItemSelected:(UICombox*) uiCombox Index:(NSInteger) index;
@end

@interface UICombox : UITextField<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
@private
    UIActionSheet *action;
    UIPickerView *picker;
    id<UIComboxDelegate> delegateForItemSelected;
}
@property(nonatomic, copy) NSArray *items;
@property(nonatomic, retain) id<UIComboxDelegate> delegateForItemSelected;
- (void)initComponents;
@end
