//
//  ViewController.m
//  NSURLSession下载文件
//
//  Created by ZMC on 16/3/3.
//  Copyright © 2016年 Zmc. All rights reserved.
//

#import "ViewController.h"
#import "MCNewDownLoadTool.h"
@interface ViewController ()
{

    UIProgressView * _pro;
    UIImageView * _imageView;
    MCNewDownLoadTool*_tool;
}
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _tool=[[MCNewDownLoadTool alloc]initWithUrl:@"http://b.hiphotos.baidu.com/zhidao/pic/item/d0c8a786c9177f3e0693932571cf3bc79f3d5676.jpg" filePath:nil];
    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    _imageView.center=self.view.center;
    [self.view addSubview:_imageView];
    
    _pro=[[UIProgressView alloc] initWithFrame:CGRectMake(0, 20, 400, 5)];
    _pro.backgroundColor=[UIColor redColor];
    [self.view addSubview:_pro];
    
    
    UIButton * button=[[UIButton alloc] initWithFrame:CGRectMake(50, _imageView.frame.origin.y+400+20, 50, 40)];
    button.backgroundColor=[UIColor blueColor];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ddLoad) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth=1;
    button.layer.borderColor=[UIColor blueColor].CGColor;
    button.layer.cornerRadius=5;
    [self.view addSubview:button];
    
    UIButton * button1=[[UIButton alloc] initWithFrame:CGRectMake(150, _imageView.frame.origin.y+400+20, 50, 40)];
    button1.backgroundColor=[UIColor blueColor];
    [button1 setTitle:@"暂停" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    button1.layer.borderWidth=1;
    button1.layer.borderColor=[UIColor blueColor].CGColor;
    button1.layer.cornerRadius=5;
    [self.view addSubview:button1];
    
    UIButton * button2=[[UIButton alloc] initWithFrame:CGRectMake(250, _imageView.frame.origin.y+400+20, 50, 40)];
    button2.backgroundColor=[UIColor blueColor];
    [button2 setTitle:@"继续" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
    button2.layer.borderWidth=1;
    button2.layer.borderColor=[UIColor blueColor].CGColor;
    button2.layer.cornerRadius=5;
    [self.view addSubview:button2];
    
    
    __weak typeof (_pro)weakPro=_pro;
    _tool.progress=^(double progress){
        weakPro.progress=(float)progress;
    };
    
    __weak typeof (_imageView)weakImage=_imageView;
    _tool.complete=^(NSData*data){
        weakImage.image=[UIImage imageWithData:data];
    };

}
-(void) ddLoad{
    [_tool startDownload];
}
- (void) pause{
    [_tool pauseDownload];
}
- (void) resume{
    [_tool continueDownload];
}

@end
