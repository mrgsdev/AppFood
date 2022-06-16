
## Custom NavigationController

<img width="299" alt="Снимок экрана 2022-06-16 в 14 03 09" src="https://user-images.githubusercontent.com/107209053/174056632-b3dada6c-8f78-406e-b69e-1c3a117fdde4.png">

``` swift
    func customNavBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonTitle = ""
        if let appearance = navigationController?.navigationBar.standardAppearance
        {
            appearance.configureWithTransparentBackground()
            if let customFont = UIFont(name: "Nunito-Bold", size: 40.0) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
``` 
