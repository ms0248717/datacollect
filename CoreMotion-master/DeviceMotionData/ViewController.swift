//
//  ViewController.swift
//  DeviceMotionData
//
//  Created by 太阳在线YHY on 2017/6/21.
//  Copyright © 2017年 太阳在线. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

	let motionManager = CMMotionManager()
	var timer: Timer!
	let altimeter = CMAltimeter()
    var number = 0
    
    let kFilteringFactor = 0.1
    var rollingX = 0.0
    var rollingY = 0.0
    var rollingZ = 0.0
    
    //Exporting CSV
    var csvText = "\("x"),\("y"),\("z")\n"
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// 判断DeviceMotion服务是否在设备上可用
		guard motionManager.isDeviceMotionAvailable else {
			print("DeviceMotion 不可用")
			return
		}
		
		motionManager.startDeviceMotionUpdates()
		
		print(motionManager.isDeviceMotionActive) // print false

	}

	// 设备运动
	@IBAction func getDeviceMotion(_ sender: UIButton) {
		
		// 设置获取的时间间隔
		motionManager.deviceMotionUpdateInterval = 1.0 / 100.0
		//motionManager.showsDeviceMovementDisplay = true
		// 开始获取数据
		motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (motions, error) in
			
			guard let motion = motions else {
				return
			}
			 // 设备现在所处的的物理状态
			/*print("2.",motion.rotationRate)
			// 设备的转速。
			print("2.",motion.gravity)
			  // 在设备参考系中表示的重力加速度矢量。
		    print("2.",motion.attitude.pitch,
		         motion.attitude.roll,motion.attitude.yaw)
			// 用户给设备的加速度。*/
            /*self.rollingX = (motion.userAcceleration.x * self.kFilteringFactor) + (self.rollingX * (1.0 - self.kFilteringFactor))
            self.rollingY = (motion.userAcceleration.y * self.kFilteringFactor) + (self.rollingY * (1.0 - self.kFilteringFactor))
            self.rollingZ = (motion.userAcceleration.z * self.kFilteringFactor) + (self.rollingZ * (1.0 - self.kFilteringFactor))*/
            
            //Save Data
            let x = motion.userAcceleration.x
            let y = motion.userAcceleration.y
            let z = motion.userAcceleration.z
            //print(motion.rotationRate)
            
            self.number += 1
            let newLine = "\(x),\(y),\(z)\n"
            self.csvText.append(contentsOf: newLine)
            print(self.number)
			//print(motion.userAcceleration)
			
		}
		//  注意： 下边的两种方法会导致，上边的那种方法失效，用的时候请根据自己的需求选择
//		motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
//		print(deviceMotion.rotationRate)
//		
//		motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: OperationQueue.current!) { (motions, error) in
//			
//			guard let motion = motions else {
//				return
//			}
//			
//			print("3.",motion.rotationRate)
//			print("3.",motion.gravity)
//			print("3.",motion.attitude)
//			print("3.",motion.userAcceleration)
//
//			
//		}
	
	}
	
	// 陀螺仪
	@IBAction func startGyroData(_ sender: UIButton) {
		
		// 判断陀螺仪在设备上是否可用
		if motionManager.isGyroAvailable {
			
			motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
				guard let gyroData = data else {
					return
				}

				// 旋转速率
				print(gyroData.rotationRate)
				
			}
			
		}

		
	}
	
	
	// 加速计
	@IBAction func getAccelerometers(_ sender: UIButton) {
		// 使用Core Motion框架的类访问原始加速度计数据。具体来说，该类提供了启用加速度计硬件的接口。在启用该硬件之前，请始终检查该属性的值以验证加速度计是否可供您使用。启用硬件时，请选择最适合您应用的界面。您只能在需要时拉动加速度计数据，或者您可以要求框架定期将更新推送到您的应用程序。每个技术涉及不同的配置步骤，并且具有不同的用例
		// 判断Accelerometer是否在设备上可用。
		if self.motionManager.isAccelerometerAvailable {
			self.motionManager.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
			self.motionManager.startAccelerometerUpdates()
			
			// Configure a timer to fetch the data.
			self.timer = Timer(fire: Date(), interval: (1.0 / 60.0),
			                   repeats: true, block: { (timer) in
								// 获取 accelerometer 数据.
								if let data = self.motionManager.accelerometerData {
									let x = data.acceleration.x
									let y = data.acceleration.y
									let z = data.acceleration.z
									print(x,y,z)
								}
			})
			
			// Add the timer to the current run loop.
			RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
		}
		
		
		self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
			
			guard let accelerometerData = data else {
				return
			}
			let x = accelerometerData.acceleration.x
			let y = accelerometerData.acceleration.y
			let z = accelerometerData.acceleration.z
			print(x,y,z)
			
		}
		

		
	}
	
	
	@IBAction func getMagnetometer(_ sender: UIButton) {
		
		// 判断磁力计在设备上是否可用
		guard motionManager.isMagnetometerAvailable else {
			return
		}
		// 获取数据
		motionManager.startMagnetometerUpdates()
		if let data = motionManager.magnetometerData {
			print(data.magneticField)
		}
		
		// 获取数据
		motionManager.startMagnetometerUpdates(to: OperationQueue.current!) { (data, error) in
			
			guard let magnetomeeterData = data else {
				return
			}
			print(magnetomeeterData.magneticField)
			
		}
		
	}

	// 获取海拔高度。不再是使用CMMotionManager获取了
	@IBAction func getAltitude(_ sender: UIButton) {
		
		
		if CMAltimeter.isRelativeAltitudeAvailable() {
			
			print(OperationQueue.current!.name!)
			
			let queue = OperationQueue()
			queue.name = "Altitude"
			queue.maxConcurrentOperationCount = 1
			
			altimeter.startRelativeAltitudeUpdates(to: queue, withHandler: { (data, error) in
				guard let altimeterData = data else {
					return
				}
				print(altimeterData.relativeAltitude)
				print(altimeterData.pressure)
			})
		}

		
	}
	

	@IBAction func stop(_ sender: UIButton) {
		
		motionManager.stopDeviceMotionUpdates()
		motionManager.stopGyroUpdates()
		motionManager.stopMagnetometerUpdates()
		motionManager.stopAccelerometerUpdates()
		altimeter.stopRelativeAltitudeUpdates()
		print(csvText)
        let fileManager = FileManager.default
        do {
            //let path = Bundle.main.path(forResource: "data", ofType: "csv")
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("data.csv")
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            vc.excludedActivityTypes = [
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo,
                UIActivityType.postToTwitter,
                UIActivityType.postToFacebook,
                UIActivityType.openInIBooks
            ]
            present(vc, animated: true, completion: nil)
            csvText.removeAll()
            csvText = "\("x"),\("y"),\("z")\n"
            number = 0
            //print(path)
        } catch {
            print("error creating file")
        }
	}

}

