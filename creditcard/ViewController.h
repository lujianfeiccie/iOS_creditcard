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
#import "AppDelegate.h"
#import "RefreshView.h"
#import "ImageLoader.h"
typedef enum{
    TypeRefresh,
    TypeMore
}RequestType;

@interface ViewController : UIViewController
<SINavigationMenuDelegate,
HttpRequestToolDelegate,
UIAlertViewDelegate,
PassValueDelegate,
RefreshViewDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    SINavigationMenuView *menu;//下拉菜单
    UITableView *mUITableView; //列表
    HttpRequestTool* mHttpRequestTool; //远端请求工具类
   // NSOperationQueue* queue; //异步队列，用于处理图片下载
    RequestType requestType; //请求方式
    
    NSInteger selectedIndex; //保存已选中index for CellItem
    
    RefreshView *refreshView;//下拉刷新视图
    
    //分页控制以及相关参数
    NSInteger page;
    NSInteger count;
    NSString* title;
    NSUInteger maxIntegral;
    NSUInteger minIntegral;
    NSUInteger tableViewOffsetY;//用于控制上拉加载更多后滚动到底部
    //网络图片缓存管理
    ImageLoader *imageLoader;
}
@property (strong, nonatomic) NSMutableArray *list;

@end
