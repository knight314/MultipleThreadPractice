//
//  NSOperationDemoViewController.m
//  MutipleThreadPractice
//
//  Created by Guangyao on 16/6/28.
//  Copyright © 2016年 Guangyao. All rights reserved.
//

#import "NSOperationDemoViewController.h"
#import "DownloadImageOperation.h"

@interface NSOperationDemoViewController ()
<UITableViewDelegate,UITableViewDataSource,DownloadImageOperationDelegate>

@property (nonatomic,strong) NSArray *selectorArray;

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation NSOperationDemoViewController

#pragma mark - getter and setter

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
    
}

-(NSArray *)selectorArray{
    if (!_selectorArray) {
        _selectorArray=@[ NSStringFromSelector(@selector(singleOperationWithBlock)),NSStringFromSelector(@selector(singleOperationWithSelector)),NSStringFromSelector(@selector(operationQueue)),NSStringFromSelector(@selector(operationQueueWithoutDependency)),NSStringFromSelector(@selector(operationQueueWithDependency)),NSStringFromSelector(@selector(customOperation)) ];
        
    }
    return _selectorArray;
    
}

#pragma mark - vc life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - selector

-(void)download{
    for (int i = 0; i<10; i++) {
        NSLog(@"------download---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
    }

}
-(void)singleOperationWithSelector{
    // 1.创建操作对象, 封装要执行的任务
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download) object:nil];
    
    // 2.执行操作(默认情况下, 如果操作没有放到队列queue中, 都是同步执行)
    [operation start];


}

-(void)singleOperationWithBlock{
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    [operation addExecutionBlock:^{
        NSLog(@"NSBlockOperation------下载图片1---%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        NSLog(@"NSBlockOperation------下载图片2---%@", [NSThread currentThread]);
    }];
    
    [operation addExecutionBlock:^{
        NSLog(@"NSBlockOperation------下载图片3---%@", [NSThread currentThread]);
    }];
    
    
    
    
    // 2.执行操作
    [operation start];

}

-(void)operationQueue{
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i<10; i++) {
            NSLog(@"NSBlockOperation------下载图片-1--%@", [NSThread currentThread]);
        }
    }];
    operation1.completionBlock = ^{
        // ...下载完图片后想做事情
        NSLog(@"NSBlockOperation------下载图片完毕-1--%@", [NSThread currentThread]);
    };
    
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation------下载图片2-1--%@", [NSThread currentThread]);
    }];
    [operation2 addExecutionBlock:^{
        NSLog(@"NSBlockOperation------下载图片2-2--%@", [NSThread currentThread]);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
      queue.maxConcurrentOperationCount = 2; // 2 ~ 3为宜
    [queue addOperation:operation1];
    [queue addOperation:operation2];

}

-(void)operationQueueWithDependency{
    
    
    NSBlockOperation *operation1= [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"NSBlockOperation------下载图片-1--%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
    }];
    NSBlockOperation *operation2= [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"NSBlockOperation------下载图片-2--%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
    }];
    
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"NSBlockOperation------下载图片-3-1-%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
    }];
    [operation3 addExecutionBlock:^{
        
        NSLog(@"NSBlockOperation------下载图片-3-2-%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
    }];
    
    // 2.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2; // 2 ~ 3为宜
    
    // 设置依赖
    [operation2 addDependency:operation3];
    [operation3 addDependency:operation1];
    
    // 3.添加操作到队列中(自动执行操作, 自动开启线程)
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];


}

-(void)operationQueueWithoutDependency{
    
    // 1.封装操作
   
    //    operation1.queuePriority = NSOperationQueuePriorityHigh
    NSBlockOperation *operation1= [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"NSBlockOperation------下载图片-1--%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
    }];
    NSBlockOperation *operation2= [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"NSBlockOperation------下载图片-2--%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:0.1];
        
    }];
    
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        
            NSLog(@"NSBlockOperation------下载图片-3-1-%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.1];
     
    }];
    [operation3 addExecutionBlock:^{
       
            NSLog(@"NSBlockOperation------下载图片-3-2-%@", [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.1];
     
    }];
    
    // 2.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2; // 2 ~ 3为宜
    
 
    
    // 3.添加操作到队列中(自动执行操作, 自动开启线程)
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    


}

-(void)customOperation{

    
    //写在一个UITableView的加载图片里面
    DownloadImageOperation *opeartion=[[DownloadImageOperation alloc]init];
    opeartion.imageURL=@"http://img01.sogoucdn.com/app/a/100540002/icard_bg_47663.jpg";
    opeartion.operationDelegate=self;
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    [queue addOperation:opeartion];
    


}
#pragma mark - table view datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.selectorArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"GCDDemoTableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *selectorName=self.selectorArray[indexPath.row];
    cell.textLabel.text=selectorName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *selectorName=self.selectorArray[indexPath.row];
    if ([self respondsToSelector:NSSelectorFromString(selectorName)]) {
        [self performSelector:NSSelectorFromString(selectorName)];
    }
    
}

#pragma mark -  operation delegate
-(void)downloadOperation:(DownloadImageOperation *)operation didFinishDownload:(UIImage *)image{

    NSLog(@"image info =%@",image);

}

@end
