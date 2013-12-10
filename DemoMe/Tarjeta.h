//
//  Tarjeta.h
//  DemoMe
//
//  Created by Emiliano Bivachi on 06/12/13.
//  Copyright (c) 2013 Emiliano Bivachi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tarjeta : NSObject

@property (nonatomic, strong) NSString *numero;
@property (nonatomic, strong) NSString *cvv;
@property (nonatomic, strong) NSString *nombre;
@property (nonatomic, strong) NSString *fecha;

@property (nonatomic, strong) NSString *entidad;

@end
