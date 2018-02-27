//
//  ZDPanoramaDetailViewController.m
//  PanoramaDemo
//
//  Created by Joey on 2018/1/26.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import "ZDPanoramaDetailViewController.h"
#import "ZDPanoramaDisplayViewController.h"
#import "JAPanoView.h"
#import "SPPhotoManager.h"
#import "SPAsset.h"
#import "ZDPanoramaDataTool.h"

@interface ZDPanoramaDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *top;
@property (weak, nonatomic) IBOutlet UIButton *bottom;
@property (weak, nonatomic) IBOutlet UIButton *left;
@property (weak, nonatomic) IBOutlet UIButton *right;
@property (weak, nonatomic) IBOutlet UIButton *forward;
@property (weak, nonatomic) IBOutlet UIButton *backward;

@property (nonatomic, weak) UIButton *currentClickedBtn;
@property (nonatomic, strong) NSMutableDictionary *muteDataDict;
@end

@implementation ZDPanoramaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelEventHandler)]];
    UIBarButtonItem *trashButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonEventHandler:)];
    self.navigationItem.rightBarButtonItem = trashButtonItem;
    
    NSLog(@"-viewDidLoad:");
    if (self.muteDataDict.allKeys.count) {
        NSString *albumName = [self.muteDataDict objectForKey:@"title"];
        NSString *top = [self.muteDataDict objectForKey:@"top"];
        NSString *bottom = [self.muteDataDict objectForKey:@"bottom"];
        NSString *left = [self.muteDataDict objectForKey:@"left"];
        NSString *right = [self.muteDataDict objectForKey:@"right"];
        NSString *forward = [self.muteDataDict objectForKey:@"forward"];
        NSString *backward = [self.muteDataDict objectForKey:@"backward"];
        if (albumName && albumName.length) {
            self.titleLabel.text = albumName;
        }
        [self configureButton:self.top usingImageID:top];
        [self configureButton:self.bottom usingImageID:bottom];
        [self configureButton:self.left usingImageID:left];
        [self configureButton:self.right usingImageID:right];
        [self configureButton:self.forward usingImageID:forward];
        [self configureButton:self.backward usingImageID:backward];
    }
}

- (void)configureButton:(UIButton *)button usingImageID:(NSString *)identifier {
    SPPhotoManager *mgr = [SPPhotoManager defaultManager];
    if (identifier && identifier.length) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"点击修改图片" forState:UIControlStateNormal];
        [button setBackgroundImage:[mgr fetchImageWithLocalIdentifier:identifier]
                          forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"-viewWillAppear:");
}

- (NSMutableDictionary *)muteDataDict {
    if (!_muteDataDict) {
        _muteDataDict = [NSMutableDictionary dictionary];
    }
    return _muteDataDict;
}

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    NSLog(@"-setDataDict:");
    if (dataDict) {
        self.muteDataDict = [NSMutableDictionary dictionaryWithDictionary:dataDict];
    }
}

#pragma make - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.currentClickedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.currentClickedBtn setTitle:@"点击修改图片" forState:UIControlStateNormal];
    [self.currentClickedBtn setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - Event Handler

- (void)titleLabelEventHandler {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"请输入标题" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"textField.text = %@", textField.text);
    }];
    UIAlertAction *confirmAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.titleLabel.text = alertCon.textFields.firstObject.text;
    }];
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:cancelAct];
    [alertCon addAction:confirmAct];
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (IBAction)imageButtonEventHandler:(UIButton *)sender {
    self.currentClickedBtn = sender;
    
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
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addAction:cameraAction];
    [alertCon addAction:photoLibraryAction];
    [alertCon addAction:cancelAction];
    
    [self presentViewController:alertCon animated:YES completion:nil];
    
}


- (IBAction)previewButtonEventHandler:(id)sender {
    if (!self.forward.currentBackgroundImage
        || !self.right.currentBackgroundImage
        || !self.backward.currentBackgroundImage
        || !self.left.currentBackgroundImage
        || !self.top.currentBackgroundImage
        || !self.bottom.currentBackgroundImage) {
        NSLog(@"请设置所有方位图片！");
        return;
    }
    ZDPanoramaDisplayViewController *vc = [[ZDPanoramaDisplayViewController alloc] init];
    [vc.panoView setFrontImage:self.forward.currentBackgroundImage
                      rightImage:self.right.currentBackgroundImage
                       backImage:self.backward.currentBackgroundImage
                       leftImage:self.left.currentBackgroundImage
                        topImage:self.top.currentBackgroundImage
                     bottomImage:self.bottom.currentBackgroundImage];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)saveButtonEventHandler:(id)sender {
    if (!self.forward.currentBackgroundImage
        || !self.right.currentBackgroundImage
        || !self.backward.currentBackgroundImage
        || !self.left.currentBackgroundImage
        || !self.top.currentBackgroundImage
        || !self.bottom.currentBackgroundImage) {
        NSLog(@"请设置所有方位图片！");
        return;
    }
    NSString *albumName = self.titleLabel.text;
    if (!albumName || !albumName.length || [albumName isEqualToString:@"点击输入标题"]) {
        albumName = [NSString stringWithFormat:@"指道全景-%zd", [ZDPanoramaDataTool totalData].count+1];
    }
    [self.muteDataDict setObject:albumName forKey:@"title"];
    
    [SVProgressHUD showWithStatus:@"正在保存..."];
    
    PMSaveImageToAlbum(self.forward.currentBackgroundImage, albumName, ^(SPAsset *asset, NSError *error) {
        [self.muteDataDict setObject:asset.phAsset.localIdentifier forKey:@"forward"];
        
        PMSaveImageToAlbum(self.backward.currentBackgroundImage, albumName, ^(SPAsset *asset, NSError *error) {
            [self.muteDataDict setObject:asset.phAsset.localIdentifier forKey:@"backward"];
            
            PMSaveImageToAlbum(self.left.currentBackgroundImage, albumName, ^(SPAsset *asset, NSError *error) {
                [self.muteDataDict setObject:asset.phAsset.localIdentifier forKey:@"left"];
                
                PMSaveImageToAlbum(self.right.currentBackgroundImage, albumName, ^(SPAsset *asset, NSError *error) {
                    [self.muteDataDict setObject:asset.phAsset.localIdentifier forKey:@"right"];
                    
                    PMSaveImageToAlbum(self.top.currentBackgroundImage, albumName, ^(SPAsset *asset, NSError *error) {
                        [self.muteDataDict setObject:asset.phAsset.localIdentifier forKey:@"top"];
                        
                        PMSaveImageToAlbum(self.bottom.currentBackgroundImage, albumName, ^(SPAsset *asset, NSError *error) {
                            [self.muteDataDict setObject:asset.phAsset.localIdentifier forKey:@"bottom"];
                            [ZDPanoramaDataTool updateData:[self.muteDataDict copy] atIndex:self.dataIndex];
                            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
                        });
                    });
                });
            });
        });
    });
    
}
- (void)deleteButtonEventHandler:(id)sender {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"删除这条数据？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAct = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [ZDPanoramaDataTool deleteDataAtIndex:self.dataIndex completion:^{
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:cancelAct];
    [alertCon addAction:deleteAct];
    [self presentViewController:alertCon animated:YES completion:nil];
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
