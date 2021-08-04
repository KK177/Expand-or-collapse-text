//
//  YTableViewCell.h
//  LongLabelShowTestTab
//
//  Created by iiik- on 2021/7/30.
//

#import <UIKit/UIKit.h>
#import "model.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^openBlock)(void);

@interface YTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, copy) openBlock blk;

@property (nonatomic, strong) model *mol;

- (NSString *)str;

- (void)initMol:(model *)mol;
@end

NS_ASSUME_NONNULL_END
