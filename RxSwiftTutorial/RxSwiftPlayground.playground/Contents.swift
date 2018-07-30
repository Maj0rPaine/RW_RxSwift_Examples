import RxSwift

// Observable lifecyle:
// Next - Elements, e.g., integers or taps
// Error - Observable is terminated
// Completed - Observable is terminated

example(of: "creating observables") {
    let mostPopular: Observable<String> = Observable<String>.just(episodeV)
    let originalTrilogy = Observable.of(episodeIV, episodeV, episodeVI)
    let prequelTrilogy = Observable.of([episodeI, episodeII, episodeIII])
    let sequelTrilogy = Observable.from([episodeVII, episodeVIII, episodeIX])
}

example(of: "subscribe") {
    let observable = Observable.of(episodeIV, episodeV, episodeVI)
    
    observable.subscribe(onNext: { element in
        print(element)
    })
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe(onNext: { (element) in
        print(element)
    }, onError: { (error) in
        print("error: \(error.localizedDescription)")
    }, onCompleted: {
        print("completed")
    }, onDisposed: {
        print("disposed")
    })
}

example(of: "never") {
    let disposeBag = DisposeBag()
    let observable = Observable<Any>.never()
    
    observable
        .do(onNext: { print($0) }, onError: { print($0) }, onCompleted: { print("Completed") }, onSubscribe: { print("Subscribe") }, onSubscribed: { print("Subscribed") }, onDispose: { print("Dispose") })
        .subscribe(onNext: { (element) in
            print(element)
        }, onError: { (error) in
            print("error: \(error.localizedDescription)")
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        }).disposed(by: disposeBag)
}

example(of: "dispose") {
    let observable = Observable.of(episodeV, episodeIV, episodeVI)
    
    let subscription = observable.subscribe { event in
        print(event)
    }
    
    subscription.dispose()
}

example(of: "dispose bag") {
    let disposeBag = DisposeBag()
    
    Observable.of(episodeVII, episodeI, rogueOne)
        .subscribe {
            print($0)
        }.disposed(by: disposeBag)
}

example(of: "create") {
    enum Droid: Error {
        case OU812
    }
    
    let disposeBag = DisposeBag()
    
    Observable<String>.create { observable in
        observable.onNext("R2-D2")
        observable.onError(Droid.OU812)
        observable.onNext("C-3PO")
        observable.onNext("K-2SO")
        observable.onCompleted()
        
        return Disposables.create()
        }.subscribe(
            onNext: { print($0)},
            onError: { print("Error: ", $0) },
            onCompleted: { print("Completed") },
            onDisposed: { print("Disposed") }
        ).disposed(by: disposeBag)
}

example(of: "single") {
    let disposeBag = DisposeBag()
    
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    func loadText(from filename: String) -> Single<String> {
        return Single.create { single in
            let disposable = Disposables.create()
            
            guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            
            single(.success(contents))
            
            return disposable
        }
    }
    
    loadText(from: "ANewHope")
        .subscribe {
            switch  $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
}

// Subjects:
// Observable - Can be subscribed to
// Observer - Add new elements

example(of: "publish subject") {
    // Get all events after subscribing
    let quotes = PublishSubject<String>()
    
    quotes.onNext(itsNotMyFault)
    
    let subscriptionOne = quotes.subscribe {
        print(label: "1)", event: $0)
    }
    
    quotes.on(.next(doOrDoNot))
    
    subscriptionOne.dispose()
    
    let subscriptionTwo = quotes.subscribe {
        print(label: "2)", event: $0)
    }

    quotes.onNext(lackOfFaith)

    quotes.onNext(eyesCanDeceive)
    
    subscriptionTwo.dispose()

    let subscriptionThree = quotes.subscribe {
        print(label: "3)", event: $0)
    }

    quotes.onNext(stayOnTarget)
    
    subscriptionThree.dispose()
    
    quotes.onCompleted()
}

example(of: "behavior subject") {
    let disposeBag = DisposeBag()
    
    // Get most recent element and everything emitted after subscription has occurred
    let quotes = BehaviorSubject(value: iAmYourFather)
    
    quotes.subscribe {
        print(label: "1)", event: $0)
    }
    
    quotes.onError(Quote.neverSaidThat)
    
    quotes.subscribe {
        print(label: "2)", event: $0)
    }.disposed(by: disposeBag)
}

example(of: "replay subject") {
    let disposeBag = DisposeBag()
    
    // Emit more than one element to new subscriptions
    // Set buffer size
    let subject = ReplaySubject<String>.create(bufferSize: 2)
    
    subject.onNext(useTheForce)
    
    subject.subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)
    
    subject.onNext(theForceIsStrong)
    
    // Replay entire buffer
    subject.subscribe {
        print(label: "2)", event: $0)
    }
}

example(of: "variable") {
    let disposeBag = DisposeBag()
    
    let variable = Variable(mayTheForceBeWithYou)
    
    print(variable.value)
    
    variable.asObservable().subscribe {
        print(label: "1)", event: $0)
    }.disposed(by: disposeBag)
    
    variable.value = mayThe4thBeWithYou
}

example(of: "PublishSubject") {
    
    let disposeBag = DisposeBag()
    
    let dealtHand = PublishSubject<[(String, Int)]>()
    
    func deal(_ cardCount: UInt) {
        var deck = cards
        var cardsRemaining: UInt32 = 52
        var hand = [(String, Int)]()
        
        for _ in 0..<cardCount {
            let randomIndex = Int(arc4random_uniform(cardsRemaining))
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }
        
        // Add code to update dealtHand here
        let total = points(for: hand)
        
        if total > 21 {
            dealtHand.onError(HandError.busted)
        } else {
            dealtHand.onNext(hand)
        }
    }
    
    // Add subscription to dealtHand here
    dealtHand.subscribe(onNext: { (element) in
        print(cardString(for: element), "for", points(for: element))
    }, onError: { (error) in
        print(String(describing: error))
    }, onCompleted: {
        print("Complete")
    }, onDisposed: {
        print("Disposed")
    })
    
    deal(3)
}
