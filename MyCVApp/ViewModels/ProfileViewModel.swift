//
//  ProfileViewModel.swift
//  MyCVApp
//
//  Created by Arina Postnikova on 1.08.23.
//

import UIKit

class ProfileViewModel {
    var profile = Profile(
        photo: "user",
        name: "Arina Postnikova",
        tagline: "iOS Developer",
        location: "Minsk, Belarus",
        skills: ["Swift", "UIKit", "MVVM"],
        about: "I'm an iOS developer with a passion for building awesome apps."
    )
    
    var skills: [String] = [
        "Swift",
        "UIKit",
        "SwiftUI",
        "MVVM",
        "API",
        "Realm",
        "SOLID",
        "HIG",
        "OOP",
        "GIT"
    ]
    
    func addSkill(name: String) {
        let skill = name
        skills.append(skill)
    }
    
    func deleteSkill(at index: Int) {
        skills.remove(at: index)
    }
    
    func editSkills() {
        
    }
}
