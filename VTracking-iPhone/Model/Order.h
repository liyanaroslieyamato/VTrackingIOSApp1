//
//  Order.h
//  VTracking-iPhone
//
//  Created by WangYZ on 2/7/15.
//  Copyright (c) 2015 WangYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *do_number;
@property (nonatomic, strong) NSString *order_type;
@property (nonatomic, strong) NSString *s_name;
@property (nonatomic, strong) NSString *s_company_name;
@property (nonatomic, strong) NSString *r_name;
@property (nonatomic, strong) NSString *r_company_name;
@property (nonatomic, strong) NSString *r_contact_number1;
@property (nonatomic, strong) NSString *r_contact_number2;
@property (nonatomic, strong) NSString *r_address1;
@property (nonatomic, strong) NSString *r_address2;
@property (nonatomic, strong) NSString *r_address3;
@property (nonatomic, strong) NSString *r_postcode;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *cod_amount;
@property (nonatomic, strong) NSString *exchange_code;
@property (nonatomic, strong) NSString *payment_term;
@property (nonatomic, strong) NSString *latest_status;



@end
