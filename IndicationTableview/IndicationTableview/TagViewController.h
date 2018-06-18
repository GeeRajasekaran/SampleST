//
//  TagViewController.h
//  IndicationTableview
//
//  Created by Guru Prasad chelliah on 8/4/17.
//  Copyright © 2017 Dreamguys. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CLTokenInputView.h"

@interface TagViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet CLTokenInputView *myTokenView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTokenViewHeight;

@end
