//
//  DemoListViewController.m
//  MutipleThreadPractice
//
//  Created by Guangyao on 16/6/28.
//  Copyright © 2016年 Guangyao. All rights reserved.
//

#import "DemoListViewController.h"

#import "GCDDemoViewController.h"
#import "NSOperationDemoViewController.h"
@interface DemoListViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *classArray;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation DemoListViewController

#pragma mark - getter and setter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];
    }
    return _tableView;

}

-(NSArray *)classArray{
    if (!_classArray) {
        _classArray=@[[GCDDemoViewController class],[NSOperationDemoViewController class]];
    }
    return _classArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - table view datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.classArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"DemoListTableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=NSStringFromClass(self.classArray[indexPath.row]);
    
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Class destinationClass=self.classArray[indexPath.row];
    UIViewController *destinationVC=[[destinationClass alloc]init];
    if ([destinationVC isKindOfClass:[UIViewController class]]) {
        destinationVC.title=NSStringFromClass(destinationClass);
        [self.navigationController pushViewController:destinationVC animated:YES];
    }
    
}

@end
