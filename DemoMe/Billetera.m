//
//  Billetera.m
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import "Billetera.h"

@implementation Billetera

+ (id)sharedBilletera {
    static Billetera *sharedMyBilletera = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyBilletera = [[self alloc] init];
    });
    return sharedMyBilletera;
}

- (id)init {
    if (self = [super init]) {
        self.misTarjetas = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addTarjeta:(Tarjeta *)tarjeta
{
    [self.misTarjetas addObject:tarjeta];
}

@end
