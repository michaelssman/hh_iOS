//
//  HHChapterViewController.m
//  HHChapterDemo
//
//  Created by Michael on 2019/8/6.
//  Copyright © 2019 michael. All rights reserved.
//

#import "HHChapterViewController.h"
#import "ChapterCornerView.h"
@interface HHChapterViewController ()

@end

@implementation HHChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ChapterCornerView *chapterV = [[ChapterCornerView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    __weak ChapterCornerView *weakChapter = chapterV;
    chapterV.chapterV.didSelectRow = ^(NSInteger index) {
//        [weakChapter hiddenAction];
    };
    [self.view addSubview:chapterV];
    [chapterV.chapterV setDataSource];
}

@end
