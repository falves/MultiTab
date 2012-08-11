//
//  ConversorDeDinheiro.h
//  MultiTab
//
//  Created by Felipe Alves on 11/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConversorDeDinheiro : NSObject

+ (NSString*) converteNumberParaString:(NSNumber*)number;
+ (NSNumber*) converteStringParaNumber:(NSString*)string;

@end
