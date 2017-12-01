//
//  UIViewController+Log.h
//  XLsn0wRunTimeLoop
//
//  Created by golong on 2017/12/1.
//  Copyright © 2017年 XLsn0w. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Log)

//声明属性时，不要以new开头。如果非要以new开头命名属性的名字，需要自己定制get方法名，如
@property(getter=theString) NSString *newString;

@property (nonatomic, copy) NSString *name;///copy一份对象 深拷贝

@end
