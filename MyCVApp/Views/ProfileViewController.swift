//
//  ViewController.swift
//  MyCVApp
//
//  Created by Arina Postnikova on 1.08.23.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Private properties
    private let viewModel = ProfileViewModel()
    private var isEditMode = false
    
    // MARK: - IBOutlets
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var photo: UIImageView! {
        didSet {
            photo.layer.cornerRadius = photo.frame.width / 2
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skillCell: UICollectionViewCell!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        photo.image = UIImage(named: viewModel.profile.photo)
        nameLabel.text = viewModel.profile.name
        taglineLabel.text = viewModel.profile.tagline
        locationLabel.text = viewModel.profile.location
        aboutLabel.text = viewModel.profile.about
        
        scrollView.contentSize = CGSize(
            width: scrollView.frame.width,
            height: aboutLabel.frame.origin.y + aboutLabel.frame.height
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    
    // MARK: - IBActions
    @IBAction func editButtonPressed(_ sender: UIButton) {
        isEditMode.toggle()
        sender.setImage(UIImage(named: isEditMode ? "checkmark" : "pencil"), for: .normal)
        viewModel.editSkills()
        collectionView.reloadData()
        self.view.layoutIfNeeded()
    }
}

// MARK: - UICollectionView
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isEditMode ? viewModel.skills.count + 1 : viewModel.skills.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SkillCell.self)", for: indexPath)
        if let cell = cell as? SkillCell {
            if indexPath.row < viewModel.skills.count {
                cell.title = viewModel.skills[indexPath.row]
                if isEditMode {
                    cell.editModeIsOn()
                    cell.deleteButton.addTarget(self, action:  #selector(self.deleteSkillButtonPressed(_:)), for: .touchUpInside)
                } else {
                    cell.editModeIsOff()
                }
            } else {
                cell.title = "+"
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tap")
        guard indexPath.row == viewModel.skills.count else {
            return
        }
    
        let alert = UIAlertController(title: "Добавление навыка", message: "Введите название навыка которым вы владеете", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction.init(title: "Добавить", style: .default, handler: { [self] action in
            if let textField = alert.textFields?.first, let text = textField.text {
                viewModel.skills.append(text)
                collectionView.reloadData()
                self.view.layoutIfNeeded()
            }
        })
        alert.addTextField {
            (textField) in textField.placeholder = "Введите название"
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func addSkillButtonPressed() {
        let alertController = UIAlertController(title: "Добавление навыка", message: "Введите название навыка которым вы владеете", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, let skillName = textField.text else {
                return
            }
            self?.viewModel.addSkill(name: skillName)
            self?.collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func deleteSkillButtonPressed(_ sender: UIButton) {
        viewModel.deleteSkill(at: sender.tag)
        collectionView.reloadData()
    }
}
