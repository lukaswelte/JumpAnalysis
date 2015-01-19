//
//  BluetoothHelper.m
//  JumpAnalysis
//
//  Created by Lukas Welte on 19.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

#import "BluetoothHelper.h"


@implementation BluetoothHelper
+ (BluetoothHelperQuaternion *)calculateQuaternionFromSensorData:(uint8_t *)data {
    BluetoothHelperQuaternion *quaternion = [BluetoothHelperQuaternion new];
    
    float q[] = { 0.0f, 0.0f, 0.0f, 0.0f };
    
    q[0] = ((data[6] << 8) | data[7]) / 16384.0f;
    q[1] = ((data[8] << 8) | data[9]) / 16384.0f;
    q[2] = ((data[10] << 8) | data[11]) / 16384.0f;
    q[3] = ((data[12] << 8) | data[13]) / 16384.0f;
    
    for (int i = 0; i < 4; i++) {
        if (q[i] >= 2.0f) {
            q[i] -= 4.0f;
        }
    }
    
    quaternion.w = q[0];
    quaternion.x = q[1];
    quaternion.y = q[2];
    quaternion.z = q[3];
    
    return quaternion;
}

+ (BluetoothHelperAcceleration *)calculateAccelerationFromSensorData:(uint8_t *)data {
    BluetoothHelperAcceleration *acceleration = [BluetoothHelperAcceleration new];
    
    acceleration.x = (data[0] << 8) | data[1];
    acceleration.y = (data[2] << 8) | data[3];
    acceleration.z = (data[4] << 8) | data[5];
    
    return acceleration;
}

@end

@implementation BluetoothHelperQuaternion


@end

@implementation BluetoothHelperAcceleration


@end
