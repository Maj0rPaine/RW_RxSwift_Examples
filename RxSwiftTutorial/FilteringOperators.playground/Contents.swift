//: Playground - noun: a place where people can play

import RxSwift

example(of: "ignoreElements") {
    let disposeBag = DisposeBag()
    
    let cannedProjects = PublishSubject<String>()
    
    cannedProjects
        .ignoreElements()
        .subscribe {
            print($0)
    }
    .disposed(by: disposeBag)
    
    cannedProjects.onNext(landOfDroids)
    cannedProjects.onNext(wookieWorld)
    cannedProjects.onNext(detours)
    
    cannedProjects.onCompleted()
}

example(of: "elementAt") {
    let disposeBag = DisposeBag()
    
    let quotes = PublishSubject<String>()
    
    quotes
        .elementAt(2)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    quotes.onNext(mayTheOdds)
    quotes.onNext(liveLongAndProsper)
    quotes.onNext(mayTheForce)
}

example(of: "filter") {
    let disposeBag = DisposeBag()
    
    Observable.from(tomatometerRatings)
        .filter { movie in
            movie.rating >= 90
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "skipWhile") {
    let disposeBag = DisposeBag()
    
    Observable.from(tomatometerRatings)
        .skipWhile { movie in
            movie.rating < 90
        }
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "skipUntil") {
    let disposeBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    let trigger = PublishSubject<Void>()
    
    subject
        .skipUntil(trigger)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
    
    subject.onNext(episodeI.title)
    subject.onNext(episodeII.title)
    subject.onNext(episodeIII.title)
    
    trigger.onNext(())
    
    subject.onNext(episodeIV.title)
}

example(of: "distinctUntilChanged") {
    let disposeBag = DisposeBag()
    
    Observable<Droid>.of(.R2D2, .C3PO, .R2D2)
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}

example(of: "Challenge 1") {
    
    let disposeBag = DisposeBag()
    
    let contacts = [
        "603-555-1212": "Florent",
        "212-555-1212": "Junior",
        "408-555-1212": "Marin",
        "617-555-1212": "Scott"
    ]
    
    func phoneNumber(from inputs: [Int]) -> String {
        var phone = inputs.map(String.init).joined()
        
        phone.insert("-", at: phone.index(
            phone.startIndex,
            offsetBy: 3)
        )
        
        phone.insert("-", at: phone.index(
            phone.startIndex,
            offsetBy: 7)
        )
    
        return phone
    }
    
    let input = PublishSubject<Int>()
    
    // Add your code here
    input
        .skipWhile { $0 == 0 }
        .filter { $0 < 10 }
        .take(10)
        .toArray()
        .subscribe(onNext: {
            let phone = phoneNumber(from: $0)
            
            if let contact = contacts[phone] {
                print("Dialing \(contact) (\(phone))...")
            } else {
                print("Contact not found")
            }
        })
    
    input.onNext(0)
    input.onNext(603)
    
    input.onNext(2)
    input.onNext(1)
    
    // Confirm that 7 results in "Contact not found", and then change to 2 and confirm that Junior is found
    input.onNext(2)
    
    "5551212".forEach {
        if let number = (Int("\($0)")) {
            input.onNext(number)
        }
    }
    
    input.onNext(9)
}
