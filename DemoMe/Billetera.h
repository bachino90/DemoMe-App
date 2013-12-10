//
//  Billetera.h
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tarjeta.h"

@interface Billetera : NSObject

@property (nonatomic, strong) NSMutableArray *misTarjetas;

+ (instancetype)sharedBilletera;
- (void)addTarjeta:(Tarjeta *)tarjeta;

@end
