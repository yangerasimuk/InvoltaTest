//
//  INVDrug.h
//  InvoltaTest
//
//  Created by Ян on 02.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INVForm;

@interface INVDrug : NSObject

@property (nonatomic, assign) NSInteger drugId;
@property (nonatomic, copy) INVForm *form;
@property (nonatomic, copy) NSString *imageUrlString;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger cost;
@property (nonatomic, assign) NSInteger minCost;
@property (nonatomic, assign) NSInteger maxCost;
@property (nonatomic, assign) NSInteger rating;

- (instancetype)initWithDrugId:(NSInteger)drugId form:(INVForm *)form imageUrlString:(NSString *)imageUrlString name:(NSString *)name cost:(NSInteger)cost minCost:(NSInteger)minCost maxCost:(NSInteger)maxCost rating:(NSInteger)rating;

- (instancetype)initWithDrugId:(NSInteger)drugId imageUrlString:(NSString *)imageUrlString name:(NSString *)name cost:(NSInteger)cost rating:(NSInteger)rating;

- (instancetype)initWithDrugId:(NSInteger)drugId form:(INVForm *)form name:(NSString *)name;

@end
