//
//  ViewController.h
//  creditcard
//
//  Created by Apple on 13-9-29.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"SINavigationMenuView.h"
#import "HttpRequestTool.h"
@interface ViewController : UIViewController<SINavigationMenuDelegate,HttpRequestToolDelegate>
{
    NSArray *bank_array;
    SINavigationMenuView *menu;
    HttpRequestTool* mHttpRequestTool;
}
@end
