//
//  INVSearchResultsViewController.m
//  InvoltaTest
//
//  Created by Ян on 04.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVSearchResultsViewController.h"
#import "INVDrug.h"
#import "INVForm.h"
#import "INVFormsWithDrugNames.h"
#import "INVDrugName.h"
#import "INVFormAndDrugNameCell.h"
#import "INVDrugAnalogsViewController.h"

static NSString *const kFormAndDrugNameCell = @"FormAndDrugNameCell";

@interface INVSearchResultsViewController () <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
        NSString *p_lastSuccessQuery;
        NSData *p_rawJSONData;
        INVFormsWithDrugNames *p_formsWithDrugNames;
}
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;
@end

@implementation INVSearchResultsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = self.searchQuery;
    
    // Регистрируем класс ячейки
    [self.searchResultsTableView registerClass:[INVFormAndDrugNameCell class] forCellReuseIdentifier:kFormAndDrugNameCell];
    
    // Делегаты
    self.searchResultsTableView.delegate = self;
    self.searchResultsTableView.dataSource = self;
}

/**
 Перед каждым появлением на экране проверяем необходимость запроса к серверу.
 */
- (void)viewWillAppear:(BOOL)animated {
    
    if(self.searchQuery && ![self.searchQuery isEqualToString:@""] && ![self.searchQuery isEqualToString:p_lastSuccessQuery]){
        
        // Запрос к серверу
        [self requestDataFromServer];
    }
}


- (void)requestDataFromServer {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"http://api2.docteka.ru/api25/drugs/search"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *stringBody = [NSString stringWithFormat:@"query=%%%@%%", self.searchQuery];
    request.HTTPBody = [stringBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    
    p_rawJSONData = data;
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Соединение завершилось ошибкой. Error: %@", error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
#ifdef DEBUG
    NSLog(@"Код сервера: %ld", [httpResponse statusCode]);
#endif
}


// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // Инициируем объект-источник данных
    p_formsWithDrugNames = [[INVFormsWithDrugNames alloc] init];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:p_rawJSONData options:0 error:nil];
    
#ifdef DEBUG
    NSLog(@"Соединенение успешно завершилось");
    NSLog(@"JSON \n%@", dict);
#endif
    
    NSDictionary *dictByForms = dict[@"byForms"];
    NSDictionary *dictFormNames = dict[@"formNames"];
    
    [dictByForms enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *formName = dictFormNames[key];
        
        INVForm *form = [[INVForm alloc] initWithId:[key integerValue] name:formName];
        
        NSLog(@"form \n%@", form);
        
        NSArray *arrDrugNames = (NSArray *)obj;
        
        NSLog(@"count of drugNames: %ld", [arrDrugNames count]);
        
        // перебираем все лекарства данной формы и заносим в масси формы
        [arrDrugNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *name = obj[@"name"];
            NSInteger nameId = [obj[@"name_id"] integerValue];
            
            NSLog(@"name: %@, name_id: %ld", name, nameId);
            
            INVDrugName *drugName = [[INVDrugName alloc] initWithId:nameId name:name formId:form.formId];
            
            NSLog(@"drugName \n%@", drugName);
            
            [form.drugNames addObject:drugName];
        }];
        
        // готовую форму с массивом лекарств заносим в объект p_formsWithDrugNames
        [p_formsWithDrugNames.forms addObject:form];
    }];
    
    [self.searchResultsTableView reloadData];
    
    // Записываем успешный запрос
    p_lastSuccessQuery = [self.searchQuery copy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    
    // Первая секция на вывод сообщения "Выберете препарат..."
    return [p_formsWithDrugNames.forms count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    //    if(section == 0)
    //        return 1;
    //    else
    return [p_formsWithDrugNames.forms[section].drugNames count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INVFormAndDrugNameCell *cell = [tableView dequeueReusableCellWithIdentifier:kFormAndDrugNameCell];
    
    if(!cell)
        cell = [[INVFormAndDrugNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFormAndDrugNameCell];
    
    cell.formName = [p_formsWithDrugNames.forms[indexPath.section].name capitalizedString];
    cell.drugName = p_formsWithDrugNames.forms[indexPath.section].drugNames[indexPath.row].name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    INVDrugAnalogsViewController *drugVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DrugAnalogsViewController"];
    
    INVForm *form = p_formsWithDrugNames.forms[indexPath.section];
    INVDrugName *drugName = p_formsWithDrugNames.forms[indexPath.section].drugNames[indexPath.row];
    INVDrug *drug = [[INVDrug alloc] initWithDrugId:drugName.nameId form:form name:drugName.name];
    
    drugVC.drug = drug;
    drugVC.drugForm = form;
    
    [self.navigationController pushViewController:drugVC animated:YES];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
