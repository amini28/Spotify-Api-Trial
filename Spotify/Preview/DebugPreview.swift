//
//  DebugPreview.swift
//  Spotify
//
//  Created by Amini on 05/10/22.
//

#if DEBUG
import SwiftUI
struct WelcomPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<WelcomPreview.ContainerView>) -> some UIViewController {
//            return AuthViewController()
//            return WelcomeViewController()
            return HomeViewController()
        }
        
        func updateUIViewController(_ uiViewController: WelcomPreview.ContainerView.UIViewControllerType,
                                    context: UIViewControllerRepresentableContext<WelcomPreview.ContainerView>) {
            
        }
    }
    
    
}

#endif
