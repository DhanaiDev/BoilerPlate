//
//  ContentLoadingProtocol.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

protocol ContentLoadingProtocol : AnyObject
{
    func showContentLoader()
    func hideContentLoader()
}


extension ContentLoadingProtocol where Self : UIViewController
{
    
    func showContentLoader() {
        self.hideContentLoader()
        let contentLoadingController = ContentLoadingController()
        self.addChild(contentLoadingController)
        self.view.addSubview(contentLoadingController.view)
        
        contentLoadingController.didMove(toParent: self)
        
        contentLoadingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLoadingController.view.topAnchor.constraint(equalTo: self.view.layoutGuide.topAnchor),
            contentLoadingController.view.leadingAnchor.constraint(equalTo: self.view.layoutGuide.leadingAnchor),
            contentLoadingController.view.bottomAnchor.constraint(equalTo: self.view.layoutGuide.bottomAnchor),
            contentLoadingController.view.trailingAnchor.constraint(equalTo: self.view.layoutGuide.trailingAnchor),
            contentLoadingController.view.centerXAnchor.constraint(equalTo: self.view.layoutGuide.centerXAnchor)
            ])

    }

    func hideContentLoader()
    {
        if let viewController = children.first(where: { $0 is ContentLoadingController })
        {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
}

class ContentLoadingController : UIViewController
{
    
    private var timer: Timer?
    
    private(set) lazy var label: UILabel = {
        let label = UILabel.default()
        label.font = UIFont.customFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()

    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.accessibilityIdentifier = "_loader_"
        return activityIndicator
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        self.startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false, block: { (timer) in
            timer.invalidate()
            self.label.text = Strings.actionLoadingDelayMessage
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
}

extension ContentLoadingController
{
    private func setupView()
    {
        self.view.backgroundColor = .clear
        view.addSubview(activityIndicator)
        view.addSubview(label)
    }
    
    private func setupConstraints()
    {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.layoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.layoutGuide.centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: activityIndicator.topAnchor, constant: 20),
            label.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

        ])
    }
}

protocol ContentLabelProtocol : AnyObject
{
    func showMessage(_ message: String)
    func hideMessage()
}


extension ContentLabelProtocol where Self : UIViewController
{
    
    func showMessage(_ message: String) {
        self.hideMessage()
        let contentLabelController = ContentLabelViewController()
        contentLabelController.messageLabel.text = message
        self.addChild(contentLabelController)
        self.view.addSubview(contentLabelController.view)
        
        contentLabelController.didMove(toParent: self)
        
        contentLabelController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabelController.view.topAnchor.constraint(equalTo: self.view.layoutGuide.topAnchor),
            contentLabelController.view.leadingAnchor.constraint(equalTo: self.view.layoutGuide.leadingAnchor),
            contentLabelController.view.bottomAnchor.constraint(equalTo: self.view.layoutGuide.bottomAnchor),
            contentLabelController.view.trailingAnchor.constraint(equalTo: self.view.layoutGuide.trailingAnchor),
            contentLabelController.view.centerXAnchor.constraint(equalTo: self.view.layoutGuide.centerXAnchor)
            ])
    }

    func hideMessage()
    {
        if let viewController = children.first(where: { $0 is ContentLabelViewController })
        {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
}

struct ContentLabelViewFactory
{
    static func contentLabel() -> UILabel {
        let messageLabel = UILabel.default()
        messageLabel.font = UIFont.customFont(ofSize: 20, weight: .medium)
        messageLabel.textColor = UIColor.appLabelBlack?.withAlphaComponent(0.5)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }
}

class ContentLabelViewController : UIViewController
{
    
    lazy var messageLabel : UILabel = {
        return ContentLabelViewFactory.contentLabel()
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
    }
}

private extension ContentLabelViewController
{
    func setupViews()
    {
        self.view.backgroundColor = .clear
        self.view.addSubview(messageLabel)
        setupConstraints()
    }
    
    func setupConstraints()
    {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.layoutGuide.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.layoutGuide.centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutGuide.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutGuide.trailingAnchor, constant: -15),
            ])
    }
}

protocol ContentButtonProtocol : AnyObject
{
    func showContentButton(withMessage message: String, buttonTitle:String, target: Any?, selector: Selector)
    func hideContentButton()
}


extension ContentButtonProtocol where Self : UIViewController
{

    func showContentButton(withMessage message: String, buttonTitle:String, target: Any?, selector: Selector)
    {
        self.hideContentButton()
        
        let contentButtonController = ContentButtonViewController()
        
        self.addChild(contentButtonController)
        self.view.addSubview(contentButtonController.view)
       
        contentButtonController.didMove(toParent: self)
        contentButtonController.messageLabel.text = message
        contentButtonController.roundedButton.title = buttonTitle
        contentButtonController.roundedButton.addTarget(target, action: selector, for: .touchUpInside)

        contentButtonController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentButtonController.view.topAnchor.constraint(equalTo: self.view.layoutGuide.topAnchor),
            contentButtonController.view.leadingAnchor.constraint(equalTo: self.view.layoutGuide.leadingAnchor),
            contentButtonController.view.bottomAnchor.constraint(equalTo: self.view.layoutGuide.bottomAnchor),
            contentButtonController.view.trailingAnchor.constraint(equalTo: self.view.layoutGuide.trailingAnchor),
            contentButtonController.view.centerXAnchor.constraint(equalTo: self.view.layoutGuide.centerXAnchor)
            ])

    }

    func hideContentButton()
    {
        if let viewController = children.first(where: { $0 is ContentButtonViewController })
        {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
}

class ContentButtonViewController : UIViewController
{
    
    private(set) lazy var messageLabel : UILabel = {
        let messageLabel = UILabel.default()
        messageLabel.font = UIFont.customFont(ofSize: 20, weight: .regular)
        messageLabel.textColor = UIColor.appLabelBlack?.withAlphaComponent(0.5)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    private(set) lazy var roundedButton : RoundedButton = {
        let roundedButton = RoundedButton(title: "", style: .solidTint)
        roundedButton.translatesAutoresizingMaskIntoConstraints = false
        return roundedButton
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
    }
}

private extension ContentButtonViewController
{
    func setupViews()
    {
        let stackView = UIView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(messageLabel)
        stackView.addSubview(roundedButton)
        
        self.view.backgroundColor = .clear
        self.view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            
            messageLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            roundedButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 15),
            roundedButton.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.leadingAnchor),
            roundedButton.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor),
            roundedButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            roundedButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),

            stackView.centerXAnchor.constraint(equalTo: view.layoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.layoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutGuide.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutGuide.trailingAnchor, constant: -15),
            
            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.layoutGuide.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutGuide.bottomAnchor, constant: -15),
        ])
    }
}


protocol ContentImageProtocol : AnyObject
{
    func showImageMessage(_ message: String, image: UIImage?)
    func hideImageMessage()
}


extension ContentImageProtocol where Self : UIViewController
{

    func showImageMessage(_ message: String, image: UIImage?)
    {
        self.hideImageMessage()
        
        let contentImageController = ContentImageViewController()
        
        self.addChild(contentImageController)
        self.view.addSubview(contentImageController.view)
        contentImageController.didMove(toParent: self)

        contentImageController.messageLabel.text = message
        contentImageController.imageView.image = image

        contentImageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentImageController.view.topAnchor.constraint(equalTo: self.view.layoutGuide.topAnchor),
            contentImageController.view.leadingAnchor.constraint(equalTo: self.view.layoutGuide.leadingAnchor),
            contentImageController.view.bottomAnchor.constraint(equalTo: self.view.layoutGuide.bottomAnchor),
            contentImageController.view.trailingAnchor.constraint(equalTo: self.view.layoutGuide.trailingAnchor),
            contentImageController.view.centerXAnchor.constraint(equalTo: self.view.layoutGuide.centerXAnchor)
            ])

    }

    func hideImageMessage()
    {
        if let viewController = children.first(where: { $0 is ContentImageViewController })
        {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
}

class TintLabel: UILabel {
    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.textColor = self.tintColor
    }
}

class ContentImageViewController : UIViewController
{
    
    private(set) lazy var messageLabel : TintLabel = {
        let messageLabel = TintLabel()
        messageLabel.font = UIFont.customFont(ofSize: 16, weight: .bold)
        messageLabel.textColor = self.view.tintColor
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    private(set) lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
    }
}

private extension ContentImageViewController
{
    func setupViews()
    {
        let stackView = UIView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addSubview(messageLabel)
        stackView.addSubview(imageView)
        
        self.view.backgroundColor = .clear
        self.view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.leadingAnchor),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: stackView.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),

            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35),
            messageLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),


            stackView.centerXAnchor.constraint(equalTo: view.layoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.layoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutGuide.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutGuide.trailingAnchor, constant: -15),
            
            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.layoutGuide.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutGuide.bottomAnchor, constant: -15),
        ])
    }
}
