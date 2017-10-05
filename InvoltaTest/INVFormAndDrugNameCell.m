//
//  INVFormAndDrugNameCell.m
//  InvoltaTest
//
//  Created by Ян on 04.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVFormAndDrugNameCell.h"

@interface INVFormAndDrugNameCell()

@property (strong, nonatomic) UILabel *labelFirstRow;
@property (strong, nonatomic) UILabel *labelSecondRow;

@end

@implementation INVFormAndDrugNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        // Первая строка
        CGRect rectFirstRowLabel = CGRectMake(16, 4, 288, 36);
        self.labelFirstRow = [[UILabel alloc] initWithFrame:rectFirstRowLabel];
        self.labelFirstRow.textAlignment = NSTextAlignmentLeft;
        self.labelFirstRow.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.labelFirstRow];
        
        // Вторая строка
        CGRect rectSecondRowLabel = CGRectMake(16, 40, 288, 36);
        self.labelSecondRow = [[UILabel alloc] initWithFrame:rectSecondRowLabel];
        self.labelSecondRow.textAlignment = NSTextAlignmentLeft;
        self.labelSecondRow.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.labelSecondRow];
    }
    return self;
}


- (void)setFormName:(NSString *)formName {
    
    if(formName && ![_formName isEqualToString:formName]){
        _formName = formName;
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                     NSForegroundColorAttributeName:[UIColor blackColor],
                                     };
        NSAttributedString *textAttributed = [[NSAttributedString alloc]
                                              initWithString:[_formName uppercaseString]
                                              attributes:attributes];
        
        self.labelFirstRow.attributedText = textAttributed;
    }
}


- (void)setDrugName:(NSString *)drugName {
    
    if(drugName && ![_drugName isEqualToString:drugName]){
        _drugName = drugName;
        
        NSDictionary *attributes = @{
                                     NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                     NSForegroundColorAttributeName:[UIColor blackColor],
                                     };
        NSAttributedString *textAttributed = [[NSAttributedString alloc]
                                              initWithString:_drugName
                                              attributes:attributes];
        
        self.labelSecondRow.attributedText = textAttributed;
    }
}

@end
