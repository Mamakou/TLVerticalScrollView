//
//  TLVerticalScrollItem.m
//  TalentsLadder
//
//  Created by goviewtech on 2020/6/17.
//  Copyright © 2020 dude. All rights reserved.
//

#import "TLVerticalScrollItem.h"
#import "UIView+AutoLayout.h"

@implementation TLVerticalScrollItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        _contentView = contentView;
        [self addSubview:contentView];
        ///上下左右距离父空间为0
        [contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        UILabel *textLabel = [[UILabel alloc]init];
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel = textLabel;
        [contentView addSubview:textLabel];
        [textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [textLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        [textLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _coverBtn = coverBtn;
        [self addSubview:coverBtn];
         ///上下左右距离父空间为0
        [coverBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    return self;
}

-(void)setRowIndex:(NSInteger)rowIndex
{
    _rowIndex = rowIndex;
    [self.coverBtn setTag:rowIndex];
}



@end
