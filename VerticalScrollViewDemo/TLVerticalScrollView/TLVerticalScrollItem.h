//
//  TLVerticalScrollItem.h
//  TalentsLadder
//
//  Created by goviewtech on 2020/6/17.
//  Copyright © 2020 dude. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface TLVerticalScrollItem : UIView

/**
 建议开发者将自定义的控件都写在contentview中
 */
@property (nonatomic,strong,readonly)UIView *contentView;

@property (nonatomic,strong,readonly)UILabel *textLabel;
///点击事件用到的
@property (nonatomic,strong,readonly)UIButton *coverBtn;

/**
 用于item重用标记用的 请误修改
 */
@property (nonatomic,assign)NSInteger rowIndex;




@end

NS_ASSUME_NONNULL_END
