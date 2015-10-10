//
//  JVBannerView.h
//  JVSlideKit
//
//  Created by liu on 15/10/9.
//
//

#import <UIKit/UIKit.h>
#import "JVSlideView.h"

@interface JVBannerView : JVSlideView

//@property (nonatomic, readonly) NSInteger currentIndex;

@property (nonatomic, assign, getter=isLoop) BOOL loop;

@end
