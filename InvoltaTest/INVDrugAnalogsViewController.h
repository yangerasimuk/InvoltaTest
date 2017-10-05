//
//  INVDrugAnalogsViewController.h
//  InvoltaTest
//
//  Created by Ян on 04.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class INVDrug, INVForm;

@interface INVDrugAnalogsViewController : UITableViewController

/// Входные параметры: лекарство и форма выпуска
@property (nonatomic, copy) INVDrug *drug;
@property (nonatomic, copy) INVForm *drugForm;

@end
