//
//  GPCell.m
//  LiveMessageList
//
//  Created by ggt on 2017/9/22.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import "GPCell.h"

@interface GPCell ()

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation GPCell

#pragma mark - Lifecycle

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"GPCell";
    GPCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[GPCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.indexPath = indexPath;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:13.0f];
        self.contentView.transform = CGAffineTransformMakeScale(1, -1);
        
        [self setupUI];
        [self setupConstraints];
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}

#pragma mark - UI

- (void)setupUI {
    
    
}


#pragma mark - Constraints

- (void)setupConstraints {
    

}


#pragma mark - Custom Accessors (Setter 与 Getter 方法)

- (void)setString:(NSString *)string {
    
    _string = string;
    
    self.textLabel.text = string;
}


#pragma mark - IBActions


#pragma mark - Public


#pragma mark - Private


#pragma mark - Protocol


#pragma mark - 懒加载

@end
