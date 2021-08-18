//
//  ActionLoadingProtocol.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

protocol ActionLoadingProtocol {
    
    var instanceHolder: InstanceHolder { get }
    
    var parentController: UIViewController { get }
    
    func showActionLoader(_ message: String)
    func showActionLoader(_ message: String, animated: Bool)
    func hideActionLoader()
    func hideActionLoader(animated: Bool)
    func hideActionLoader(completion: (() -> Void)?)
    func hideActionLoader(animated: Bool, completion: (() -> Void)?)

    func hideActionLoader(status: ActionLoadingController.SuccessType, animated: Bool, completion: (() -> Void)?)

}

extension ActionLoadingProtocol where Self: UIViewController {
    
    var parentController: UIViewController {
        return self.navigationController ?? self
    }

    func showActionLoader(_ message: String) {

        self.showActionLoader(message, animated: true)

    }
    
    func showActionLoader(_ message: String, animated: Bool) {

        let actionLoader = ActionLoadingController()

        actionLoader.label.text = message
        actionLoader.activity.startAnimating()
        actionLoader.modalTransitionStyle = .crossDissolve
        actionLoader.modalPresentationStyle = .overCurrentContext
        self.instanceHolder.actionLoader = actionLoader

        parentController.present(actionLoader, animated: animated, completion: nil)
    }

    func hideActionLoader() {
        self.hideActionLoader(animated: true, completion: nil)
    }
    
    func hideActionLoader(animated: Bool) {
        self.hideActionLoader(animated: animated, completion: nil)
    }

    func hideActionLoader(completion: (() -> Void)?) {
        self.hideActionLoader(animated: true, completion: completion)
    }
    
    func hideActionLoader(animated: Bool, completion: (() -> Void)?) {
        if let actionLoader = self.instanceHolder.actionLoader {
            actionLoader.dismiss(animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
    
    func hideActionLoader(status: ActionLoadingController.SuccessType, animated: Bool, completion: (() -> Void)?) {
        if let actionLoader = self.instanceHolder.actionLoader {
            actionLoader.show(status: status, completion: completion)
        } else {
            completion?()
        }
    }

}

class ActionLoadingController: ParentViewController {
    
    enum SuccessType {
        case success(message: String)
        case failure(message: String)
        
        var icon: UIImage? {
            switch self {
            case .success:
                return Asset.icCheck.templateImage
            case .failure:
                return Asset.icClose.templateImage
            }
        }
        
        var message: String {
            switch self {
            case .success(let message):
                return message
            case .failure(let message):
                return message
            }
        }
        
        var color: UIColor {
            switch self {
            case .success:
                return .systemGreen
            case .failure:
                return .systemRed
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.iconView.layer.cornerRadius = self.iconView.frame.width / 2
    }
    
    private var timer: Timer?
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (timer) in
            timer.invalidate()
            if let text = self.label.text {
                self.label.text = text + "\n\(Strings.actionLoadingDelayMessage)"
            }
        })
    }
    
    private(set) lazy var label: UILabel = {
        let label = UILabel.default()
        label.font = UIFont.customFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .gray)
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private(set) lazy var iconView: UIImageView = {
        let iconView = UIImageView(image: Asset.icCheck.templateImage)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.isHidden = true
        iconView.tintColor = .white
        return iconView
    }()
    
    private func configureView() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.backgroundColor = .white
        holder.layer.cornerRadius = 10
        self.view.addSubview(holder)
        
        holder.addSubview(activity)
        holder.addSubview(label)
        holder.addSubview(iconView)

        NSLayoutConstraint.activate([
            holder.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: 10),
            holder.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            holder.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            activity.leadingAnchor.constraint(equalTo: holder.leadingAnchor, constant: 20),
            activity.centerYAnchor.constraint(equalTo: holder.centerYAnchor),
            
            label.trailingAnchor.constraint(equalTo: holder.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: holder.topAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: holder.bottomAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: activity.trailingAnchor, constant: 020),
            
            iconView.centerXAnchor.constraint(equalTo: activity.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: activity.centerYAnchor),
            iconView.widthAnchor.constraint(equalTo: activity.widthAnchor),
            iconView.heightAnchor.constraint(equalTo: activity.heightAnchor),
        ])
    }
    
    func show(status: SuccessType, completion: (() -> Swift.Void)?) {
        timer?.invalidate()

        self.activity.stopAnimating()
        
        self.iconView.backgroundColor = status.color
        self.iconView.image = status.icon
        self.label.text = status.message

        self.iconView.isHidden = false
        
        self.iconView.transform = self.iconView.transform.scaledBy(x: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.iconView.transform = self.iconView.transform.scaledBy(x: 1/0.1, y: 1/0.1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: completion)
        }
    }
}

extension UIViewController {
    func showAlertMessage(_ message: String) {
        self.showAlertMessage(message, completion: nil)
    }
    
    func showAlertMessage(_ message: String, completion: (() -> Swift.Void)?) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: Strings.done, style: .cancel) { (action) in
            completion?()
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
