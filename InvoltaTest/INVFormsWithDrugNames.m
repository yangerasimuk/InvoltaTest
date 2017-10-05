//
//  INVFormsWithDrugNames.m
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVFormsWithDrugNames.h"
#import "INVForm.h"

@implementation INVFormsWithDrugNames

- (instancetype)init {
    self = [super init];
    if(self){
        _forms = [NSMutableArray array];
    }
    return self;
}

@end
