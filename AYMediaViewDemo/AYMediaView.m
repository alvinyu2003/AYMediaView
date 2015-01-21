//
//  AYMediaView.m
//  AYMediaViewDemo
//
//  Created by Alvin Yu on 1/19/15.
//  Copyright (c) 2015 Alvin Yu. All rights reserved.
//

#import "AYMediaView.h"
#import "AVPlayerDemoPlaybackView.h"
#import "NSString+NSHash.h"

@interface AYMediaView()

@property (nonatomic, strong) AVPlayerDemoPlaybackView *mPlaybackView;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *photoExtensionArray;
@property (nonatomic, strong) NSArray *videoExtensionArray;
@property (nonatomic, strong) IBOutlet UIButton *playOrPauseButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation AYMediaView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"init with frame: %@", NSStringFromCGRect(frame));
        [self setUpMediaView];
    }
    return self;
}

- (void)awakeFromNib
{
    NSLog(@"awake from nib with frame: %@", NSStringFromCGRect(self.frame));
    [self setUpMediaView];
}

- (void)setUpMediaView
{
    self.backgroundColor = [UIColor blackColor];
    
    //set up video view
    self.mPlaybackView = [[AVPlayerDemoPlaybackView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.mPlaybackView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.mPlaybackView];
    
    self.playOrPauseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.playOrPauseButton addTarget:self action:@selector(playOrPauseMedia:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.mPlaybackView addSubview:self.playOrPauseButton];
    
    //set up image view
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.imageView];
    
    //set up activity indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.activityIndicator hidesWhenStopped];
    self.activityIndicator.frame = CGRectMake((self.frame.size.width - self.activityIndicator.frame.size.width)/2, (self.frame.size.height - self.activityIndicator.frame.size.height)/2, self.activityIndicator.frame.size.width, self.activityIndicator.frame.size.height);
    [self addSubview:self.activityIndicator];
    
    //allowed extensios
    self.photoExtensionArray = [NSArray arrayWithObjects:@"jpg", @"JPG", @"jpeg", @"JPEG", @"png", @"PNG", nil];
    self.videoExtensionArray = [NSArray arrayWithObjects:@"mov", @"MOV", @"mp4", @"MP4", nil];
}

- (void)setMediaWithURL:(NSURL*)url
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSString *path = [url path];
    NSString *extension = [path pathExtension];
    NSString *fileName = [path SHA1];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@", cachePath, fileName, extension];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:filePath])
    {
        [self setMediaWithFile:filePath];
    }
    else
    {
        if([self isFileExtensionSupported:extension])
        {
            [self downloadMedia:url toFile:filePath];
        }
        else
        {
            NSLog(@"unsupported file");
        }
    }
}

- (void)downloadMedia:(NSURL*)url toFile:(NSString*)filePath
{
    [self.activityIndicator startAnimating];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self.activityIndicator stopAnimating];
             
             if ([data length] >0 && error == nil)
             {
                 [data writeToFile:filePath atomically:YES];
                 [self setMediaWithFile:filePath];
             }
             else
             {
                 NSLog(@"failed to download file");
             }
         });
     }];
}

- (void)setMediaWithFile:(NSString*)filePath
{
    if([self isVideoExtension:[filePath pathExtension]])
        [self setVideoWithFile:filePath];
    else
        [self setImageWithFile:filePath];
}

- (void)setVideoWithFile:(NSString*)filePath
{
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    self.avPlayer = [AVPlayer playerWithPlayerItem:item];
    [self.mPlaybackView setPlayer:self.avPlayer];
    self.imageView.hidden = YES;
    self.mPlaybackView.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.avPlayer currentItem]];
}

- (void)setImageWithFile:(NSString*)filePath
{
    [self.imageView setImage:[UIImage imageWithContentsOfFile:filePath]];
    self.imageView.hidden = NO;
    self.mPlaybackView.hidden = YES;
}

- (BOOL)isPhotoExtension:(NSString*)ext
{
    if([self.photoExtensionArray containsObject:ext])
        return YES;
    else
        return NO;
}

- (BOOL)isVideoExtension:(NSString*)ext
{
    if([self.videoExtensionArray containsObject:ext])
        return YES;
    else
        return NO;
}

- (BOOL)isFileExtensionSupported:(NSString*)extension
{
    if(([self.videoExtensionArray containsObject:extension])||([self.photoExtensionArray containsObject:extension]))
        return YES;
    else
        return NO;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    NSLog(@"played item");
    [self.playOrPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.avPlayer seekToTime:kCMTimeZero];
}

- (IBAction)playOrPauseMedia:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if(self.avPlayer.rate>0)
    {
        [button setTitle:@"Play" forState:UIControlStateNormal];
        [self.avPlayer pause];
    }
    else
    {
        [button setTitle:@"Pause" forState:UIControlStateNormal];
        [self.avPlayer play];
    }
}

@end
