//
//  FirstViewController.m
//  Basics
//
//  Created by admin on 10/04/2017.
//  Copyright © 2017 codewithChris. All rights reserved.
//

#import "FirstViewController.h"

#import "SecondViewController.h"

#import "ThirdViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)DidReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Text Field Delegate
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.firstTxtFld)
        [self.secondTxtFld becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    // add your method here
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


- (IBAction)btnTapped:(id)sender {
    
    
    if (self.firstTxtFld.text.length == 00 && self.secondTxtFld.text.length == 8) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"User Name and Password should not be empty" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // Ok action example
        }];
       
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    else if (self.firstTxtFld.text.length == 0) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"User Name should not be empty" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // Ok action example
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    else if (![self validateEmail:self.firstTxtFld.text]) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please Enter Valid Email Address !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // Ok action example
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else if (self.firstTxtFld.text.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"User Name should not be empty" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // Ok action example
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    else if (self.secondTxtFld.text.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Password should not be empty" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // Ok action example
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    else if (self.secondTxtFld.text.length <= 8) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Password should not be minimum 8 letters" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            // Ok action example
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    SecondViewController *aViewController = [SecondViewController new];
    [self.navigationController pushViewController:aViewController animated:YES];
}


- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

@end
