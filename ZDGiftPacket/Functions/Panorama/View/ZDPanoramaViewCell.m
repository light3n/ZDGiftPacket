//
//  ZDPanoramaViewCell.m
//  PanoramaDemo
//
//  Created by Joey on 2018/1/25.
//  Copyright © 2018年 Joey. All rights reserved.
//

#import "ZDPanoramaViewCell.h"
#import "SPPhotoManager.h"

@interface ZDPanoramaViewCell()
// UI
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *top;
@property (weak, nonatomic) IBOutlet UIButton *bottom;
@property (weak, nonatomic) IBOutlet UIButton *left;
@property (weak, nonatomic) IBOutlet UIButton *right;
@property (weak, nonatomic) IBOutlet UIButton *forward;
@property (weak, nonatomic) IBOutlet UIButton *backward;


@end

@implementation ZDPanoramaViewCell

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    SPPhotoManager *mgr = [SPPhotoManager defaultManager];
    self.titleLabel.text = [dataDict objectForKey:@"title"];
    
    NSString *topName = [dataDict objectForKey:@"top"];
    UIImage *image = [self imageWithName:topName];
    if (image) {
        [self.top setBackgroundImage:[self imageWithName:[dataDict objectForKey:@"top"]] forState:UIControlStateNormal];
        [self.bottom setBackgroundImage:[self imageWithName:[dataDict objectForKey:@"bottom"]] forState:UIControlStateNormal];
        [self.left setBackgroundImage:[self imageWithName:[dataDict objectForKey:@"left"]] forState:UIControlStateNormal];
        [self.right setBackgroundImage:[self imageWithName:[dataDict objectForKey:@"right"]] forState:UIControlStateNormal];
        [self.forward setBackgroundImage:[self imageWithName:[dataDict objectForKey:@"forward"]] forState:UIControlStateNormal];
        [self.backward setBackgroundImage:[self imageWithName:[dataDict objectForKey:@"backward"]] forState:UIControlStateNormal];
    } else {
        [self.top setBackgroundImage:[mgr fetchThumbnailWithLocalIdentifier:[dataDict objectForKey:@"top"]] forState:UIControlStateNormal];
        [self.bottom setBackgroundImage:[mgr fetchThumbnailWithLocalIdentifier:[dataDict objectForKey:@"bottom"]] forState:UIControlStateNormal];
        [self.left setBackgroundImage:[mgr fetchThumbnailWithLocalIdentifier:[dataDict objectForKey:@"left"]] forState:UIControlStateNormal];
        [self.right setBackgroundImage:[mgr fetchThumbnailWithLocalIdentifier:[dataDict objectForKey:@"right"]] forState:UIControlStateNormal];
        [self.forward setBackgroundImage:[mgr fetchThumbnailWithLocalIdentifier:[dataDict objectForKey:@"forward"]] forState:UIControlStateNormal];
        [self.backward setBackgroundImage:[mgr fetchThumbnailWithLocalIdentifier:[dataDict objectForKey:@"backward"]] forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImage *)imageWithName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Button Event Handler

- (IBAction)previewButtonEventHandler:(id)sender {
    [self.delegate panoramaViewCell:self willPreviewPanoramaWithData:self.dataDict];
}

- (IBAction)editButtonEventHandler:(id)sender {
    [self.delegate panoramaViewCell:self willEditData:self.dataDict];
}


@end
