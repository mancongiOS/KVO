//
//  ViewController.m
//  Demo_KVC
//
//  Created by goulela on 17/1/20.
//  Copyright © 2017年 MC. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "MCBuyData.h"

#define kNumber @"number"
#define kMoney  @"money"

@interface ViewController ()

@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * moneyLabel;
@property (nonatomic, strong) UIButton * toBuyButton;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingObserver];

    [self initUI];
}

- (void)dealloc {
    

    [self.buyData removeObserver:self forKeyPath:kNumber context:@"number"];
    [self.buyData removeObserver:self forKeyPath:kMoney context:@"money"];
}

#pragma mark - 点击事件
- (void)toBuyButtonClicked {

    NSInteger number = [[self.buyData valueForKey:kNumber] integerValue];
    number += 1;
    [self.buyData setValue:@(number) forKey:kNumber];
    
    
    NSInteger money = [[self.buyData valueForKey:kMoney] integerValue];
    money += 100;
    [self.buyData setValue:@(money) forKey:kMoney];

}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 该change的内容记录的是本次监听到的属性的改变.
    NSLog(@"change: %@",change);
    
    NSString * new = change[@"new"];

    if (object == self.buyData && [keyPath isEqualToString:kNumber] && (context == @"number")) {
        self.numberLabel.text = [NSString stringWithFormat:@"次数: %@",new];
    } else {
        // 写了这句,如果父视图中没有注册的KVO,就会崩掉.
        // reason: '<ViewController: 0x7fd7af406030>: An -observeValueForKeyPath:ofObject:change:context: message was received but not handled.
     //   [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    if ([keyPath isEqualToString:kMoney]) {
        self.moneyLabel.text = [NSString stringWithFormat:@"金额: %@",new];
    } else {
       // [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)settingObserver {

    self.buyData = [[MCBuyData alloc] init];
    [self.buyData setValue:@(0) forKey:kNumber];
    [self.buyData setValue:@(0) forKey:kMoney];
   [self.buyData addObserver:self forKeyPath:kNumber options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"number"];
    [self.buyData addObserver:self forKeyPath:kMoney options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"money"];
}

- (void)initUI {

    [self.view addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(20);
        make.right.mas_equalTo(self.view).with.offset(-20);
        make.top.mas_equalTo(self.view).with.offset(100);
        make.height.mas_equalTo(50);
    }];
    
    [self.view addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(20);
        make.right.mas_equalTo(self.view).with.offset(-20);
        make.top.mas_equalTo(self.view).with.offset(250);
        make.height.mas_equalTo(50);
    }];
    

    [self.view addSubview:self.toBuyButton];
    [self.toBuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(20);
        make.right.mas_equalTo(self.view).with.offset(-20);
        make.top.mas_equalTo(self.view).with.offset(400);
        make.height.mas_equalTo(50);
    }];

}

#pragma mark - setter & getter 
- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.backgroundColor = [UIColor orangeColor];
        self.numberLabel.font = [UIFont systemFontOfSize:15];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.text = @"次数: 1";
    } return _numberLabel;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        self.moneyLabel = [[UILabel alloc] init];
        self.moneyLabel.backgroundColor = [UIColor orangeColor];
        self.moneyLabel.font = [UIFont systemFontOfSize:15];
        self.moneyLabel.textColor = [UIColor whiteColor];
        self.moneyLabel.textAlignment = NSTextAlignmentCenter;
        self.moneyLabel.text = @"金额: 1";
    } return _moneyLabel;
}

- (UIButton *)toBuyButton {
    if (_toBuyButton == nil) {
        self.toBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.toBuyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.toBuyButton.backgroundColor = [UIColor redColor];
        [self.toBuyButton setTitle:@"买 买 买!!!" forState:UIControlStateNormal];
        [self.toBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.toBuyButton addTarget:self action:@selector(toBuyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    } return _toBuyButton;
}

@end
