//
//  ShowMAC.m
//  ConView
//
//  Created by Philipp Fehre on 5/9/12.
//  Copyright (c) 2012 Cospired. All rights reserved.
//

#import "ShowMAC.h"
//  Get mac from network interface
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


@implementation ShowMAC

// Based on Stackoverflow posts about getting the MAC address on a Mac in ObjC 
- (NSString *)getMacAddress
{
  int                 mgmtInfoBase[6];
  char                *msgBuffer = NULL;
  size_t              length;
  unsigned char       macAddress[6];
  struct if_msghdr    *interfaceMsgStruct;
  struct sockaddr_dl  *socketStruct;
  NSString            *errorFlag = NULL;
 
  // Setup the management Information Base (mib)
  mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
  mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
  mgmtInfoBase[2] = 0;              
  mgmtInfoBase[3] = AF_LINK;        // Request link layer information
  mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
 
  // With all configured interfaces requested, get handle index
  if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) 
    errorFlag = @"if_nametoindex failure";
  else
  {
    // Get the size of the data available (store in len)
    if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) 
      errorFlag = @"sysctl mgmtInfoBase failure";
    else
    {
      // Alloc memory based on above call
      if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
      else
      {
        // Get system information, store in buffer
        if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
          errorFlag = @"sysctl msgBuffer failure";
      }
    }
  }
 
  // Befor going any further...
  if (errorFlag != NULL)
  {
    NSLog(@"Error: %@", errorFlag);
    return errorFlag;
  }
 
  // Map msgbuffer to interface message structure
  interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
 
  // Map to link-level socket structure
  socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
 
  // Copy link layer address data in socket structure to an array
  memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
 
  // Read from char array into a string object, into traditional Mac address format
  NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                                macAddress[0], macAddress[1], macAddress[2], 
                                macAddress[3], macAddress[4], macAddress[5]];
 
  // Release the buffer memory
  free(msgBuffer);
 
  return macAddressString;
}

// 
- (void)getMAC:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
{
  //get the callback id
  NSString *callbackId = [arguments pop];
 
  CDVPluginResult *result;
  
  result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[self getMacAddress]];
  [self writeJavascript:[result toSuccessCallbackString:callbackId]];
}



@end
