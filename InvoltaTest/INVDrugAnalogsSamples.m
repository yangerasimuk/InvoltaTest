//
//  INVDrugAnalogsSamples.m
//  InvoltaTest
//
//  Created by Ян on 02.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVDrugAnalogsSamples.h"
#import "INVAnalogsSample.h"

@implementation INVDrugAnalogsSamples

- (instancetype)init {
    self = [super init];
    if(self){
        _list = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
