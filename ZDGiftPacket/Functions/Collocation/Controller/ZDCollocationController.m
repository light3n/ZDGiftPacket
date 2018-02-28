//
//  ZDCollocationController.m
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/27.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import "ZDCollocationController.h"
#import "ZDCollocationDataTool.h"

#import "SPPhotoManager.h"
#import "SPAsset.h"

#import "TouchableImageView.h"
#import "AGQuadControlsSample.h"
#import "CropPathViewController.h"

@interface ZDCollocationController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropPathViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *workView;
@property (nonatomic, strong) UICollectionView *materialCollectionView;

// design
@property (nonatomic, weak) TouchableImageView *currentEditingView;
@property (nonatomic, weak) UIButton *currentSelectedStyleButton;
@property (nonatomic, weak) UIButton *currentSelectedElementTypeButton;

// data
@property (nonatomic, copy) NSArray *materialDataArray;

// for display
@property (weak, nonatomic) IBOutlet UIView *materialViewContainer;
@property (weak, nonatomic) IBOutlet UIView *horizontalLine;
@property (weak, nonatomic) IBOutlet UIStackView *elementTypeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialCollectionViewBottomConstraint;

@end

@implementation ZDCollocationController

static NSString *cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.materialDataArray = [ZDCollocationDataTool getCollocationData:@"窗帘"];
    
    [self.materialCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    for (UIButton *elementTypeButton in self.elementTypeView.subviews) {
        if ([elementTypeButton.currentTitle isEqualToString:@"窗帘"]) {
            elementTypeButton.selected = YES;
            self.currentSelectedElementTypeButton = elementTypeButton;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.materialDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    UIImageView *imageView = [cell.contentView viewWithTag:520];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.tag = 520;
        imageView.frame = cell.contentView.bounds;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageView];
    }
    if (indexPath.item < self.materialDataArray.count) {
        imageView.image = UIImageMake(self.materialDataArray[indexPath.item]);
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = UIImageMake(self.materialDataArray[indexPath.item]);
    NSInteger scale = [UIScreen mainScreen].scale;
    CGFloat imageWidth = image.size.width/scale;
    CGFloat imageHeight = image.size.height/scale;
    if (imageWidth > 250) {
        imageHeight = imageHeight * 250 / imageWidth;
        imageWidth = 250;
    } else if (imageWidth < 150) {
        imageHeight = imageHeight * 150 / imageWidth;
        imageWidth = 150;
    }
    TouchableImageView* touchableImage = [[TouchableImageView alloc] init];
    if ([self.currentSelectedElementTypeButton.currentTitle isEqualToString:@"窗帘"]) {
        touchableImage.frame = CGRectMake(60, 60, imageWidth, imageHeight);
    } else {
        touchableImage.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        touchableImage.center = self.workView.center;
    }
    
    touchableImage.image = image;
    [self.workView addSubview:touchableImage];
    self.currentEditingView = touchableImage;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchableImageViewTapGesture:)];
    [touchableImage addGestureRecognizer:tapGes];
    
}

#pragma mark - touchableImageView tap Gesture handler

- (void)handleTouchableImageViewTapGesture:(UITapGestureRecognizer *)recognizer {
    TouchableImageView *imageView = (TouchableImageView *)recognizer.view;
    [imageView removeFromSuperview];
    [self.workView addSubview:imageView];
    self.currentEditingView = imageView;
}


#pragma mark - Handle Button Event

// function event

- (IBAction)handleBackButtonEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handleSaveButtonEvent:(id)sender {
    
}


- (IBAction)handleAddElementButtonEvent:(UIButton *)sender {
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCon addAction:cameraAction];
    [alertCon addAction:photoLibraryAction];
    [alertCon addAction:cancelAction];
    
    [alertCon setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [alertCon popoverPresentationController];
    popPresenter.sourceView = sender;
    popPresenter.sourceRect = sender.bounds;
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (IBAction)handleDIYButtonEvent:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        self.horizontalLine.hidden = NO;
        self.elementTypeView.hidden = NO;
        self.materialCollectionViewBottomConstraint.constant = 58;
    } else {
        self.horizontalLine.hidden = YES;
        self.elementTypeView.hidden = YES;
        self.materialCollectionViewBottomConstraint.constant = 0;
    }
}

// design event

- (IBAction)handleDeleteButtonEvent:(id)sender {
    if (self.currentEditingView) {
        [self.currentEditingView removeFromSuperview];
    } else if (self.workView.subviews.count > 1) {
        [[self.workView.subviews lastObject] removeFromSuperview];
    }
}

- (IBAction)handleStyleButtonEvent:(UIButton *)sender {
    if (self.currentSelectedStyleButton != sender) {
        self.currentSelectedStyleButton.selected = NO;
        sender.selected = YES;
        self.currentSelectedStyleButton = sender;
    }
}

- (IBAction)handleElementTypeButtonEvent:(UIButton *)sender {
    if (self.currentSelectedElementTypeButton != sender) {
        self.currentSelectedElementTypeButton.selected = NO;
        sender.selected = YES;
        self.currentSelectedElementTypeButton = sender;
    }
    self.materialDataArray = [ZDCollocationDataTool getCollocationData:sender.currentTitle];
    ReleaseSDWebImageCacheMemory;
    [self.materialCollectionView reloadData];
    [self.materialCollectionView setContentOffset:CGPointZero];
}


#pragma make - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    BezierPaths* tmpPath = nil;
    CropPathViewController *cropVC = [[CropPathViewController alloc] initWithNibName:@"CropPathViewController" bundle:nil];
    cropVC.bezierPath = tmpPath;
    cropVC.orgImage = image;
    cropVC.delegate = self;
    [self.navigationController pushViewController:cropVC animated:YES];
}


#pragma make - CropPathViewControllerDelegate

- (void)finishedSelectionCropImage:(UIImage*)image withController:(CropPathViewController*)controller {
    [SVProgressHUD showWithStatus:@"正在保存..."];
    PMSaveImageToAlbum(image, @"软装搭配素材图", ^(SPAsset *asset, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
        [self dismiss];
    });
}

- (UICollectionView *)materialCollectionView {
    if (!_materialCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(80, 80);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self.materialViewContainer addSubview:collectionView];
        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.materialViewContainer.mas_left).offset(50);
            make.right.equalTo(self.materialViewContainer.mas_right).offset(-50);
            make.top.equalTo(self.materialViewContainer.mas_top);
            make.bottom.equalTo(self.materialViewContainer.mas_bottom);
        }];
        _materialCollectionView = collectionView;
    }
    return _materialCollectionView;
}

@end
