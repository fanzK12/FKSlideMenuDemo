//
//  FKAddChannelVC.h
//  FKSlideMenuDemo
//
//  Created by apple on 17/3/17.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置返回刷新代理
@protocol FKBackRefreshDelegate <NSObject>

@optional
//返回刷新方法
- (void)fk_backToRefresh;
//指定频道返回并刷新
- (void)fk_setChannelText:(NSString *)text andIndex:(NSInteger)index;

@end

@interface FKAddChannelVC : UIViewController

@property (nonatomic, weak) id<FKBackRefreshDelegate>delegate;

@end
