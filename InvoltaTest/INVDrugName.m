//
//  INVDrugName.m
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVDrugName.h"

@implementation INVDrugName

- (instancetype)initWithId:(NSInteger)nameId name:(NSString *)name formId:(NSInteger)formId {
    
    self = [super init];
    if(self){
        _nameId = nameId;
        _name = [name copy];
        _formId = formId;
    }
    return self;
}

@end
