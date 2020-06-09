//
//  cUIPickerViewField.swift
//  
//
//  Created by Blake Anderson on 1/17/20.
//

import UIKit

class cUIPickerViewField: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var label: UILabel = UILabel(frame: CGRect(x: 10, y: 30, width: 250, height: 15))
    var ogLabel: String?
    
    var fieldView: UIView = UIView(frame: CGRect(x: 0, y:15, width: 300, height: 45))
    
    var picker: UIPickerView?
    var datePicker: UIDatePicker?
    
    
    private var viewListeners = [UIView]()
    private var listener: cUIPickerViewFieldListener?
    
    private var isActive: Bool = false
    
    private var data: [String]?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, label: String, data: [String]?, type: cUIPickerStyle) {
        super.init(frame: frame)
        
        switch type {
        case .date:
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 300, height: 135))
            datePicker?.datePickerMode = .date
        case .custom:
            picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 135))
            
        }
        self.data = data
        
        setup(label)
    }
    
    private func setup(_ label: String) {
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        
        self.fieldView.layer.cornerRadius = 10
        self.fieldView.layer.borderColor = lightGrey.cgColor
        self.fieldView.layer.borderWidth = 1
        
        self.label.text = label
        self.label.font = UIFont.systemFont(ofSize: 13)
        self.label.textColor = UIColor.black.withAlphaComponent(0.40)
        self.addSubview(self.label)
        
        self.ogLabel = label
        
        self.fieldView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(open)))
        self.addSubview(fieldView)
        
        if picker != nil {
            picker!.dataSource = self
            picker!.delegate = self
        }
        
    }
    func registerControllerListener(_ listener: cUIPickerViewFieldListener) {
        self.listener = listener
    }
    
    func isFirstResponder() -> Bool {
        return self.isActive
    }
    
    @objc func open() {
        listener?.lookForOtherResponder(self)
        
        if isActive == false {
            UIView.animate(withDuration: 0.1, animations: {
                
                for view in self.viewListeners {
                    if view.frame.origin.y < self.frame.origin.y {
                        view.frame = view.frame.offsetBy(dx: 0, dy: -45)
                    } else {
                        view.frame = view.frame.offsetBy(dx: 0, dy: 45)
                    }
                }
                
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 300, height: 150)
                self.frame = self.frame.offsetBy(dx: 0, dy: -45)
                
                self.fieldView.frame = self.fieldView.frame.offsetBy(dx: 0, dy: -45)
                self.fieldView.frame = CGRect(x: 0, y: 15, width: 300, height: 135)
                self.fieldView.layer.borderColor = primaryColor.cgColor
                
                self.label.frame = self.label.frame.offsetBy(dx: 0, dy: -30)
                self.label.textColor = primaryColor
                self.label.text = self.ogLabel
                
            }) { (complete) in
                self.showPicker()
                self.isActive = true
            }
        }
    }
    
    func close() {
        
        UIView.animate(withDuration: 0.1, animations: {
            
            for view in self.viewListeners {
                if view.frame.origin.y < self.frame.origin.y {
                    view.frame = view.frame.offsetBy(dx: 0, dy: 45)
                } else {
                    view.frame = view.frame.offsetBy(dx: 0, dy: -45)
                }
            }
            
            if self.picker != nil {
                self.label.text = self.data![self.picker!.selectedRow(inComponent: 0)]
                
                self.fieldView.willRemoveSubview(self.picker!)
                self.picker!.removeFromSuperview()
            } else {
                self.datePicker!.datePickerMode = UIDatePicker.Mode.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd yyyy"
                self.label.text = dateFormatter.string(from: self.datePicker!.date)
                
                self.fieldView.willRemoveSubview(self.datePicker!)
                self.datePicker!.removeFromSuperview()
            }
            
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 300, height: 60)
            self.fieldView.frame = CGRect(x: 0, y: 15, width: 300, height: 45)
            self.frame = self.frame.offsetBy(dx: 0, dy: 45)
            self.fieldView.layer.borderColor = primaryColor.cgColor
            self.label.frame = self.label.frame.offsetBy(dx: 0, dy: 30)
            self.label.textColor = .black
            
            self.isActive = false
            
        }) { (copmlete) in
            
        }
    }
    
    func registerViewListener(_ view: UIView) {
        viewListeners.append(view)
    }
    
    private func showPicker() {
        if picker != nil {
            self.fieldView.addSubview(picker!)
        } else {
            self.fieldView.addSubview(datePicker!)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data![row]
    }
}

enum cUIPickerStyle {
    case date
    case custom
}
