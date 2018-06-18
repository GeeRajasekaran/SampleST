//
//  TagViewController.m
//  IndicationTableview
//
//  Created by Guru Prasad chelliah on 8/4/17.
//  Copyright © 2017 Dreamguys. All rights reserved.
//

#import "TagViewController.h"

@interface TagViewController () <UIScrollViewDelegate,CLTokenInputViewDelegate>
{
    
    UIScrollView  *MyScrollVw;
    CLTokenInputView *aTokenView;
}

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Via programatically
//    MyScrollVw= [[UIScrollView alloc]initWithFrame:CGRectMake(0 ,100 ,320 ,100)];
//    MyScrollVw.delegate= self;
//    [MyScrollVw setShowsHorizontalScrollIndicator:NO];
//    [MyScrollVw setShowsVerticalScrollIndicator:YES];
//    MyScrollVw.scrollEnabled= YES;
//    MyScrollVw.userInteractionEnabled= YES;
//
//    MyScrollVw.backgroundColor = [UIColor lightGrayColor];
//    
//    aTokenView = [[CLTokenInputView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
//
//    aTokenView.delegate = self;
//    
//    for (int i= 0; i < 100; i++) {
//        
//        CLToken *aToken = [[CLToken alloc] initWithDisplayText:@"XXXXXXXXX" context:nil];
//        [aTokenView addToken:aToken];
//    }
//    
//    aTokenView.backgroundColor = [UIColor yellowColor];
//    
//    [MyScrollVw addSubview:aTokenView];
//    [self.view addSubview:MyScrollVw];
    
    // Via xib
    self.myScrollView.backgroundColor = [UIColor lightGrayColor];
    self.myTokenView.delegate = self;
    
    for (int i= 0; i < 10; i++) {
        
        CLToken *aToken = [[CLToken alloc] initWithDisplayText:@"XXXXXXXXX" context:nil];
        [self.myTokenView addToken:aToken];
    }
    
    self.myTokenView.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLTokenInputViewDelegate

- (void)tokenInputView:(CLTokenInputView *)view didChangeHeightTo:(CGFloat)height {
    
    self.myScrollView.contentSize= CGSizeMake(320 ,height);
    self.constraintTokenViewHeight.constant = height;
}

- (void)tokenInputView:(CLTokenInputView *)view didChangeText:(NSString *)text {
    
}

- (void)tokenInputView:(CLTokenInputView *)view didAddToken:(CLToken *)token {
    
    
}

- (void)tokenInputView:(CLTokenInputView *)view didRemoveToken:(CLToken *)token {
    
}

- (CLToken *)tokenInputView:(CLTokenInputView *)view tokenForText:(NSString *)text {
    return nil;
}

- (void)tokenInputViewDidEndEditing:(CLTokenInputView *)view {
    NSLog(@"token input view did end editing: %@", view);
    view.accessoryView = nil;
}

- (void)tokenInputViewDidBeginEditing:(CLTokenInputView *)view {
    
}


@end
