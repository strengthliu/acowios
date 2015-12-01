//
//  myFilter.h
//  tabbarTest
//
//  Created by lucifer on 15/11/16.
//  Copyright © 2015年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  其实我是要用SCFilter，但引入时出错。SCImageView.h这里import了SCFilter，就先用着吧。
 */
#import "SCRecorder/SCImageView.h"

//#import "SCRecorder/SCFilter.h"

@interface myFilter : NSObject <SCFilterDelegate>

@end
