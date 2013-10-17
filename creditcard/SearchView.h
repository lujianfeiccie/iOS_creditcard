//
//  SearchView.h
//  creditcard
//
//  Created by Apple on 13-10-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    __weak IBOutlet UITextField *txtTitle;
    __weak IBOutlet UIButton *btnSelectIntegral;

}
-(IBAction)IntegralSelect:(id)sender;
-(IBAction)textfieldTouchUpOutside:(id)sender;
@property (strong, nonatomic) NSArray *pickerData;
@property (retain, nonatomic) IBOutlet UIPickerView *pickerView;
@end
