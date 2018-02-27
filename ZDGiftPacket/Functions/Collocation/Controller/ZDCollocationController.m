//
//  ZDCollocationController.m
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/27.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import "ZDCollocationController.h"

#import "SPPhotoManager.h"
#import "SPAsset.h"

#import "AGQuadControlsSample.h"
#import "CropPathViewController.h"

@interface ZDCollocationController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropPathViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *workView;
@property (nonatomic, strong) UICollectionView *materialCollectionView;

@property (weak, nonatomic) IBOutlet UIView *materialViewContainer;
@property (weak, nonatomic) IBOutlet UIView *horizontalLine;
@property (weak, nonatomic) IBOutlet UIStackView *elementTypeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialCollectionViewBottomConstraint;

@end

@implementation ZDCollocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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

- (IBAction)handleDIYButtonEvent:(id)sender {
    
}

// design event

- (IBAction)handleDeleteButtonEvent:(id)sender {
    
}

- (IBAction)handleStyleButtonEvent:(id)sender {
    
}

- (IBAction)handleElementTypeButtonEvent:(id)sender {

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

-(void)finishedSelectionCropImage:(UIImage*)image withController:(CropPathViewController*)controller {
//    [self saveComponent:image];
    
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
        flowLayout.itemSize = CGSizeMake(100, 100);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor redColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self.materialViewContainer addSubview:collectionView];
        
        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 50, 0, -50));
//            make.left.equalTo(self.materialViewContainer.mas_left).offset(50);
//            make.right.equalTo(self.materialViewContainer.mas_right).offset(-50);
//            make.top.equalTo(self).offset(top);
//            make.height.mas_equalTo(height);
        }];
        _materialCollectionView = collectionView;
    }
    return _materialCollectionView;
}

@end
