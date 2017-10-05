//
//  INVDrugAnalogsSamples.h
//  InvoltaTest
//
//  Created by Ян on 02.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INVAnalogsSample;

@interface INVDrugAnalogsSamples : NSObject

@property (nonatomic) NSMutableArray <INVAnalogsSample *> *list;

- (instancetype)init;

@end
