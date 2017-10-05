//
//  INVSliderViewController.m
//  InvoltaTest
//
//  Created by Ян on 03.10.17.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "INVSliderViewController.h"

#import "INVDrugAnalogsSamples.h"
#import "INVDrug.h"
#import "INVAnalogsSample.h"
#import "INVDrugSliderView.h"

@interface INVSliderViewController () {
    
    // Источник данных об аналогах
    INVDrugAnalogsSamples *p_analogsSamples;
    
    // Три вьюхи, наименование отражает их расположение на макете scrollView
    INVDrugSliderView *p_firstView;
    INVDrugSliderView *p_secondView;
    INVDrugSliderView *p_thirdView;
    
    // Индексы положения текущего курсора в массиве p_analogsSamples
    NSInteger prevIndex;
    NSInteger currIndex;
    NSInteger nextIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation INVSliderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if([self loadSamples]){
        
        // Загрузка прошла успешно - инициализируем слайдер
        [self initSlider];
    }
    else{

        // Ошибка при загрузке - выводим сообщение
        UIAlertController *warningController = [UIAlertController alertControllerWithTitle:@"Внимание!" message:@"Загрузка данных с сервера завершилось ошибкой. Проверьте соединение и повторите операцию." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [warningController addAction:okAction];
        [self presentViewController:warningController animated:YES completion:nil];
    }
}


- (void)initSlider {
    
    p_firstView = [[INVDrugSliderView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.scrollView addSubview:p_firstView];
    
    p_secondView = [[INVDrugSliderView alloc] initWithFrame:CGRectMake(320, 0, 320, 320)];
    [self.scrollView addSubview:p_secondView];
    
    p_thirdView = [[INVDrugSliderView alloc] initWithFrame:CGRectMake(640, 0, 320, 320)];
    [self.scrollView addSubview:p_thirdView];
    
    // Инициализация индексов и первая загрузка 3-х вьюх
    prevIndex = [p_analogsSamples.list count]-1;
    currIndex = 0;
    currIndex = 1;
    [self loadSampleWithIndex:prevIndex onViewWithIndex:0];
    [self loadSampleWithIndex:currIndex onViewWithIndex:1];
    [self loadSampleWithIndex:nextIndex onViewWithIndex:2];

    // Общий макет scrollView - вытянут в длину
    self.scrollView.contentSize = CGSizeMake(960, 320);
    
    // Видимая часть макет scrollView
    [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,320) animated:NO];
    
    self.scrollView.delegate = self;
    
    // Автоматическая прокрутка
    [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(autoscrollSlider) userInfo:nil repeats:YES];
}


/**
 Метод автоматической прокрутки слайдера. Вызывается таймером.
 */
- (void)autoscrollSlider {
    
    CGFloat newX = self.scrollView.contentOffset.x + 320.f;
    CGFloat oldY = self.scrollView.contentOffset.y;
    
    [self.scrollView setContentOffset:CGPointMake(newX, oldY) animated:YES];
    
    // костыль, сам метод делегата не вызывается, а без него не генерятся вьюхи
    [self scrollViewDidEndDecelerating:self.scrollView];
}


- (void)loadSampleWithIndex:(NSInteger)sampleIndex onViewWithIndex:(NSInteger)viewIndex {

    // load data for views
    switch (viewIndex) {
        case 0:
            p_firstView.analogsSample = p_analogsSamples.list[sampleIndex];
            break;
        case 1:
            p_secondView.analogsSample = p_analogsSamples.list[sampleIndex];
            break;
        case 2:
            p_thirdView.analogsSample = p_analogsSamples.list[sampleIndex];
            break;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    
    if(self.scrollView.contentOffset.x > self.scrollView.frame.size.width) {
        // Идем вперед - слева-направо
        
        [self loadSampleWithIndex:currIndex onViewWithIndex:0];
        currIndex = (currIndex >= [p_analogsSamples.list count]-1) ? 0 : currIndex + 1;
        [self loadSampleWithIndex:currIndex onViewWithIndex:1];
        
        nextIndex = (currIndex >= [p_analogsSamples.list count]-1) ? 0 : currIndex + 1;
        [self loadSampleWithIndex:nextIndex onViewWithIndex:2];
    }
    else if(self.scrollView.contentOffset.x < self.scrollView.frame.size.width) {
        
        // Идем назад - справа-налево
        [self loadSampleWithIndex:currIndex onViewWithIndex:2];
        currIndex = (currIndex == 0) ? [p_analogsSamples.list count]-1 : currIndex - 1;
        [self loadSampleWithIndex:currIndex onViewWithIndex:1];
        prevIndex = (currIndex == 0) ? [p_analogsSamples.list count]-1 : currIndex - 1;
        [self loadSampleWithIndex:prevIndex onViewWithIndex:0];
    }
    
    // Сдвиг на середину макета
    [self.scrollView scrollRectToVisible:CGRectMake(320,0,320,320) animated:NO];
}


#pragma mark - Load drug analog samples
/**
 
 @return: Результат выполнения
 */
- (BOOL)loadSamples {
    
    BOOL result = NO;
    NSData *data;
    
    @try {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api2.docteka.ru/api25/drugs/getAnalogsCard"]];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        if(!error){
            
            p_analogsSamples = [[INVDrugAnalogsSamples alloc] init];
            NSArray *analogsSamples = [json valueForKey:@"analogs"];
            
            for (NSDictionary *analog in analogsSamples){
                
                INVDrug *expensiveDrug = [[INVDrug alloc]
                                          initWithDrugId:[analog[@"expensive_id"] integerValue]
                                          imageUrlString:analog[@"expensive_image"]
                                          name:analog[@"expensive_name"]
                                          cost:[analog[@"expensive_cost"] integerValue]
                                          rating:[analog[@"expensive_rating"] integerValue]];
                
                INVDrug *cheapDrug = [[INVDrug alloc]
                                      initWithDrugId:[analog[@"analog_id"] integerValue]
                                      imageUrlString:analog[@"analog_image"]
                                      name:analog[@"analog_name"]
                                      cost:[analog[@"analog_cost"] integerValue]
                                      rating:[analog[@"analog_rating"] integerValue]];
                
                INVAnalogsSample *sample = [[INVAnalogsSample alloc] initWithExpensiveDrug:expensiveDrug cheapDrug:cheapDrug];
                
                [p_analogsSamples.list addObject:sample];
                
                result = YES;
            }
        }
        else{
            NSLog(@"Error occured in load json data. -[INVSliderViewController loadSamples]. %@", [error description]);
        }
    }
    @catch (NSException *ex){
        
        NSLog(@"Exception occured in load json data. -[INVSliderViewController loadSamples]. %@", ex);
    }
    @finally{
        return result;
    }
}

@end
