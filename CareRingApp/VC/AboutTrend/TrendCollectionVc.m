//
//  TrendCollectionVc.m
//  CareRingApp
//
//  Created by 兰仲平 on 2022/10/13.
//

#import <DateTools/DateTools.h>
#import "TrendCollectionVc.h"
#import <Masonry/Masonry.h>
#import "TrendClcViewCell.h"
#import "TrendDrawObj.h"

@interface TrendCollectionVc ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(strong, nonatomic)UICollectionView *collecView;

@property(strong, nonatomic)NSMutableArray<TrendDrawObj *> *trendObjArray;

@end

@implementation TrendCollectionVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self collectionViewShowLast];

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
  
    [self collectionViewShowLast];

}

-(void)initData {
    
    NSInteger year = [NSDate date].year;
    self.trendObjArray = [TrendDrawObj objArrayWith:year DataType:self.trendVcType TimeType:self.timeType];
    [self.collecView reloadData];
//    [self collectionViewShowLast];
    self.collecView.delegate = self;
    self.collecView.dataSource = self;
    
}

-(void)initUI {
    [self.view addSubview:self.collecView];
    [self.collecView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.collecView.superview);
    }];
    
}


-(void)collectionViewShowLast {
    
    // 滑动到最后
    NSIndexPath *path = [NSIndexPath indexPathForItem:self.trendObjArray.count - 1 inSection:0];
    [self.collecView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
}


#pragma mark -- UICollectionViewDelegate + UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.trendObjArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collecView) {
        
        return CGSizeMake(self.collecView.bounds.size.width, self.collecView.bounds.size.height);
    }
    return CGSizeZero;
    
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TrendClcViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    
    cell.trendObj = self.trendObjArray[indexPath.row];
    
    return cell;
}

#pragma mark --lazy

-(UICollectionView *)collecView
{
    if (!_collecView) {
        //cllectionviews
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;

        UICollectionView *colecView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collecView = colecView;
        _collecView.backgroundColor = [UIColor clearColor];
        _collecView.showsVerticalScrollIndicator = false;
        _collecView.showsHorizontalScrollIndicator = false;
        _collecView.pagingEnabled = YES;
        [_collecView registerClass:[TrendClcViewCell class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
    }
    return _collecView;
}

@end
