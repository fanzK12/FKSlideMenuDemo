//
//  common.h
//  网易新闻客户端实践
//
//  Created by 杨金发 on 2017/2/16.
//  Copyright © 2017年 杨金发. All rights reserved.
//

//#ifndef common_h
//#define common_h
//
//
//#endif /* common_h */

#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define padding 10
#define  navigation_height 44
#define statuBar_height 20
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
