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
        
        updateEditModeUI()
    }
    
    private func updateEditModeUI() {
        if isEditMode {
            let addSkillButton = UIButton(type: .system)
            addSkillButton.setTitle("+", for: .normal)
            addSkillButton.tintColor = .black
            addSkillButton.addTarget(self, action: #selector(addSkillButtonPressed), for: .touchUpInside)
            collectionView.addSubview(addSkillButton)
            addSkillButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addSkillButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                addSkillButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            ])
        } else {
            let addSkillButton = collectionView.subviews.first { $0 is UIButton }
            addSkillButton?.removeFromSuperview()
        }
    }
    
    // MARK: - IBActions
    @IBAction func editButtonPressed(_ sender: UIButton) {
        isEditMode.toggle()
        sender.setImage(UIImage(named: isEditMode ? "checkmark" : "pencil"), for: .normal)
        viewModel.editSkills()
        updateEditModeUI()
        collectionView.reloadData()
        self.view.layoutIfNeeded()
    }
}

// MARK: - UICollectionView
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.skills.count
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