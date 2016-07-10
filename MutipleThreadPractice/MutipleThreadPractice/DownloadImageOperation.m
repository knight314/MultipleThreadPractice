//
//  DownloadImageOperation.m
//  MutipleThreadPractice
//
//  Created by Guangyao on 16/7/10.
//  Copyright © 2016年 Guangyao. All rights reserved.
//

#import "DownloadImageOperation.h"

@implementation DownloadImageOperation

-(void)main{

    @autoreleasepool {
        NSURL *downloadUrl = [NSURL URLWithString:self.imageURL];
        NSData *data = [NSData dataWithContentsOfURL:downloadUrl]; // 这行会比较耗时
        UIImage *image = [UIImage imageWithData:data];
        
        if ([self.operationDelegate respondsToSelector:@selector(downloadOperation:didFinishDownload:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{ // 回到主线程, 传递图片数据给代理对象
                [self.operationDelegate downloadOperation:self didFinishDownload:image];
            });
        }
    }

}

@end
