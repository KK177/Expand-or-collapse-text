//
//  YTableViewCell.m
//  LongLabelShowTestTab
//
//  Created by iiik- on 2021/7/30.
//

#import "YTableViewCell.h"
#import <SDAutoLayout.h>

@interface YTableViewCell()<UITextViewDelegate>

@property (nonatomic, assign)CGFloat showMaxHeight;

@property (nonatomic, copy)NSString *suffixStr;

@end

@implementation YTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.editable = NO;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
        [self.contentView addSubview:_textView];
    }
    return _textView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initMol:(model *)mol {
    NSString *contentText = mol.title;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:16.]};
    CGRect statusMattStrRect = [mol.title boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
    if (statusMattStrRect.size.height > self.showMaxHeight) {
        if (mol.isOpen) {
            contentText = [NSString stringWithFormat:@"%@#%@",contentText,@"...收起"];
            self.suffixStr = @"收起";
            NSAttributedString *temp = [self attributeStr:_suffixStr content:contentText strFont:[UIFont systemFontOfSize:16.0]];
            self.textView.attributedText = temp;
            self.textView.sd_layout
            .leftEqualToView(self.contentView)
            .rightEqualToView(self.contentView)
            .topEqualToView(self.contentView)
            .heightIs(statusMattStrRect.size.height);
        }else {
            contentText = [self stringByTruncatingString:contentText suffixStr:@"...展开" font:[UIFont systemFontOfSize:16] forLength:self.contentView.bounds.size.width * 3];
            //添加富文本
            self.suffixStr = @"展开";
            NSAttributedString *temp = [self attributeStr:_suffixStr content:contentText strFont:[UIFont systemFontOfSize:16.0]];
            self.textView.attributedText = temp;
            self.textView.sd_layout
            .leftEqualToView(self.contentView)
            .rightEqualToView(self.contentView)
            .topEqualToView(self.contentView)
            .heightIs(self.showMaxHeight);
        }
    }else {
        self.textView.text = contentText;
        self.textView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .heightIs(statusMattStrRect.size.height);
    }

    [self setupAutoHeightWithBottomView:self.textView bottomMargin:20];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSString *str = @"sada";
        NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:16.]};
        CGRect statusMattStrRect = [str boundingRectWithSize:CGSizeMake(self.contentView.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil];
        self.showMaxHeight =  statusMattStrRect.size.height * 3;
    }
    return self;
}
/// 将文本按长度度截取并加上指定后缀
/// @param str 文本
/// @param suffixStr 指定后缀
/// @param font 文本字体
/// @param length 文本长度
- (NSString*)stringByTruncatingString:(NSString *)str suffixStr:(NSString *)suffixStr font:(UIFont *)font forLength:(CGFloat)length {
    if (!str) return nil;
    if (str  && [str isKindOfClass:[NSString class]]) {
        for (int i=(int)[str length] - (int)[suffixStr length]; i< [str length];i = i - (int)[suffixStr length]){
            NSString *tempStr = [str substringToIndex:i];
            CGSize size = [tempStr sizeWithAttributes:@{NSFontAttributeName:font}];
            if(size.width < length){
                tempStr = [NSString stringWithFormat:@"%@%@",tempStr,suffixStr];
                CGSize size1 = [tempStr sizeWithAttributes:@{NSFontAttributeName:font}];
                if(size1.width < length){
                    str = tempStr;
                    break;
                }
            }
        }
    }
    return str;
}

- (NSAttributedString *)attributeStr:(NSString *)suffixStr content:(NSString *)contentStr strFont:(UIFont *)font{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr attributes:@{NSFontAttributeName:font}];
    NSRange range = [contentStr rangeOfString:suffixStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor systemBlueColor] range:range];
    NSString *valueString = [[NSString stringWithFormat:@"didOpenClose://%@", suffixStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [str addAttribute:NSLinkAttributeName value:valueString range:range];
    return str;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"didOpenClose"]) {
        //刷新对应的cell
        self.blk();
        return NO;
    }
    return YES;
}

@end
