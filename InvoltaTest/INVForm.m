//
//  INVForm.m
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVForm.h"
#import "INVDrugName.h"

@implementation INVForm

- (instancetype)initWithId:(NSInteger)formId name:(NSString *)name drugNames:(NSMutableArray <INVDrugName *> *)drugNames {
    
    self = [super init];
    if(self){
        _formId = formId;
        _name = [name copy];
        
        if(drugNames)
            _drugNames = [drugNames copy];
        else
            _drugNames = [NSMutableArray array];
    }
    return self;
}


- (instancetype)initWithId:(NSInteger)formId name:(NSString *)name {
    
    return [self initWithId:formId name:name drugNames:nil];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Форма выпуска лекарства. id = %ld, %@", _formId, _name];
}

- (BOOL)isEqual:(id)object {
    
    if(self == object)
        return YES;
    
    if(![self isMemberOfClass:[object class]])
        return NO;
    
    INVForm *objectForm = (INVForm *)object;
    
    if(self.formId != objectForm.formId)
        return NO;
    if(![self.name isEqualToString:objectForm.name])
        return NO;
    if([self.drugNames count] != [objectForm.drugNames count])
        return NO;
    
    return YES;
}


#pragma mark - NSCoping

- (id)copyWithZone:(NSZone *)zone {
    
    INVForm *newForm = [[INVForm alloc] init];
    newForm.formId = _formId;
    newForm.name = [_name copy];
    newForm.drugNames = [_drugNames mutableCopy];
    
    return newForm;
}
@end
