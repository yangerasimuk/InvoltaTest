//
//  INVDrugCell.m
//  InvoltaTest
//
//  Created by Ян on 04.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVDrugCell.h"
#import "INVStarsRatingView.h"
#import "INVDrug.h"

@interface INVDrugCell()

@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelPrice;
@property (nonatomic, strong) INVStarsRatingView *ratingView;

@end

@implementation INVDrugCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        // Имя + цена
        CGRect rectNameAndPriceLabel = CGRectMake(16, 10, 190, 66);
        self.labelName = [[UILabel alloc] initWithFrame:rectNameAndPriceLabel];
        self.labelName.textAlignment = NSTextAlignmentLeft;
        self.labelName.numberOfLines = 0;
        self.labelName.lineBreakMode = NSLineBreakByWordWrapping;
        self.labelName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelName];
        
        // Рейтинг
        CGRect rectRatingView = CGRectMake(210, 33, 100, 20);
        self.ratingView = [[INVStarsRatingView alloc] initWithFrame:rectRatingView];
        self.ratingView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.ratingView];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setDrug:(INVDrug *)drug {
    
    if(drug && ![drug isEqual:_drug]){
        
        // set ivar
        _drug = [drug copy];
        
        NSMutableAttributedString *nameAndPriceString = [[NSMutableAttributedString alloc] init];
        
        // Name
        NSDictionary *nameAttributes = @{
                                     NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                     NSForegroundColorAttributeName:[UIColor blackColor],
                                     };
        NSAttributedString *nameAttributed = [[NSAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"%@\n", drug.name]
                                              attributes:nameAttributes];
        
        [nameAndPriceString appendAttributedString:nameAttributed];

        // Цена
        NSString *priceString;
        if(drug.maxCost > 0)
            priceString = [NSString stringWithFormat:@"от %ld до %ld руб.", drug.minCost, drug.maxCost];
        else
            priceString = [NSString stringWithFormat:@"от %ld руб.", drug.minCost];
        
        CGFloat priceFontSize = [UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize - 4.f;
        
        NSDictionary *priceAttributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:priceFontSize],
                                         NSForegroundColorAttributeName:[UIColor grayColor],
                                         };
        NSAttributedString *priceAttributed = [[NSAttributedString alloc]
                                              initWithString:priceString
                                              attributes:priceAttributes];
        
        [nameAndPriceString appendAttributedString:priceAttributed];
        
        self.labelName.attributedText = [nameAndPriceString copy];
        
        // Рейтинг
        self.ratingView.rating = drug.rating;
    }
}

@end
