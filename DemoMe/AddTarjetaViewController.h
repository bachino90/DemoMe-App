//
//  AddTarjetaViewController.h
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tarjeta.h"

@protocol AddTarjetaDelegate <NSObject>
- (void)cancelAddTarjeta;
- (void)addTarjeta:(Tarjeta *)tarjeta;
@end

@interface AddTarjetaViewController : UIViewController
@property (nonatomic, weak) id <AddTarjetaDelegate> delegate;
@end
