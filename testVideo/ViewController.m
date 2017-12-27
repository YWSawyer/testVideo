//
//  ViewController.m
//  testVideo
//
//  Created by dahuoshi on 07/11/2017.
//  Copyright © 2017 dahuoshi. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *str = @"http://124.65.36.50:8360/jilin/upload/test.mp4?nsukey=RTXXkYak9e7vZbe5UEHDLCSWEq%2BgcHx37coatCRDEkJ%2FquKd%2B%2FZB9s8v38uOXTPymngFG7X%2B7sE4S2FtM24OgOpz9PHPAr%2B9p0l9EgEBGqvP1IgiWd7dUX6zW6CZd3DN3KTLUFzTOFd3khsC91X%2B9cFnEgJAqnpMCYQZn9G%2BZ7ZTTArLS5lTfW3ma%2Ft%2FaZABFpP1UnDaGAF6yOuRZndsfQ%3D%3D";
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:str]];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame = CGRectMake(0, 0, 320, 400);
    [self.view.layer addSublayer:layer];
    [self.player play];
    NSLog(@"error :%@",self.player.error.localizedDescription);
    [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
}

- (IBAction)asdfadgag:(UIButton *)sender {
    AVPlayerViewController *vc = [AVPlayerViewController new];
    NSString *str = @"http://124.65.36.50:8360/group1/M00/00/31/wKgBJFoBG0mAWEJWAECyweWmRYE515.mp4?token=20da9b111a40895e199489b3a05f40dc&ts=1510021961";
    AVPlayer *palyer = [AVPlayer playerWithURL:[NSURL URLWithString:str]];
    vc.player = palyer;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
