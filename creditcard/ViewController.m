//
//  ViewController.m
//  creditcard
//
//  Created by Apple on 13-9-29.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "CustomCell.h"
#import "Good.h"
#import "CellAndImage.h"
#import "SVProgressHUD.h"
#import "ImageHelper.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize list = _list;

#pragma mark -
#pragma mark ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loadin/Users/apple/Desktop/ios_workspace/creditcard/creditcard/creditcard/ViewController.mg the view, typically from a nib.
    [self MyLog:@"viewDidLoad"];
    [self initView];
    [self initData];
    [self initEvent];
    
    for (id obj in self.view.subviews)  {
        [ImageHelper setRect:obj];
    }

    [refreshView startLoading];
    [self requestData];
}
-(void)viewDidLayoutSubviews{
  //  [self MyLog:@"viewDidLayoutSubviews"];
   
}

- (void) initView{
      mHttpRequestTool = [HttpRequestTool alloc]; //初始化HTTP请求类
    //加入List
     _list = [[NSMutableArray alloc] init];
    
    //初始化网络图片缓存类
    imageLoader = [[ImageLoader alloc] init];
    
    //加入标题下拉按钮
    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"平安银行"];
        [menu displayMenuInView:self.view];
             
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.titleView = menu;
        
        //加入关于按钮
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"关于" style:UIBarButtonItemStyleBordered target:self action:@selector(aboutDlg)];
        
        [ImageHelper setToolBarBtn:backButton];
        
        
        self.navigationItem.leftBarButtonItem = backButton;
        
        //加入筛选按钮
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"筛选"style:UIBarButtonItemStyleBordered target:self action:@selector(filterDlg)];
        
        [ImageHelper setToolBarBtn:filterButton];
        
        self.navigationItem.rightBarButtonItem = filterButton;
    }
    //加入列表
    mUITableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height)];
    
    [self.view addSubview:mUITableView];
    
    mUITableView.rowHeight=120;
}
- (void) initData{
    title = @"";
    minIntegral = 0;
    maxIntegral = 0;
    page = 1;   //第一页
    count = 10; //每页大小为十条数据
    menu.items = [NSArray arrayWithObjects:@"平安银行", @"农业银行", @"中国银行", @"招商银行", nil];
   
    requestType = TypeRefresh;
}

-(void) initEvent{
   
    menu.delegate = self;
    mHttpRequestTool.delegate = self;           //注册回调
    mUITableView.delegate = self;
    mUITableView.dataSource = self;
    refreshView = [[RefreshView alloc] initWithOwner:mUITableView delegate:self];
}

-(void)passValue:(UserEntity *)value{ //从筛选界面过来
    [self MyLog:[NSString stringWithFormat:@"%@ min %i max %i",value.title,value.minIntegral,value.maxIntegral]];
    title = value.title;
    minIntegral = value.minIntegral;
    maxIntegral = value.maxIntegral;
    requestType = TypeRefresh;
    [refreshView startLoading];
    [self requestData];
}
-(void) changeSelection{
    page = 1;
    title = @"";
    minIntegral = 0;
    maxIntegral = 0;
    CGPoint point = CGPointMake(0, 0);
    [mUITableView setContentOffset:point]; //回到顶端
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self MyLog:[NSString stringWithFormat:@"clickedButtonAtIndex %i",buttonIndex]];
    switch (buttonIndex) {
        case 0://取消
            break;
        case 1:{//确定
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            Good *good = [self.list objectAtIndex:selectedIndex];
            pboard.string = good.no;
            [SVProgressHUD showSuccessWithStatus:@"已成功复制!"];
        }break;
        default:
            break;
    }
}

-(NSInteger) getTypeId:(NSInteger)bank{
    NSInteger result = 0;
    switch (bank) {
        case 0:
            result = 1;
            break;
        case 1:
            result = 2;
            break;
        case 2:
            result = 3;
            break;
        case 3:
            result = 4;
            break;
        default:
            break;
    }
    return result;
}



//请求服务器数据
-(void)requestData{
    // [SVProgressHUD showWithStatus:@"正在获取数据" maskType:SVProgressHUDMaskTypeClear];  //弹出等待提示
    
    
    NSString* request_url = [NSString stringWithFormat:@"%@?good_typeid=%i&count=%i&page=%i",API_URL,
                             [self getTypeId:menu.selectedIndex],
                             count,
                             page];
    
    if(minIntegral !=0 && maxIntegral != 0 && maxIntegral>minIntegral){ //追加积分条件
        request_url = [NSString stringWithFormat:@"%@&low_integral=%i&high_integral=%i",request_url,minIntegral,maxIntegral];
    }
    
    if(![title isEqual:Nil] && ![title isEqual:@"(null)"]){
        request_url = [NSString stringWithFormat:@"%@&good_name=%@",request_url,[title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
   // [self MyLog:[NSString stringWithFormat:@"%@",request_url]];
    mHttpRequestTool.url = request_url;
    
    NSThread* myThread = [[NSThread alloc] initWithTarget:mHttpRequestTool selector:@selector(startRequest) object:nil];
    [myThread start];
    
}

//关于对话框
- (void) aboutDlg {
    
    UIViewController* view = [[self storyboard] instantiateViewControllerWithIdentifier:@"aboutdlgview"];
    [[self navigationController] pushViewController:view animated:YES];
}

//筛选对话框
- (void) filterDlg {
    [self changeSelection];
    SearchView* view = [[self storyboard] instantiateViewControllerWithIdentifier:@"searchview"];
    view.delegate = self;
    [[self navigationController] pushViewController:view animated:YES];
}

//下载图片
-(void) downloadImage:(CellAndImage*) mCellAndImage{
   // [self MyLog:[NSString stringWithFormat:@"url=%@",mCellAndImage.image_url] ];
    [imageLoader displayImage: mCellAndImage.imageView ImageUrl:mCellAndImage.image_url];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self MyLog:@"didReceiveMemoryWarning"];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidDisappear:(BOOL)animated{
   // [self MyLog:@"viewDidDisappear"];
}
#pragma mark - RefreshViewDelegate
- (void)refreshViewDidCallBack {
    [self MyLog:@"refreshViewDidCallBack"];
    requestType = TypeRefresh;
    page = 1;
    [self requestData];
}
- (void) moreViewdDidCallBack{
    tableViewOffsetY =  mUITableView.contentOffset.y;
    requestType = TypeMore;
    ++page;
    [self requestData];
}

#pragma mark -
#pragma mark Dropdown menu
//回调方法,下拉框
- (void)didSelectItemAtIndex:(NSUInteger)index SelectedIndexOld:(NSUInteger)selectedIndexOld{
    if(index != selectedIndexOld){
        NSString* bank = menu.items[index];
        [menu setTitle:bank];
        [self changeSelection];
        requestType = TypeRefresh;
        [refreshView startLoading];
        [self requestData];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"PullTableView numberOfRowsInSection %i",section);
    return _list.count;
}
//Cell适配, 给每项Cell赋值
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"cellForRowAtIndexPath");
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:
                        CustomCellIdentifier];
    
    NSUInteger row = [indexPath row];
  //  [self MyLog:[NSString stringWithFormat:@"row=%i",row]];
    
    Good *good =[self.list objectAtIndex:row];
    
    [cell initStyle];
    [cell setTitle:good.title];
    
    
    NSString* temp_integral = @"";
    if ([good.cash floatValue] == 0.0f) {
        temp_integral = [NSString stringWithFormat:@"%@",good.integral];
    }else{
        temp_integral = [NSString stringWithFormat:@"%@ ￥%@",good.integral,good.cash];
    }
    [cell setIntegral:temp_integral];
  
    [cell setNo:good.no];
    
    //图片处理
    CellAndImage* mCellAndImage = [[CellAndImage alloc] init];
    [mCellAndImage setImageView:cell.imageView];
    [mCellAndImage setImage_url:good.image_url];
    //加入到异步队列线程里
    [self downloadImage:mCellAndImage];
   // NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self //selector:@selector(downloadImage:) object:mCellAndImage];
   
   // [queue addOperation:op];
    
    return cell;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}*/


//选中某个Cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Good *good = [self.list objectAtIndex:[indexPath row]];
    selectedIndex = [indexPath row];
    NSString* message = [NSString stringWithFormat:@"复制编号:%@ ?",good.no];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert = nil;

}


#pragma mark -
#pragma mark Http
//回调方法,接收http返回json数据
-(void)onMsgReceive :(NSData*) msg :(NSError*) error
{
    [refreshView stopLoading];
    if(error != Nil){
        NSInteger code = [error code];
        [self MyLog:[NSString stringWithFormat:@"error %i %@",[error code],error]];
        switch (code) {
            case NSURLErrorNotConnectedToInternet://网络断开
                [SVProgressHUD showErrorWithStatus:@"无法连接到网络!"];
                break;
            case NSURLErrorTimedOut://请求超时
                 [SVProgressHUD showErrorWithStatus:@"请求超时!"];
                break;
            default:
                break;
        }
        return;
    }
    
    NSError *parse_error=Nil;
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:msg options:NSJSONReadingMutableLeaves error:&parse_error];
    
    
    if(parse_error != Nil){
        [self MyLog:[NSString stringWithFormat:@"parse error %i %@",[parse_error code],parse_error]];
        return;
    }
    
       switch (requestType) {
        case TypeRefresh:
        {
            [[self list] removeAllObjects];
            [self MyLog:@"onMsgReceive refresh"];
        }
            break;
        case TypeMore:{
            [self MyLog:@"onMsgReceive more"];            
        }break;
        default:
            break;
    }
    
    NSDictionary* data =[dataDic objectForKey:@"data"];//解析得到数据集
  
    for (NSDictionary* each_data in data) {//遍历数据集
        
        NSString *good_name =[each_data objectForKey:@"good_name"];
        NSString *good_integral =[each_data objectForKey:@"good_integral"];
        NSString *good_no =[each_data objectForKey:@"good_no"];
        NSString *good_imgurl =[each_data objectForKey:@"good_imgurl"];
        NSString *good_cash =[each_data objectForKey:@"good_cash"];
        Good *good = [[Good alloc]init];
        good.title = [good_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        good.integral = good_integral;
        good.no = good_no;
        good.image_url = good_imgurl;
        good.cash =good_cash;
        if(good_name==nil) continue;
        
        [self.list addObject:good];//加入到list
    }
    [self MyLog:[NSString stringWithFormat:@"data.count=%i list.count=%i",
                 data.count,_list.count]];
    
    [self performSelectorOnMainThread:@selector(reloadView) withObject:nil waitUntilDone:YES];
}

-(void) reloadView {
    [mUITableView reloadData];
    switch (requestType) {
        case TypeRefresh:
        {
          
        }
            break;
        case TypeMore:{
             [self MyLog:[NSString stringWithFormat:@"loadMoreView=%f page=%i result=%f",mUITableView.frame.size.height,page,(mUITableView.frame.size.height) * page]];
            [mUITableView setContentOffset:CGPointMake(0,
                                                      tableViewOffsetY) animated:NO];
            
        }break;
        default:
            break;
    }
}
-(void) MyLog: (NSString*) msg{
#if defined(LOG_DEBUG)
    NSLog(@"%@ %@",NSStringFromClass([self class]),msg);
#endif
}
@end
