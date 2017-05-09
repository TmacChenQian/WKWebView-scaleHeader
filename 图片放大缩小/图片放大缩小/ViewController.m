//
//  ViewController.m
//  图片放大缩小
//
//  Created by 陈乾 on 16/9/5.
//  Copyright © 2016年 陈乾. All rights reserved.
//

#import "ViewController.h"
@import WebKit;

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,UIGestureRecognizerDelegate>

@property(nonatomic, strong) WKWebView *wkWebView;

@end

@implementation ViewController

-(WKWebView *)wkWebView{
  
    if (_wkWebView == nil) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        //添加tap点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecongnizer:)];
        tap.delegate = self;
        [_wkWebView addGestureRecognizer:tap];
    }
    return _wkWebView;
}

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.wkWebView];
    NSURL *url = [NSURL URLWithString:@"http://image.baidu.com"];
//    NSURL *url = [NSURL URLWithString:@"http://m.dianping.com/tuan/deal/5501525"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate  = self;
    [self.wkWebView loadRequest:request];
  
}

#pragma mark - tapRecongnizer
-(void)tapRecongnizer:(UITapGestureRecognizer*)tapGesture{

    //获取点击的点
    CGPoint point = [tapGesture locationInView:self.wkWebView];
    NSString *js = [NSString stringWithFormat:@"hm_imageSourceFromPoint(%f,%f)",point.x,point.y];
    //执行函数
    [self testJS:^{
       [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable result, NSError * _Nullable error) {
           NSLog(@"================>%@",result);
       }];
    }];
    
    
}

#pragma mark - 获取js
-(NSString *)getJS{
    //获取url
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"tool.js" withExtension:nil];
    //获取js字符串
    NSString *jsStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
   return jsStr;
}


-(NSString *)getJS2{
    //获取js字符串
    NSString *jsStr = @"var figureTag = document.getElementsByTagName('figure')[0].children[0]; figureTag.onclick = function(){window.location.href = 'hmiOS7://www.xxoo.com'};";
    return jsStr;
}


#pragma mark - 测试js注入
-(void)testJS:(void (^)())completeBlock{

    NSString *js = @"typeof hm_imageSourceFromPoint";
    [self.wkWebView evaluateJavaScript:js completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"注入失败了");
            return;
        }
        //注入成功了
        completeBlock();
    }];
}



#pragma mark - WKNavigationDelegate,WKUIDelegate
///决定去加载 注意点：苹果原生的decisionHandler回调一定要实现。
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
   
    //请求的url
    NSLog(@"%@",navigationAction.request);
   
    // WKNavigationActionPolicyCancel,
    // WKNavigationActionPolicyAllow
    //相当于以前的返回 YES
    decisionHandler(WKNavigationActionPolicyAllow);
}

//开始记载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

}
//完成加载
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
    //注入js
    [self.wkWebView evaluateJavaScript:[self getJS] completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
        
        //测试js是否注入成功
        [self testJS:^{
            NSLog(@"注入成功");
        }];
        
    }];
    
}



///拦截 提示框。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
{

    NSLog(@"------------<<<<<%@",message);
    completionHandler();
    
}


#pragma mark - UIGestureRecognizerDelegate

///允许多个手势触发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
