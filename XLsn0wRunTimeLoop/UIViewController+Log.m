//
//  UIViewController+Log.m
//  XLsn0wRunTimeLoop
//
//  Created by golong on 2017/12/1.
//  Copyright © 2017年 XLsn0w. All rights reserved.
//

#import "UIViewController+Log.h"///在catagory中只能添加方法的申明，以及方法的实现。添加属性的话会因为没有实现set,get方法而报错。但是如果使用runtime，是可以设置属性的。
#import <objc/runtime.h>

@implementation UIViewController (Log)

static char *nameKey = "name";
- (void)setName:(NSString *)name {
//    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, nameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
   return objc_getAssociatedObject(self, @"name");
}

/*
 Selector（typedef struct objc_selector *SEL）:
 
 在运行时 Selectors 用来代表一个方法的名字。
 Selector 是一个在运行时被注册（或映射）的C类型字符串。
 Selector 由编译器产生并且在当类被加载进内存时由运行时自动进行名字和实现的映射。
 
 Method （typedef struct objc_method *Method）:
 
 方法是一个不透明的用来代表一个方法的定义的类型。
 Implementation（typedef id (*IMP)(id, SEL,...)）:
 
 这个数据类型指向一个方法的实现的最开始的地方。该方法为当前CPU架构使用标准的C方法调用来实现。该方法的第一个参数指向调用方法的自身（即内存中类的实例对象，若是调用类方法，该指针则是指向元类对象metaclass）。第二个参数是这个方法的名字selector，该方法的真正参数紧随其后。*/

//swizzling应该只在+load中完成。
//在Objective-C的运行时中，每个类有两个方法都会自动调用。
//+load是在一个类被初始装载时调用，
+ (void)load {//swizzling应该只在+load中完成 只会执行一次
    
    static dispatch_once_t onceToken;//** swizzling 应该只在 dispatch_once 中完成**
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(viewDidLoad);///key
        
        SEL swizzledSelector =@selector(log_viewDidLoad);
        
        Method originalMethod =class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod =class_getInstanceMethod([self class], swizzledSelector);//获取实例方法
        
        BOOL isAddMethod  = class_addMethod([self class],           originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
        
        if(isAddMethod) {
            
            class_replaceMethod([self class],
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
            
        }else{
            
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
}
#pragma mark - Method Swizzling

- (void)log_viewDidLoad {
    [self log_viewDidLoad];
    NSLog(@"log_viewDidLoad: %@", [self class]);
}

@end
