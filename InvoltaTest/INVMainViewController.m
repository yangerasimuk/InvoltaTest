//
//  INVMainViewController.m
//  InvoltaTest
//
//  Created by Ян on 02.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVMainViewController.h"
#import "INVSearchResultsViewController.h"
#import "INVDrug.h"
#import "INVDrugAnalogsViewController.h"

@interface INVMainViewController () <UITextFieldDelegate>
- (IBAction)textFieldSearchDidEndOnExit:(UITextField *)sender;
@end

@implementation INVMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(showSearchResultsViewController:)
                   name:@"DrugViewTapEvent"
                 object:nil];
}


- (void)showSearchResultsViewController:(NSNotification *)notification {
    
    INVDrug *drug = notification.userInfo[@"Drug"];
    
    assert(drug != nil);
    
    INVSearchResultsViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsViewController"];
    
    searchVC.searchQuery = drug.name;

    [self.navigationController pushViewController:searchVC animated:YES];
}


- (void)dealloc {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


- (IBAction)textFieldSearchDidEndOnExit:(UITextField *)sender {
    
    INVSearchResultsViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultsViewController"];
    
    searchVC.searchQuery = sender.text;
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

@end
