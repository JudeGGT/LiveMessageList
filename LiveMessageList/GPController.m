//
//  GPController.m
//  LiveMessageList
//
//  Created by ggt on 2017/9/22.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import "GPController.h"
#import "GPCell.h"
#import "Masonry.h"

@interface GPController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource; /**< 数据源 */
@property (nonatomic, strong) NSArray *stringArray; /**< 字符串数组 */
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *unReadbutton; /**< 未读消息按钮 */
@property (nonatomic, assign) NSInteger unReadCount; /**< 未读消息个数 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GPController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource = [NSMutableArray array];
    self.index = 0;
    
    [self setupUI];
    [self setupConstraints];
    [self timersStart];
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - UI

- (void)setupUI {
    
    UIView *tableViewBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 300, 150)];
    // 渐变蒙层
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = @[
                     (__bridge id)[UIColor colorWithWhite:0 alpha:0.05f].CGColor,
                     (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor
                     ];
    layer.locations = @[@0, @0.25]; // 设置颜色的范围
    layer.startPoint = CGPointMake(0, 0); // 设置颜色渐变的起点
    layer.endPoint = CGPointMake(0, 1); // 设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
    layer.frame = tableViewBackView.bounds; // 设置 Frame
    
    tableViewBackView.layer.mask = layer; // 设置 mask 属性
    [self.view addSubview:tableViewBackView];
    
    [tableViewBackView addSubview:self.tableView];
    
    UIButton *unReadButton = [[UIButton alloc] init];
    unReadButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    unReadButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [unReadButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [unReadButton addTarget:self action:@selector(scrollToBottom) forControlEvents:UIControlEventTouchUpInside];
    [tableViewBackView addSubview:unReadButton];
    unReadButton.hidden = YES;
    self.unReadbutton = unReadButton;
    [unReadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(tableViewBackView);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
}


#pragma mark - Constraints

- (void)setupConstraints {
    
    
}


#pragma mark - Custom Accessors (Setter 与 Getter 方法)


#pragma mark - IBActions

- (void)scrollToBottom {
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
    self.unReadCount = 0;
    self.unReadbutton.hidden = YES;
}


#pragma mark - Public


#pragma mark - Private

/**
 定时器工作
 */
- (void)timersStart {
    
    self.timer = [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (self.index >= self.stringArray.count) {
            self.index = 0;
        }
        
        [self.dataSource insertObject:self.stringArray[self.index] atIndex:0];
        [self reloadTableView];
        self.index++;
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)reloadTableView {

    // 先判断 tableView 是否发生过偏移
    BOOL isScroll = self.tableView.contentOffset.y < 50 ? YES : NO;
    
    if (isScroll) {
        // 自动滚
        self.unReadbutton.hidden = YES;
        self.unReadCount = 0;
        NSInteger rowCount = [self.tableView numberOfRowsInSection:0]; /**< 显示的消息个数 */
        NSInteger unReadCount = self.dataSource.count - rowCount;
        
        NSMutableArray *indexPathArray = [NSMutableArray array]; /**< 插入 cell 数组 */
        for (NSInteger i = 0; i < unReadCount; i++) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        if (indexPathArray.count) {
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        }
    } else {
        // 显示未读消息提示
        self.unReadbutton.hidden = NO;
        self.unReadCount++;
        [self.unReadbutton setTitle:[NSString stringWithFormat:@"%ld条未读消息", self.unReadCount] forState:UIControlStateNormal];
    }
}


#pragma mark - Protocol

#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GPCell *cell = [GPCell cellWithTableView:tableView indexPath:indexPath];
    cell.string = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView && self.unReadCount) {
        NSLog(@"%s", __func__);
        [self.tableView reloadData];
    }
}

#pragma mark - 懒加载

- (NSArray *)stringArray {
    
    if (_stringArray == nil) {
        _stringArray = @[
                        @"坐在巷口的那对男女",
                        @"紧紧的抱在一起",
                        @"一动也不动的呆在那里",
                        @"时间好像跟他们没关系",
                        @"是什么样的心情 什么样的心情",
                        @"难道这就是爱情",
                        @"啦啦啦啦...",
                        @"坐在巷口的那对男女",
                        @"脸上没有表情",
                        @"路灯一盏一盏的熄灭",
                        @"他们始终没有说上半句",
                        @"是什么样的情绪 什么样的情绪",
                        @"难道这就是爱情",
                        @"啦啦啦啦...",
                        @"让人又哭又笑抓摸不定",
                        @"让人飞翔让人坠落谷底",
                        @"喔 难道这就是爱情",
                        @"坐在巷口的那对男女",
                        @"笑声从来没停",
                        @"老师叫你上台介绍自己",
                        @"也没见你那么充满自信",
                        @"是什么样的勇气 什么样的勇气",
                        @"我想这就是爱情",
                        @"啦啦啦啦...",
                        @"我想这就是爱情",
                        @"啦啦啦啦...",
                        @"我想这就是爱情",
                        @"啦啦啦啦...",
                        @"我想这就是爱情"
                        ];
    }
    
    return _stringArray;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 150) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 20;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.transform = CGAffineTransformMakeScale(1, -1);
    }
    
    return _tableView;
}

@end
