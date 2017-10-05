//
//  INVForm.h
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INVDrugName;

@interface INVForm : NSObject

@property (nonatomic, assign) NSInteger formId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSMutableArray <INVDrugName *> *drugNames;

- (instancetype)initWithId:(NSInteger)formId name:(NSString *)name;

@end
