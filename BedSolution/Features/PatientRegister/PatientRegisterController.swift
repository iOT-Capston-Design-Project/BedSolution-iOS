//
//  PatientRegisterController.swift
//  BedSolution
//
//  Created by 이재호 on 9/4/25.
//

import Foundation

enum PatientRegisterStep: CaseIterable {
    case name, weight, caution, registering
    
    var step: Double {
        switch self {
        case .name:
            0.1
        case .weight:
            0.45
        case .caution:
            0.70
        case .registering:
            1
        }
    }
    
    var name: LocalizedStringResource {
        switch self {
        case .name:
            "환자명"
        case .weight:
            "몸무게"
        case .caution:
            "주요부위"
        case .registering:
            "등록완료"
        }
    }
}

@Observable
class PatientRegisterController {
    var name: String = ""
    var weight: Int = 15
    var occiputTime: Int? = nil
    var scapulaTime: Int? = nil
    var elbowTime: Int? = nil
    var hipTime: Int? = nil
    var heelTime: Int? = nil
    var isFailed: Bool = false
    private(set) var currentStep: PatientRegisterStep = .name
    var dismissEnabled: Bool { currentStep != .registering }
    private(set) var isRegistering: Bool = false
    private let repo = PatientRepository()
    
    func nextStep() {
        switch currentStep {
        case .name:
            currentStep = .weight
        case .weight:
            currentStep = .caution
        case .caution:
            currentStep = .registering
        case .registering:
            break
        }
    }
    
    func backStep() {
        switch currentStep {
        case .name:
            break
        case .weight:
            currentStep = .name
        case .caution:
            currentStep = .weight
        case .registering:
            currentStep = .caution
        }
    }
    
    func register(uid: UUID?) {
        guard let uid else {
            isFailed = true
            return
        }
        isRegistering = true
        isFailed = false
        
        Task {
            defer {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
                    self?.isRegistering = false
                }
            }
            do {
                try await repo.insert(
                    Patient(
                        id: nil, createdAt: .now, updatedAt: nil, uid: uid,
                        name: name, height: nil, weight: Float(weight),
                        occiputTime: occiputTime, scapulaTime: scapulaTime,
                        elbowTime: elbowTime, hipTime: hipTime, heelTime: heelTime,
                        deviceID: nil
                    )
                )
            } catch {
                isFailed = true
            }
        }
    }
}
