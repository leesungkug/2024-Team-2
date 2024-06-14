//
//  ContentView.swift
//  13jo
//
//  Created by sungkug_apple_developer_ac on 6/14/24.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager
    @Published var isDeviceFlipped: Bool = false
    
    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = 0.1
        
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                guard let data = data, error == nil else { return }
                self?.handleDeviceMotion(data: data)
            }
        }
    }
    
    private func handleDeviceMotion(data: CMAccelerometerData) {
        let acceleration = data.acceleration
        DispatchQueue.main.async {
            self.isDeviceFlipped = acceleration.z < -0.9
        }
    }
}

struct ContentView: View {
    @StateObject private var motionManager = MotionManager()
    
    var body: some View {
        VStack {
            if motionManager.isDeviceFlipped {
                Text("Device is flipped upside down")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            } else {
                Text("Device is not flipped")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}



#Preview {
    ContentView()
}
