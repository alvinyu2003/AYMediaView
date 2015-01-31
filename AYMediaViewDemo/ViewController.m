//
//  ViewController.m
//  AYMediaViewDemo
//
//  Created by Alvin Yu on 1/19/15.
//  Copyright (c) 2015 Alvin Yu. All rights reserved.
//

#import "ViewController.h"
#import "AYMediaView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *photoURL = [NSURL URLWithString:@"http://cdn.funnyisms.com/939bba9e-5172-4d7b-99c5-05e29c2d7045.jpg"];
    NSURL *videoURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/9804931/7bdb25bd-449b-4afd-94b7-040cd76b1b92.mp4"];
    
    AYMediaView *ayMediaView = [[AYMediaView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-320)/2.0, (self.view.frame.size.height-320)/2.0, 320, 320)];
    [self.view addSubview:ayMediaView];
    
    //[ayMediaView setMediaWithURL:photoURL];
    [ayMediaView setMediaWithURL:videoURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
