//
//  ViewController.m
//  MutipleThreadPractice
//
//  Created by Guangyao on 16/6/28.
//  Copyright © 2016年 Guangyao. All rights reserved.
//

#import "GCDDemoViewController.h"

@interface GCDDemoViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSArray *selectorArray;

@property (nonatomic,strong) UITableView *tableView;
@end

@implementation GCDDemoViewController

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
        _selectorArray=@[ NSStringFromSelector(@selector(syncSerial)),NSStringFromSelector(@selector(syncConcurrent)),NSStringFromSelector(@selector(asyncSerial)),NSStringFromSelector(@selector(asyncConcurrent)),NSStringFromSelector(@selector(dispatchGroup)),NSStringFromSelector(@selector(dispatch_barrier_async))];
   
    }
    return _selectorArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageView.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:imageView];
    self.imageView=imageView;
    
    UIBarButtonItem *testButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"TEST" style:UIBarButtonItemStylePlain target:self action:@selector(testBackgroundDownloadImage)];
    
    self.navigationItem.rightBarButtonItem=testButtonItem;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
  

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)testBackgroundDownloadImage{
    
 

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL * url = [NSURL
                       URLWithString:@"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        }
    });

}
//同步函数 + 串行队列
- (void)syncSerial {
    
    NSLog(@"start %s -------%@",__FUNCTION__,[NSThread currentThread]);
    /* 创建串行队列 */
    dispatch_queue_t queue = dispatch_queue_create("https://teilim.com", DISPATCH_QUEUE_SERIAL);
    
    /* 将执行任务加入队列 */
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"task A time %lo -----%@", i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"task B time %lo -----%@", i,[NSThread currentThread]);
        }
    });
    NSLog(@"finish %s -------%@",__FUNCTION__,[NSThread currentThread]);

}

//同步函数 + 并发队列
- (void)syncConcurrent {
    
    NSLog(@"start %s -------%@",__FUNCTION__,[NSThread currentThread]);
    /* 创建并发队列 */
    dispatch_queue_t queue = dispatch_queue_create("https://teilim.com", DISPATCH_QUEUE_CONCURRENT);
    
    /* 将执行任务加入队列 */
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
                NSLog(@"task A time %lo -----%@", i,[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
              NSLog(@"task B time %lo -----%@", i,[NSThread currentThread]);
        }
    });
    NSLog(@"finish %s -------%@",__FUNCTION__,[NSThread currentThread]);
}
//异步函数 + 串行队列
- (void)asyncSerial {
    
    NSLog(@"start %s -------%@",__FUNCTION__,[NSThread currentThread]);
    
    /* 创建串行队列 */
    dispatch_queue_t queue = dispatch_queue_create("https://teilim.com", DISPATCH_QUEUE_SERIAL);
    
    /* 将任务加入队列 */
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
            NSLog(@"task A time %lo -----%@", i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
              NSLog(@"task B time %lo -----%@", i,[NSThread currentThread]);
        }
    });
    
    NSLog(@"finish %s -------%@",__FUNCTION__,[NSThread currentThread]);

}

//异步函数 ＋ 并发队列
- (void)asyncConcurrent {
    
    NSLog(@"start %s -------%@",__FUNCTION__,[NSThread currentThread]);
    
    /* 创建并发队列 */
    dispatch_queue_t queue = dispatch_queue_create("com.520it.queue", DISPATCH_QUEUE_CONCURRENT);
    
    /* 将任务加入队列 */
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
             NSLog(@"task A time %lo -----%@", i,[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<5; i++) {
              NSLog(@"task B time %lo -----%@", i,[NSThread currentThread]);
        }
    });
    
    NSLog(@"finish %s -------%@",__FUNCTION__,[NSThread currentThread]);

}


-(void)dispatchGroup{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"download image 1");
        /*加载图片1 */ });
    dispatch_group_async(group, queue, ^{
         NSLog(@"download image 2");
        /*加载图片2 */ });
    dispatch_group_async(group, queue, ^{
         NSLog(@"download image 3");
        /*加载图片3 */ });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 合并图片
        NSLog(@"combine download images");
    });

}

-(void)dispatch_barrier_async{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-1");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-2");
    });
    dispatch_barrier_async(concurrentQueue, ^(){
        NSLog(@"dispatch-barrier");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-3");
    });
    dispatch_async(concurrentQueue, ^(){
        NSLog(@"dispatch-4");
    });
    
    
    
    
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
@end
