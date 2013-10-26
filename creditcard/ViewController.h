//
//  ViewController.h
//  creditcard
//
//  Created by Apple on 13-9-29.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIPasteboard.h>
#import"SINavigationMenuView.h"
#import "HttpRequestTool.h"
@interface ViewController : UIViewController
<SINavigationMenuDelegate,
UITableViewDataSource,
UITableViewDelegate,
HttpRequestToolDelegate,
UIAlertViewDelegate>
{
    NSArray *bank_array; //存放银行列表信息
    SINavigationMenuView *menu;//下拉菜单
    UITableView *mUITableView; //列表
    HttpRequestTool* mHttpRequestTool; //远端请求工具类
    NSOperationQueue* queue; //异步队列，用于处理图片下载
    NSInteger selectedIndex; //保存已选中index for CellItem
    BOOL flagRefresh;
    BOOL loadingMore;
    NSInteger page;
    NSInteger count;
    NSInteger selectedBankIndex;
}
@property (strong, nonatomic) NSMutableArray *list;
@end
