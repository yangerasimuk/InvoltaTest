//
//  INVDrug.m
//  InvoltaTest
//
//  Created by Ян on 02.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVDrug.h"
#import "INVForm.h"

@implementation INVDrug

- (instancetype)initWithDrugId:(NSInteger)drugId form:(INVForm *)form imageUrlString:(NSString *)imageUrlString name:(NSString *)name cost:(NSInteger)cost minCost:(NSInteger)minCost maxCost:(NSInteger)maxCost rating:(NSInteger)rating {

    self = [super init];
    if(self){
        _drugId = drugId;
        _form = [form copy];
        _imageUrlString = [imageUrlString copy];
        _name = [name copy];
        _cost = cost;
        _minCost = minCost;
        _maxCost = maxCost;
        _rating = rating;
    }
    return self;
}

- (instancetype)initWithDrugId:(NSInteger)drugId imageUrlString:(NSString *)imageUrlString name:(NSString *)name cost:(NSInteger)cost rating:(NSInteger)rating {
    
    return [self initWithDrugId:drugId form:nil imageUrlString:imageUrlString name:name cost:cost minCost:-1 maxCost:-1 rating:rating];
}

- (instancetype)initWithDrugId:(NSInteger)drugId form:(INVForm *)form name:(NSString *)name {
    
    return [self initWithDrugId:drugId form:form imageUrlString:nil name:name cost:-1 minCost:-1 maxCost:-1 rating:0];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld, %@, %@, %@, %ld, %ld, %ld, %ld", _drugId, _form, _imageUrlString, _name, _cost, _minCost, _maxCost, _rating];
}


- (BOOL)isEqual:(id)object {
    
    if(self == object)
        return YES;
    
    if(![self isMemberOfClass:[object class]])
        return NO;
    
    INVDrug *objectDrug = (INVDrug *)object;
    
    if(self.drugId != objectDrug.drugId)
        return NO;
    if(![self.name isEqualToString:objectDrug.name])
        return NO;
    
    return YES;
}


#pragma mark - NSCoping

- (id)copyWithZone:(NSZone *)zone {
    
    INVDrug *newDrug = [[INVDrug alloc] init];
    newDrug.drugId = _drugId;
    newDrug.form = [_form copy];
    newDrug.name = [_name copy];
    newDrug.imageUrlString = [_imageUrlString copy];
    newDrug.cost = _cost;
    newDrug.minCost = _minCost;
    newDrug.maxCost = _maxCost;
    newDrug.rating = _rating;
    
    return newDrug;
}

@end
