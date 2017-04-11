//
//  MyWebViewController.m
//  AVPlayerTest
//
//  Created by Yogo-iOS on 2017/3/7.
//  Copyright © 2017年 Yogo-iOS. All rights reserved.
//

#import "MyWebViewController.h"
#import <WebKit/WebKit.h>

@interface MyWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView * wkWebView;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@end

@implementation MyWebViewController

-(NSMutableArray *)sourceArray{
    if (!_sourceArray) {
        _sourceArray = [NSMutableArray array];
    }
    return _sourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _wkWebView = [[WKWebView alloc]initWithFrame:self.view.bounds];
//    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _wkWebView.contentMode = UIViewContentModeRedraw;
    _wkWebView.opaque = YES;
    [self.view addSubview:_wkWebView];
    
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
    [self createBackButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.sourceArray removeAllObjects];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
    if (![self.sourceArray containsObject:navigationResponse.response.URL]) {
        [self.sourceArray addObject:navigationResponse.response.URL];
    }
}


#pragma mark 重写barbutton
-(UIBarButtonItem *)createBackButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"common-back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, (44 -18) /2, 18, 18);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = menuButton;
    return menuButton;
}

-(void)popself{
    if (self.sourceArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.sourceArray removeLastObject];
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:self.sourceArray.lastObject]];
    }
}




@end
