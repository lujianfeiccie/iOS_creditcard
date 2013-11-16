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
#import "SearchView.h"
#import "EGORefreshTableHeaderView.h"
typedef enum{
	PULL_UPDATING = 0,
	PULL_MORE_LOADING
} PULL_State;

@interface ViewController : UIViewController
<SINavigationMenuDelegate,
UITableViewDataSource,
UITableViewDelegate,
HttpRequestToolDelegate,
UIAlertViewDelegate,
PassValueDelegate,
EGORefreshTableHeaderDelegate>
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
    NSString* title;
    NSUInteger maxIntegral;
    NSUInteger minIntegral;
    BOOL noNeedToLoad; //已经没有数据的时候，无需载入
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    PULL_State state ;
    
    UIView *tableFooterView; //底部视图
    UILabel *loadMoreText; //标签
    UIActivityIndicatorView* activityIndicatorView;//底部动画
    
    NSMutableDictionary *urlDict;//地址字典
}
@property (strong, nonatomic) NSMutableArray *list;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
