//
//  RefreshView.m
//  Testself
//
//  Created by Jason Liu on 12-1-10.
//  Copyright 2012年 Yulong. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView
@synthesize isLoading = _isLoading;
@synthesize owner = _owner;
@synthesize delegate = _delegate;
- (id)initWithOwner:(UIScrollView *)owner delegate:(id<RefreshViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.frame = CGRectMake(0, - owner.frame.size.height, owner.bounds.size.width, owner.frame.size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        //更新状态文本
        _refreshStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshStatusLabel.frame = CGRectMake(0.0f, owner.frame.size.height - 48.0f, self.frame.size.width, 20.0f);
		_refreshStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_refreshStatusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_refreshStatusLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
		_refreshStatusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_refreshStatusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_refreshStatusLabel.backgroundColor = [UIColor clearColor];
		_refreshStatusLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_refreshStatusLabel];

        //最后更新时间文本
        _refreshLastUpdatedTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshLastUpdatedTimeLabel.frame = CGRectMake(0.0f, owner.frame.size.height - 30.0f, self.frame.size.width, 20.0f);
		_refreshLastUpdatedTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_refreshLastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12.0f];
		_refreshLastUpdatedTimeLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
		_refreshLastUpdatedTimeLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_refreshLastUpdatedTimeLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_refreshLastUpdatedTimeLabel.backgroundColor = [UIColor clearColor];
		_refreshLastUpdatedTimeLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_refreshLastUpdatedTimeLabel];
        
        //刷新提示器
		_refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshIndicator.frame = CGRectMake(25.0f, owner.frame.size.height - 45.0f, 20.0f, 20.0f);
		[self addSubview:_refreshIndicator];
        
        //箭头提示
        _refreshArrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _refreshArrowImageView.frame = CGRectMake(25.0f, owner.frame.size.height - 55.0f, 17.0, 42.0);
        _refreshArrowImageView.image = [UIImage imageNamed:@"blueArrow.png"];
		[self addSubview:_refreshArrowImageView];

        
    
        [owner insertSubview:self atIndex:0];

        
        //加入脚视图
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, 60.0f)];
        
        //加入载入提示点击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMore)];
        [footerView addGestureRecognizer:singleTap];
        
        //加载更多文本
        _moreStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, 0.0f, 50.0f, 60.0f)];
        [_moreStatusLabel setCenter:footerView.center];
        [_moreStatusLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        [_moreStatusLabel setText:MORE_STATUS];
        
        [footerView addSubview:_moreStatusLabel];
        
        //加载更多刷新指示器
        _moreIndicator = [[UIActivityIndicatorView alloc ]
                                 initWithFrame:CGRectMake(self.bounds.size.width-50.0,14,30.0,30.0)];
        
        _moreIndicator.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
        
        [footerView addSubview:_moreIndicator];
        
        ((UITableView*)owner).tableFooterView = footerView;
        /*if (loading) {
         [activityIndicatorView startAnimating];
         }else{
         [activityIndicatorView stopAnimating];
         }*/
        
        _owner = owner;
        _delegate = delegate;
        [_refreshIndicator stopAnimating];
        
         self.owner.delegate = self;
    }
    return self;
}
- (void)loadMore{
    if (!_isLoading) {
        [_moreIndicator startAnimating];
        _moreStatusLabel.text = MORE_LOADING_STATUS;
        
        if ([_delegate respondsToSelector:@selector(moreViewdDidCallBack)]) {
            [_delegate moreViewdDidCallBack];
        }
    }
}
// refreshView 结束加载动画
- (void)stopLoading {
    NSLog(@"stopLoading");
    // control
    _isLoading = NO;
    
    // Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _owner.contentOffset = CGPointZero;//偏移量归零,tableview置顶
    _refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);//箭头回到零度
    [UIView commitAnimations];
    
    // UI 更新日期计算
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"MM'-'dd HH':'mm':'ss"];
    NSString *timeStr = [outFormat stringFromDate:nowDate];
    // UI 赋值
    _refreshLastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@", REFRESH_UPDATE_TIME_PREFIX, timeStr];
    _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;//恢复成"下拉可以刷新"文本
    _refreshArrowImageView.hidden = NO; //隐藏箭头
    [_refreshIndicator stopAnimating]; //停止圆圈动画
    
    //加载更多提示
    [_moreIndicator stopAnimating];
    _moreStatusLabel.text = MORE_STATUS;
}

// refreshView 开始加载动画
- (void)startLoading {
    // control
    _isLoading = YES;
    // Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _owner.contentOffset = CGPointMake(0, -REFRESH_TRIGGER_HEIGHT);//下向拽的偏移量
    _owner.contentInset = UIEdgeInsetsMake(REFRESH_TRIGGER_HEIGHT, 0, 0, 0);//scrollview的contentview的顶点相对于scrollview的位置
    _refreshStatusLabel.text = REFRESH_LOADING_STATUS;//加载中文本
    _refreshArrowImageView.hidden = YES;//隐藏箭头
    [_refreshIndicator startAnimating];//开始刷新按钮动画
    [UIView commitAnimations];
}
// refreshView 刚开始拖动时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   // NSLog(@"scrollViewWillBeginDragging");
    if (_isLoading) return;//正在刷新则忽略
    _isDragging = YES; //记录正在拉拽
}
// refreshView 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // NSLog(@"scrollViewDidScroll");
    if (_isLoading) {//载入中的情况
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0) //tableview升过顶
            scrollView.contentInset = UIEdgeInsetsZero;//scrollview的contentView恢复为零
        else if (scrollView.contentOffset.y >= -REFRESH_TRIGGER_HEIGHT)//高于正在刷新的高度
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);//跟随scrollview的内容视图偏移量变化
    } else if (_isDragging && scrollView.contentOffset.y < 0) { //正在拉拽且tableview下拉
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < - REFRESH_TRIGGER_HEIGHT) {//下拉时超过设定header的界线
            // User is scrolling above the header
            _refreshStatusLabel.text = REFRESH_RELEASED_STATUS;//提示松开时可刷新
            _refreshArrowImageView.transform = CGAffineTransformMakeRotation(3.14);//旋转箭头180度
        } else { // User is scrolling somewhere within the header
            //下拉时没有超过设定header的界线
            _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;//提示下拉时可刷新
            _refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
        }
        [UIView commitAnimations];
    }
    else if(!_isDragging && !_isLoading){ 
            scrollView.contentInset = UIEdgeInsetsZero;
    }
}
// refreshView 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
   // NSLog(@"scrollViewDidEndDragging");
    if (_isLoading) return;//正在刷新则忽略
    _isDragging = NO;
    if (scrollView.contentOffset.y <= - REFRESH_TRIGGER_HEIGHT) {//松开时下拉调试超过设定header的高度,回调刷新
        if ([_delegate respondsToSelector:@selector(refreshViewDidCallBack)]) {
            [_delegate refreshViewDidCallBack];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 //   NSLog(@"%f %f %f",
       //   scrollView.contentOffset.y,
       //   scrollView.contentSize.height,
       //   scrollView.frame.size.height);
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
        //滑到底部加载更多
        [self loadMore];
    }
}
@end
