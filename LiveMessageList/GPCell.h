//
//  GPCell.h
//  LiveMessageList
//
//  Created by ggt on 2017/9/22.
//  Copyright © 2017年 ggt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPCell : UITableViewCell

#pragma mark - Property

@property (nonatomic, copy) NSString *string;


#pragma mark - Method

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
