//
//  INVStarsRatingView.m
//  InvoltaTest
//
//  Created by Ян on 04.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVStarsRatingView.h"

#define RATING_MAX 5

@implementation INVStarsRatingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        //
        self.rating = 0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
        
    CGPoint currPoint = CGPointZero;
    
    UIColor *starColor = [UIColor colorWithRed:255/255.f green:209/255.f blue:25/255.f alpha:1.f];
    
    for (int i = 0; i < _rating; i++){
        
        NSDictionary *fullStarAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],
                                             NSForegroundColorAttributeName:starColor,};
        NSAttributedString *fullStarAttrString = [[NSAttributedString alloc] initWithString:@"★" attributes:fullStarAttributes];
        [fullStarAttrString drawAtPoint:currPoint];
        currPoint.x += 20;
    }
    
    for (int i = 0; i < (RATING_MAX - _rating); i++){
        
        NSDictionary *emptyStarAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],
                                             NSForegroundColorAttributeName:starColor,};
        NSAttributedString *emptyStarAttrString = [[NSAttributedString alloc] initWithString:@"☆" attributes:emptyStarAttributes];
        [emptyStarAttrString drawAtPoint:currPoint];
        currPoint.x += 20;
    }
}


- (void)setRating:(NSInteger)rating {
    
    if(rating != _rating){
        
        _rating = rating;
        [self setNeedsDisplay];
    }
}

@end
