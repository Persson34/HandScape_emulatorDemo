/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  A view controller displaying an asset full screen.
  
 */

#import "AAPLAssetViewController.h"

#import <HandScapeSDK/HSCHandsView.h>
#import <HandScapeSDK/HSCTouchpadManager.h>
#import <HandScapeSDK/HSCPinchGestureRecognizer.h>
#import <HandScapeSDK/HSCDragGestureRecognizer.h>
#import <HandScapeSDK/HSCTapGestureRecognizer.h>

@implementation CIImage (Convenience)
- (NSData *)aapl_jpegRepresentationWithCompressionQuality:(CGFloat)compressionQuality {
	static CIContext *ciContext = nil;
	if (!ciContext) {
		EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		ciContext = [CIContext contextWithEAGLContext:eaglContext];
	}
	CGImageRef outputImageRef = [ciContext createCGImage:self fromRect:[self extent]];
	UIImage *uiImage = [[UIImage alloc] initWithCGImage:outputImageRef scale:1.0 orientation:UIImageOrientationUp];
	if (outputImageRef) {
		CGImageRelease(outputImageRef);
	}
	NSData *jpegRepresentation = UIImageJPEGRepresentation(uiImage, compressionQuality);
	return jpegRepresentation;
}
@end


@interface AAPLAssetViewController () <PHPhotoLibraryChangeObserver,UIScrollViewDelegate,HSCTouchpadManagerDelegate> {
    CGFloat imgScale;
    CGFloat prevChange;
    CGFloat pivot;
    BOOL wasIncreasing;
}
@property (strong, nonatomic) IBOutlet UIView *myview;
@property (nonatomic, retain)IBOutlet UIImageView *leftImageView;
@property (nonatomic, retain)IBOutlet UIImageView *imageView;
@property (nonatomic, retain)IBOutlet UIImageView *rightImageView;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, strong) NSMutableArray *views;
@property (strong) IBOutlet UIBarButtonItem *playButton;
@property (strong) IBOutlet UIBarButtonItem *space;
@property (strong) IBOutlet UIBarButtonItem *trashButton;
@property (strong) IBOutlet UIBarButtonItem *editButton;
@property (strong) IBOutlet UIProgressView *progressView;
@property (strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIPinchGestureRecognizer *frontPinchRecognizer;
@property (nonatomic, strong) HSCPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong) HSCDragGestureRecognizer *dragRecognizer;
@property (nonatomic, strong) HSCTapGestureRecognizer *tapRecognizer;
@property (nonatomic, assign) CGPoint StartPoint;

@end


@implementation AAPLAssetViewController

static NSString * const AdjustmentFormatIdentifier = @"com.example.apple-samplecode.SamplePhotosApp";
//do not change BUFFER
CGFloat const BUFFER = 25;

- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

CGFloat width;
CGFloat height;
CGSize contentSize;

- (void)viewDidLoad
{
    [super viewDidLoad];

    HSCHandsView *handsView = [[HSCHandsView alloc] initWithFrame:self.view.frame];
    handsView.opaque = NO;
    handsView.alpha = 0.5;
    handsView.layer.zPosition = 1;
    [self.view addSubview:handsView];
    [HSCTouchpadManager sharedManager].delegate = self;

    self.views = [[NSMutableArray alloc] init];
    width = self.view.frame.size.width + BUFFER;
    height = self.view.frame.size.height - 108;
    CGRect frame = CGRectMake(0, 64, width, height);
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:frame];

    contentSize = CGSizeMake(width * self.assetsFetchResults.count, height);
    self.imageScrollView.contentSize = contentSize;
    [self.imageScrollView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageScrollView setContentOffset:CGPointMake(width * self.index, 0) animated:NO];
    
    [self loadImagesAround:(int)self.index];
    lastPage = self.index;
    
    self.imageScrollView.minimumZoomScale = 1.0;
    self.imageScrollView.maximumZoomScale = 2.5;
    
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.scrollsToTop = NO;
    
    self.imageScrollView.delegate = self;
    self.imageScrollView.pagingEnabled = NO;
    self.imageScrollView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.imageScrollView];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
    self.frontPinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.imageScrollView addGestureRecognizer:self.frontPinchRecognizer];
    
    self.pinchRecognizer = [[HSCPinchGestureRecognizer alloc] init];
    self.dragRecognizer = [[HSCDragGestureRecognizer alloc] init];
    wasIncreasing = false;
    prevChange = 1.0;
    imgScale = 1.0;
    pivot = 1.0;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)sender {
    CGFloat newChange = sender.scale;
    CGFloat newScale = imgScale * newChange;
    CGFloat dif = newScale - imgScale;
    newScale = imgScale + dif / 7.5;
    
    if (newScale < self.imageScrollView.minimumZoomScale) {
        newScale = self.imageScrollView.minimumZoomScale;
    }
    if (newScale > self.imageScrollView.maximumZoomScale) {
        newScale = self.imageScrollView.maximumZoomScale;
    }
    imgScale = newScale;
    
    [self.imageScrollView setZoomScale:imgScale];
    CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
    self.imageScrollView.transform = transform;
}

-(void)loadImagesAround:(int)index {
    for (int i = index - 1; i < index + 2; i++) {
        if (i < 0 || i >= self.assetsFetchResults.count) {
            continue;
        }
        CGFloat width = self.view.frame.size.width + BUFFER;
        CGFloat height = self.view.frame.size.height - 108;
        CGRect imageFrame = CGRectMake(width * i, 0, self.view.frame.size.width, height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = i;
        [self updateImage:imageView withAsset:self.assetsFetchResults[i]];
        [self.imageScrollView addSubview:imageView];
        if (i == index) {
            self.imageView = imageView;
        }
    }
}

- (void)willRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (UIDeviceOrientationIsLandscape(fromInterfaceOrientation)) {
        NSLog(@"Was landscape");
        [self.imageView setFrame:CGRectMake(0, 0, self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height)];
        
    } else {
        [self.imageView setFrame:CGRectMake(0, 0, self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height)];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (self.index != page) {
        [self clearImages];
        [self loadImagesAround:(int)page];
        self.index = page;
    }
}

NSInteger lastPage;

-(CGFloat)getXOffsetOnPage:(NSInteger)page {
    CGFloat frameDiff = (self.imageScrollView.frame.size.width - width) / 2;
    CGFloat leftDiff = frameDiff * width / self.imageScrollView.frame.size.width;
    frameDiff = (frameDiff - BUFFER / width * self.imageScrollView.frame.size.width) / self.imageScrollView.frame.size.width * width;
    CGFloat rightDiff = frameDiff > 0 ? frameDiff : 0;
    if (page > lastPage) {
        lastPage = page;
        return width * page - leftDiff;
    } else if (page < lastPage) {
        lastPage = page;
        return width * page + rightDiff;
    } else if (self.imageScrollView.contentOffset.x > width * page + rightDiff) {
        return width * page + rightDiff;
    } else if (self.imageScrollView.contentOffset.x < width * page - leftDiff){
        return width * page - leftDiff;
    }
    return self.imageScrollView.contentOffset.x;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat pageWidth = width;
    CGFloat fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    [scrollView setContentOffset:CGPointMake([self getXOffsetOnPage:page], 0) animated:YES];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = width;
    CGFloat fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    [scrollView setContentOffset:CGPointMake([self getXOffsetOnPage:page], 0) animated:YES];
}

-(void)clearImages{
    NSArray *subviews = self.imageScrollView.subviews;
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.asset.mediaType == PHAssetMediaTypeVideo) {
        self.toolbarItems = @[self.playButton, self.space, self.trashButton];
    } else {
        self.toolbarItems = @[self.space, self.trashButton];
    }
    
    BOOL isEditable = ([self.asset canPerformEditOperation:PHAssetEditOperationProperties] || [self.asset canPerformEditOperation:PHAssetEditOperationContent]);
    self.editButton.enabled = isEditable;
    
    BOOL isTrashable = NO;
    if (self.assetCollection) {
        isTrashable = [self.assetCollection canPerformEditOperation:PHCollectionEditOperationRemoveContent];
    } else {
        isTrashable = [self.asset canPerformEditOperation:PHAssetEditOperationDelete];
    }
    self.trashButton.enabled = isTrashable;
    
    [self.view layoutIfNeeded];
}
/*
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!CGSizeEqualToSize(self.imageView.bounds.size, self.lastImageViewSize)) {
        [self updateImage];
    }
}
*/
- (void)updateImage:(UIImageView *)imageView withAsset:(PHAsset *)asset
{
//    [imageView setFrame:CGRectMake(0, 0, self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height)];


    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(imageView.bounds) * scale, CGRectGetHeight(imageView.bounds) * scale);

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    // Download from cloud if necessary
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
            self.progressView.hidden = (progress <= 0.0 || progress >= 1.0);
        });
    };
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        if (result) {
            imageView.image = result;
        }
    }];
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // Call might come on any background queue. Re-dispatch to the main queue to handle it.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // check if there are changes to the album we're interested on (to its metadata, not to its collection of assets)
        PHObjectChangeDetails *changeDetails = [changeInstance changeDetailsForObject:self.asset];
        if (changeDetails) {
            // it changed, we need to fetch a new one
            self.asset = [changeDetails objectAfterChanges];
            
            if ([changeDetails assetContentChanged]) {
                [self updateImage:self.imageView withAsset:self.asset];
                
                if (self.playerLayer) {
                    [self.playerLayer removeFromSuperlayer];
                    self.playerLayer = nil;
                }
            }
        }
        
    });
}

#pragma mark - Actions

- (void)applyFilterWithName:(NSString *)filterName
{
    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
    [options setCanHandleAdjustmentData:^BOOL(PHAdjustmentData *adjustmentData) {
        return [adjustmentData.formatIdentifier isEqualToString:AdjustmentFormatIdentifier] && [adjustmentData.formatVersion isEqualToString:@"1.0"];
    }];
    [self.asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
        // Get full image
        NSURL *url = [contentEditingInput fullSizeImageURL];
        int orientation = [contentEditingInput fullSizeImageOrientation];
        CIImage *inputImage = [CIImage imageWithContentsOfURL:url options:nil];
        inputImage = [inputImage imageByApplyingOrientation:orientation];

        // Add filter
        CIFilter *filter = [CIFilter filterWithName:filterName];
        [filter setDefaults];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        CIImage *outputImage = [filter outputImage];

        // Create editing output
        NSData *jpegData = [outputImage aapl_jpegRepresentationWithCompressionQuality:0.9f];
        PHAdjustmentData *adjustmentData = [[PHAdjustmentData alloc] initWithFormatIdentifier:AdjustmentFormatIdentifier formatVersion:@"1.0" data:[filterName dataUsingEncoding:NSUTF8StringEncoding]];
        
        PHContentEditingOutput *contentEditingOutput = [[PHContentEditingOutput alloc] initWithContentEditingInput:contentEditingInput];
        [jpegData writeToURL:[contentEditingOutput renderedContentURL] atomically:YES];
        [contentEditingOutput setAdjustmentData:adjustmentData];
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *request = [PHAssetChangeRequest changeRequestForAsset:self.asset];
            request.contentEditingOutput = contentEditingOutput;
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error: %@", error);
            }
        }];
    }];
}

- (IBAction)handleEditButtonItem:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:NULL]];

    if ([self.asset canPerformEditOperation:PHAssetEditOperationProperties]) {
        NSString *favoriteActionTitle = !self.asset.favorite ? NSLocalizedString(@"Favorite", @"") : NSLocalizedString(@"Unfavorite", @"");
        [alertController addAction:[UIAlertAction actionWithTitle:favoriteActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *request = [PHAssetChangeRequest changeRequestForAsset:self.asset];
                [request setFavorite:![self.asset isFavorite]];
            } completionHandler:^(BOOL success, NSError *error) {
                if (!success) {
                    NSLog(@"Error: %@", error);
                }
            }];
        }]];
    }
    if ([self.asset canPerformEditOperation:PHAssetEditOperationContent]) {
        if (self.asset.mediaType == PHAssetMediaTypeImage) {
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Sepia", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self applyFilterWithName:@"CISepiaTone"];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Chrome", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self applyFilterWithName:@"CIPhotoEffectChrome"];
            }]];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Revert", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest *request = [PHAssetChangeRequest changeRequestForAsset:self.asset];
                [request revertAssetContentToOriginal];
            } completionHandler:^(BOOL success, NSError *error) {
                if (!success) {
                    NSLog(@"Error: %@", error);
                }
            }];
        }]];
    }
	alertController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:alertController animated:YES completion:NULL];
	alertController.popoverPresentationController.barButtonItem = sender;
	alertController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
}

- (IBAction)handleTrashButtonItem:(id)sender
{
    void (^completionHandler)(BOOL, NSError *) = ^(BOOL success, NSError *error) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self navigationController] popViewControllerAnimated:YES];
            });
        } else {
            NSLog(@"Error: %@", error);
        }
    };
    
    if (self.assetCollection) {
        // Remove asset from album
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.assetCollection];
            [changeRequest removeAssets:@[self.asset]];
        } completionHandler:completionHandler];
        
    } else {
        // Delete asset from library
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:@[self.asset]];
        } completionHandler:completionHandler];
        
    }
}

- (IBAction)handlePlayButtonItem:(id)sender
{
    if (!self.playerLayer) {
        [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self.playerLayer) {
                    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:avAsset];
                    playerItem.audioMix = audioMix;
                    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
                    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
                    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                    
                    CALayer *layer = self.view.layer;
                    [layer addSublayer:playerLayer];
                    [playerLayer setFrame:layer.bounds];
                    [player play];
                }
            });
        }];
        
    } else {
        [self.playerLayer.player play];
    }
}

- (void)touchpadTouchReceived:(HSCTouch*)touch
{
    [self.dragRecognizer handleTouch:touch view:self.view callback:^(HSCGestureState state, CGPoint change) {
        if (state == HSC_GESTURE_STATE_BEGAN) {
            self.StartPoint = CGPointMake(0, 0);
        }
        if (state == HSC_GESTURE_STATE_CHANGED) {
            CGPoint newDragStartPoint = change;
            change.x -= self.StartPoint.x;
            if (imgScale > 1.0001) {
                change.y -= self.StartPoint.y;
            } else {
                change.y = 0;
            }
            [self.imageScrollView setContentOffset:CGPointMake(self.imageScrollView.contentOffset.x + change.x,
                                                               self.imageScrollView.contentOffset.y + change.y)];
            self.StartPoint = newDragStartPoint;
        } else if (state == HSC_GESTURE_STATE_ENDED) {
            CGPoint offset = self.imageScrollView.contentOffset;
            CGFloat fractionalPage = self.imageScrollView.contentOffset.x / width;
            NSInteger page = lround(fractionalPage);
            if (fabs(fractionalPage - page) > 0.30 && fabs(fractionalPage - page) < 0.5) {
                if (fractionalPage > page) {
                    page = page + 1;
                } else {
                    page = page - 1;
                }
            }
            page = page < 0 ? 0 : page;
            page = page >= self.assetsFetchResults.count ? self.assetsFetchResults.count - 1 : page;
            offset.x = [self getXOffsetOnPage:page];
            if (offset.y < (height - height * imgScale) / 6) {
                offset.y = (height - height * imgScale) / 6;
            }
            if (offset.y > (height * imgScale - height) / 6) {
                offset.y = (height * imgScale - height) / 6;
            }
            [self.imageScrollView setContentOffset:CGPointMake(offset.x, offset.y) animated:YES];
        }
    }];
    
    
    [self.pinchRecognizer handleTouch:touch view:self.view callback:^(HSCGestureState state, CGFloat change) {
        if (state == HSC_GESTURE_STATE_CHANGED) {
            BOOL increasing = change > prevChange;
            prevChange = change;
            if (increasing != wasIncreasing) {
                wasIncreasing = increasing;
                pivot = change;
            }
            CGFloat newChange = change - pivot + 1.0;
            CGFloat newScale = imgScale * newChange;
            CGFloat dif = newScale - imgScale;
            newScale = imgScale + dif / 7.5;
            
            if (newScale < self.imageScrollView.minimumZoomScale) {
                newScale = self.imageScrollView.minimumZoomScale;
            }
            if (newScale > self.imageScrollView.maximumZoomScale) {
                newScale = self.imageScrollView.maximumZoomScale;
            }
            imgScale = newScale;
            CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
            self.imageScrollView.transform = transform;
        }
    }];
}


@end


