#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreImage/CoreImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <substrate.h>
#import "ExportMusic.h"
#import "TTOpenInAppActivity.h"
#import "UIActionSheet+Blocks.h"

#define ShareMusixSystemVersionGreaterThanOrEqualTo(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface MPAVItem : NSObject
// @property(readonly) AVPlayerItemAccessLog * accessLog;
// @property(readonly) RURadioAdTrack * adTrack;
@property(readonly) NSString * album;
@property(readonly) NSString * albumArtist;
@property(copy,readonly) NSString * albumBuyButtonText;
@property(readonly) long long albumBuyButtonType;
@property(readonly) long long albumStoreID;
@property(readonly) unsigned long long albumTrackCount;
@property(readonly) unsigned long long albumTrackNumber;
@property(readonly) bool allowsEQ;
// @property(readonly) MPAlternateTracks * alternateTracks;
@property(readonly) NSString * artist;
@property(retain) NSArray * artworkTimeMarkers;
@property(readonly) AVAsset * asset;
@property(copy,readonly) NSString * assetFlavor;
// @property(readonly) RadioAudioClip * audioClip;
@property(copy,readonly) NSArray * buyOffers;
@property(readonly) bool canSeedGenius;
@property(retain) NSArray * chapterTimeMarkers;
@property(retain) NSArray * closedCaptionTimeMarkers;
@property(readonly) NSString * composer;
@property(copy,readonly) NSString * copyrightText;
@property(readonly) unsigned long long countForQueueFeeder;
@property(readonly) double currentTimeDisplayOverride;
@property(readonly) long long customAVEQPreset;
@property float defaultPlaybackRate;
@property(readonly) bool didAttemptToLoadAsset;
@property(readonly) unsigned long long discCount;
@property(readonly) unsigned long long discNumber;
@property(readonly) NSString * displayableText;
@property(readonly) bool displayableTextLoaded;
@property(readonly) double durationFromExternalMetadata;
@property(readonly) double durationIfAvailable;
@property(readonly) bool durationIsValid;
// @property(readonly) RadioArtworkCollection * effectiveArtworkCollection;
@property(getter=isExplicitTrack,readonly) bool explicitTrack;
// @property MPQueueFeeder * feeder;
@property(readonly) NSString * genre;
@property(readonly) bool hasDisplayableText;
@property bool hasPlayedThisSession;
@property unsigned long long indexInQueueFeeder;
@property(readonly) bool isAd;
@property(readonly) bool isAlwaysLive;
@property bool isAssetLoaded;
@property(readonly) bool isCloudItem;
@property(readonly) bool isRadioItem;
@property(readonly) bool isStreamingQuality;
@property(readonly) NSString * localizedPositionInPlaylistString;
@property float loudnessInfoVolumeNormalization;
@property(readonly) NSString * lyrics;
@property(readonly) NSString * mainTitle;
@property(retain,readonly) MPMediaItem * mediaItem;
@property(readonly) unsigned long long persistentID;
@property(readonly) double playableDuration;
@property(readonly) double playableDurationIfAvailable;
@property double playbackCheckpointCurrentTime;
// @property MPAVController * player;
@property(readonly) AVPlayerItem * playerItem;
@property(readonly) NSURL * podcastURL;
// @property(readonly) RadioTrack * radioTrack;
// @property(retain) MPAlternateTextTrack * selectedAlternateTextTrack;
@property float soundCheckVolumeNormalization;
@property(readonly) long long status;
@property(readonly) long long storeID;
// @property(readonly) RadioStreamTrack * streamTrack;
@property(getter=isStreamable,readonly) bool streamable;
@property(readonly) bool supportsRadioTrackActions;
@property(readonly) bool supportsRewindAndFastForward15Seconds;
@property(readonly) bool supportsSettingCurrentTime;
@property(readonly) bool supportsSkip;
@property(readonly) double timeOfSeekableEnd;
@property(readonly) double timeOfSeekableStart;
@property(readonly) NSArray * timedMetadataIfAvailable;
@property(readonly) unsigned long long type;
@property(retain) NSArray * urlTimeMarkers;
@property(readonly) bool useEmbeddedChapterData;
@property bool userAdvancedDuringPlayback;
@property(readonly) float userRating;
@property(copy) NSString * videoID;
@end

@interface MPAVController : NSObject
@property(readonly) MPAVItem * currentItem;
@property(readonly) bool currentItemIsRental;
@property(readonly) MPMediaItem * currentMediaItem;
@end

@interface MPUNowPlayingViewController : UIViewController
@property(readonly) MPAVItem * _item;
@property(retain) MPAVController * player;
@end

@interface MusicNowPlayingViewController : UIViewController
@end

@interface MCDMusicNowPlayingViewController : UIViewController
@end

@interface MSNowPlayingViewController : UIViewController
@end

@interface MusicNowPlayingViewController (ShareMusix) <TTOpenInAppActivityDelegate, UIPopoverPresentationControllerDelegate>
@end
@interface MCDMusicNowPlayingViewController (ShareMusix) <TTOpenInAppActivityDelegate, UIPopoverPresentationControllerDelegate>
@end
@interface MSNowPlayingViewController (ShareMusix) <TTOpenInAppActivityDelegate, UIPopoverPresentationControllerDelegate>
@end
@interface MPUNowPlayingViewController (ShareMusix) <TTOpenInAppActivityDelegate, UIPopoverPresentationControllerDelegate>
@end

%group iOS8
%hook MPUNowPlayingViewController
- (void)viewDidAppear:(bool)arg1 {
	%orig;
	NSArray *rightButtonsArray = [self navigationItem].rightBarButtonItems;
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	NSString *imageBarItemPath = @"/Library/Application Support/ShareMusix/TTOpenInAppActivity7@2x.png";
	UIBarButtonItem *newShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:imageBarItemPath] style:UIBarButtonItemStylePlain target:self action:@selector(newShareButtonPressed:)];
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);
	UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[newShare setBackgroundImage:blank forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[mutableArray addObjectsFromArray:rightButtonsArray];
	[mutableArray addObject:newShare];
	[self.navigationItem setRightBarButtonItems:mutableArray];
}
%new
- (void)newShareButtonPressed:(id)sender {
	if (ShareMusixSystemVersionGreaterThanOrEqualTo(@"8.0")) {
		UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"ShareMusix" message:@"What you wanna do ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *shareFileAction = [UIAlertAction actionWithTitle:@"Share Music" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        	[self performSelector:@selector(newShareFileButtonPressed) withObject:nil afterDelay:0.0];            
        }];
        UIAlertAction *shareInfoAction = [UIAlertAction actionWithTitle:@"Share Music Info" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSelector:@selector(newShareInfoButtonPressed) withObject:nil afterDelay:0.0];
        }];
        [altC addAction:cancelAction];
        [altC addAction:shareFileAction];
        [altC addAction:shareInfoAction];
        UIPopoverPresentationController *popover = altC.popoverPresentationController;
        if (popover) {
            popover.sourceView = self.view;
            popover.sourceRect = self.view.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [self presentViewController:altC animated:YES completion:nil];
	} else {
		[UIActionSheet showInView:self.view
		                withTitle:@"ShareMusix"
		        cancelButtonTitle:@"Cancel"
		   destructiveButtonTitle:nil
		        otherButtonTitles:@[@"Share Music", @" Share Music Info"]
		                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
		                    NSString *sheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
		                    if ([sheetTitle isEqualToString:@"Share Music"]) {
		                     	[self performSelector:@selector(newShareFileButtonPressed) withObject:nil afterDelay:0.0];
		                    }
		                    if ([sheetTitle isEqualToString:@" Share Music Info"]) {
		                     	[self performSelector:@selector(newShareInfoButtonPressed) withObject:nil afterDelay:0.0];
		                    }
		}];
	}

}

%new
- (void)newShareInfoButtonPressed {
	NSString* title = [self.player.currentMediaItem valueForProperty:MPMediaItemPropertyTitle];
	MPMediaItemArtwork *artork = [self.player.currentMediaItem valueForProperty:MPMediaItemPropertyArtwork];

	UIImage *imageArt = [artork imageWithSize:CGSizeMake(200, 200)];
	if (imageArt == nil) {
		imageArt = [UIImage imageWithContentsOfFile:@"/Library/Application Support/ShareMusix/AudioPlayerNoArtwork@2x.png"];
	}
	NSString *shareText = [NSString stringWithFormat:@"I'm listening to %@\nby %@\nfrom Album %@\ngenre %@\n#ShareMusix", title, self.player.currentItem.artist, self.player.currentItem.album, self.player.currentItem.genre];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* pathLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *dataPath = [pathLibrary stringByAppendingPathComponent:@"/ShareMusix"];
	    	TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
		    openInAppActivity.delegate = self;
			NSArray *activitesApp = @[openInAppActivity];
		    NSArray *activitesItem = @[shareText, imageArt];
		    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
		    activityController.excludedActivityTypes = @[UIActivityTypePrint];
		    
		    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		        openInAppActivity.superViewController = activityController;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    } else {
		        // Create pop up
		        UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
		        activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
		        activityController.popoverPresentationController.sourceView = self.view;
		        presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
		        presentPOP.delegate = self;
		        presentPOP.sourceRect = CGRectMake(700,80,0,0);
		        presentPOP.sourceView = self.view;
		        openInAppActivity.superViewController = presentPOP;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    }
	});
}
%new
- (void)newShareFileButtonPressed {

	NSURL* assetURL = [self.player.currentMediaItem valueForProperty:MPMediaItemPropertyAssetURL];
	if (assetURL == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"this is an iCloud item so download it before you share"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;                               
	}
	NSString* title = [self.player.currentMediaItem valueForProperty:MPMediaItemPropertyTitle];

	NSString *shareText = [NSString stringWithFormat:@"I'm listening to %@\nby %@\nfrom Album %@\ngenre %@\n#ShareMusix", title, self.player.currentItem.artist, self.player.currentItem.album, self.player.currentItem.genre];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* ext = [ExportMusic extensionForAssetURL:assetURL];
		NSString* pathLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *dataPath = [pathLibrary stringByAppendingPathComponent:@"/ShareMusix"];

		if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
		    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder

	    NSURL* outURL = [[NSURL fileURLWithPath:[dataPath stringByAppendingPathComponent:title]] URLByAppendingPathExtension:ext];
	    // we're responsible for making sure the destination url doesn't already exist
	    [[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
	    // create the import object
	    ExportMusic *aorakiImport = [[ExportMusic alloc] init];
	    [aorakiImport importAsset:assetURL toURL:outURL completionBlock:^(ExportMusic *import) {
	    	TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
		    openInAppActivity.delegate = self;
			NSArray *activitesApp = @[openInAppActivity];
		    NSArray *activitesItem = @[outURL];
		    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
		    activityController.excludedActivityTypes = @[UIActivityTypePrint];
		    
		    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		        openInAppActivity.superViewController = activityController;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    } else {
		        // Create pop up
		        UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
		        activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
		        activityController.popoverPresentationController.sourceView = self.view;
		        presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
		        presentPOP.delegate = self;
		        presentPOP.sourceRect = CGRectMake(700,80,0,0);
		        presentPOP.sourceView = self.view;
		        openInAppActivity.superViewController = presentPOP;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    }
	    }];
	});
}
%end

%hook MCDMusicNowPlayingViewController
- (void)viewDidAppear:(bool)arg1 {
	%orig;
	NSArray *rightButtonsArray = [self navigationItem].rightBarButtonItems;
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	NSString *imageBarItemPath = @"/Library/Application Support/ShareMusix/TTOpenInAppActivity7@2x.png";
	UIBarButtonItem *newShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:imageBarItemPath] style:UIBarButtonItemStylePlain target:self action:@selector(newShareButtonPressed:)];
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);
	UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[newShare setBackgroundImage:blank forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[mutableArray addObjectsFromArray:rightButtonsArray];
	[mutableArray addObject:newShare];
	[self.navigationItem setRightBarButtonItems:mutableArray];
}
%new
- (void)newShareButtonPressed:(id)sender {
	if (ShareMusixSystemVersionGreaterThanOrEqualTo(@"8.0")) {
		UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"ShareMusix" message:@"What you wanna do ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *shareFileAction = [UIAlertAction actionWithTitle:@"Share Music" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        	[self performSelector:@selector(newShareFileButtonPressed) withObject:nil afterDelay:0.0];            
        }];
        UIAlertAction *shareInfoAction = [UIAlertAction actionWithTitle:@"Share Music Info" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSelector:@selector(newShareInfoButtonPressed) withObject:nil afterDelay:0.0];
        }];
        [altC addAction:cancelAction];
        [altC addAction:shareFileAction];
        [altC addAction:shareInfoAction];
        UIPopoverPresentationController *popover = altC.popoverPresentationController;
        if (popover) {
            popover.sourceView = self.view;
            popover.sourceRect = self.view.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [self presentViewController:altC animated:YES completion:nil];
	} else {
		[UIActionSheet showInView:self.view
		                withTitle:@"ShareMusix"
		        cancelButtonTitle:@"Cancel"
		   destructiveButtonTitle:nil
		        otherButtonTitles:@[@"Share Music", @" Share Music Info"]
		                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
		                    NSString *sheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
		                    if ([sheetTitle isEqualToString:@"Share Music"]) {
		                     	[self performSelector:@selector(newShareFileButtonPressed) withObject:nil afterDelay:0.0];
		                    }
		                    if ([sheetTitle isEqualToString:@" Share Music Info"]) {
		                     	[self performSelector:@selector(newShareInfoButtonPressed) withObject:nil afterDelay:0.0];
		                    }
		}];
	}

}

%new
- (void)newShareInfoButtonPressed {
	MPAVController *player = MSHookIvar<MPAVController *>(self, "_player");
	NSString* title = [player.currentMediaItem valueForProperty:MPMediaItemPropertyTitle];
	MPMediaItemArtwork *artork = [player.currentMediaItem valueForProperty:MPMediaItemPropertyArtwork];

	UIImage *imageArt = [artork imageWithSize:CGSizeMake(200, 200)];
	if (imageArt == nil) {
		imageArt = [UIImage imageWithContentsOfFile:@"/Library/Application Support/ShareMusix/AudioPlayerNoArtwork@2x.png"];
	}
	NSString *shareText = [NSString stringWithFormat:@"I'm listening to %@\nby %@\nfrom Album %@\ngenre %@\n#ShareMusix", title, player.currentItem.artist, player.currentItem.album, player.currentItem.genre];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* pathLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *dataPath = [pathLibrary stringByAppendingPathComponent:@"/ShareMusix"];
	    	TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
		    openInAppActivity.delegate = self;
			NSArray *activitesApp = @[openInAppActivity];
		    NSArray *activitesItem = @[shareText, imageArt];
		    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
		    activityController.excludedActivityTypes = @[UIActivityTypePrint];
		    
		    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		        openInAppActivity.superViewController = activityController;
		        // Store reference to superview (UIActionSheet) to allow dismissal
		        // Show UIActivityViewController
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    } else {
		        // Create pop up
		        UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
		        activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
		        activityController.popoverPresentationController.sourceView = self.view;
		        presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
		        presentPOP.delegate = self;
		        presentPOP.sourceRect = CGRectMake(700,80,0,0);
		        presentPOP.sourceView = self.view;
		        openInAppActivity.superViewController = presentPOP;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    }
	});
}
%new
- (void)newShareFileButtonPressed {

	MPAVController *player = MSHookIvar<MPAVController *>(self, "_player");

	NSURL* assetURL = [player.currentMediaItem valueForProperty:MPMediaItemPropertyAssetURL];
	if (assetURL == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"this is an iCloud item so download it before you share"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;                               
	}
	NSString* title = [player.currentMediaItem valueForProperty:MPMediaItemPropertyTitle];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* ext = [ExportMusic extensionForAssetURL:assetURL];
		NSString* pathLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *dataPath = [pathLibrary stringByAppendingPathComponent:@"/ShareMusix"];

		if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
		    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder

	    NSURL* outURL = [[NSURL fileURLWithPath:[dataPath stringByAppendingPathComponent:title]] URLByAppendingPathExtension:ext];
	    // we're responsible for making sure the destination url doesn't already exist
	    [[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
	    // create the import object
	    ExportMusic *aorakiImport = [[ExportMusic alloc] init];
	    [aorakiImport importAsset:assetURL toURL:outURL completionBlock:^(ExportMusic *import) {
	    	TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
		    openInAppActivity.delegate = self;
			NSArray *activitesApp = @[openInAppActivity];
		    NSArray *activitesItem = @[outURL];
		    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
		    activityController.excludedActivityTypes = @[UIActivityTypePrint];
		    
		    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		        openInAppActivity.superViewController = activityController;
		        // Store reference to superview (UIActionSheet) to allow dismissal
		        // Show UIActivityViewController
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    } else {
		        // Create pop up
		        UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
		        activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
		        activityController.popoverPresentationController.sourceView = self.view;
		        presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
		        presentPOP.delegate = self;
		        presentPOP.sourceRect = CGRectMake(700,80,0,0);
		        presentPOP.sourceView = self.view;
		        openInAppActivity.superViewController = presentPOP;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    }
	    }];
	});
}
%end
%end

// IOS7
%group IOS7
%hook MusicNowPlayingViewController
- (void)viewDidAppear:(bool)arg1 {
	%orig;
	NSArray *rightButtonsArray = [self navigationItem].rightBarButtonItems;
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	NSString *imageBarItemPath = @"/Library/Application Support/ShareMusix/TTOpenInAppActivity7@2x.png";
	UIBarButtonItem *newShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:imageBarItemPath] style:UIBarButtonItemStylePlain target:self action:@selector(newShareButtonPressed:)];
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);
	UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[newShare setBackgroundImage:blank forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[mutableArray addObjectsFromArray:rightButtonsArray];
	[mutableArray addObject:newShare];
	[self.navigationItem setRightBarButtonItems:mutableArray];
}
%new
- (void)newShareButtonPressed:(id)sender {
	if (ShareMusixSystemVersionGreaterThanOrEqualTo(@"8.0")) {
		UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"ShareMusix" message:@"What you wanna do ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *shareFileAction = [UIAlertAction actionWithTitle:@"Share Music" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        	[self performSelector:@selector(newShareFileButtonPressed) withObject:nil afterDelay:0.0];            
        }];
        UIAlertAction *shareInfoAction = [UIAlertAction actionWithTitle:@"Share Music Info" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSelector:@selector(newShareInfoButtonPressed) withObject:nil afterDelay:0.0];
        }];
        [altC addAction:cancelAction];
        [altC addAction:shareFileAction];
        [altC addAction:shareInfoAction];
        UIPopoverPresentationController *popover = altC.popoverPresentationController;
        if (popover) {
            popover.sourceView = self.view;
            popover.sourceRect = self.view.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [self presentViewController:altC animated:YES completion:nil];
	} else {
		[UIActionSheet showInView:self.view
		                withTitle:@"ShareMusix"
		        cancelButtonTitle:@"Cancel"
		   destructiveButtonTitle:nil
		        otherButtonTitles:@[@"Share Music", @" Share Music Info"]
		                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
		                    NSString *sheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
		                    if ([sheetTitle isEqualToString:@"Share Music"]) {
		                     	[self performSelector:@selector(newShareFileButtonPressed) withObject:nil afterDelay:0.0];
		                    }
		                    if ([sheetTitle isEqualToString:@" Share Music Info"]) {
		                     	[self performSelector:@selector(newShareInfoButtonPressed) withObject:nil afterDelay:0.0];
		                    }
		}];
	}

}

%new
- (void)newShareInfoButtonPressed {
	MPAVItem *avItem = MSHookIvar<MPAVItem *>(self, "_item");

	NSString* title = [avItem.mediaItem valueForProperty:MPMediaItemPropertyTitle];
	MPMediaItemArtwork *artork = [avItem.mediaItem valueForProperty:MPMediaItemPropertyArtwork];

	UIImage *imageArt = [artork imageWithSize:CGSizeMake(200, 200)];
	if (imageArt == nil) {
		imageArt = [UIImage imageWithContentsOfFile:@"/Library/Application Support/ShareMusix/AudioPlayerNoArtwork@2x.png"];
	}
	NSString *shareText = [NSString stringWithFormat:@"I'm listening to %@\nby %@\nfrom Album %@\ngenre %@\n#ShareMusix", title, avItem.artist, avItem.album, avItem.genre];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* pathLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *dataPath = [pathLibrary stringByAppendingPathComponent:@"/ShareMusix"];
	    	TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
		    openInAppActivity.delegate = self;
			NSArray *activitesApp = @[openInAppActivity];
		    NSArray *activitesItem = @[shareText, imageArt];
		    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
		    activityController.excludedActivityTypes = @[UIActivityTypePrint];
		    
		    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		        openInAppActivity.superViewController = activityController;
		        // Store reference to superview (UIActionSheet) to allow dismissal
		        // Show UIActivityViewController
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    } else {
		        // Create pop up
		        UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
		        activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
		        activityController.popoverPresentationController.sourceView = self.view;
		        presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
		        presentPOP.delegate = self;
		        presentPOP.sourceRect = CGRectMake(700,80,0,0);
		        presentPOP.sourceView = self.view;
		        openInAppActivity.superViewController = presentPOP;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    }
	});
}
%new
- (void)newShareFileButtonPressed {

	MPAVItem *avItem = MSHookIvar<MPAVItem *>(self, "_item");

	NSURL* assetURL = [avItem.mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
	if (assetURL == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"this is an iCloud item so download it before you share"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;                               
	}
	NSString* title = [avItem.mediaItem valueForProperty:MPMediaItemPropertyTitle];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* ext = [ExportMusic extensionForAssetURL:assetURL];
		NSString* pathLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *dataPath = [pathLibrary stringByAppendingPathComponent:@"/ShareMusix"];

		if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
		    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder

	    NSURL* outURL = [[NSURL fileURLWithPath:[dataPath stringByAppendingPathComponent:title]] URLByAppendingPathExtension:ext];
	    // we're responsible for making sure the destination url doesn't already exist
	    [[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
	    // create the import object
	    ExportMusic *aorakiImport = [[ExportMusic alloc] init];
	    [aorakiImport importAsset:assetURL toURL:outURL completionBlock:^(ExportMusic *import) {
	    	TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
		    openInAppActivity.delegate = self;
			NSArray *activitesApp = @[openInAppActivity];
		    NSArray *activitesItem = @[outURL];
		    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
		    activityController.excludedActivityTypes = @[UIActivityTypePrint];
		    
		    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		        openInAppActivity.superViewController = activityController;
		        // Store reference to superview (UIActionSheet) to allow dismissal
		        // Show UIActivityViewController
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    } else {
		        // Create pop up
		        UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
		        activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
		        activityController.popoverPresentationController.sourceView = self.view;
		        presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
		        presentPOP.delegate = self;
		        presentPOP.sourceRect = CGRectMake(700,80,0,0);
		        presentPOP.sourceView = self.view;
		        openInAppActivity.superViewController = presentPOP;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    }
	    }];
	});
}
%end
%hook MSNowPlayingViewController
- (void)viewDidAppear:(bool)arg1 {
	%orig;
	NSArray *rightButtonsArray = [self navigationItem].rightBarButtonItems;
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	NSString *imageBarItemPath = @"/Library/Application Support/ShareMusix/TTOpenInAppActivity7@2x.png";
	UIBarButtonItem *newShare = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithContentsOfFile:imageBarItemPath] style:UIBarButtonItemStylePlain target:self action:@selector(newShareButtonPressed:)];
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(20, 20), NO, 0.0);
	UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[newShare setBackgroundImage:blank forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[mutableArray addObjectsFromArray:rightButtonsArray];
	[mutableArray addObject:newShare];
	[self.navigationItem setRightBarButtonItems:mutableArray];
}
%new
- (void)newShareButtonPressed:(id)sender {
	if (ShareMusixSystemVersionGreaterThanOrEqualTo(@"8.0")) {
		UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"ShareMusix" message:@"What you wanna do ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *shareFileAction = [UIAlertAction actionWithTitle:@"Share Music" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        	[self performSelector:@selector(newShareFileButtonPressed) withObject:nil afterDelay:0.0];            
        }];
        UIAlertAction *shareInfoAction = [UIAlertAction actionWithTitle:@"Share Music Info" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSelector:@selector(newShareInfoButtonPressed) withObject:nil afterDelay:0.0];
        }];
        [altC addAction:cancelAction];
        [altC addAction:shareFileAction];
        [altC addAction:shareInfoAction];
        UIPopoverPresentationController *popover = altC.popoverPresentationController;
        if (popover) {
            popover.sourceView = self.view;
            popover.sourceRect = self.view.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        [self presentViewController:altC animated:YES completion:nil];
	} else {
		[UIActionSheet showInView:self.view
		                withTitle:@"ShareMusix"
		        cancelButtonTitle:@"Cancel"
		   destructiveButtonTitle:nil
		        otherButtonTitles:@[@"Share Music", @" Share Music Info"]
		                 tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
		                    NSString *sheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
		                    if ([sheetTitle isEqualToString:@"Share Music"]) {
		                     	[self performSelector:@selector(newShareFileButtonPressed) withObject:nil afterDelay:0.0];
		                    }
		                    if ([sheetTitle isEqualToString:@" Share Music Info"]) {
		                     	[self performSelector:@selector(newShareInfoButtonPressed) withObject:nil afterDelay:0.0];
		                    }
		}];
	}

}

%new
- (void)newShareInfoButtonPressed {
	MPAVController *player = MSHookIvar<MPAVController *>(self, "_player");

	NSString* title = [player.currentMediaItem valueForProperty:MPMediaItemPropertyTitle];
	MPMediaItemArtwork *artork = [player.currentMediaItem valueForProperty:MPMediaItemPropertyArtwork];

	UIImage *imageArt = [artork imageWithSize:CGSizeMake(200, 200)];
	if (imageArt == nil) {
		imageArt = [UIImage imageWithContentsOfFile:@"/Library/Application Support/ShareMusix/AudioPlayerNoArtwork@2x.png"];
	}
	NSString *shareText = [NSString stringWithFormat:@"I'm listening to %@\nby %@\nfrom Album %@\ngenre %@\n#ShareMusix", title, player.currentItem.artist, player.currentItem.album, player.currentItem.genre];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* pathLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *dataPath = [pathLibrary stringByAppendingPathComponent:@"/ShareMusix"];
	    	TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
		    openInAppActivity.delegate = self;
			NSArray *activitesApp = @[openInAppActivity];
		    NSArray *activitesItem = @[shareText, imageArt];
		    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
		    activityController.excludedActivityTypes = @[UIActivityTypePrint];
		    
		    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		        openInAppActivity.superViewController = activityController;
		        // Store reference to superview (UIActionSheet) to allow dismissal
		        // Show UIActivityViewController
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    } else {
		        // Create pop up
		        UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
		        activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
		        activityController.popoverPresentationController.sourceView = self.view;
		        presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
		        presentPOP.delegate = self;
		        presentPOP.sourceRect = CGRectMake(700,80,0,0);
		        presentPOP.sourceView = self.view;
		        openInAppActivity.superViewController = presentPOP;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    }
	});
}
%new
- (void)newShareFileButtonPressed {

	MPAVController *player = MSHookIvar<MPAVController *>(self, "_player");

	NSURL* assetURL = [player.currentMediaItem valueForProperty:MPMediaItemPropertyAssetURL];
	if (assetURL == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"this is an iCloud item so download it before you share"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;                               
	}
	NSString* title = [player.currentMediaItem valueForProperty:MPMediaItemPropertyTitle];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSString* ext = [ExportMusic extensionForAssetURL:assetURL];
		NSString* pathLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString *dataPath = [pathLibrary stringByAppendingPathComponent:@"/ShareMusix"];

		if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
		    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil]; //Create folder

	    NSURL* outURL = [[NSURL fileURLWithPath:[dataPath stringByAppendingPathComponent:title]] URLByAppendingPathExtension:ext];
	    // we're responsible for making sure the destination url doesn't already exist
	    [[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
	    // create the import object
	    ExportMusic *aorakiImport = [[ExportMusic alloc] init];
	    [aorakiImport importAsset:assetURL toURL:outURL completionBlock:^(ExportMusic *import) {
	    	TTOpenInAppActivity *openInAppActivity = [[TTOpenInAppActivity alloc] initWithView:self.view andRect:self.view.frame];
		    openInAppActivity.delegate = self;
			NSArray *activitesApp = @[openInAppActivity];
		    NSArray *activitesItem = @[outURL];
		    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activitesItem applicationActivities:activitesApp];
		    activityController.excludedActivityTypes = @[UIActivityTypePrint];
		    
		    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
		        openInAppActivity.superViewController = activityController;
		        // Store reference to superview (UIActionSheet) to allow dismissal
		        // Show UIActivityViewController
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    } else {
		        // Create pop up
		        UIPopoverPresentationController *presentPOP = activityController.popoverPresentationController;
		        activityController.popoverPresentationController.sourceRect = CGRectMake(400,200,0,0);
		        activityController.popoverPresentationController.sourceView = self.view;
		        presentPOP.permittedArrowDirections = UIPopoverArrowDirectionRight;
		        presentPOP.delegate = self;
		        presentPOP.sourceRect = CGRectMake(700,80,0,0);
		        presentPOP.sourceView = self.view;
		        openInAppActivity.superViewController = presentPOP;
		        if (self.splitViewController.viewControllers.count > 0) {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self.splitViewController.viewControllers[0] presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        } else {
		        	dispatch_async(dispatch_get_main_queue(), ^{
		        		[self presentViewController:activityController animated:YES completion:^{
			            }];
		        	});
		        }
		    }
	    }];
	});
}
%end
%end

%ctor {
	if (ShareMusixSystemVersionGreaterThanOrEqualTo(@"8.0")) {
		%init(iOS8);
	} else {
		%init(IOS7);
	}
}
/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
