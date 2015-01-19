//
//  BluetoothHelper.h
//  JumpAnalysis
//
//  Created by Lukas Welte on 19.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluetoothHelperQuaternion : NSObject
@property (nonatomic) double w;
@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) double z;

@end

@interface BluetoothHelperAcceleration : NSObject
@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) double z;

@end

@interface BluetoothHelper : NSObject
+ (BluetoothHelperQuaternion *)calculateQuaternionFromSensorData:(uint8_t *)data;
+ (BluetoothHelperAcceleration *)calculateAccelerationFromSensorData:(uint8_t *)data;
@end

