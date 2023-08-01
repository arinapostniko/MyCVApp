//
//  SkillCell.swift
//  MyCVApp
//
//  Created by Arina Postnikova on 1.08.23.
//

import UIKit

class SkillCell: UICollectionViewCell {
    static let identifier = "SkillCell"
    
    var deleteButton: UIButton!
    var title: String = "" {
        didSet {
            skillLabel.text = title
        }
    }
    
    @IBOutlet weak var skillLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title = ""
        disableEditMode()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func setup(with text: String, isEditMode: Bool) {
        skillLabel.text = text
        layer.cornerRadius = 12
    }
    
    func editModeIsOn() {
        deleteButton = UIButton(frame: CGRect(x: skillLabel.frame.maxX + 2, y: skillLabel.frame.minY + 1.5, width: 14, height: 14))
        deleteButton.setImage(UIImage(named: "crosss"), for: .normal)
        
        self.addSubview(deleteButton)
    }
    
    func editModeIsOff() {
        if let button = deleteButton {
            button.removeFromSuperview()
        }
    }
    
    func disableEditMode( ){
        if let button = deleteButton {
            button.removeFromSuperview()
        }
    }
}
