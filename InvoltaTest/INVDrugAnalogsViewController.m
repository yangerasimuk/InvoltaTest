//
//  INVDrugAnalogsViewController.m
//  InvoltaTest
//
//  Created by Ян on 04.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVDrugAnalogsViewController.h"
#import "INVDrug.h"
#import "INVForm.h"
#import "INVFormsWithDrugNames.h"
#import "INVDrugName.h"
#import "INVDrugCell.h"
#import "INVDrugSourceCell.h"

static NSString *const kDrugCell = @"DrugCell";
static NSString *const kDrugSourceCell = @"DrugSourceCell";

@interface INVDrugAnalogsViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSString *p_lastSuccessQuery;
    NSData *p_rawJSONData;
    NSMutableArray *p_drugAnalogs;
    
    INVDrug *p_findedDrug;
    INVForm *p_findedDrugForm;
}
@end

@implementation INVDrugAnalogsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Заголовок
    self.navigationItem.title = self.drug.name;
    
    // Регистрируем класс ячейки
    [self.tableView registerClass:[INVDrugCell class] forCellReuseIdentifier:kDrugCell];
    [self.tableView registerClass:[INVDrugSourceCell class] forCellReuseIdentifier:kDrugSourceCell];
    
    // Пока нет успешных запросов
    p_findedDrug = nil;
    p_findedDrugForm = nil;
}

/**
 Перед каждым появлением на экране проверяем необходимость запроса к серверу.
 */
- (void)viewWillAppear:(BOOL)animated {
        
    if(![self.drug isEqual:p_findedDrug] || ![self.drugForm isEqual:p_findedDrugForm]){
        
        [self requestDataFromServer];
    }
}


- (void)requestDataFromServer {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:@"http://api2.docteka.ru/api25/drugs/search"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *stringBody = [NSString stringWithFormat:@"query=%@&form_id=%ld", self.drug.name, self.drugForm.formId];
    
    NSLog(@"post string: %@", stringBody);
    
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
    p_drugAnalogs = [NSMutableArray array];
    
    NSDictionary *dictFromJSON = [NSJSONSerialization JSONObjectWithData:p_rawJSONData options:0 error:nil];
    
#ifdef DEBUG
    NSLog(@"Соединенение успешно завершилось");
    NSLog(@"JSON \n%@", dictFromJSON);
#endif

    NSArray *arrDrugs = dictFromJSON[@"drugs"];
    NSLog(@"dictDrugs count: %ld", [arrDrugs count]);
    
    //

    
    NSArray *arrDrugAnalogs = dictFromJSON[@"analogs"];
    NSLog(@"dictDrugAnalogs count: %ld", [arrDrugAnalogs count]);
    
    [arrDrugAnalogs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        
        NSDictionary *drugRaw = (NSDictionary *)obj;
        
        INVDrug *drug = [[INVDrug alloc] initWithDrugId:[drugRaw[@"name_id"] integerValue]
                                                   form:self.drugForm
                                                   name:drugRaw[@"name"]];
        drug.minCost = [drugRaw[@"min_cost"] integerValue];
        drug.maxCost = [drugRaw[@"max_cost"] integerValue];
        drug.rating = [drugRaw[@"rating"] integerValue];
        
        NSLog(@"drug: %@", drug);
        
        [p_drugAnalogs addObject:drug];
    }];
    
    // Заполняем поля для исходного лекарства из пришедшего массива drugs
    self.drug.minCost = [arrDrugs[0][@"min_cost"] integerValue];
    self.drug.maxCost = [arrDrugs[0][@"max_cost"] integerValue];
    self.drug.rating = [arrDrugs[0][@"rating"] integerValue];
    
    NSLog(@"source drug: %@", self.drug);
    
    // Добавляем в последние успешно найденные лекарства
    p_findedDrug = [self.drug copy];
    p_findedDrugForm = [self.drugForm copy];
    
    // Загружаем данные в таблицу
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Убираем загрузку данных, если источник данных пуст
    if([p_drugAnalogs count] == 0)
        return 0;
    else
        return [p_drugAnalogs count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86.f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Исходное лекарство (к нему подбираются аналоги) или аналоги
    if(indexPath.row == 0){
        
        INVDrugSourceCell *cell = (INVDrugSourceCell *)[tableView dequeueReusableCellWithIdentifier:kDrugSourceCell forIndexPath:indexPath];
        
        if(!cell){
            cell = [[INVDrugSourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDrugSourceCell];
        }
        
        cell.drug = self.drug;
        
        return cell;
    }
    else{
        
        INVDrugCell *cell = [tableView dequeueReusableCellWithIdentifier:kDrugCell forIndexPath:indexPath];
        
        if(!cell){
            cell = [[INVDrugCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDrugCell];
        }
        
        cell.drug = p_drugAnalogs[indexPath.row-1];
        
        return cell;
    }
}

@end

