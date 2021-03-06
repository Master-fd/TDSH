//
//  FDGoodsModel.h
//  T动衫魂
//
//  Created by asus on 16/5/17.
//  Copyright (c) 2016年 asus. All rights reserved.
//

#import <Foundation/Foundation.h>

//服务器返回的json是array，每个goods是dict。下面为对应的key
#define kGoodsidKey      @"id"
#define kGoodsnameKey        @"name"
#define kGoodspriceKey        @"price"
#define kGoodssubClassKey        @"subClass"
#define kGoodssexKey        @"sex"
#define kGoodsminImageUrl1Key        @"minImageUrl1"
#define kGoodsminImageUrl2Key        @"minImageUrl2"
#define kGoodsminImageUrl3Key        @"minImageUrl3"
#define kGoodsdescImageUrl1Key              @"descImageUrl1"
#define kGoodsdescImageUrl2Key              @"descImageUrl2"
#define kGoodsdescImageUrl3Key              @"descImageUrl3"
#define kGoodsdescImageUrl4Key              @"descImageUrl4"
#define kGoodsdescImageUrl5Key              @"descImageUrl5"
#define kGoodsaboutImageUrlKey              @"aboutImageUrl"
#define kGoodssizeImageUrlKey              @"sizeImageUrl"
#define kGoodsremarkImageUrlKey              @"remarkImageUrl"



@interface FDGoodsModel : NSObject

/**
 *  保存在服务器数据库的ID
 */
@property (nonatomic, copy) NSString *ID;

/**
 *  衣服名称，描述
 */
@property (nonatomic, copy) NSString *name;

/**
 *  价格
 */
@property (nonatomic, copy) NSString *price;

/**
 *  分类
 */
@property (nonatomic, copy) NSString *subClass;

/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;

/**
 *  请求小图片的Url = url+图片名称+4个数字随机数
 */
@property (nonatomic, copy) NSString *minImageUrl1;
@property (nonatomic, copy) NSString *minImageUrl2;
@property (nonatomic, copy) NSString *minImageUrl3;

/**
 *  请求细节图片的Url = url+图片名称+4个数字随机数
 */
@property (nonatomic, copy) NSString *descImageUrl1;
@property (nonatomic, copy) NSString *descImageUrl2;
@property (nonatomic, copy) NSString *descImageUrl3;
@property (nonatomic, copy) NSString *descImageUrl4;
@property (nonatomic, copy) NSString *descImageUrl5;

/**
 *  商品说明
 */
@property (nonatomic, copy) NSString *aboutImageUrl;

/**
 *  尺码表
 */
@property (nonatomic, copy) NSString *sizeImageUrl;

/**
 *购买说明
 */
@property (nonatomic, copy) NSString *remarkImageUrl;







/**
 *  字典转模型
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)goodsWithDict:(NSDictionary *)dict;




@end
