//
//  IndicationWebViewController.m
//  IndicationTableview
//
//  Created by Guru Prasad chelliah on 7/12/17.
//  Copyright © 2017 Dreamguys. All rights reserved.
//

#import "IndicationWebViewController.h"

@interface IndicationWebViewController () <UIScrollViewDelegate,UIWebViewDelegate>

{
    BOOL isCheckIndication;
}

@end

@implementation IndicationWebViewController

- (void)viewDidAppear:(BOOL)animated {
    
//    NSString *fullURL = @"http://www.pdfpdf.com/samples/Sample1.PDF";
//    NSURL *url = [NSURL URLWithString:fullURL];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [self.myWebView loadRequest:requestObj];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // self.myWebView.scrollView.delegate = self;

    self.navigationController.navigationBar.translucent = NO;

    // Single page
    //http://che.org.il/wp-content/uploads/2016/12/pdf-sample.pdf
    
    // Five page
    //http://www.pdf995.com/samples/pdf.pdf
    
    // 11 Page
    //http://www.pdfpdf.com/samples/Sample1.PDF
    
    
    self.myWebView.delegate = self;
    
    NSString *resourceDir = [[NSBundle mainBundle] resourcePath];
    NSArray *pathComponents = [NSArray arrayWithObjects:resourceDir,@"test.html", nil];
    NSURL *indexUrl = [NSURL fileURLWithPathComponents:pathComponents];
    NSURLRequest *req = [NSURLRequest requestWithURL:indexUrl];
    [self.myWebView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = request.URL;
    
    if ([url.host isEqualToString:@"abc.xxx.com"]) {
        
        NSString *fragment = url.fragment;
        
        // Do something with the fragment which is the bit after the #
        // Return NO if you don't want to load the URL
    }
    
    return YES;
}


//- (void)webViewDidStartLoad:(UIWebView *)webView {
//
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//
//    CGSize contentSize = webView.scrollView.contentSize;
//
//    if (contentSize.height  > self.myWebView.frame.size.height) {
//
//        [self showIndicatorView];
//        isCheckIndication = YES;
//    }
//
//    else {
//
//        [self hideIndicatorView];
//    }
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//
//    //Check if the web view loadRequest is sending an error message
//    NSLog(@"Error : %@",error);
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    if (isCheckIndication) {
//
//        if(scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - 100)) {
//
//            [self hideIndicatorView];
//            NSLog(@"BOTTOM REACHED");
//        }
//
//        else if(scrollView.contentOffset.y <= 0.0)
//            NSLog(@"TOP REACHED");
//
//        else
//            [self showIndicatorView];
//    }
//}
//
//
//- (void)showIndicatorView {
//
//    self.myBtnIndication.alpha = 1.0;
//}
//
//- (void)hideIndicatorView {
//
//    self.myBtnIndication.alpha = 0.0;
//}


@end
