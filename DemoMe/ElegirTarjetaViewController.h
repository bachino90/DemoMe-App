//
//  ElegirTarjetaViewController.h
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tarjeta.h"

@protocol ElegirTarjetaDelegate <NSObject>
- (void)cancel;
- (void)choseTarjeta:(Tarjeta *)tarjeta andSave:(BOOL)save;
@end

@interface ElegirTarjetaViewController : UIViewController
@property (nonatomic, weak) id <ElegirTarjetaDelegate> delegate;
@end
