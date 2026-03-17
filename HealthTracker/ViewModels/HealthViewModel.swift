//
//  HealthViewModel.swift
//  HealthTracker
//
//  Created by Fai on 16/03/26.
//

import Foundation
import HealthKit
import Combine

@MainActor
class HealthViewModel: ObservableObject {
    @Published var steps: Int = 0
    @Published var distance: Double = 0.0
    @Published var activityStatus: String = "Not Active"
    @Published var authStatus: String = "Not requested"
    @Published var isAuthorized: Bool = false
    @Published var isLoading: Bool = false
    @Published var lastUpdated: String = ""
    
    private let healthStore = HKHealthStore()
    
    init() {
        checkHealthDataAvailability()
    }
    
    private func checkHealthDataAvailability() {
        if !HKHealthStore.isHealthDataAvailable() {
            authStatus = "Not Available"
        }
    }
    
    func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isAuthorized = true
                    self.authStatus = "Authorized"
                    self.fetchAllData()
                } else {
                    self.isAuthorized = false
                    self.authStatus = "Denied"
                }
            }
        }
    }
    
    func fetchAllData() {
        guard isAuthorized else { return }
        isLoading = true
        
        let group = DispatchGroup()
        
        group.enter()
        fetchTodaySteps { group.leave() }
        
        group.enter()
        fetchTodayDistance { group.leave() }
        
        group.notify(queue: .main) {
            self.isLoading = false
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            self.lastUpdated = formatter.string(from: Date())
            self.updateActivityStatus()
        }
    }
    
    private func fetchTodaySteps(completion: @escaping () -> Void) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            completion()
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    self.steps = Int(sum.doubleValue(for: HKUnit.count()))
                } else {
                    self.steps = 0
                }
                completion()
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchTodayDistance(completion: @escaping () -> Void) {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion()
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            DispatchQueue.main.async {
                if let sum = result?.sumQuantity() {
                    let distanceInMeters = sum.doubleValue(for: HKUnit.meter())
                    self.distance = distanceInMeters / 1000.0 // Converting meters to km
                } else {
                    self.distance = 0.0
                }
                completion()
            }
        }
        healthStore.execute(query)
    }
    
    private func updateActivityStatus() {
        if steps < 2000 {
            activityStatus = "Sedentary"
        } else if steps < 5000 {
            activityStatus = "Lightly Active"
        } else if steps < 7000 {
            activityStatus = "Moderately Active"
        } else if steps < 10000 {
            activityStatus = "Active"
        } else {
            activityStatus = "Very Active"
        }
    }
}
