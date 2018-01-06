//
//  AdvertView.m
//  baba88
//
//  Created by JCAI on 15/7/20.
//  Copyright (c) 2015年 BABA88. All rights reserved.
//

#import "AdvertView.h"
#import "YLDSadvertisementModel.h"
#import "UIImageView+AFNetworking.h"
#import "HttpClient.h"
#import "UIDefines.h"
@interface AdvertView () <UIScrollViewDelegate>

@property (nonatomic,  strong) UIScrollView *scrollView;
@property (nonatomic,  strong) UIPageControl *pageController;
@property (nonatomic,  strong) NSTimer *timer;
@property (nonatomic,  strong) NSArray *messageAry;
@end


@implementation AdvertView

@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize pageController = _pageController;
@synthesize timer = _timer;


- (void)dealloc
{
    self.delegate = nil;
    self.scrollView = nil;
    self.pageController = nil;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame=CGRectMake(0, 0, kWidth, 0.368*kWidth);
        self.frame=frame;
        
        CGRect scrollFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        scrollView.showsVerticalScrollIndicator=NO;
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.delegate = self;
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setBounces:NO];
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
        [scrollView setBackgroundColor:BGColor];
        CGRect pageFrame = CGRectMake(0, scrollFrame.size.height-20, self.frame.size.width, 20);
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:pageFrame];
        [pageController setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.0 ]];
        [self addSubview:pageController];
        pageController.currentPageIndicatorTintColor = NavColor;
        
        pageController.pageIndicatorTintColor = BGColor;
        self.pageController = pageController;

    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setBackgroundColor:[UIColor greenColor]];
        
        CGRect scrollFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        scrollView.showsVerticalScrollIndicator=NO;
        scrollView.showsHorizontalScrollIndicator=NO;
        scrollView.delegate = self;
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setBounces:NO];
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
        [scrollView setBackgroundColor:BGColor];
        CGRect pageFrame = CGRectMake(0, scrollFrame.size.height-20, self.frame.size.width, 20);
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:pageFrame];
        [pageController setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.0 ]];
        [self addSubview:pageController];
        pageController.currentPageIndicatorTintColor = NavColor;
        
        pageController.pageIndicatorTintColor = BGColor;
        self.pageController = pageController;
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width;
    NSInteger offset = self.scrollView.contentOffset.x/viewWidth-1;
    self.pageController.currentPage = offset;
    if (self.scrollView.contentOffset.x >= (self.scrollView.contentSize.width-1.5*viewWidth)) {
        [self.scrollView setContentOffset:CGPointMake(viewWidth, 0)];
        self.pageController.currentPage = self.scrollView.contentOffset.x/viewWidth-1;
    }
    if (self.scrollView.contentOffset.x<=0.5*viewWidth) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-2*viewWidth, 0)];
        self.pageController.currentPage = scrollView.contentOffset.x/viewWidth-1;
    }
}

- (void)setAdInfoWithAry:(NSArray *)imageAry
{
    
//    NSArray *imageAry= @[@"bannelSmall1.jpg", @"bannelSmall2.jpg",@"bannelSmall3.jpg", @"bannelSmall4.jpg",@"bannelSmall5.png"];
    if (imageAry.count<=0) {
        
        imageAry=@[@"morenguanggaotu"];
    }
    self.messageAry = imageAry;
    [self.pageController setNumberOfPages:[imageAry count]];
    
    CGRect imageFrame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    imageFrame.origin = CGPointZero;
    UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    id models=imageAry[0];
    if ([models isKindOfClass:[YLDSadvertisementModel class]]) {
        [firstImageView setBackgroundColor:BGColor];
        YLDSadvertisementModel *model=[imageAry lastObject];
        [firstImageView setImageWithURL:[NSURL URLWithString:model.attachment] placeholderImage:[UIImage imageNamed:@"morenguanggaotu"]];
        
        [self.scrollView addSubview:firstImageView];
        imageFrame.origin.x += imageFrame.size.width;
        
        
        for (int i =0;  i<imageAry.count; i++) {
            YLDSadvertisementModel *model=imageAry[i];
            UIButton *button = [[UIButton alloc] initWithFrame:imageFrame];
            [button addTarget:self
                       action:@selector(buttonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
            //[button setTag:tag];
            [self.scrollView addSubview:button];
            [button setTag:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            [imageView setImageWithURL:[NSURL URLWithString:model.attachment] placeholderImage:[UIImage imageNamed:@"morenguanggaotu"]];
            [self.scrollView addSubview:imageView];
            
            imageFrame.origin.x += imageFrame.size.width;
            
        }
        
        UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        YLDSadvertisementModel *model2=[imageAry lastObject];
        [lastImageView setImageWithURL:[NSURL URLWithString:model2.attachment] placeholderImage:[UIImage imageNamed:@"morenguanggaotu"]];
        [self.scrollView addSubview:lastImageView];
  
    }else
    {
        [firstImageView setImage:[UIImage imageNamed:[imageAry firstObject]]];
        [self.scrollView addSubview:firstImageView];
        imageFrame.origin.x += imageFrame.size.width;
        
        
        for (int i =0;  i<imageAry.count; i++) {
            
           
      
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            [imageView setImage:[UIImage imageNamed:imageAry[i]]];
            [self.scrollView addSubview:imageView];
            
            imageFrame.origin.x += imageFrame.size.width;
            
        }
        
        UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        [lastImageView setImage:[UIImage imageNamed:[imageAry lastObject]]];
        [self.scrollView addSubview:lastImageView];
    }
    [self.scrollView setContentSize:CGSizeMake(imageFrame.size.width*([imageAry count]+2),
                                               0)];
    [self.scrollView setContentOffset:CGPointMake(imageFrame.size.width, 0)];
}

#pragma mark - 
#pragma mark -
- (void)changeTime
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSInteger page = self.pageController.numberOfPages;
    NSInteger currentPage = self.pageController.currentPage;
    CGPoint scrollOffset = self.scrollView.contentOffset;
    CGFloat scrollWidth = self.scrollView.frame.size.width;
    currentPage ++;
    scrollOffset.x = scrollWidth * (currentPage+1);
    
    if (currentPage >= page) {
        self.pageController.currentPage = 0;
        [self.scrollView setContentOffset:CGPointMake(scrollWidth, 0) animated:NO];
    }
    else {
        self.pageController.currentPage = currentPage;
        [self.scrollView setContentOffset:scrollOffset animated:YES];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                  target:self
                                                selector:@selector(changeTime)
                                                userInfo:nil
                                                 repeats:NO];
}


- (void)buttonClicked:(UIButton *)button
{
    NSInteger tag = button.tag;
        if ([self.delegate respondsToSelector:@selector(advertPush:)]) {
            if (tag<self.messageAry.count) {
                id model=self.messageAry[tag];
                if ([model isKindOfClass:[YLDSadvertisementModel class]]) {
                    YLDSadvertisementModel *modelz=self.messageAry[tag];
                    NSString *ttt;
                    if ([APPDELEGATE isNeedLogin]) {
                        ttt=@"0";
                    }else{
                        ttt=@"1";
                    }
                    HttpClient *adH=[HttpClient sharedADClient];
                    [adH adClickAcitionWithADuid:modelz.uid WithMemberUid:APPDELEGATE.userModel.access_id WithBrowsePage:nil WithBrowseUserType:ttt withiosClientId:APPDELEGATE.IDFVSTR Success:^(id responseObject) {
//                        [ToastView showTopToast:[responseObject objectForKey:@"msg"]];
                    } failure:^(NSError *error) {
                        
                    }];
                    [HTTPCLIENT adReadNumWithAdUid:modelz.uid Success:^(id responseObject) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
               
            }
           
            [self.delegate advertPush:tag];
        }
    
}


- (void)adStart
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3
                                                  target:self
                                                selector:@selector(changeTime)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)adStop
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
