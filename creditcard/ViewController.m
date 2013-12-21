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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self MyLog:@"viewDidLoad"];
   
    [self initData];
    for (id obj in self.view.subviews)  {
        [ImageHelper setRect:obj];
    }
    /*[mUITableView setFrame:CGRECT_HAVE_NAV(mUITableView.frame.origin.x,
                                            mUITableView.frame.origin.y,
                                            mUITableView.frame.size.width,
                                            self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
     */
}

//关于对话框
- (void) aboutDlg {
   /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"关于" message:@"作者：陆键霏" delegate:nil cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;*/
    
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
- (void) initData{
    title = @"";
    minIntegral = 0;
    maxIntegral = 0;
    flagRefresh = NO;
    loadingMore = NO;
    noNeedToLoad = NO;
    page = 1;   //第一页
    count = 10; //每页大小为十条数据
    selectedBankIndex = 0;
    state = PULL_UPDATING;
    bank_array = [NSArray arrayWithObjects:@"平安银行", @"农业银行", @"中国银行", @"招商银行", nil];
    
    mHttpRequestTool = [HttpRequestTool alloc]; //初始化HTTP请求类
    mHttpRequestTool.delegate = self;           //注册回调
    
    //加入标题下拉按钮
    if (self.navigationItem) {
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"平安银行"];
        [menu displayMenuInView:self.view];
        menu.items = bank_array;
        menu.delegate = self;
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
    mUITableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height)];
    [mUITableView setDelegate:self];
    [mUITableView setDataSource:self];
    
    [self.view addSubview:mUITableView];
    
    //加入下拉刷新的header view
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mUITableView.bounds.size.height, self.view.frame.size.width, mUITableView.bounds.size.height)];
		view.delegate = self;
        [mUITableView  setSectionHeaderHeight:0.0f];
		[mUITableView addSubview:view];
		_refreshHeaderView = view;
		view = nil;
	}

    
    [self createTableFooter:INIT_FOOTER_TEXT:NO]; //加入footer
    [mUITableView.tableFooterView setHidden:YES]; //刚开始先隐藏
         //加入List
    NSMutableArray *MutableArray = [[NSMutableArray alloc] init];
    self.list = MutableArray;
    
    urlDict = [[NSMutableDictionary alloc] init];//url字典
    //初始化异步队列线程类
    queue = [[NSOperationQueue alloc] init];
    
   [SVProgressHUD showWithStatus:@"正在获取数据" maskType:SVProgressHUDMaskTypeClear];  //弹出等待提示
    [self requestData:[ self getTypeId:0]];//一开始就加入平安银行的数据
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"numberOfRowsInSection");
    return [self.list count];
}

//下载图片
-(void) downloadImage:(CellAndImage*) mCellAndImage{
    
    if ([urlDict objectForKey:mCellAndImage.image_url]==nil) {
        [self MyLog:[NSString stringWithFormat:@"url=%@",mCellAndImage.image_url] ];
        [urlDict setObject:mCellAndImage.image_url forKey:mCellAndImage.image_url];
        
        NSURL *imageUrl = [NSURL URLWithString:mCellAndImage.image_url];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        //压缩图片
        CGSize mCGSize = CGSizeMake(CELL_IMAGE_WIDTH, CELL_IMAGE_HEIGHT);
        UIImage* after_image = [ImageHelper image:image fitInSize:mCGSize];
        
        [[self.list objectAtIndex:mCellAndImage.index] setImage:after_image];
        
        //即时更新
        
        [mUITableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
        image = nil;
        after_image = nil;
    }
   
}

//Cell适配, 给每项Cell赋值
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"cellForRowAtIndexPath");
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    //static BOOL nibsRegistered = NO;
   // if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
      //  nibsRegistered = YES;
    //}
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:
                        CustomCellIdentifier];
    
    NSUInteger row = [indexPath row];
    
    
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
    if(good.image==nil){
        CellAndImage* mCellAndImage = [[CellAndImage alloc] init];
        [mCellAndImage setCell:cell];
        [mCellAndImage setImage_url:good.image_url];
        [mCellAndImage setIndex:row];
        //加入到异步队列线程里
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:mCellAndImage];
        [queue addOperation:op];
    }else{
        //更新图片
        [cell setImage:good.image];
    }
    
    
    return cell;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}

//选中某个Cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Good *good = [self.list objectAtIndex:[indexPath row]];
    selectedIndex = [indexPath row];
    NSString* message = [NSString stringWithFormat:@"复制编号:%@ ?",good.no];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    alert = nil;

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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self MyLog:@"didReceiveMemoryWarning"];
    // Dispose of any resources that can be recreated.
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

//回调方法,下拉框
- (void)didSelectItemAtIndex:(NSUInteger)index{
    noNeedToLoad = NO;
    NSString* bank = bank_array[index];
    [menu setTitle:bank];
    [self changeSelection];
    [SVProgressHUD showWithStatus:@"正在获取数据" maskType:SVProgressHUDMaskTypeClear];  //弹出等待提示
    [self requestData:[ self getTypeId:index]];//一开始就加入平安银行的数据
}

//请求服务器数据
-(void)requestData:(NSUInteger)index{
    [self MyLog:[NSString stringWithFormat:@"requestData %i %i %i",index,loadingMore,_reloading]];
    if (loadingMore) {
        
        return;
    }
    if(_reloading){
        
        return;
    }
    // [SVProgressHUD showWithStatus:@"正在获取数据" maskType:SVProgressHUDMaskTypeClear];  //弹出等待提示

    
    if (state == PULL_MORE_LOADING) {
        [self MyLog:@"state==PULL_MORE_LOADING"];
         ++page;
        loadingMore = YES;
    }else if (state == PULL_UPDATING){
        [self MyLog:@"state==PULL_UPDATING"];
    }
   
    NSString* request_url = [NSString stringWithFormat:@"%@?good_typeid=%i&count=%i&page=1",API_URL,index,count*page];
    
    if(minIntegral !=0 && maxIntegral != 0 && maxIntegral>minIntegral){ //追加积分条件
        request_url = [NSString stringWithFormat:@"%@&low_integral=%i&high_integral=%i",request_url,minIntegral,maxIntegral];
    }
    
    if(![title isEqual:Nil] && ![title isEqual:@"(null)"]){
        request_url = [NSString stringWithFormat:@"%@&good_name=%@",request_url,[title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [self MyLog:[NSString stringWithFormat:@"%@",request_url]];
    mHttpRequestTool.url = request_url;
    
    //NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(threafunc) object:nil];
    NSThread* myThread = [[NSThread alloc] initWithTarget:mHttpRequestTool selector:@selector(startRequest) object:nil];
    [myThread start];
    
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
   // NSLog(@"offset y=%f bounds.height=%f size1.height=%f",offset.y,bounds.size.height,size.height);
    float y1 = offset.y + bounds.size.height;
    float h1 = size.height;
    float offset_pull_up = 100;//上拉的偏移量
    if ((y1 - h1) > offset_pull_up) {
        flagRefresh = YES;
    }
    else {
        flagRefresh = NO;
    }
    if(flagRefresh){
        
       [self MyLog:@"上拉刷新"];
      // state = PULL_MORE_LOADING;
      // [self reloadTableViewDataSourceWhenPullUp];
    }else{
       // NSLog(@"取消刷新");
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [self MyLog:@"scrollViewDidEndDragging"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 创建表格底部
- (void) createTableFooter:(NSString*) footer_title : (BOOL) loading;
{
    if (tableFooterView==Nil ) {
        tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mUITableView.bounds.size.width, 60.0f)];
        
        //加入载入更多提示
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMore)];
        [mUITableView addGestureRecognizer:singleTap];
        
        if(loadMoreText==nil){
            loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 60.0f)];
            [loadMoreText setCenter:tableFooterView.center];
            [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
            [loadMoreText setText:footer_title];
            [tableFooterView addSubview:loadMoreText];
        }
        if (activityIndicatorView==nil) {
            activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                     initWithFrame:CGRectMake(self.view.bounds.size.width-50.0,14,30.0,30.0)];
            activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
            [tableFooterView addSubview:activityIndicatorView];
            if (loading) {
                 [activityIndicatorView startAnimating];
            }else{
                [activityIndicatorView stopAnimating];
            }
           
        }
       mUITableView.tableFooterView = tableFooterView;
    }else{
       [loadMoreText setText:footer_title];
        if (loading) {
            [activityIndicatorView startAnimating];
        }else{
            [activityIndicatorView stopAnimating];
        }
    }
}
-(void) loadMore{
    [self createTableFooter:INIT_FOOTER_GETING_CONTENT_TEXT:YES];
    state = PULL_MORE_LOADING;
    [self requestData:[ self getTypeId:[menu selectedIndex] ]];
}
//回调方法,接收http返回json数据
-(void)onMsgReceive :(NSData*) msg :(NSError*) error
{
    
    [SVProgressHUD dismiss];//消除等待提示
    [self doneLoadingTableViewData];
    [mUITableView.tableFooterView setHidden:NO];//让Footer显示出来
   // [self createTableFooter:INIT_FOOTER_TEXT :YES];
    loadingMore = NO;
    if(selectedBankIndex != menu.selectedIndex){ //切换银行时，回到顶部
        CGPoint point = CGPointMake(0, 0);
        [mUITableView setContentOffset:point]; //回到顶端
        
        selectedBankIndex = menu.selectedIndex;
    }
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
    
    for (Good* temp_good in self.list) { //清除旧数据
        [temp_good setImage:nil];
    }
     [self.list removeAllObjects];
    
    NSDictionary* data =[dataDic objectForKey:@"data"];//解析得到数据集
    
    for (NSDictionary* each_data in data) {//遍历数据集
        
        NSString *good_name =[each_data objectForKey:@"good_name"];
        NSString *good_integral =[each_data objectForKey:@"good_integral"];
        NSString *good_no =[each_data objectForKey:@"good_no"];
        NSString *good_imgurl =[each_data objectForKey:@"good_imgurl"];
        NSString *good_cash =[each_data objectForKey:@"good_cash"];
        Good *good = [[Good alloc]init];
        good.title = good_name;
        good.integral = good_integral;
        good.no = good_no;
        good.image_url = good_imgurl;
        good.cash =good_cash;
        if(good_name==nil) continue;
        
        [self.list addObject:good];//加入到list
    }
    [self MyLog:[NSString stringWithFormat:@"data.count=%i",data.count]];
    if(data.count==0){
        noNeedToLoad = YES;
        [self createTableFooter:INIT_FOOTER_NO_CONTENT_TEXT:NO];
    }else{
        [self createTableFooter:INIT_FOOTER_TEXT:NO];
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"共%i条信息,亲", data.count]];
    }
    [mUITableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];//主线程更新列表数据
    
    
}
-(void)passValue:(UserEntity *)value{ //从筛选界面过来
    [self MyLog:[NSString stringWithFormat:@"%@ min %i max %i",value.title,value.minIntegral,value.maxIntegral]];
    noNeedToLoad = NO;
    _reloading = NO;

    title = value.title;
    minIntegral = value.minIntegral;
    maxIntegral = value.maxIntegral;
    [SVProgressHUD showWithStatus:@"正在获取数据" maskType:SVProgressHUDMaskTypeClear];  //弹出等待提示
    [self requestData:[ self getTypeId:[menu selectedIndex] ]];//一开始就加入平安银行的数据
}
-(void) changeSelection{
    [queue cancelAllOperations];//取消所有操作
    queue = nil;
    queue = [[NSOperationQueue alloc] init];
    page = 1;
    title = @"";
    [urlDict removeAllObjects];
    minIntegral = 0;
    maxIntegral = 0;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
     [self requestData:[self getTypeId:menu.selectedIndex]];
    _reloading = YES;
    [self MyLog:@"reloadTableViewDataSource"];
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:mUITableView];
    [self MyLog:@"doneLoadingTableViewData"];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];//搞定就调用doneLoadingTableViewData
    [self MyLog:@"egoRefreshTableHeaderDidTriggerRefresh"];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    //NSLog(@"egoRefreshTableHeaderDataSourceIsLoading");
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    [self MyLog:@"egoRefreshTableHeaderDataSourceLastUpdated"];
	return [NSDate date]; // should return date data source was last changed
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
    //NSLog(@"titleForHeaderInSection");
	return [NSString stringWithFormat:@"Section %i", section];
	
}


- (void) reloadTableViewDataSourceWhenPullUp{
    if (noNeedToLoad) {
        [SVProgressHUD showErrorWithStatus:@"没有信息了，亲!"];
        return;
    }
    [self createTableFooter:INIT_FOOTER_GETING_CONTENT_TEXT :YES];
    [self requestData:[self getTypeId:menu.selectedIndex]];
}

- (void) viewDidDisappear:(BOOL)animated{
    [self MyLog:@"viewDidDisappear"];
}

-(void) MyLog: (NSString*) msg{
#if defined(LOG_DEBUG)
    NSLog(@"%@ %@",NSStringFromClass([self class]),msg);
#endif
}
@end
