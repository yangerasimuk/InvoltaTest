//
//  INVDrugSliderView.m
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVDrugSliderView.h"
#import "INVAnalogsSample.h"
#import "INVDrug.h"
#import "INVDrugView.h"

@interface INVDrugSliderView(){
    INVDrugView *p_expenseDrugView;
    INVDrugView *p_cheapDrugView;
}

@end

@implementation INVDrugSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
        p_expenseDrugView = [[INVDrugView alloc] initWithFrame:CGRectMake(10, 10, 300, 120)];
        [self addSubview:p_expenseDrugView];
        
        p_cheapDrugView = [[INVDrugView alloc] initWithFrame:CGRectMake(10, 140, 300, 120)];
        [self addSubview:p_cheapDrugView];
    }
    return self;
}

- (void)setAnalogsSample:(INVAnalogsSample *)analogsSample {
    
    _analogsSample = analogsSample;
    p_expenseDrugView.drug = analogsSample.expensiveDrug;
    p_cheapDrugView.drug = analogsSample.cheapDrug;
    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setIndex:(int)index {
    
    if(index == 0)
        index = 30;
    
    CGFloat colorBase = (CGFloat)255/index;
    colorBase = colorBase/255.f;
    
    NSLog(@"colorBase: %f", colorBase);
    
    UIColor *backColor = [UIColor colorWithRed:colorBase
                                         green:colorBase
                                          blue:colorBase
                                         alpha:1];
    
    self.backgroundColor = backColor;
    //[self setNeedsDisplay];
}

- (void)setBackColor:(UIColor *)backColor {
    if(backColor) {
        self.backgroundColor = backColor;
    }
}

@end
