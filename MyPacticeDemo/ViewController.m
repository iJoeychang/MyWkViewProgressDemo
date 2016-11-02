//
//  ViewController.m
//  MyPacticeDemo
//
//  Created by chang on 2016/11/2.
//  Copyright © 2016年 chang. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate>

@property(nonatomic,strong) UIProgressView * myProgressView;
@property(nonatomic,strong) WKWebView * myWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 绘制myWebView
    self.myWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.myWebView.navigationDelegate = self;
    [self.view addSubview:self.myWebView];
    
    
    // 绘制myProgressView
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    
    
    self.myProgressView = [[UIProgressView alloc] initWithFrame:barFrame];// CGRectMake(0, 100, 375, 2)
    self.myProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.myProgressView.tintColor = [UIColor orangeColor];
    self.myProgressView.trackTintColor = [UIColor yellowColor];
    // [self.view addSubview:self.myProgressView];
    [self.navigationController.navigationBar addSubview:self.myProgressView];
    
    [self.myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 请求网页数据
    [self loadBaidu];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadBaidu {
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]];// http://www.csdn.net/
    [self.myWebView loadRequest:req];
   
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == self.myWebView) {
            [self.myProgressView setAlpha:1.0f];
            [self.myProgressView setProgress:self.myWebView.estimatedProgress animated:YES];
            NSLog(@"myWebView.estimatedProgress=== %f",self.myWebView.estimatedProgress);
            if(self.myWebView.estimatedProgress >=1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.myProgressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.myProgressView setProgress:0.0f animated:NO];
                }];
                
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
}

@end
