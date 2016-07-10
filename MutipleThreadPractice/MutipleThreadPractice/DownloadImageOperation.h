//
//  DownloadImageOperation.h
//  MutipleThreadPractice
//
//  Created by Guangyao on 16/7/10.
//  Copyright © 2016年 Guangyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownloadImageOperation;
@protocol DownloadImageOperationDelegate <NSObject>
@optional

-(void)downloadOperation:(DownloadImageOperation *)operation didFinishDownload:(UIImage *)image;
@end

@interface DownloadImageOperation : NSOperation

@property (nonatomic,weak) id <DownloadImageOperationDelegate> operationDelegate;


@property (nonatomic,copy) NSString *imageURL;


@end
