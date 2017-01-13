//
//  BQScanViewController.m
//  BeeQuick
//
//  Created by 邓昊 on 2016/12/22.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BQScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface BQScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property(strong,nonatomic)AVCaptureInput *videoInput;
@property(strong,nonatomic)AVCaptureMetadataOutput *output;
@property(strong,nonatomic)AVCaptureSession *session;
@property (weak, nonatomic) IBOutlet UIImageView *areaimageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;


@end

@implementation BQScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 定义输入
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    
    // 2. 定义输出
    self.output = [AVCaptureMetadataOutput new];
    // 2.1 定制输出的代理
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    // 3. 关联对象
    self.session = [AVCaptureSession new];
    
    // 3.1 关联输入
    if([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    // 3.2 管理输出
    if([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    
    // 2.2 设置输出数据的类型(二维码识别)
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 4. 设置预览(注意:创建预览的layer需要添加到视图中)
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    // 5. 开始运作
    [self.session startRunning];
    
    [self setupAnimations];
    
}

- (void)setupAnimations {
    [self.view layoutIfNeeded];
    CGPoint originPoint = self.lineImageView.layer.position;
    CGPoint targetPoint = CGPointMake(originPoint.x, originPoint.y + self.areaimageView.frame.size.height - self.lineImageView.frame.size.height - 10);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:originPoint];
    animation.toValue = [NSValue valueWithCGPoint:targetPoint];
    animation.duration = 3.0;
    animation.repeatCount = MAXFLOAT;
    [self.lineImageView.layer addAnimation:animation forKey:nil];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate -
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[obj stringValue]]];
    }
}

@end
