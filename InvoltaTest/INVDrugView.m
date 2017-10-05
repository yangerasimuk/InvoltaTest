//
//  INVDrugView.m
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVDrugView.h"
#import "INVDrug.h"
#import "INVStarsRatingView.h"
#import "INVDrugAnalogsViewController.h"

@interface INVDrugView() {
    
    UIImageView *p_imageView;
    UILabel *p_labelName;
    UILabel *p_labelPrice;
    INVStarsRatingView *p_rating;
}
@end

@implementation INVDrugView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self){
        p_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self addSubview:p_imageView];
        
        p_labelName = [[UILabel alloc] initWithFrame:CGRectMake(125, 20, 150, 20)];
        [self addSubview:p_labelName];
        p_labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(125, 45, 150, 20)];
        [self addSubview:p_labelPrice];
        p_rating = [[INVStarsRatingView alloc] initWithFrame:CGRectMake(125, 70, 150, 25)];
        [self addSubview:p_rating];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}


- (void)handleTapGesture:(UITapGestureRecognizer *)gesture {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"DrugViewTapEvent"
                          object:self
                        userInfo:@{@"Drug":self.drug}];
}


- (void)setDrug:(INVDrug *)drug {
    
    if(drug && ![drug isEqual:_drug]){
        
        // ivar
        _drug = [drug copy];
        
        // image
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:drug.imageUrlString]];
        UIImage *image = [UIImage imageWithData:imageData];
        p_imageView.image = image;
        
        //    dispatch_async(dispatch_get_global_queue(0,0), ^{
        //        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: drug.imageUrlString]];
        //        if (data == nil)
        //            return;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            p_imageView.image = [UIImage imageWithData: data];
        //        });
        //    });
        
        NSDictionary *priceAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
        NSAttributedString *priceAttrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld ₽", drug.cost] attributes:priceAttributes];
        
        p_labelName.text = drug.name;
        p_labelPrice.attributedText = priceAttrString;
        p_rating.rating = drug.rating;
    }
}

@end
