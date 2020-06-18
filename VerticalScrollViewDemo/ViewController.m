//
//  ViewController.m
//  VerticalScrollViewDemo
//
//  Created by goviewtech on 2020/6/18.
//  Copyright © 2020 goviewtech. All rights reserved.
//

#import "ViewController.h"
#import "TLVerticalScrollView.h"

#import "UIView+AutoLayout.h"

@interface TLVerticalScrollDemoData : NSObject

@property (nonatomic,copy)NSString *title;

@end

@implementation TLVerticalScrollDemoData


@end




@interface ViewController ()<TLVerticalScrollViewDelegate>

@property (nonatomic,strong)NSArray *dataArray;

@property (nonatomic,weak)TLVerticalScrollView *scrollView;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor greenColor];
    
    ///这里只展示用约束的形式添加scrollView
    ///当然也可以通过设置frame的形式添加
    
    //TLVerticalScrollView *scrollView = [[TLVerticalScrollView alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 100)];
    TLVerticalScrollView *scrollView = [[TLVerticalScrollView alloc]init];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
    [scrollView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:12];
    [scrollView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [scrollView autoSetDimension:ALDimensionHeight toSize:100];
    
    
    [self loadData];
    
}

- (void)loadData
{
    TLVerticalScrollDemoData *demo1 = [TLVerticalScrollDemoData new];
    demo1.title = @"哈哈哈哈哈哈";
    
    TLVerticalScrollDemoData *demo2 = [TLVerticalScrollDemoData new];
    demo2.title = @"啦啦啦啦哈哈哈哈";
    
    TLVerticalScrollDemoData *demo3 = [TLVerticalScrollDemoData new];
    demo3.title = @"呼呼呼呼呼呼呼";
    
    TLVerticalScrollDemoData *demo4 = [TLVerticalScrollDemoData new];
    demo4.title = @"可可可可可可可";
    
    TLVerticalScrollDemoData *demo5 = [TLVerticalScrollDemoData new];
    demo5.title = @"乐乐乐乐乐乐乐乐";
    self.dataArray = @[demo1,demo2,demo3,demo4,demo5];
    [self.scrollView reloadData];
}

#pragma mark - TLVerticalScrollViewDelegate

/**item的总个数*/
- (NSInteger)scrollTotalItemCount:(TLVerticalScrollView*)scrollView
{
    return self.dataArray.count;
}

/**
 初始化位置显示的item
 */
- (TLVerticalScrollItem*)scrollViewItemView:(TLVerticalScrollView*)scrollView
{
    TLVerticalScrollItem *itemView = [[TLVerticalScrollItem alloc]init];
    return itemView;
}

/**
 每个需要展现的数据，在这个代理中完成
 */
- (void)scrollView:(TLVerticalScrollView*)scrollView itemView:(TLVerticalScrollItem*)itemView index:(NSInteger)index
{
    TLVerticalScrollDemoData *demoData = self.dataArray[index];
    itemView.textLabel.text = demoData.title;
}


@end
