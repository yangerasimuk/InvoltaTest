//
//  INVAnalogsSample.h
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INVDrug;

@interface INVAnalogsSample : NSObject

@property (nonatomic) INVDrug *expensiveDrug;
@property (nonatomic) INVDrug *cheapDrug;

- (instancetype)initWithExpensiveDrug:(INVDrug *)expensiveDrug cheapDrug:(INVDrug *)cheapDrug;

@end
