//
//  ZDPreviewTileEffectViewController.m
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/24.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import "ZDPreviewTileEffectViewController.h"
#import "SPImageCroperController.h"

@interface ZDPreviewTileEffectViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, SPImageCroperControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageHolderView;
@property (nonatomic, assign) BOOL hasImage;
@end

@implementation ZDPreviewTileEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hasImage = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleOpenFileEvent:(id)sender {
    
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
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"打开图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addAction:cameraAction];
    [alertCon addAction:photoLibraryAction];
    [alertCon addAction:cancelAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}

#pragma make - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    SPImageCroperController *vc = [[SPImageCroperController alloc] init];
    vc.originalImage = image;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - SPImageCroperControllerDelegate

- (void)imageCroperController:(SPImageCroperController *)viewController
        didFinishCropingImage:(UIImage *)image {
    self.imageHolderView.image = image;
    self.hasImage = YES;
    NSLog(@"invoke -imageCroperController:didFinishCropingImage:");
}

- (void)imageCroperControllerDidCancel:(SPImageCroperController *)viewController {
    NSLog(@"invoke -imageCroperControllerDidCancel:");
}


- (IBAction)handleSaveEvent:(id)sender {
    if (self.hasImage) {
        [SVProgressHUD showWithStatus:@"正在保存..."];
        PMSaveImageToAlbum(self.imageHolderView.image, @"墙纸平铺预览效果图", ^(SPAsset *asset, NSError *error) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            [self dismiss];
        });
    } else {
        [SVProgressHUD showErrorWithStatus:@"请先进行图片编辑！"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
