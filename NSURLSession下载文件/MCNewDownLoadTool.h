//
//  MCNewDownLoadTool.h
//  NSURLSession下载文件
//
//  Created by ZMC on 16/3/3.
//  Copyright © 2016年 Zmc. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  下载状态
 */
typedef NS_ENUM(NSInteger, MCDownLoadStatus) {
    /**
     *  从未下载
     */
    MCDownLoadStatusNotDownLoad=1,
    /**
     *  下载部分
     */
    MCDownLoadStatusIsDownLoading,
    /**
     *  继续下载
     */
    MCDownLoadStatusContinueDownLoad
};

@interface MCNewDownLoadTool : NSObject<NSURLSessionDownloadDelegate>

/**
 *  下载进度
 */
@property(copy,nonatomic)void(^progress)(double progress);
/**
 *  下载地址
 */
@property(copy,nonatomic)NSString*urlString;
/**
 *  存储路径
 */
@property(copy,nonatomic)NSString*filePath;
/**
 *  下载结果
 */
@property(copy,nonatomic)void(^complete)(NSData*data);
/**
 *  下载状态
 */
@property(assign,nonatomic)MCDownLoadStatus status;

#pragma mark-方法

-(instancetype)initWithUrl:(NSString*)urlString filePath:(NSString*)filePath;

#pragma mark-post和get请求

-(void)getDataTaskWithUrl:(NSString *)url completionHandler:(void (^)(NSString *dataString, NSURLResponse *response, NSError *error))completionHandler;

- (void) postDataTaskWithUrl:(NSString*)url params:(NSString*)params completionHandler:(void (^)(NSString *dataString, NSURLResponse *response, NSError *error))completionHandler;





#pragma mark-下载大文件的方法

/**
 *  开始下载
 */
- (void) startDownload;
/**
 *  暂停下载
 */
- (void) pauseDownload;
/**
 *  恢复下载
 */
- (void) continueDownload;
@end
