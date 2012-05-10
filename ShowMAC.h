//
//  ShowMAC.h
//  ConView
//
//  Created by Philipp Fehre on 5/9/12.
//  Copyright (c) 2012 Cospired. All rights reserved.
//


#import <Foundation/Foundation.h>

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPlugin.h>
#else
    #import "CDVPlugin.h"
#endif

@interface ShowMAC : CDVPlugin 

- (void)getMAC:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
