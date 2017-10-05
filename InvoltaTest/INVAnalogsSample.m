//
//  INVAnalogsSample.m
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVAnalogsSample.h"
#import "INVDrug.h"

@implementation INVAnalogsSample

- (instancetype)initWithExpensiveDrug:(INVDrug *)expensiveDrug cheapDrug:(INVDrug *)cheapDrug {
    
    self = [super init];
    if(self){
        _expensiveDrug = expensiveDrug;
        _cheapDrug = cheapDrug;
    }
    
    return self;
}

@end
