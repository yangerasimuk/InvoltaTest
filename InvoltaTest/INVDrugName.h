//
//  INVDrugName.h
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INVDrugName : NSObject

@property (nonatomic, assign) NSInteger nameId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger formId;

- (instancetype)initWithId:(NSInteger)nameId name:(NSString *)name formId:(NSInteger)formId;

@end
