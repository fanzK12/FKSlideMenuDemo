//
//  FKAddChannelVC.m
//  FKSlideMenuDemo
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "FKAddChannelVC.h"
#import "FKChannelCollectionViewCell.h"
#import "FKChannelCollectionReusableView.h"
#import "Pch.pch"

#define itemSize_Height 30

#define itemSize_Width 60

#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)

static NSString * channelID = @"ChannelCollectionViewCell";
static NSString * reusableViewID = @"ChannelCollectionReusableView";

//定义cell是否是编辑状态的枚举
typedef NS_ENUM(NSInteger,cellStatus){
    cellStatusEdite = 0,//编辑状态
    cellStatusFinsh     //完成状态
};

@interface FKAddChannelVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * _collectionView;
    UICollectionViewFlowLayout * _layout;
    NSMutableArray * _channelArray;//装载我的频道的数据
    NSMutableArray * _recommendArray;//装载推荐频道的数据
    cellStatus cellEditeStatus;//记录编辑状态
}
@end

@implementation FKAddChannelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [self setBackBtn];
    
    [self loadData];
    
    //默认设置初始cell的编辑状态为 未编辑即完成状态
    cellEditeStatus = cellStatusFinsh;
    
    [self createCollectionView];
    
}
#pragma mark -- 设置返回按钮--
- (void)setBackBtn{
    UIButton*cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth-60, 20, 60, 30)];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}
- (void)backBtnAction:(UIButton *)sender{
    [_delegate fk_backToRefresh];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 加载数据--
- (void)loadData{
    NSArray*array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*path=[array[0] stringByAppendingPathComponent:@"channel.plist"];
    _channelArray=[NSMutableArray arrayWithContentsOfFile:path];
    
    NSString*tuijianPath=[array[0] stringByAppendingPathComponent:@"recommend.plist"];
    _recommendArray=[NSMutableArray arrayWithContentsOfFile:tuijianPath];
    if (_recommendArray.count==0||_recommendArray==nil){
        
        _recommendArray=[NSMutableArray arrayWithArray:@[@"娱乐",@"健康",@"旅游",@"历史",@"时尚",@"闺房",@"游戏",@"互联网",@"干货",@"教育",@"育儿",@"奇闻",@"美食",@"文玩",@"星座",@"动漫",@"股票",@"NBA",@"家居",@"留学",@"美容",@"数码"]];
        [_recommendArray writeToFile:tuijianPath atomically:YES];
        
    }

}

#pragma mark -- 初始化collectionView --
- (void)createCollectionView{
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(itemSize_Width, itemSize_Height);
    _layout.minimumLineSpacing = 10;
    _layout.minimumInteritemSpacing = 10;
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navigation_height + statuBar_height, kDeviceWidth, KDeviceHeight - navigation_height - statuBar_height) collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor grayColor];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FKChannelCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:channelID];
    
     [_collectionView registerNib:[UINib nibWithNibName:@"FKChannelCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewID];
    [_layout setHeaderReferenceSize:CGSizeMake(kDeviceWidth, 50)];
    
    [self.view addSubview:_collectionView];
}

#pragma mark+++设置collectionView 的区块数++++++
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
#pragma mark++++  设置每个区块的单元格的个数 ++++++++
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section==0)
    {
        return _channelArray.count;
        
    }
    else
    {
        return _recommendArray.count;
    }
    
}
#pragma mark++ 设置单元格 +++
-( __kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FKChannelCollectionViewCell*channelCell=[collectionView dequeueReusableCellWithReuseIdentifier:channelID forIndexPath:indexPath];
    
    if (cellEditeStatus==cellStatusFinsh)//未编辑状态
    {
        channelCell.cannelImage.hidden=YES;// 隐藏编辑符号
        
        if (indexPath.section==0)//第一个区块
        {
            channelCell.textLb.text=_channelArray[indexPath.item];
        }
        else//第二个区块
        {
            channelCell.textLb.text=_recommendArray[indexPath.item];
        }
        
    }
    else  if (cellEditeStatus ==cellStatusEdite)//编辑状态
    {
        if (indexPath.section==0)//第一个区块
        {
            channelCell.textLb.text=_channelArray[indexPath.item];
            channelCell.cannelImage.hidden=NO;//不隐藏编辑符号
        }
        else  //第二个区块
        {
            channelCell.textLb.text=_recommendArray[indexPath.item];
            channelCell.cannelImage.hidden=YES;
            
        }
        
    }
    return channelCell;
    
}

#pragma mark++  设置单元格的点击事件 +++
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FKChannelCollectionViewCell*channelCell=(FKChannelCollectionViewCell*)[_collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    if (cellEditeStatus==cellStatusEdite)//编辑状态
    {
        if (indexPath.section==0)//第一个区块
        {
            
            //获取当前选择的单元格的内容
            NSString*cellText=channelCell.textLb.text;
            //在第一个区块删除当前所选择的单元格
            [_channelArray removeObject:cellText];
            //在第二个区块插入当前所删除的单元格
            [_recommendArray insertObject:cellText atIndex:0];
            //将更改的数据保存到沙河中
            [self saveDataForEdited];
            //刷新数据
            [_collectionView reloadData];
            
        }
        else //第二个区块
        {
            NSString*cellText=channelCell.textLb.text;
            [_recommendArray removeObject:cellText];
            [_channelArray addObject:cellText];
            [self saveDataForEdited];
            [_collectionView reloadData];
            
        }
    }
    else //非编辑状态
    {
        if (indexPath.section==0)//第一个区块
        {
            [_delegate fk_setChannelText:channelCell.textLb.text andIndex:indexPath.item];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        }
        else //第二个区块
        {
            NSString*cellText=channelCell.textLb.text;
            [_recommendArray removeObject:cellText];
            [_channelArray addObject:cellText];
            [self saveDataForEdited];
            [_collectionView reloadData];
        }
    }
    
    
}

#pragma mark++保存更改的数据到沙河+++
-(void)saveDataForEdited
{
    NSArray*array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*channelPlistPath=[array[0] stringByAppendingPathComponent:@"channel.plist"];
    NSString*tuijianPlistPath=[array[0] stringByAppendingPathComponent:@"recommend.plist"];
    
    [_recommendArray writeToFile:tuijianPlistPath atomically:YES];
    [_channelArray writeToFile:channelPlistPath atomically:YES];
    
}

#pragma mark +++ 设置collectionView的表头 +++++
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //判断是表头还是表尾
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        FKChannelCollectionReusableView*headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableViewID forIndexPath:indexPath];
        
        
        //分区
        if (indexPath.section==0)
        {
            headerView.editeBtn.hidden=NO;
            [headerView.editeBtn addTarget:self action:@selector(editeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            headerView.textLb.text=@"我的频道";
            
        }
        else
        {
            headerView.textLb.text=@"推荐频道";
            
            headerView.editeBtn.hidden=YES;
            
        }
        
        return headerView;
    }
    return nil;
}


#pragma mark+++ 设置编辑按钮的点击事件 +++
-(void)editeBtnAction:(UIButton *)sender
{
    
    
    //根据枚举值 做相应的更改
    if (cellEditeStatus==cellStatusFinsh)//未编辑状态
    {
        cellEditeStatus= cellStatusEdite;//更改当前编辑状态
        
        [sender setTitle:@"编辑" forState:UIControlStateNormal];//更改编辑按钮显示的标题
        
        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];//刷新数据
        
        //获取当前处于编辑状态的单元格
        
        
        NSInteger i=0;
        
        for (NSString*str in _channelArray)
        {
            
            FKChannelCollectionViewCell*cell=(FKChannelCollectionViewCell*)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            if ([str isEqualToString:cell.textLb.text])
            {
                CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
                anim.keyPath = @"transform.rotation";
                
                anim.values = @[@(Angle2Radian(-5)), @(Angle2Radian(5)), @(Angle2Radian(-5))];
                anim.duration = 0.25;
                
                // 动画次数设置为最大
                anim.repeatCount = MAXFLOAT;
                // 保持动画执行完毕后的状态
                anim.removedOnCompletion = YES;
                anim.fillMode = kCAFillModeForwards;
                
                [cell.layer addAnimation:anim forKey:@"shake"];
            }
            
            
            i++;
        }
        
        
    }
    else if(cellEditeStatus==cellStatusEdite)
    {
        cellEditeStatus=cellStatusFinsh;
        
        
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        
        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}







@end
