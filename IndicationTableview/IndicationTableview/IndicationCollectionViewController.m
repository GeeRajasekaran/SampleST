//
//  IndicationCollectionViewController.m
//  IndicationTableview
//
//  Created by Guru Prasad chelliah on 7/12/17.
//  Copyright © 2017 Dreamguys. All rights reserved.
//

#import "IndicationCollectionViewController.h"

@interface IndicationCollectionViewController ()

{
    NSInteger myIntRowCount;
}

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *myBtnIndication;

@end

@implementation IndicationCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    myIntRowCount = 30;

    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return myIntRowCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor greenColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.myCollectionView.frame.size.width, 50);
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *visibleRows = [self.myCollectionView indexPathsForVisibleItems];
    NSIndexPath *lastRow = [visibleRows lastObject];
    
    NSLog(@"count--------> %lu", (unsigned long)visibleRows.count);

    if (myIntRowCount != visibleRows.count) {
        
        if (myIntRowCount - 1 == lastRow.row)
            [self hideIndicatorView];
        else
            [self showIndicatorView];
    }
    
    else
        [self hideIndicatorView];
    
    NSLog(@"willDisplayCell");

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    for (UICollectionViewCell *cell in [self.myCollectionView visibleCells]) {
        
        NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
        
        NSLog(@"%@",indexPath);
    }
}


- (void)showIndicatorView {
    
    self.myBtnIndication.alpha = 1.0;
}

- (void)hideIndicatorView {
    
    self.myBtnIndication.alpha = 0.0;
}


@end
