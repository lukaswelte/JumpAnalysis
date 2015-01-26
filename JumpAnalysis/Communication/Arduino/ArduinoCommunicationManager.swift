//
//  ArduinoCommunicationManager.swift
//  JumpAnalysis
//
//  Created by Lukas Welte on 19.01.15.
//  Copyright (c) 2015 Lukas Welte. All rights reserved.
//

import Foundation

private let _SharedInstance = ArduinoCommunicationManager()

class ArduinoCommunicationManager: NSObject, BLEDiscoveryDelegate, BLEServiceDelegate, BLEServiceDataDelegate {
    
    let numberOfRequiredSensors: Int = 1
    var shouldAutomaticallyReconnect = false
    
    class var sharedInstance: ArduinoCommunicationManager {
        return _SharedInstance
    }

    var sensorDataDelegate: SensorDataDelegate? = nil

    override init() {
        super.init()
        let sharedInstance = BLEDiscovery.sharedInstance()
        sharedInstance.discoveryDelegate = self
        sharedInstance.peripheralDelegate = self
        
        sharedInstance.startScanningForSupportedUUIDs()
    }
    
    func isAbleToReceiveSensorData() -> Bool {
        let foundPeripherals = BLEDiscovery.sharedInstance().foundPeripherals.count
        NSLog("Found %d Peripherals", foundPeripherals)
        return foundPeripherals == numberOfRequiredSensors
    }
    
    func connectToPeripherals() {
        let sharedInstance = BLEDiscovery.sharedInstance()
        for object in sharedInstance.foundPeripherals {
            if let peripheral = object as? CBPeripheral {
                sharedInstance.connectPeripheral(peripheral)
            }
        }
    }
    
    func disconnectFromPeripherals() {
        NSLog("Disconnect from Peripherals ...")
        BLEDiscovery.sharedInstance().disconnectConnectedPeripherals()
    }
    
    func startReceivingSensorData() {
        self.shouldAutomaticallyReconnect = true
        
        self.connectToPeripherals()
    }
    
    func stopReceivingSensorData() {
        self.shouldAutomaticallyReconnect = false
        
        self.disconnectFromPeripherals()
    }
    
//Mark: BLEDiscovery
    
    func discoveryDidRefresh() {
        NSLog("Discovered did refresh")
        if (self.isAbleToReceiveSensorData()) {
            self.connectToPeripherals()
        }
    }
    
    func peripheralDiscovered(peripheral: CBPeripheral!) {
        NSLog("Discovered Peripherial: %@", peripheral)
        if (self.isAbleToReceiveSensorData()) {
            self.connectToPeripherals()
        }
    }
    
    func discoveryStatePoweredOff() {
        NSLog("Discovery State Powerered Off ...")
    }
    
    
//MARK: BLEServiceProtocol
    
    func bleServiceDidConnect(service: BLEService!) {
        service.delegate = self
        service.dataDelegate = self
        
        NSLog("bleServiceDidConnect:%@", service);
    }
    
    func bleServiceDidDisconnect(service: BLEService!) {
        NSLog("bleServiceDidDisconnect:%@", service);
    }
    
    func bleServiceIsReady(service: BLEService!) {
        NSLog("bleServiceIsReady:%@", service);
    }
    
    func bleServiceDidReset() {
        NSLog("bleServiceDidReset");
    }
    
//MARK: BLEServiceData Delegate
    
    func didReceiveData(data: UnsafeMutablePointer<UInt8>, length: Int) {
        if (length == 15) {
            let sensorID = Int(data[14])
            
            let helperQuaternion = BluetoothHelper.calculateQuaternionFromSensorData(data)
            
            let quaternion = Quaternion(w: helperQuaternion.w, x: helperQuaternion.x, y: helperQuaternion.y, z: helperQuaternion.z)
            
            let helperRawAcceleration = BluetoothHelper.calculateAccelerationFromSensorData(data)
            
            let rawAcceleration = RawAcceleration(x: helperRawAcceleration.x, y: helperRawAcceleration.y, z: helperRawAcceleration.z)
            
            let sensorData = SensorData(sensorID: sensorID, rawAcceleration: rawAcceleration, quaternion: quaternion)
            
            if let delegate = self.sensorDataDelegate {
                delegate.didReceiveData(sensorData)
            }
        }
    }
    
}