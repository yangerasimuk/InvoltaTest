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
    
    NSString *stringBody = [NSString stringWithFormat:@"query=%@", self.searchQuery];
    request.HTTPBody = [stringBody dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// Запоминаем данные в переменную контроллера
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    
    p_rawJSONData = data;
}


// Ошибка соединения
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Соединение завершилось ошибкой. Error: %@", error);
}

// Код сервера
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
#ifdef DEBUG
    NSLog(@"Код сервера: %ld", [httpResponse statusCode]);
#endif
}


// Соединения прошло успешно - работаем с данными
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
        
        NSArray *arrDrugNames = (NSArray *)obj;
        
        // Перебираем все лекарства данной формы и заносим в масси формы
        [arrDrugNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *name = obj[@"name"];
            NSInteger nameId = [obj[@"name_id"] integerValue];
            
            INVDrugName *drugName = [[INVDrugName alloc] initWithId:nameId name:name formId:form.formId];
            
            [form.drugNames addObject:drugName];
        }];
        
        // Готовую форму с массивом лекарств заносим в объект p_formsWithDrugNames
        [p_formsWithDrugNames.forms addObject:form];
    }];
    
    [self.searchResultsTableView reloadData];
    
    // Записываем успешный запрос
    p_lastSuccessQuery = [self.searchQuery copy];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Первая секция на вывод сообщения "Выберете препарат..."
    return [p_formsWithDrugNames.forms count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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

@end
