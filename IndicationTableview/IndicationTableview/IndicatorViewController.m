//
//  IndicatorViewController.m
//  IndicationTableview
//
//  Created by Guru Prasad chelliah on 7/11/17.
//  Copyright © 2017 Dreamguys. All rights reserved.
//

#import "IndicatorViewController.h"

#import "IndicatorTableViewCell.h"

@interface IndicatorViewController ()

{
    NSInteger myIntRowCount;
}

@property (weak, nonatomic) IBOutlet UIButton *myBtnDataIndication;

@property (weak, nonatomic) IBOutlet UITableView *myTblView;

@end

@implementation IndicatorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    myIntRowCount = 30;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView -

#pragma mark - Delegate and Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myIntRowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IndicatorTableViewCell * aCell;
    
    if (!aCell)
    {
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IndicatorTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([IndicatorTableViewCell class])];
        aCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndicatorTableViewCell class])];
    }
    
    aCell.gLblTitle.text = @"test";
    
    return aCell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *visibleRows = [self.myTblView indexPathsForVisibleRows];
    NSIndexPath *lastRow = [visibleRows lastObject];
    
    if (myIntRowCount != visibleRows.count) {
        
        if (myIntRowCount - 1 == lastRow.row)
            [self hideIndicatorView];
        else
            [self showIndicatorView];
    }
    
    else
        [self hideIndicatorView];
}

- (void)showIndicatorView {
    
    self.myBtnDataIndication.alpha = 1.0;
}

- (void)hideIndicatorView {
    
    self.myBtnDataIndication.alpha = 0.0;
}


//- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
//    
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    // NSLog(@"offset: %f", offset.y);
//    // NSLog(@"content.height: %f", size.height);
//    // NSLog(@"bounds.height: %f", bounds.size.height);
//    // NSLog(@"inset.top: %f", inset.top);
//    // NSLog(@"inset.bottom: %f", inset.bottom);
//    // NSLog(@"pos: %f of %f", y, h);
//    
//    float reload_distance = 10;
//    
//    if(y > h + reload_distance) {
//        
//        NSLog(@"load more rows");
//    }
//}


@end
