//
//  FDAddressCell.h
//  T动衫魂
//
//  Created by asus on 16/8/2.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kcellID  @"addressCellID"
@class FDAddressModel;
@interface FDAddressCell : UITableViewCell

@property (nonatomic, strong) FDAddressModel *model;

@property (nonatomic, copy) void(^defaultsDidClickBlock)(id address);

@end
