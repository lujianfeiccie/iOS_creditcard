//
//  SearchView.h
//  creditcard
//
//  Created by Apple on 13-10-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICombox.h"
#import "ImageHelper.h"
#import "AppDelegate.h"

@interface UserEntity : NSObject<NSCoding> //用户传值实体类
{
    NSString *title;
    NSUInteger maxIntegral;
    NSUInteger minIntegral;
    NSUInteger selectedIndex;
}
@property (strong, nonatomic) NSString *title;
@property(assign) NSUInteger maxIntegral;
@property(assign) NSUInteger minIntegral;
@property(assign) NSUInteger selectedIndex;
@end

@protocol PassValueDelegate <NSObject> //传值协议
-(void)passValue:(UserEntity *)value;
@end

@interface SearchView : UIViewController<UIComboxDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITextField *txtTitle;
    NSUInteger maxIntegral;
    NSUInteger minIntegral;
}
-(IBAction)IntegralSelect:(id)sender;
-(IBAction)textfieldTouchUpOutside:(id)sender;
@property (strong, nonatomic) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UIView *otherIntegralView;
@property id<PassValueDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UICombox *txtIntegral;
@property (weak, nonatomic) IBOutlet UITextField *txtMaxIntegral;
@property (weak, nonatomic) IBOutlet UITextField *txtMinIntegral;

@end
