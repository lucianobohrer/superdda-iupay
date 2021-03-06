//
//  IPReceiptViewController.swift
//  SuperDDAIuPay
//
//  Created by Luciano Bohrer on 07/10/2020.
//

import UIKit

/**
 Screen for payment receipt
 
 ### Usage: ###
``` 
 let receiptVc = IPReceiptViewController(cedentName: "COMPANHIA DE ELETRICIDADE DO RIO DE JANEIRO",
                                         cnpj: "15.139.629/0001-99",
                                         payerName: "ROBERTO DE OLIVEIRA SANTOS",
                                         barcode: "34191.09065 44830. 1285 40141.906 8 00001.83120.59475",
                                         dueDate: Date(),
                                         paidDate: Date(),
                                         value: 223.24,
                                         discount: 0.0,
                                         interest: 0.0,
                                         fine: 0.0,
                                         chargedValue: 223.24,
                                         authCode: "A.6DE.DF4.75E.DBB,128",
                                         baseColor: .systemRed)
 
 // As an alternative when usigin .xibs this method can be call to setup the screen
 receiptVC.setContent(cedentName: "COMPANHIA DE ELETRICIDADE DO RIO DE JANEIRO",
                      cnpj: "15.139.629/0001-99",
                      payerName: "ROBERTO DE OLIVEIRA SANTOS",
                      barcode: "34191.09065 44830. 1285 40141.906 8 00001.83120.59475",
                      dueDate: Date(),
                      paidDate: Date(),
                      value: 223.24,
                      discount: 0.0,
                      interest: 0.0,
                      fine: 0.0,
                      chargedValue: 223.24,
                      authCode: "A.6DE.DF4.75E.DBB,128",
                      baseColor: .systemRed)
 
 receiptVC.handleShareClick = {
     // Closure for handling share button click
 }
 
 receiptVC.handleOptionsClick = {
 // Closure for handling option button click
 }
 
 // Closure to handle button on the screen
 payDetailsVC.handleButtonClick = {
     IPMessageModalViewController.showModal(from: payDetailsVC,
                                            title: "Title text",
                                            message: "message text")
 }
```
 */
public class IPReceiptViewController: UIViewController {

    public var handleShareClick: (() -> ())?
    public var handleOptionsClick: (() -> ())?
    
    private var cedentName: String?
    private var cnpj: String?
    private var payerName: String?
    private var barcode: String?
    private var dueDate: Date?
    private var paidDate: Date?
    private var value: Double?
    private var discount: Double?
    private var interest: Double?
    private var fine: Double?
    private var chargedValue: Double?
    private var authCode: String?
    private var baseColor: UIColor?
    
    private lazy var backButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage.bundleImage(named: "left-arrow"), for: .normal)
        $0.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        $0.tintColor = .darkGray
        return $0
    }(UIButton(frame: .zero))
    
    private lazy var titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.customFont(ofSize: 15, weight: .regular)
        $0.text = "Comprovante"
        $0.textColor = .darkGray
        return $0
    }(UILabel(frame: .zero))
    
    private lazy var dotsButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage.bundleImage(named: "dots-menu"), for: .normal)
        $0.addTarget(self, action: #selector(self.handleOptions), for: .touchUpInside)
        $0.tintColor = .darkGray
        return $0
    }(UIButton(frame: .zero))
    
    private lazy var scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView(frame: .zero))
    
    private lazy var stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        return $0
    }(UIStackView(frame: .zero))
    
    private lazy var mainButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont.customFont(ofSize: 16, weight: .bold)
        $0.addTarget(self, action: #selector(self.handleShare), for: .touchUpInside)
        return $0
    }(UIButton(frame: .zero))
    
    public init(cedentName: String,
                cnpj: String,
                payerName: String,
                barcode: String,
                dueDate: Date,
                paidDate: Date,
                value: Double,
                discount: Double,
                interest: Double,
                fine: Double,
                chargedValue: Double,
                authCode: String,
                baseColor: UIColor) {
        
        super.init(nibName: nil, bundle: nil)
        self.setContent(cedentName: cedentName,
                        cnpj: cnpj,
                        payerName: payerName,
                        barcode: barcode,
                        dueDate: dueDate,
                        paidDate: paidDate,
                        value: value,
                        discount: discount,
                        interest: interest,
                        fine: fine,
                        chargedValue: chargedValue,
                        authCode: authCode,
                        baseColor: baseColor)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupConstraints() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        self.view.addSubview(self.mainButton)
        self.view.addSubview(self.dotsButton)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.titleLabel)
        
        self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: .smallMargin).isActive = true
        self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: .mediumMargin).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: .bigMediumMargin).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: .bigMediumMargin).isActive = true
        
        self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: .largeMargin).isActive = true
        
        self.dotsButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -.mediumMargin).isActive = true
        self.dotsButton.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor).isActive = true
        self.dotsButton.heightAnchor.constraint(equalToConstant: .bigMediumMargin).isActive = true
        self.dotsButton.widthAnchor.constraint(equalToConstant: .bigMediumMargin).isActive = true
        
        self.scrollView.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: .bigMediumMargin).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.mainButton.topAnchor, constant: -.smallestMargin).isActive = true
        
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 600).isActive = true
        self.stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)

        self.mainButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -.mediumMargin).isActive = true
        self.mainButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: .bigMediumMargin).isActive = true
        self.mainButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -.bigMediumMargin).isActive = true
        self.mainButton.heightAnchor.constraint(equalToConstant: .defaultArea).isActive = true
    }
    
    private func setupLayout() {
        self.mainButton.backgroundColor = .clear
        self.mainButton.setTitleColor(self.baseColor, for: .normal)
        self.mainButton.setTitle("Compartilhar Comprovante", for: .normal)
        self.mainButton.layer.borderColor = self.baseColor?.cgColor
        self.mainButton.layer.borderWidth = 2
        
        self.stackView.addArrangedSubview(self.label(caption: "Cedente:",
                                                     text: cedentName ?? "",
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "CNPJ:",
                                                     text: cnpj ?? "",
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "Pagador:",
                                                     text: payerName ?? "",
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "Código de Barras:",
                                                     text: barcode ?? "",
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "Data de Vencimento:",
                                                     text: dueDate?.formatDate(format: "dd/MM/yyyy") ?? "",
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "Data de Pagamento:",
                                                     text: paidDate?.formatDate(format: "dd/MM/yyyy") ?? "",
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "Valor do Documento:",
                                                     text: "R$ " + "\(value ?? 0.0)".currencyInputFormatting(),
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "Descontos:",
                                                     text: String(format: "%.2f", discount ?? 0.0),
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "Juros:",
                                                     text: String(format: "%.2f", interest ?? 0.0),
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))

        self.stackView.addArrangedSubview(self.label(caption: "Multa:",
                                                     text: String(format: "%.2f", fine ?? 0.0),
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))

        self.stackView.addArrangedSubview(self.label(caption: "Valor Cobrado:",
                                                     text: "R$ " + "\(chargedValue ?? 0.0)".currencyInputFormatting(),
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))
        
        self.stackView.addArrangedSubview(self.label(caption: "Código de Autenticação:",
                                                     text: authCode ?? "",
                                                     sizeCaption: 13,
                                                     sizeText: 15,
                                                     textColor: .grayKit))

    }
    
    public func setContent(cedentName: String,
                           cnpj: String,
                           payerName: String,
                           barcode: String,
                           dueDate: Date,
                           paidDate: Date,
                           value: Double,
                           discount: Double,
                           interest: Double,
                           fine: Double,
                           chargedValue: Double,
                           authCode: String,
                           baseColor: UIColor) {
        self.cedentName = cedentName
        self.cnpj = cnpj
        self.payerName = payerName
        self.barcode = barcode
        self.dueDate = dueDate
        self.paidDate = paidDate
        self.value = value
        self.discount = discount
        self.interest = interest
        self.fine = fine
        self.chargedValue = chargedValue
        self.authCode = authCode
        self.baseColor = baseColor
        self.setupLayout()
    }
        
    private func horizontalView(caption: String, text: String, textColor: UIColor? = .darkGray) -> UIView {
        let container = UIStackView(frame: .zero)
        container.axis = .horizontal
        container.distribution = .fillProportionally

        container.heightAnchor.constraint(equalToConstant: .defaultArea).isActive = true
        
        let captionLabel = IPPaddingLabel(text: caption, fontSize: 15, weight: .regular, textColor: .darkGray)
        captionLabel.textAlignment = .left
        
        
        let textLabel = IPPaddingLabel(text: text, fontSize: 15, weight: .bold, textColor: textColor ?? .grayKit)
        textLabel.textAlignment = .right
        
        container.addArrangedSubview(captionLabel)
        container.addArrangedSubview(textLabel)
        return container
    }

    @objc private func handleShare() {
        self.handleShareClick?()
    }
    
    @objc private func handleOptions() {
        self.handleOptionsClick?()
    }
    
    @objc private func closeAction() {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
