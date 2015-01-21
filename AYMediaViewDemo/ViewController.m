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

@property(nonatomic, strong) IBOutlet AYMediaView *ayMediaView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *photoURL = [NSURL URLWithString:@"http://cdn.funnyisms.com/939bba9e-5172-4d7b-99c5-05e29c2d7045.jpg"];
    NSURL *videoURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/9804931/Smoke.mp4"];
    
    [self.ayMediaView setMediaWithURL:photoURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
