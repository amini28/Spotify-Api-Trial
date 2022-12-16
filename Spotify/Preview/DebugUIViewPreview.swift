//
//  DebugUIViewPreview.swift
//  Spotify
//
//  Created by Amini on 06/10/22.
//

import SwiftUI

#if DEBUG
struct UIViewPreview: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewRepresentable {
        func makeUIView(context: UIViewRepresentableContext<UIViewPreview.ContainerView>) -> some UIView {
            return HighlightsView()
        }
        
        func updateUIView(_ uiView: UIViewPreview.ContainerView.UIViewType,
                          context: UIViewRepresentableContext<UIViewPreview.ContainerView>) {
            
        }
    }
    
}
#endif
