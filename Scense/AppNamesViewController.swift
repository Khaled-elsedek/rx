//
//  AppNamesViewController.swift
//  observable-withUIElement
//
//  Created by khaled elsedek on 8/28/19.
//  Copyright (c) 2019 khaled elsedek. All rights reserved.
//
//  This file was generated by the Clean Swift HELM Xcode Templates
//  https://github.com/HelmMobile/clean-swift-templates

import UIKit
import RxSwift
import RxCocoa

protocol AppNamesViewControllerInput {
    func givenameforlabel(name: String)
}

protocol AppNamesViewControllerOutput {
    func getNameFromTxtField(nameEntry : String)
}

class AppNamesViewController: UIViewController, AppNamesViewControllerInput {
    
    
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var helloLbl: UILabel!
    @IBOutlet private weak var nameEntryTxtField: UITextField!
    @IBOutlet private weak var submitBtn: UIButton!
    @IBOutlet private weak var namesLbl: UILabel!
    
    var output: AppNamesViewControllerOutput?
    var router: AppNamesRouter?
    let disposeBag = DisposeBag()
    var namesArray: BehaviorRelay<[String]> = BehaviorRelay(value: [])

    
    // MARK: Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AppNamesConfigurator.sharedInstance.configure(viewController: self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindSubmitButton()
    }
    
    // MARK: Requests
    
    
    // MARK: Display logic
    
    // MARK: Functions
    func bindTextField() {
        //create observer to pay attention to every  character was typed
        nameEntryTxtField.rx.text.asObservable().subscribe(onNext: {
            self.output?.getNameFromTxtField(nameEntry: $0 ?? "")
            
        }).disposed(by: disposeBag)
    }
    
    func givenameforlabel(name: String) {
        helloLbl.text = name
    }
    
    func bindSubmitButton() {
        submitBtn.rx.tap.subscribe(onNext: {
            if self.nameEntryTxtField.text != "" {
                var array: [String] = [] + self.namesArray.value
                array.append(self.nameEntryTxtField.text ?? "")
                self.namesArray.accept(array)
                self.namesLbl.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                self.nameEntryTxtField.rx.text.onNext("")
                self.helloLbl.rx.text.onNext("Type your name below.")
            }
        }).disposed(by: disposeBag)
    }
    
}

//This should be on configurator but for some reason storyboard doesn't detect ViewController's name if placed there
extension AppNamesViewController: AppNamesPresenterOutput {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(for: segue)
    }
}
