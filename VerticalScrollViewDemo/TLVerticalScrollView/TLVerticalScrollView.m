//
//  TLVerticalScrollView.m
//  TalentsLadder
//
//  Created by goviewtech on 2020/6/17.
//  Copyright © 2020 dude. All rights reserved.
//

#import "TLVerticalScrollView.h"

#define NOMAL_DISPLAY_COUNT 2


@interface TLVerticalScrollView ()

@property (nonatomic,assign)BOOL canAutoScoll;
@property (nonatomic,strong)NSMutableArray *itemArray;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSTimeInterval interval;


///显示到了第几个 如果是可以滚动的情况下，showIndex的值一开始则为display
@property (nonatomic,assign)NSInteger showIndex;

@property (nonatomic,assign)NSInteger currentDiplayCount;

@property (nonatomic,assign)NSInteger totalItemCount;

@property (nonatomic,assign)BOOL hadFirstSetFrame;

@end

@implementation TLVerticalScrollView

-(NSMutableArray *)itemArray
{
    if(!_itemArray){
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpBaseMessage];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self){
        [self setUpBaseMessage];
    }
    return self;
}

- (void)setUpBaseMessage
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = true;
    self.interval = 4;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verticleScrollDidEenterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verticleScrollDidEenterForground) name:UIApplicationWillEnterForegroundNotification object:nil];
}



- (void)reloadData
{
    self.canAutoScoll = false;
    self.showIndex = 0;
    [self clearTimer];
    if(self.subviews.count > 0){
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.itemArray removeAllObjects];
    if(![self.delegate respondsToSelector:@selector(scrollTotalItemCount:)]){
        return;
    }
    
    NSInteger totalItemCount = [self.delegate scrollTotalItemCount:self];
    if(totalItemCount == 0){
        return;
    }
    self.totalItemCount = totalItemCount;
    ///同时出现多少个item
    NSInteger displayCount = NOMAL_DISPLAY_COUNT;
    if([self.delegate respondsToSelector:@selector(scrollItemDisplayCount:)]){
        displayCount = [self.delegate scrollItemDisplayCount:self];
    }
    self.currentDiplayCount = displayCount;
    
    self.canAutoScoll = totalItemCount > displayCount;
    
    CGFloat itemHeight = 0;
    itemHeight = self.bounds.size.height / displayCount;
    if([self.delegate respondsToSelector:@selector(scrollViewItemHeight:)]){
        itemHeight = [self.delegate scrollViewItemHeight:self];
        if(itemHeight > 0){///如果外界实现了这个代理，则以外界的为准，内部则不需要 再layoutSubviews再进行布局了
            self.hadFirstSetFrame = true;
        }
    }
    if(itemHeight == 0)return;
    CGFloat itemWidth = self.bounds.size.width;
    if([self.delegate respondsToSelector:@selector(scrollViewItemWidth:)]){
        itemWidth = [self.delegate scrollViewItemWidth:self];
    }
    
    BOOL canTap = false;
    if([self.delegate respondsToSelector:@selector(scrollViewItemCanTapResponse:)]){
        canTap = [self.delegate scrollViewItemCanTapResponse:self];
    }
    
    if(self.canAutoScoll){
        ///在可以滚动的时候，如果同时显示2个，则需要创建三个item方法实现滚动效果
        for (int i = 0; i<displayCount+1; i++) {
            TLVerticalScrollItem *itemView = [self.delegate scrollViewItemView:self];
            itemView.rowIndex = i;
            itemView.frame = CGRectMake(0, i*itemHeight, itemWidth, itemHeight);
            if(canTap == false){
                itemView.coverBtn.userInteractionEnabled = false;
            }else{
                [itemView.coverBtn addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:itemView];
            [self.itemArray addObject:itemView];
            ///一开始就要先更新
            if([self.delegate respondsToSelector:@selector(scrollView:itemView:index:)]){
                [self.delegate scrollView:self itemView:itemView index:i];
            }
            self.showIndex = (displayCount+1)-1;///显示到的数据的下标
        }
        [self createTimer];
    }else{
        ///在不能滚动的时候，有多少个item就展示都是个item
        for (int i = 0; i<totalItemCount; i++) {
            TLVerticalScrollItem *itemView = [self.delegate scrollViewItemView:self];
            itemView.frame = CGRectMake(0, i*itemHeight, itemWidth, itemHeight);
            itemView.rowIndex = i;
            if(canTap == false){
                itemView.coverBtn.userInteractionEnabled = false;
            }else{
                [itemView.coverBtn addTarget:self action:@selector(clickItemAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self addSubview:itemView];
            if([self.delegate respondsToSelector:@selector(scrollView:itemView:index:)]){
                [self.delegate scrollView:self itemView:itemView index:i];
            }
        }
    }
}

- (void)releaseScrollView
{
    [self clearTimer];
}


#pragma mark - private 私有方法

///创建定时器
- (void)createTimer
{
    NSTimeInterval interval = self.interval;
    if([self.delegate respondsToSelector:@selector(scollInterval:)]){
        interval = [self.delegate scollInterval:self];
    }
    if(interval < 1)interval = 1;///至少间隔一秒，否则在内部控件位置轮换的时候会有影响
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(itemScrollAction) userInfo:nil repeats:true];
}

///清除定时器
- (void)clearTimer
{
    if(self.timer != nil){
        [self.timer invalidate];
        self.timer = nil;
    }
}

///总共有两个地方需要考虑
///1、重用的itemview
///2、滚动的下标控制，就是源数据的下标控制

- (void)itemScrollAction
{
    self.showIndex += 1;
    ///需要显示的数据源的下标，这个是提前显示的，调用这个的时候，在最下方
    if(self.showIndex >= self.totalItemCount){
        self.showIndex = 0;
    }
    ///先完成滚动动画后，在来回调数据源展示方法
    for (int i = 0; i<self.itemArray.count; i++) {
        TLVerticalScrollItem *itemView = self.itemArray[i];
        itemView.rowIndex -= 1;
        [UIView animateWithDuration:0.35 animations:^{
            CGRect itemViewFrame = itemView.frame;
            itemViewFrame.origin.y -= (itemViewFrame.size.height);
            itemView.frame = itemViewFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
    ///延迟时间稍微多加一点
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35+0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TLVerticalScrollItem *item = [self findItemViewWhichYValueMineZero];
        CGRect itemFrame = item.frame;
        CGFloat itemHeight = itemFrame.size.height;
        CGFloat itemY = self.currentDiplayCount * itemHeight;
        itemFrame.origin.y = itemY;
        item.frame = itemFrame;
        if([self.delegate respondsToSelector:@selector(scrollView:itemView:index:)]){
            [self.delegate scrollView:self itemView:item index:self.showIndex];
        }
    });
}

- (TLVerticalScrollItem*)findItemViewWhichYValueMineZero
{
    TLVerticalScrollItem *result = nil;
    for (TLVerticalScrollItem*item in self.itemArray) {
        if(item.rowIndex < 0){
            result = item;
            break;
        }
    }
    if(result){
        result.rowIndex = self.itemArray.count-1;
    }
    return result;
}

/**
 item的点击事件
 */
- (void)clickItemAction:(UIButton*)sender
{
    if(self.canAutoScoll == false){
        if([self.delegate respondsToSelector:@selector(scollView:selectedIndex:)]){
            [self.delegate scollView:self selectedIndex:sender.tag];
        }
    }else{
        ///例如默认displayCount为2，那个理论上能点击到的item的rowindex只能是0和1，因为rowindex为2还底部用户看不见
        ///假如出现点击的item的index等于currentDiplayCount，那么就默认点击为显示中的最后一个
        NSInteger itemIndex = sender.tag;
        if(itemIndex == self.currentDiplayCount){
            itemIndex = self.currentDiplayCount-1;
        }
        ///根据showindex得出当前正在显示的数据下标，按当前默认displayCount==2来说，如果showindex为2，则（0，1）就是可以被点击的数据下标集合
        ///假如当前数据总数为5，则可以得出一下结论
        /// showIndex  可点击下标
        /// 2           (0,1)
        /// 3           (1，2)
        /// 4           (2, 3)
        /// 0           (3, 4)
        /// 1           (4, 0)
        NSArray *indexList = [self currentShowDataIndexListWithShowIndex:self.showIndex];
        NSNumber *resultIndexNumber = indexList[itemIndex];
        if([self.delegate respondsToSelector:@selector(scollView:selectedIndex:)]){
            [self.delegate scollView:self selectedIndex:resultIndexNumber.integerValue];
        }
    }
}

- (NSArray*)currentShowDataIndexListWithShowIndex:(NSInteger)showIndex
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:self.currentDiplayCount];
    NSInteger index = showIndex;
    for (int i = 0; i<self.currentDiplayCount; i++) {
        if(index == 0){
            index += self.totalItemCount;
        }
        index -= 1;
        NSNumber *indexValue = [NSNumber numberWithInteger:index];
        [results insertObject:indexValue atIndex:0];
    }
    return results;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    ///如果是通过约束添加的，则一开始肯定是没有大小的，因此有必要在这个方法中在进行reload操作
    if(self.delegate && !self.hadFirstSetFrame){
        if(self.bounds.size.width > 0 && self.bounds.size.height > 0){
            self.hadFirstSetFrame = true;
            [self reloadData];
        }
    }
}


///通知处理

- (void)verticleScrollDidEenterBackground
{
    [self clearTimer];
}

- (void)verticleScrollDidEenterForground
{
    if(self.canAutoScoll){
        [self createTimer];
    }
}

- (void)dealloc
{
    NSLog(@"TLVerticalScrollView销毁了");
}



@end
