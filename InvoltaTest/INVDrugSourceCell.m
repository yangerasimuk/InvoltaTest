//
//  INVDrugSourceCell.m
//  InvoltaTest
//
//  Created by Ян on 04.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVDrugSourceCell.h"

@implementation INVDrugSourceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:255/255.f green:224/255.f blue:161/255.f alpha:0.5f];
    }
    return self;
}

@end
