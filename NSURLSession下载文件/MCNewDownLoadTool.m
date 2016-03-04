//
//  MCNewDownLoadTool.m
//  NSURLSession下载文件
//
//  Created by ZMC on 16/3/3.
//  Copyright © 2016年 Zmc. All rights reserved.
//

#import "MCNewDownLoadTool.h"
@interface MCNewDownLoadTool()

{
//------下载大文件的变量------//
    NSURLSessionDownloadTask * _task;
    NSData * _resumeData;
    NSURLSession * _session;
    NSURLRequest * _request;
//------网络请求的变量------//
    NSURLSessionDataTask*_dataTask;
}
@end;


@implementation MCNewDownLoadTool

//私有方法-data转string
- (NSString*)dataToString:(NSData*)data{
    NSString*str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return str;
    
};

- (void) getDataTaskWithUrl:(NSString *)url completionHandler:(void (^)(NSString *dataString, NSURLResponse *response, NSError *error))completionHandler{
    _session=[NSURLSession sharedSession];
    NSURLRequest*request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    _dataTask=[_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler([self dataToString:data],response,error);
        }
    }];
    [_dataTask resume];
}
- (void) postDataTaskWithUrl:(NSString *)url params:(NSString *)params completionHandler:(void (^)(NSString *dataString, NSURLResponse *response, NSError *error))completionHandler{
    _session=[NSURLSession sharedSession];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod=@"POST";
    request.HTTPBody=[params dataUsingEncoding:NSUTF8StringEncoding];
    _dataTask=[_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler([self dataToString:data],response,error);
        }
    }];
    [_dataTask resume];
}
-(instancetype)initWithUrl:(NSString *)urlString filePath:(NSString *)filePath{
    if (self=[super init]) {
        self.urlString=urlString;
        self.filePath=filePath;
        self.status=MCDownLoadStatusNotDownLoad;
    }
    return self;
}

- (void) startDownload{
    
    NSURLSessionConfiguration * config=[NSURLSessionConfiguration defaultSessionConfiguration];
    _session=[NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url=[NSURL URLWithString:self.urlString];
    _request=[NSURLRequest requestWithURL:url];
    _task= [_session downloadTaskWithRequest:_request];
    [_task resume];
    

}
- (void) pauseDownload{
    [_task cancelByProducingResumeData:^(NSData *resumeData) {
        _resumeData=resumeData;
    }];
    _task=nil;
    self.status=MCDownLoadStatusIsDownLoading;
}
- (void) continueDownload{
    //恢复
    if(!_resumeData){
        NSURL *url=[NSURL URLWithString:self.urlString];
        _request=[NSURLRequest requestWithURL:url];
        _task=[_session downloadTaskWithRequest:_request];
    }else{
        _task=[_session downloadTaskWithResumeData:_resumeData];
    }
    [_task resume];
    self.status=MCDownLoadStatusContinueDownLoad;
}

#pragma mark-代理-下载大文件


/**
 *  接受下载数据就调用
 *
 *  @param bytesWritten              本次下载的数据大小
 *  @param totalBytesWritten         已经写入到文件中的数据大小
 *  @param totalBytesExpectedToWrite 文件的总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    double progress=(totalBytesWritten*1.0)/totalBytesExpectedToWrite;
    if (self.progress) {
        self.progress(progress);
    }
}
/**
 *  恢复(继续下载就调用)
 *  @param fileOffset         恢复之后从文件什么地方开始继续下载
 *  @param expectedTotalBytes 文件数据的总大小
 */
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}
/**
 *  下载完毕后调用该方法
 */
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"##__下载完毕后调用该方法__##");
    if (self.filePath) {
        NSURL * url=[NSURL fileURLWithPath:self.filePath];
        NSFileManager * manager=[NSFileManager defaultManager];
        [manager moveItemAtURL:location toURL:url error:nil];
        NSData * data=[manager contentsAtPath:self.filePath];
        if (self.complete) {
            self.complete(data);
        }
    }
    else{
        if (self.complete) {
            NSData*data=[NSData dataWithContentsOfURL:location];
            self.complete(data);
        }
    }
}
/**
 *  请求完成之后调用
 *  @param error   请求失败返回的错误信息
 */
- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{

}


@end
