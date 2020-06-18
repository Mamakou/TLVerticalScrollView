//
//  TLVerticalScrollView.h
//  TalentsLadder
//
//  Created by goviewtech on 2020/6/17.
//  Copyright © 2020 dude. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLVerticalScrollItem.h"

@class TLVerticalScrollView;

@protocol TLVerticalScrollViewDelegate <NSObject>

@required
/**item的总个数*/
- (NSInteger)scrollTotalItemCount:(TLVerticalScrollView*)scrollView;

/**
 初始化位置显示的item
 */
- (TLVerticalScrollItem*)scrollViewItemView:(TLVerticalScrollView*)scrollView;


/**
 每个需要展现的数据，在这个代理中完成
 */
- (void)scrollView:(TLVerticalScrollView*)scrollView itemView:(TLVerticalScrollItem*)itemView index:(NSInteger)index;

@optional

/**
 同时展现item的数据，比如1个1个滚动，或者同时两个滚动，目前的业务默认为2
 默认为2，所以当数据的总个数大于它的时候，才会滚动
 */
- (NSInteger)scrollItemDisplayCount:(TLVerticalScrollView*)scrollView;

/**
 滚动item的宽度 这个默认是等于self.bounds.width
 */
- (CGFloat)scrollViewItemWidth:(TLVerticalScrollView*)scrollView;

/**
 滚动itemview的高度 默认是等于self.bounds.height除以显示个个数
 */
- (CGFloat)scrollViewItemHeight:(TLVerticalScrollView*)scrollView;

/**
 定时滚动时间
 最低的间隔时间为1秒
 */
- (NSTimeInterval)scollInterval:(TLVerticalScrollView*)scrollView;
/**
 点击对应 的下标
  如果需要回调，需要将scrollViewItemCanTapResponse返回true即可
 */
- (void)scollView:(TLVerticalScrollView*)scrollView selectedIndex:(NSInteger)index;

/**
 点击事件是否可以响应，默认不响应
 */
- (BOOL)scrollViewItemCanTapResponse:(TLVerticalScrollView*)scrollView;

@end


@interface TLVerticalScrollView : UIView

@property (nonatomic,weak)id <TLVerticalScrollViewDelegate>delegate;

/**
 重新刷新
 */
- (void)reloadData;
/**
 销毁
 */
- (void)releaseScrollView;

@end

