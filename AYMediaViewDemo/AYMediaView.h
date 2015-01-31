//
//  AYMediaView.h
//  AYMediaViewDemo
//
//  Created by Alvin Yu on 1/19/15.
//  Copyright (c) 2015 Alvin Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>

@interface AYMediaView : UIView

- (void)setMediaWithURL:(NSURL*)url;

@end
