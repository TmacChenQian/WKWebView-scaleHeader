//
//  HeadViewController.m
//  图片放大缩小
//
//  Created by 陈乾 on 16/9/5.
//  Copyright © 2016年 陈乾. All rights reserved.
//

#import "HeadViewController.h"
#import "HMObjcSugar.h"
#define reuserID @"cell"
#define KheadViewHeight 200
@interface HeadViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView             * _headView;
    UIView             * _lineView;
    UITableView        * _tableView;
    UIImageView        * _imageView;
    UIStatusBarStyle     _StatusBarStyle;

}

@end

@implementation HeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _StatusBarStyle = UIStatusBarStyleLightContent;
    //准备UI
    [self prepareUI];
    //准备头部
    [self prepareHeadView];
  
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
  
    return _StatusBarStyle;
}

-(void)prepareUI{
    
    //创建tableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //关闭这个就不会给我们自动调整20的高度了
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.contentInset = UIEdgeInsetsMake(KheadViewHeight, 0, 0, 0);
    //注册cell
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuserID];
    
    //设置滚动指示器的偏移
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(KheadViewHeight, 0, 0, 0);
    //添加
    [self.view addSubview:_tableView];

}

-(void)prepareHeadView{
    
    /*-------------head----------------*/
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.hm_width, KheadViewHeight)];
    _headView.backgroundColor = [UIColor hm_colorWithHex:0xF8F8F8];

    //创建效果
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //创建毛玻璃view
    UIVisualEffectView *Effectview = [[UIVisualEffectView alloc] initWithEffect:effect];
    //设置frame
    Effectview.frame = _headView.bounds;
    //添加
    [_headView addSubview:Effectview];
    [self.view addSubview:_headView];
    
    
    /*-------------图----------------*/
    _imageView = [[UIImageView alloc] initWithFrame:_headView.bounds];
    
    _imageView.image = [UIImage imageNamed:@"DSC_0089"];
    
    _imageView.clipsToBounds = YES;
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_headView addSubview:_imageView];
    
    /*-------------导航栏的线----------------*/
    
    CGFloat lineHeight = 1 / [UIScreen mainScreen].scale;
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, KheadViewHeight - lineHeight , _headView.hm_width, lineHeight)];
    _lineView.backgroundColor  = [UIColor lightGrayColor];
    [_headView addSubview:_lineView];

}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
  
    
    CGFloat offset = _tableView.contentOffset.y + _tableView.contentInset.top;
//    NSLog(@"%f",offset);
    
    if(offset <= 0){//放大
        
        _headView.hm_y = 0;
        _headView.hm_height = KheadViewHeight - offset;
        _imageView.hm_height = _headView.hm_height;
        _lineView.hm_y = KheadViewHeight - offset;
    
    }else{//原样不动的平移上去
    
        
        _headView.hm_height = KheadViewHeight;
        _imageView.hm_height = KheadViewHeight;
        
        CGFloat minY = KheadViewHeight - 64;
        _headView.hm_y = -MIN(minY, offset);
        
        NSLog(@"%f",minY/offset);
        
        _imageView.alpha = 1 - (offset/minY);
        
        _StatusBarStyle = (1 - (offset/minY) < 0.5) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        
        //更新导航栏的状态栏的颜色
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
        
    }
}



@end
