//
//  input.swift
//  TyphoonSwiftExample
//
//  Created by Aleksey Garbarev on 23/10/2016.
//  Copyright ©©©©  2016 AppsQuick.ly. All rights reserved.
//

//
//  Assembly.swift


import Foundation

class Man {
    var name :String?
    var age :UInt?
    
    var pet: String?
    var company: String?
    
    var brother: Man?
    
    init() {
    
    }
    
    convenience init(withName name: String) {
        self.init()
        self.name = name
    }
    
    func setValues(_ name:String, withAge age:UInt) {
        self.name = name
        self.age = age
        //"init(withName:)" -> init(withName: a)
        //"setValues(_:withAge:) -> setValues(a, withAge: b)
    }
    
    func setCompany(_ company: String) {
        self.company = company
    }
    
    func setPet(pet: String) {
        self.pet = pet
    }
    
    func setAdultAge() {
        self.age = 18
    }
}

class Woman : Man {
    
}

struct Service {
    var name: String?
    
    init() {
        print("Service created!!")
    }
    
}

class Component {
    
    var dependency :Component?
    
    init() {
        
    }
    
    init(withDependency: Component) {
        self.dependency = withDependency
    }
}

class ViewsFactory : Assembly
{
    
}

class CoreComponents : Assembly {
    
    func manWith(_ name: String) -> Definition {
        return Definition(withClass: Man.self) {
            $0.injectProperty("name", with: name)
            $0.setScope(Definition.Scope.ObjectGraph)
            $0.injectProperty("brother", with: self.man())
        }
    }
    
    func manWithInitializer() -> Definition {
        return Definition(withClass: Man.self) {
            $0.setScope(Definition.Scope.Prototype)
            $0.useInitializer("init(withName:)", with: { (m) in
                m.injectArgument("Tom")
            })
            $0.injectMethod("setAdultAge")
            $0.injectMethod("setValues(_:withAge:)") { (m) in
                m.injectArgument("John")
                m.injectArgument(21)
            }
        }
    }
    
    func manWithMethods() -> Definition {
        return Definition(withClass: Man.self) {
            $0.injectMethod("setPet(pet:)") { m in
                m.injectArgument("Barsik")
            }
            $0.injectMethod("setCompany(_:)") { m in
                m.injectArgument("Apple")
            }
            $0.injectProperty("name", with: "ManWithMethods")
        }
    }
    
    func oneWoman() -> Definition {
        let definitnion = Definition(withClass:Woman.self, configuration: { (d) -> (Void) in
            d.injectProperty("name", with: "Anna")
            d.injectProperty("age", with: 23)
        })
        return definitnion
    }
    
    func shareService2() -> Definition
    {
        let service = Definition(withClass: Service.self)
        service.injectProperty("name", with: "Hello world")
        service.setScope(Definition.Scope.Singletone)
        return service
    }
    
    func shareService(_ withArgument:Int) -> Definition
    {
        return Definition(withClass: Service.self) { d in
            d.setScope(Definition.Scope.WeakSingletone)
        }
    }
    
    func man() -> Definition
    {
        return Definition(withClass: Man.self) { configuration in
            configuration.injectProperty("name", with: "Tom")
            configuration.injectProperty("brother", with: self.manWith("Alex"))
        }
    }
    
    func name() -> Definition
    {
        return Definition(withClass: String.self) { d in
            
        }
    }
    
    func component1() -> Definition
    {
        return Definition(withClass: Component.self) { d in
            d.injectProperty("dependency", with: self.component2())
        }
    }

    func component2() -> Definition
    {
        return Definition(withClass: Component.self) { d in
            d.injectProperty("dependency", with: self.component3())
        }
    }

    func component3() -> Definition
    {
        return Definition(withClass: Component.self) { d in
            d.injectProperty("dependency", with: self.component1())
        }
    }
    
    
    func twoPlusTwo(two: Int, plusTwo: Int) -> Int {
        return two + two;
    }
}
//
//  Assembly.swift


