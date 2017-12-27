//
//  TestViewController.m
//  testVideo
//
//  Created by dahuoshi on 09/11/2017.
//  Copyright © 2017 dahuoshi. All rights reserved.
//

#import "TestViewController.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface TestViewController ()
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *palyPause;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建网络视频路径
    NSString *urlStr = @"http://59.108.36.106:91/SC_CORE/rest/attachment/e1d06c8c970a420fb0bbe85317b177b9";
    //urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//url只支持英文和少数其它字符，因此对url中非标准字符需要进行编码，这个编码方*****能不完善，因此使用下面的方法编码。
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *netUrl = [NSURL URLWithString:urlStr];
    //2.创建AVPlayer
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:netUrl];
    _avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    //_avPlayer.currentItem;//用于获取当前的AVPlayerItem
    //3.设置每秒执行一次进度更新
    UIProgressView *progressView = _progress;//
    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current) {
            progressView.progress = current / total;
        }
    }];
    //4.监控播放状态,KVO
    [_avPlayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监控状态属性，获取播放状态。
    [_avPlayer.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//监控网络加载情况
    //5.创建播放层，开始播放视频
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    playerLayer.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
    //playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    [_containerView.layer addSublayer:playerLayer];
    [_avPlayer play];
    //7.添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer.currentItem];
}

//视频播放完成
-(void)playbackFinish:(NSNotification *)notification{
    NSLog(@"视频播放完成");
}

//通过KVO监控播放器的状态
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"正在播放:%.2f", CMTimeGetSeconds(playerItem.duration));
        }else if(status == AVPlayerStatusFailed) {
            NSLog(@"加载失败：%@",_avPlayer.currentItem.error);
        }else if(status == AVPlayerStatusUnknown) {
            NSLog(@"未知状态：%@",_avPlayer.currentItem.error);
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f", totalBuffer);
    }
}

-(void)dealloc{
    [_avPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    [_avPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)playPause:(id)sender {
    if (_avPlayer.rate == 0) {//暂停
        [_avPlayer play];
    }else if(_avPlayer.rate == 1){//正在播放
        [_avPlayer pause];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
