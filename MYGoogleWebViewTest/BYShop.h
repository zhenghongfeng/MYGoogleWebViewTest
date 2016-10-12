//
//  BYShop.h
//  BinYouHuLian
//
//  Created by zhf on 16/4/18.
//  Copyright © 2016年 郑洪锋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYShop : NSObject

/** name */
@property (nonatomic, copy) NSString *name;
/** 分类 */
@property(nonatomic, copy) NSString *category;
/** 描述 */
@property(nonatomic, copy) NSString *myDescription;
/** legalPerson */
@property (nonatomic, copy) NSString *legalPerson;
/** id */
@property (nonatomic, copy) NSString *myId;
/** 纬度 latitude */
@property (nonatomic, copy) NSString *latitude;
/** 经度 longitude */
@property (nonatomic, copy) NSString *longitude;
/** phone */
@property (nonatomic, copy) NSString *myLegalPerson;
/** location */
@property (nonatomic, copy) NSString *location;
/** images */
@property (nonatomic, strong) NSArray *images;



@end
