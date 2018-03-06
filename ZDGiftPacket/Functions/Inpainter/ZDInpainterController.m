//
//  ZDInpainterController.m
//  ZDGiftPacket
//
//  Created by Joey on 2018/2/24.
//  Copyright © 2018年 ZhiDao. All rights reserved.
//

#import "ZDInpainterController.h"
#import "SPImageInpainterController.h"

@interface ZDInpainterController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ZDInpainterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handlerOpenFileEvent:(id)sender {
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDirection" object:@"1"];
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDirection" object:@"1"];
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

- (IBAction)handleDemoButtonEvent:(id)sender {
    SPImageInpainterController *inpainter = [[SPImageInpainterController alloc] init];
    inpainter.sourceImage = UIImageMake(@"Inpainter_demo");
    [self.navigationController pushViewController:inpainter animated:YES];
}

#pragma make - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    SPImageInpainterController *inpainter = [[SPImageInpainterController alloc] init];
    inpainter.sourceImage = image;
    [self.navigationController pushViewController:inpainter animated:YES];
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
