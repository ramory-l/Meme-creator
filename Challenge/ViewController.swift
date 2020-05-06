//
//  ViewController.swift
//  Challenge
//
//  Created by Mikhail Strizhenov on 06.05.2020.
//  Copyright © 2020 Mikhail Strizhenov. All rights reserved.
//

import UIKit
import CoreGraphics

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imageView: UIImageView!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        title = "Meme creator"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sendPhoto))
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        var topText: String? = "Test"
        var bottomText: String? = "test"
        
        dismiss(animated: true)
        
        let firstAc = UIAlertController(title: "Line of text for top", message: nil, preferredStyle: .alert)
        firstAc.addTextField()
        
        firstAc.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak firstAc] _ in
            topText = firstAc?.textFields?[0].text
            let secondAc = UIAlertController(title: "Line of text for bottom", message: nil, preferredStyle: .alert)
            secondAc.addTextField()
            secondAc.addAction(UIAlertAction(title: "Submit", style: .default) { [weak secondAc] _ in
                bottomText = secondAc?.textFields?[0].text
                self?.draw(topText: topText!, and: bottomText!, with: image)
            })
            self?.present(secondAc, animated: true)
        })
        present(firstAc, animated: true)
        
    }
    
    func draw(topText: String, and bottomText: String, with image: UIImage) {
        let renderer = UIGraphicsImageRenderer(size: image.size)

        let imageToRender = renderer.image { ctx in
            image.draw(at: .zero)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 64),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
            
            var rectangle = CGRect(x: 0, y: 0, width: image.size.width, height: 100)
            let firstAttributedString = NSAttributedString(string: topText, attributes: attrs)
            let secondAttributedString = NSAttributedString(string: bottomText, attributes: attrs)
            
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            firstAttributedString.draw(in: rectangle)
            
            rectangle = CGRect(x: 0, y: image.size.height - 100, width: image.size.width, height: 100)
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            secondAttributedString.draw(in: rectangle)
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageToRender
    }
    
    @objc func addPhoto() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func sendPhoto() {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No image found", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
            return
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }
}

