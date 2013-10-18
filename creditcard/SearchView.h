//
//  SearchView.h
//  creditcard
//
//  Created by Apple on 13-10-17.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICombox.h"
@interface SearchView : UIViewController<UIComboxDelegate>
{
    __weak IBOutlet UITextField *txtTitle;

}
-(IBAction)IntegralSelect:(id)sender;
-(IBAction)textfieldTouchUpOutside:(id)sender;
@property (strong, nonatomic) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UICombox *dataPicker;
@property (weak, nonatomic) IBOutlet UIView *otherIntegralView;
@end
