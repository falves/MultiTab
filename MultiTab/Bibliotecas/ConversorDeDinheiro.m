//
//  ConversorDeDinheiro.m
//  MultiTab
//
//  Created by Felipe Alves on 11/08/12.
//  Copyright (c) 2012 Bolzani. All rights reserved.
//

#import "ConversorDeDinheiro.h"

@implementation ConversorDeDinheiro

+ (NSString*) converteNumberParaString:(NSNumber*)number {
    
    if (number == 0) {
        return @"R$0,00";
    } else {
        
        NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
        //    locale = [NSLocale currentLocale];
        NSNumberFormatter * currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setMaximumFractionDigits:2];
        [currencyFormatter setLocale:locale];
        
        return [currencyFormatter stringFromNumber:number];

    }
    
}

+ (NSNumber*) converteStringParaNumber:(NSString*)numeroString {

    numeroString = [numeroString stringByReplacingOccurrencesOfString:@"." withString:@""];
    numeroString = [numeroString stringByReplacingOccurrencesOfString:@"," withString:@""];
    numeroString = [numeroString stringByReplacingOccurrencesOfString:@"R$" withString:@""];
        
    return [NSNumber numberWithDouble:[numeroString doubleValue]/100];
}

@end
