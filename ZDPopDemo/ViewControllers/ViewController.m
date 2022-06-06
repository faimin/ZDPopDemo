//
//  ViewController.m
//  ZDPopDemo
//
//  Created by Zero.D.Saber on 2017/5/8.
//  Copyright © 2017年 zero.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSString *title = [(UIButton *)sender titleForState:UIControlStateNormal];

  __unused UIViewController *fromVC = segue.sourceViewController;
  UIViewController *toVC = segue.destinationViewController;
  toVC.title = title;
}

@end
