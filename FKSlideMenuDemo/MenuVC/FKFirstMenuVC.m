//
//  FKFirstMenuVC.m
//  FKSlideMenuDemo
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "FKFirstMenuVC.h"
#import "Pch.pch"
#import "FKAddChannelVC.h"
#define FK_ChannelBtn_Height  30
#define FK_ChannelBth_Width   60

@interface FKFirstMenuVC ()<FKBackRefreshDelegate>
{
    NSDictionary * _rootDict;   //装载plist数据
    NSMutableArray * _dataArray;//分类数组
    UIButton * _cuurentBtn;     //记录当前按钮
    UILabel * _line;
}
@end

@implementation FKFirstMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPlistData];
    [self loadScrollView];
    _line = [[UILabel alloc]initWithFrame:CGRectMake(0, FK_ChannelBtn_Height-2, FK_ChannelBth_Width, 2)];
    _line.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_line];
    
    //根据分类数组 创建导航栏上的分类按钮
    [self createChannelButtons];
    
    //默认设置第一个按钮为 选中状态
    [self setSelectedAtIndex:0];
}
#pragma mark -- 默认设置选中第N个按钮的方法--
- (void)setSelectedAtIndex:(NSInteger)index{
    
    NSInteger i = 0;
    
    for (UIView * view in _scrollView.subviews) {
        
        if([view isKindOfClass:[UIButton class]]){
            if(i == index){
                UIButton * btn = (UIButton *)view;
                [self currentChannelBtnAction:btn];
            }
            else{
            
            }
            i++;
        }
    }
}

#pragma mark -- 代理方法--
- (void)fk_backToRefresh{
    [self loadPlistData];
    [self createChannelButtons];
    [self setSelectedAtIndex:1];
}
- (void)fk_setChannelText:(NSString *)text andIndex:(NSInteger)index{
    [self loadPlistData];
    [self createChannelButtons];
    [self setSelectedAtIndex:index];
}

- (void)loadPlistData{
    
    //plist数据
    NSString * path = [[NSBundle mainBundle] pathForResource:@"频道ID" ofType:@"plist"];
    _rootDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    //沙盒
    NSArray * array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //拼接路径
    NSString * dataPath = [array[0] stringByAppendingPathComponent:@"channel.plist"];
    //读取沙盒文件
    _dataArray = [NSMutableArray arrayWithContentsOfFile:dataPath];
    
    //文件初始值为空时赋默认值
    if (_dataArray.count == 0 || _dataArray == nil){
        _dataArray = [NSMutableArray arrayWithObjects:@"推荐",@"热点",@"社会",@"财经",@"体育",@"军事",@"科技",@"汽车",@"房产",@"国际", nil];
        [_dataArray writeToFile:dataPath atomically:YES];
    }
}

#pragma mark --初始化scrollView--
- (void)loadScrollView{
    _scrollView = [[UIScrollView alloc]init];
    [_scrollView setFrame:CGRectMake(0, 14, kDeviceWidth - padding*3, FK_ChannelBtn_Height)];
    UIButton * editBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-padding*3, 14, padding*3, padding*3)];
    [editBtn setTitle:@"十" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:editBtn];
    
    //取消弹簧效果
    [self.scrollView setBounces:NO];
    //取消竖直滚动条
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    //取消水平滚动条
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.navigationController.navigationBar addSubview:self.scrollView];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x35a8fc);
}

#pragma mark --添加按钮点击事件--
- (void)editBtnAction:(UIButton *)sender{
    FKAddChannelVC * addChannelVC = [[FKAddChannelVC alloc]init];
    addChannelVC.delegate = self;
    [self presentViewController:addChannelVC animated:YES completion:nil];
}

#pragma mark -- 创建频道分类按钮--
- (void)createChannelButtons{
    
    //移除scrollView上所有的按钮，下划线
    for (UIView * view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]){
            [view removeFromSuperview];
        }
    }
    
    //设置滚动视图的画幅
    [_scrollView setContentSize:CGSizeMake(_dataArray.count * FK_ChannelBth_Width, FK_ChannelBtn_Height)];
    
    NSInteger i = 0;
    
    for (NSString * titleStr in _dataArray) {
        UIButton * titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(i*FK_ChannelBth_Width, 0, FK_ChannelBth_Width, FK_ChannelBtn_Height);
        [titleBtn setTitle:titleStr forState:UIControlStateNormal];
        
        [titleBtn setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
        
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [titleBtn addTarget:self action:@selector(currentChannelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:titleBtn];
        
        i++;
    }
}

#pragma mark -- 分类按钮的点击事件--
- (void)currentChannelBtnAction:(UIButton *)sender{
    
    _cuurentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //取消上一个按钮
    _cuurentBtn.selected = NO;
    //记录当前的按钮
    _cuurentBtn = sender;
    //选中当前按钮
    sender.selected = YES;
    
    sender.titleLabel.font = [UIFont systemFontOfSize:20];
    
    //判断当前滚动视图的画幅是否小于其可见的frame 小于或等于时点击按钮不移动
    if (_scrollView.contentSize.width <= _scrollView.frame.size.width){
    
    }
    //滚动视图的画幅大于可见范围 按钮显示不全
    else{
        
        CGFloat moveNum = sender.center.x - _scrollView.frame.size.width/2;
        if(moveNum < 0) moveNum = 0;//在窗口最左端不移动
        //计算按钮的最大可偏移量，防止scrollView上最右端的按钮发生偏移
        CGFloat maxNum = _scrollView.contentSize.width - _scrollView.frame.size.width;
        
        if(moveNum > maxNum){//如果按钮的可移动范围超出最大值要调整
            moveNum = maxNum;
        }
        [_scrollView setContentOffset:CGPointMake(moveNum, 0) animated:YES];
    }
    
    CGPoint linePoint = _line.center;
    linePoint.x = sender.center.x;
    _line.center = linePoint;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
