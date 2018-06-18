//
//  SecondViewController.m
//  Basics
//
//  Created by admin on 10/04/2017.
//  Copyright © 2017 codewithChris. All rights reserved.
//
#import "FirstViewController.h"

#import "SecondViewController.h"

#import "ThirdViewController.h"

@interface SecondViewController ()

@property (nonatomic, strong) NSArray *arrayInfo, *arrayColorInfo;

@property (nonatomic, strong) NSMutableArray *dynamicInfo;

@end

@implementation SecondViewController

@synthesize arrayInfo, dynamicInfo, arrayColorInfo;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arrayInfo = @[@"test",@"test 1",@"test 2",@"test 3",@"test 4",@"test 5",@"test 6",@"test 7",@"test 8",@"test 9"];
    
    arrayColorInfo = @[[UIColor redColor], [UIColor blueColor], [UIColor blackColor], [UIColor grayColor], [UIColor greenColor], [UIColor darkGrayColor],[UIColor magentaColor], [UIColor redColor],[UIColor redColor],[UIColor redColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrayInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *stringForCell;
   
    stringForCell = arrayInfo[indexPath.row];
    
    [cell.textLabel setText:stringForCell];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThirdViewController *aViewController = [ThirdViewController new];
    
    aViewController.strInfo = arrayInfo[indexPath.row];
    
    [self.navigationController pushViewController:aViewController animated:YES];
}

@end
