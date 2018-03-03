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
@property (nonatomic, weak) NSString *currentSelectedStyle;
@property (nonatomic, weak) UIButton *currentSelectedStyleButton;
@property (nonatomic, weak) UIButton *currentSelectedElementTypeButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *logoButton;

// data
@property (nonatomic, copy) NSArray *materialDataArray;

// for display
@property (weak, nonatomic) IBOutlet UIView *materialViewContainer;
@property (weak, nonatomic) IBOutlet UIView *horizontalLine;
@property (weak, nonatomic) IBOutlet UIStackView *elementTypeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialCollectionViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoButtonHeightConstraint;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation ZDCollocationController

static NSString *cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.materialCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self loadCustomMaterials];
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
        if ([[self.materialDataArray firstObject] isKindOfClass:[NSString class]]) {
            imageView.image = UIImageMake(self.materialDataArray[indexPath.item]);
        } else {
            SPAsset *asset = self.materialDataArray[indexPath.item];
            imageView.image = [asset thumbnailWithSize:cell.contentView.frame.size];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TouchableImageView* touchableImage = [[TouchableImageView alloc] init];
    
    UIImage *image;
    if ([[self.materialDataArray firstObject] isKindOfClass:[NSString class]]) {
        image = UIImageMake(self.materialDataArray[indexPath.item]);
    } else {
        SPAsset *asset = self.materialDataArray[indexPath.item];
        image = [asset originImage];
    }
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
    if ([self.currentSelectedElementTypeButton.currentTitle isEqualToString:@"窗帘"]) {
        touchableImage.frame = CGRectMake(60, 60, imageWidth, imageHeight);
    } else {
        touchableImage.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        touchableImage.center = self.workView.center;
    }
    
    touchableImage.image = image;
    [self.workView insertSubview:touchableImage belowSubview:self.logoButton];
    self.currentEditingView = touchableImage;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchableImageViewTapGesture:)];
    [touchableImage addGestureRecognizer:tapGes];
    
}

#pragma mark - touchableImageView tap Gesture handler

- (void)handleTouchableImageViewTapGesture:(UITapGestureRecognizer *)recognizer {
    TouchableImageView *imageView = (TouchableImageView *)recognizer.view;
    [imageView removeFromSuperview];
    [self.workView insertSubview:imageView belowSubview:self.logoButton];
    self.currentEditingView = imageView;
}


#pragma mark - Handle Button Event

// function event

- (IBAction)handleBackButtonEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handleFlipButtonEvent:(id)sender {
    self.currentEditingView.transform = CGAffineTransformMakeScale(self.currentEditingView.fliped, 1);
    self.currentEditingView.fliped = -self.currentEditingView.fliped;
}

- (IBAction)handleDeleteButtonEvent:(id)sender {
    if (self.currentEditingView) {
        [self.currentEditingView removeFromSuperview];
    } else if (self.workView.subviews.count > 2) {
        // except bgImageView and logoButton
        [[self.workView.subviews objectAtIndex:self.workView.subviews.count-2] removeFromSuperview];
    }
}

- (IBAction)handleSaveButtonEvent:(id)sender {
    UIImage *finalDesignImage = [UIView snapshot:self.workView];
    [SVProgressHUD showWithStatus:@"正在保存..."];
    PMSaveImageToAlbum(finalDesignImage, @"软装搭配效果图", ^(SPAsset *asset, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    });
}

- (IBAction)handleLogoButtonEvent:(UIButton *)sender {
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"替换为LOGO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            self.imagePicker = imagePicker;
        }];
        
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            self.imagePicker = imagePicker;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addAction:cameraAction];
        [alertCon addAction:photoLibraryAction];
        [alertCon addAction:cancelAction];
        [self presentViewController:alertCon animated:YES completion:nil];
    }];
    
    UIAlertAction *telAction = [UIAlertAction actionWithTitle:@"替换为文字" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"请输入您想要的文字" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = self.logoButton.currentTitle;
        }];
        UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *text = alertCon.textFields.firstObject.text;
            [self.logoButton setImage:nil forState:UIControlStateNormal];
            [self.logoButton setTitle:text forState:UIControlStateNormal];
            CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : self.logoButton.titleLabel.font}];
            self.logoButtonWidthConstraint.constant = size.width+20;
            self.logoButtonHeightConstraint.constant = size.height;
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCon addAction:cancelAct];
        [alertCon addAction:confirmAct];
        [self presentViewController:alertCon animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"更换LOGO或联系方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCon addAction:photoAction];
    [alertCon addAction:telAction];
    [alertCon addAction:cancelAction];
    
    [alertCon setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [alertCon popoverPresentationController];
    popPresenter.sourceView = sender;
    popPresenter.sourceRect = sender.bounds;
    [self presentViewController:alertCon animated:YES completion:nil];
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
        
        if (!self.currentSelectedElementTypeButton) {
            for (UIButton *elementTypeButton in self.elementTypeView.subviews) {
                if ([elementTypeButton.currentTitle isEqualToString:@"窗帘"]) {
                    elementTypeButton.selected = YES;
                    self.currentSelectedElementTypeButton = elementTypeButton;
                }
            }
        }
        [self loadCollocationMaterials];
    } else {
        self.horizontalLine.hidden = YES;
        self.elementTypeView.hidden = YES;
        self.materialCollectionViewBottomConstraint.constant = 0;
        [self loadCustomMaterials];
    }
}

// menu control

- (IBAction)handleStyleButtonEvent:(UIButton *)sender {
    if (self.currentSelectedStyleButton != sender) {
        self.currentSelectedStyleButton.selected = NO;
        sender.selected = YES;
        self.currentSelectedStyleButton = sender;
    }
    NSArray *styleArray = [ZDCollocationDataTool getStyleMenu:sender.currentTitle];
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选取风格" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *style in styleArray) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:style style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // remove all additional materials
            for (UIView *subview in self.workView.subviews) {
                if (subview != [self.workView.subviews firstObject] && subview != self.logoButton) {
                    [subview removeFromSuperview];
                }
            }
            [self addAssociateStyleMaterial:style];
        }];
        [alertCon addAction:action];
    }
    [alertCon setModalPresentationStyle:UIModalPresentationPopover];
    UIPopoverPresentationController *popPresenter = [alertCon popoverPresentationController];
    popPresenter.sourceView = sender;
    popPresenter.sourceRect = sender.bounds;
    [self presentViewController:alertCon animated:YES completion:nil];
    
}

- (IBAction)handleElementTypeButtonEvent:(UIButton *)sender {
    if (self.currentSelectedElementTypeButton != sender) {
        self.currentSelectedElementTypeButton.selected = NO;
        sender.selected = YES;
        self.currentSelectedElementTypeButton = sender;
    }
    [self loadCollocationMaterials];
}


#pragma make - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 更换logo
    if (picker == self.imagePicker) {
        [self.logoButton setTitle:@"" forState:UIControlStateNormal];
        [self.logoButton setImage:image forState:UIControlStateNormal];
        self.logoButtonWidthConstraint.constant = 100;
        self.logoButtonHeightConstraint.constant = image.size.height*100/image.size.width;
    } else { // 添加素材
        BezierPaths* tmpPath = nil;
        CropPathViewController *cropVC = [[CropPathViewController alloc] initWithNibName:@"CropPathViewController" bundle:nil];
        cropVC.bezierPath = tmpPath;
        cropVC.orgImage = image;
        cropVC.delegate = self;
        [self.navigationController pushViewController:cropVC animated:YES];
    }
}


#pragma make - CropPathViewControllerDelegate

- (void)finishedSelectionCropImage:(UIImage*)image withController:(CropPathViewController*)controller {
    [SVProgressHUD showWithStatus:@"正在保存..."];
    PMSaveImageToAlbum(image, CollocationMaterialAlbumName, ^(SPAsset *asset, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
        [self loadCustomMaterials];
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

#pragma mark - Custom Methods

- (void)loadCustomMaterials {
    [ZDCollocationDataTool getCustomMaterialData:^(NSArray<SPAsset *> *resultArr) {
        self.materialDataArray = resultArr;
        [self reloadMaterialCollectionView];
    }];
}

- (void)loadCollocationMaterials {
    self.materialDataArray = [ZDCollocationDataTool getCollocationData:self.currentSelectedElementTypeButton.currentTitle];
    [self reloadMaterialCollectionView];
}

- (void)reloadMaterialCollectionView {
    ReleaseSDWebImageCacheMemory;
    [self.materialCollectionView reloadData];
    [self.materialCollectionView setContentOffset:CGPointZero];
}

- (void)convenientAddTouchableImageView:(NSString *)imageName frame:(CGRect)frame {
    // 现代、欧式的切片坐标输入的时候是直接输入点坐标，而不是像素坐标，所以不需要除以2
    if (![imageName containsString:@"现代"] && ![imageName containsString:@"欧式"]) {
        frame = CGRectMake(frame.origin.x / 2, frame.origin.y / 2, frame.size.width / 2, frame.size.height / 2);
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    if (!path) {
        return; // 图片不存在直接return
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    TouchableImageView *imageView = [[TouchableImageView alloc] init];
    imageView.image = image;
    imageView.frame = frame;
    [self.workView insertSubview:imageView belowSubview:self.logoButton];
    self.currentEditingView = imageView;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchableImageViewTapGesture:)];
    [imageView addGestureRecognizer:tapGes];
}

- (void)addAssociateStyleMaterial:(NSString *)style {
    // 现代
    if ([style isEqualToString:@"现代客厅"]) {
        [self convenientAddTouchableImageView:@"现代客厅1_窗帘" frame:CGRectMake(32, 70, 294, 375)];
        [self convenientAddTouchableImageView:@"现代客厅1_装饰画" frame:CGRectMake(511, 112, 160, 138)];
        [self convenientAddTouchableImageView:@"现代客厅1_地毯" frame:CGRectMake(371, 356, 435, 105)];
        [self convenientAddTouchableImageView:@"现代客厅1_沙发组合" frame:CGRectMake(334, 260, 517, 179)];
    } else if ([style isEqualToString:@"现代简约客厅"]) {
        [self convenientAddTouchableImageView:@"现代简约客厅2_窗帘" frame:CGRectMake(48, 88, 280, 334)];
        [self convenientAddTouchableImageView:@"现代简约客厅2_装饰画组合" frame:CGRectMake(500, 171, 198, 78)];
        [self convenientAddTouchableImageView:@"现代简约客厅2_地毯4" frame:CGRectMake(330, 358, 522, 100)];
        [self convenientAddTouchableImageView:@"现代简约客厅2_沙发组合" frame:CGRectMake(340, 270, 495, 160)];
        [self convenientAddTouchableImageView:@"现代简约客厅2_吊灯" frame:CGRectMake(520, 55, 160, 110)];
    } else if ([style isEqualToString:@"现代餐厅"]) {
        [self convenientAddTouchableImageView:@"现代餐厅2_窗帘" frame:CGRectMake(46, 70, 260, 370)];
        [self convenientAddTouchableImageView:@"现代餐厅2_吊灯" frame:CGRectMake(559, 64, 72, 134)];
        [self convenientAddTouchableImageView:@"现代餐厅2_地毯" frame:CGRectMake(290, 350, 585, 92)];
        [self convenientAddTouchableImageView:@"现代餐厅2_橱柜" frame:CGRectMake(700, 117, 145, 256)];
        [self convenientAddTouchableImageView:@"现代餐厅2_餐桌组合" frame:CGRectMake(355, 190, 480, 255)];
    } else if ([style isEqualToString:@"现代书房"]) {
        [self convenientAddTouchableImageView:@"现代书房_窗帘" frame:CGRectMake(68, 70, 254, 390)];
        [self convenientAddTouchableImageView:@"现代书房_装饰画" frame:CGRectMake(500, 140, 133, 93)];
        [self convenientAddTouchableImageView:@"现代书房_地毯" frame:CGRectMake(335, 414, 500, 75)];
        [self convenientAddTouchableImageView:@"现代书房_书柜" frame:CGRectMake(683, 125, 168, 300)];
        [self convenientAddTouchableImageView:@"现代书房_书桌" frame:CGRectMake(435, 245, 277, 225)];
    } else if ([style isEqualToString:@"现代卧室"]) {
        [self convenientAddTouchableImageView:@"现代卧室_窗帘" frame:CGRectMake(23, 70, 294, 375)];
        [self convenientAddTouchableImageView:@"现代卧室_灯" frame:CGRectMake(541, 96, 160, 111)];
        [self convenientAddTouchableImageView:@"现代卧室_地毯" frame:CGRectMake(359, 342, 520, 120)];
        [self convenientAddTouchableImageView:@"现代卧室_床品" frame:CGRectMake(314, 240, 494, 216)];
    }
    
    // 欧式
    if ([style isEqualToString:@"欧式客厅1"]) {
        [self convenientAddTouchableImageView:@"欧式客厅1_窗帘" frame:CGRectMake(30, 50, 294, 354)];
        [self convenientAddTouchableImageView:@"欧式客厅1_画" frame:CGRectMake(521, 162, 144, 93)];
        [self convenientAddTouchableImageView:@"欧式客厅1_灯" frame:CGRectMake(533, 63, 122, 111)];
        [self convenientAddTouchableImageView:@"欧式客厅1_地毯" frame:CGRectMake(335, 366, 524, 97)];
        [self convenientAddTouchableImageView:@"欧式客厅1_沙发组合" frame:CGRectMake(304, 250, 572, 187)];
    } else if ([style isEqualToString:@"欧式客厅2"]) {
        [self convenientAddTouchableImageView:@"欧式客厅2_窗帘" frame:CGRectMake(30, 50, 265, 375)];
        [self convenientAddTouchableImageView:@"欧式客厅2_装饰画" frame:CGRectMake(521, 171, 140, 75)];
        [self convenientAddTouchableImageView:@"欧式客厅2_吊灯" frame:CGRectMake(537, 61, 111, 117)];
        [self convenientAddTouchableImageView:@"欧式客厅2_地毯" frame:CGRectMake(325, 368, 557, 105)];
        [self convenientAddTouchableImageView:@"欧式客厅2_沙发组合" frame:CGRectMake(297, 233, 572, 232)];
    } else if ([style isEqualToString:@"欧式客厅3"]) {
        [self convenientAddTouchableImageView:@"欧式客厅3_窗帘" frame:CGRectMake(30, 50, 265, 375)];
        [self convenientAddTouchableImageView:@"欧式客厅3_装饰画" frame:CGRectMake(521, 150, 140, 106)];
        [self convenientAddTouchableImageView:@"欧式客厅3_吊灯" frame:CGRectMake(537, 50, 111, 117)];
        [self convenientAddTouchableImageView:@"欧式客厅3_地毯" frame:CGRectMake(325, 368, 557, 105)];
        [self convenientAddTouchableImageView:@"欧式客厅3_沙发组合" frame:CGRectMake(297, 115, 572, 330)];
    } else if ([style isEqualToString:@"欧式客厅4"]) {
        [self convenientAddTouchableImageView:@"欧式客厅4_窗帘" frame:CGRectMake(30, 50, 255, 400)];
        [self convenientAddTouchableImageView:@"欧式客厅4_吊灯" frame:CGRectMake(537, 50, 135, 178)];
        [self convenientAddTouchableImageView:@"欧式客厅4_地毯" frame:CGRectMake(320, 377, 535, 105)];
        [self convenientAddTouchableImageView:@"欧式客厅4_沙发组合" frame:CGRectMake(315, 250, 541, 200)];
    } else if ([style isEqualToString:@"欧式餐厅1"]) {
        [self convenientAddTouchableImageView:@"欧式餐厅1_窗帘" frame:CGRectMake(30, 50, 270, 420)];
        [self convenientAddTouchableImageView:@"欧式餐厅1_吊灯" frame:CGRectMake(535, 35, 132, 137)];
        [self convenientAddTouchableImageView:@"欧式餐厅1_地毯" frame:CGRectMake(308, 380, 575, 92)];
        [self convenientAddTouchableImageView:@"欧式餐厅1_柜子" frame:CGRectMake(317, 108, 157, 290)];
        [self convenientAddTouchableImageView:@"欧式餐厅1_餐桌" frame:CGRectMake(390, 213, 426, 270)];
    } else if ([style isEqualToString:@"欧式餐厅2"]) {
        [self convenientAddTouchableImageView:@"欧式餐厅2_窗帘" frame:CGRectMake(30, 50, 267, 370)];
        [self convenientAddTouchableImageView:@"欧式餐厅2_装饰画" frame:CGRectMake(559, 64, 132, 134)];
        [self convenientAddTouchableImageView:@"欧式餐厅2_地毯" frame:CGRectMake(320, 350, 575, 92)];
        [self convenientAddTouchableImageView:@"欧式餐厅2_书柜" frame:CGRectMake(707, 139, 140, 250)];
        [self convenientAddTouchableImageView:@"欧式餐厅2_书桌组合" frame:CGRectMake(330, 190, 480, 275)];
    } else if ([style isEqualToString:@"欧式书房"]) {
        [self convenientAddTouchableImageView:@"欧式书房_窗帘" frame:CGRectMake(30, 50, 267, 370)];
        [self convenientAddTouchableImageView:@"欧式书房_装饰画" frame:CGRectMake(544, 140, 77, 77)];
        [self convenientAddTouchableImageView:@"欧式书房_地毯" frame:CGRectMake(325, 386, 522, 86)];
        [self convenientAddTouchableImageView:@"欧式书房_书柜" frame:CGRectMake(650, 145, 221, 265)];
        [self convenientAddTouchableImageView:@"欧式书房_书桌组合" frame:CGRectMake(307, 225, 425, 250)];
    } else if ([style isEqualToString:@"欧式卧室"]) {
        [self convenientAddTouchableImageView:@"欧式卧室1_窗帘" frame:CGRectMake(30, 50, 245, 375)];
        [self convenientAddTouchableImageView:@"欧式卧室1_吊灯" frame:CGRectMake(507, 73, 80, 111)];
        [self convenientAddTouchableImageView:@"欧式卧室1_地毯" frame:CGRectMake(283, 366, 557, 100)];
        [self convenientAddTouchableImageView:@"欧式卧室1_床品组合" frame:CGRectMake(375, 208, 340, 240)];
        [self convenientAddTouchableImageView:@"欧式卧室1_梳妆台" frame:CGRectMake(725, 228, 150, 200)];
    }
    
    // 中式
    if ([style isEqualToString:@"中式客厅1"]) {
        [self convenientAddTouchableImageView:@"中式客厅1_窗帘" frame:CGRectMake(74, 144, 472, 756)];
        [self convenientAddTouchableImageView:@"中式客厅1_装饰" frame:CGRectMake(1016, 304, 264, 214)];
        [self convenientAddTouchableImageView:@"中式客厅1_地毯" frame:CGRectMake(585, 775, 1108, 212)];
        [self convenientAddTouchableImageView:@"中式客厅1_沙发" frame:CGRectMake(590, 445, 1162, 498)];
    } else if ([style isEqualToString:@"中式客厅2"]) {
        [self convenientAddTouchableImageView:@"中式客厅2_窗帘" frame:CGRectMake(30, 204, 502, 684)];
        [self convenientAddTouchableImageView:@"中式客厅2_地毯" frame:CGRectMake(666, 736, 1052, 191)];
        [self convenientAddTouchableImageView:@"中式客厅2_柜子" frame:CGRectMake(796, 266, 763, 483)];
        [self convenientAddTouchableImageView:@"中式客厅2_吊灯" frame:CGRectMake(1016, 162, 307, 140)];
        [self convenientAddTouchableImageView:@"中式客厅2_沙发组合" frame:CGRectMake(546, 516, 1204, 438)];
    } else if ([style isEqualToString:@"中式客厅3"]) {
        [self convenientAddTouchableImageView:@"中式客厅3_窗帘" frame:CGRectMake(44, 142, 538, 714)];
        [self convenientAddTouchableImageView:@"中式客厅3_吊灯" frame:CGRectMake(1029, 162, 264, 232)];
        [self convenientAddTouchableImageView:@"中式客厅3_地毯" frame:CGRectMake(588, 720, 1132, 286)];
        [self convenientAddTouchableImageView:@"中式客厅3_沙发组合" frame:CGRectMake(592, 280, 1164, 616)];
    } else if  ([style isEqualToString:@"中式餐厅1"]) {
        [self convenientAddTouchableImageView:@"中式餐厅1_窗帘" frame:CGRectMake(56, 120, 554, 799)];
        [self convenientAddTouchableImageView:@"中式餐厅1_吊灯" frame:CGRectMake(1056, 164, 156, 272)];
        [self convenientAddTouchableImageView:@"中式餐厅1_柜子组合" frame:CGRectMake(1252, 258, 484, 544)];
        [self convenientAddTouchableImageView:@"中式餐厅1_餐台组合" frame:CGRectMake(680, 552, 904, 388)];
    } else if ([style isEqualToString:@"中式餐厅2"]) {
        [self convenientAddTouchableImageView:@"中式餐厅3_窗帘" frame:CGRectMake(35, 148, 524, 726)];
        [self convenientAddTouchableImageView:@"中式餐厅3_吊灯" frame:CGRectMake(982, 124, 242, 256)];
        [self convenientAddTouchableImageView:@"中式餐厅3_柜子组合" frame:CGRectMake(956, 251, 788, 540)];
        [self convenientAddTouchableImageView:@"中式餐厅3_餐桌组合" frame:CGRectMake(540, 440, 1218, 488)];
    } else if ([style isEqualToString:@"中式书房"]) {
        [self convenientAddTouchableImageView:@"中式书房1_窗帘" frame:CGRectMake(68, 168, 548, 776)];
        [self convenientAddTouchableImageView:@"中式书房1_装饰画" frame:CGRectMake(950, 358, 268, 128)];
        [self convenientAddTouchableImageView:@"中式书房1_地毯" frame:CGRectMake(548, 828, 1060, 154)];
        [self convenientAddTouchableImageView:@"中式书房1_书柜" frame:CGRectMake(1286, 322, 414, 466)];
        [self convenientAddTouchableImageView:@"中式书房1_书桌组合" frame:CGRectMake(736, 498, 710, 436)];
    } else if ([style isEqualToString:@"中式卧室"]) {
        [self convenientAddTouchableImageView:@"中式卧室1_窗帘" frame:CGRectMake(92, 165, 506, 722)];
        [self convenientAddTouchableImageView:@"中式卧室1_吊灯" frame:CGRectMake(1028, 128, 136, 230)];
        [self convenientAddTouchableImageView:@"中式卧室1_地毯" frame:CGRectMake(652, 704, 1030, 222)];
        [self convenientAddTouchableImageView:@"中式卧室1_床品组合" frame:CGRectMake(718, 332, 1000, 552)];
    }
    
    // 美式
    if ([style isEqualToString:@"美式客厅1"]) {
        [self convenientAddTouchableImageView:@"美式客厅1_窗帘" frame:CGRectMake(56, 110, 530, 744)];
        [self convenientAddTouchableImageView:@"美式客厅1_装饰" frame:CGRectMake(1014, 282, 316, 198)];
        [self convenientAddTouchableImageView:@"美式客厅1_吊灯" frame:CGRectMake(992, 80, 342, 252)];
        [self convenientAddTouchableImageView:@"美式客厅1_地毯" frame:CGRectMake(638, 740, 1024, 192)];
        [self convenientAddTouchableImageView:@"美式客厅1_沙发组合" frame:CGRectMake(594, 466, 1124, 524)];
    } else if ([style isEqualToString:@"美式客厅2"]) {
        [self convenientAddTouchableImageView:@"美式客厅3_窗帘" frame:CGRectMake(62, 102, 557, 812)];
        [self convenientAddTouchableImageView:@"美式客厅3_装饰画" frame:CGRectMake(1034, 256, 298, 170)];
        [self convenientAddTouchableImageView:@"美式客厅3_地毯" frame:CGRectMake(670, 728, 1046, 198)];
        [self convenientAddTouchableImageView:@"美式客厅3_沙发组合" frame:CGRectMake(662, 462, 1084, 446)];
    } else if ([style isEqualToString:@"美式餐厅"]) {
        [self convenientAddTouchableImageView:@"美式餐厅1_窗帘" frame:CGRectMake(142, 194, 478, 724)];
        [self convenientAddTouchableImageView:@"美式餐厅1_灯饰" frame:CGRectMake(1020, 168, 296, 236)];
        [self convenientAddTouchableImageView:@"美式餐厅1_地毯" frame:CGRectMake(676, 812, 940, 176)];
        [self convenientAddTouchableImageView:@"美式餐厅1_橱柜" frame:CGRectMake(1392, 274, 310, 544)];
        [self convenientAddTouchableImageView:@"美式餐厅1_餐桌" frame:CGRectMake(834, 524, 656, 404)];
    } else if ([style isEqualToString:@"美式书房"]) {
        [self convenientAddTouchableImageView:@"美式书房_窗帘" frame:CGRectMake(64, 98, 570, 782)];
        [self convenientAddTouchableImageView:@"美式书房_装饰画" frame:CGRectMake(844, 276, 136, 168)];
        [self convenientAddTouchableImageView:@"美式书房_地毯" frame:CGRectMake(588, 768, 974, 224)];
        [self convenientAddTouchableImageView:@"美式书房_柜子" frame:CGRectMake(642, 480, 356, 306)];
        [self convenientAddTouchableImageView:@"美式书房_书柜" frame:CGRectMake(1266, 240, 446, 532)];
        [self convenientAddTouchableImageView:@"美式书房_书桌组合" frame:CGRectMake(880, 500, 564, 429)];
    } else if ([style isEqualToString:@"美式卧室"]) {
        [self convenientAddTouchableImageView:@"美式卧室1_窗帘" frame:CGRectMake(56, 120, 552, 746)];
        [self convenientAddTouchableImageView:@"美式卧室1_吊灯" frame:CGRectMake(896, 166, 170, 196)];
        [self convenientAddTouchableImageView:@"美式卧室1_地毯" frame:CGRectMake(679, 638, 932, 242)];
        [self convenientAddTouchableImageView:@"美式卧室1_床" frame:CGRectMake(670, 376, 754, 462)];
        [self convenientAddTouchableImageView:@"美式卧室1_梳妆台" frame:CGRectMake(1430, 330, 314, 456)];
    }
    
    // 田园
    if ([style isEqualToString:@"田园客厅1"]) {
        [self convenientAddTouchableImageView:@"田园客厅2_窗帘" frame:CGRectMake(80, 150, 510, 752)];
        [self convenientAddTouchableImageView:@"田园客厅2_装饰画" frame:CGRectMake(994, 326, 402, 140)];
        [self convenientAddTouchableImageView:@"田园客厅2_地毯" frame:CGRectMake(672, 760, 1050, 190)];
        [self convenientAddTouchableImageView:@"田园客厅2_沙发组合" frame:CGRectMake(606, 496, 1108, 440)];
    } else if ([style isEqualToString:@"田园客厅2"]) {
        [self convenientAddTouchableImageView:@"田园客厅3_窗帘" frame:CGRectMake(82, 154, 554, 768)];
        [self convenientAddTouchableImageView:@"田园客厅3_装饰画" frame:CGRectMake(1076, 308, 216, 210)];
        [self convenientAddTouchableImageView:@"田园客厅3_吊灯" frame:CGRectMake(1088, 136, 202, 230)];
        [self convenientAddTouchableImageView:@"田园客厅3_地毯" frame:CGRectMake(680, 734, 1050, 200)];
        [self convenientAddTouchableImageView:@"田园客厅3_沙发组合" frame:CGRectMake(676, 530, 1068, 374)];
    } else if ([style isEqualToString:@"田园餐厅"]) {
        [self convenientAddTouchableImageView:@"田园餐厅1_窗帘" frame:CGRectMake(80, 100, 548, 810)];
        [self convenientAddTouchableImageView:@"田园餐厅1_装饰画" frame:CGRectMake(1052, 260, 250, 170)];
        [self convenientAddTouchableImageView:@"田园餐厅1_吊灯" frame:CGRectMake(1078, 52, 213, 254)];
        [self convenientAddTouchableImageView:@"田园餐厅1_地毯" frame:CGRectMake(618, 768, 1152, 182)];
        [self convenientAddTouchableImageView:@"田园餐厅1_柜子" frame:CGRectMake(1390, 218, 316, 548)];
        [self convenientAddTouchableImageView:@"田园餐厅1_餐桌" frame:CGRectMake(650, 460, 1079, 422)];
    } else if ([style isEqualToString:@"田园书房"]) {
        [self convenientAddTouchableImageView:@"田园书房1_窗帘" frame:CGRectMake(96, 134, 478, 744)];
        [self convenientAddTouchableImageView:@"田园书房1_装饰" frame:CGRectMake(994, 316, 258, 192)];
        [self convenientAddTouchableImageView:@"田园书房1_地毯" frame:CGRectMake(730, 844, 844, 160)];
        [self convenientAddTouchableImageView:@"田园书房1_单人椅" frame:CGRectMake(602, 682, 262, 298)];
        [self convenientAddTouchableImageView:@"田园书房1_书柜" frame:CGRectMake(1326, 338, 392, 512)];
        [self convenientAddTouchableImageView:@"田园书房1_书桌组合" frame:CGRectMake(862, 536, 580, 406)];
    } else if ([style isEqualToString:@"田园卧室1"]) {
        [self convenientAddTouchableImageView:@"田园卧室1_窗帘" frame:CGRectMake(38, 118, 590, 762)];
        [self convenientAddTouchableImageView:@"田园卧室1_吊灯" frame:CGRectMake(1047, 116, 298, 238)];
        [self convenientAddTouchableImageView:@"田园卧室1_地毯" frame:CGRectMake(696, 720, 1040, 192)];
        [self convenientAddTouchableImageView:@"田园卧室1_床品组合" frame:CGRectMake(650, 387, 900, 552)];
    } else if ([style isEqualToString:@"田园卧室2"]) {
        [self convenientAddTouchableImageView:@"田园卧室2_窗帘" frame:CGRectMake(76, 130, 582, 772)];
        [self convenientAddTouchableImageView:@"田园卧室2_吊灯" frame:CGRectMake(1032, 136, 202, 232)];
        [self convenientAddTouchableImageView:@"田园卧室2_地毯" frame:CGRectMake(590, 724, 1170, 100)];
        [self convenientAddTouchableImageView:@"田园卧室2_床品组合" frame:CGRectMake(768, 408, 950, 470)];
    }
}

@end
