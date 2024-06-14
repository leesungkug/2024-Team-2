//
//  newCardViewModel.swift
//  13jo
//
//  Created by Shim Hyeonhee on 6/15/24.
//

import Foundation
import SwiftUI

struct MaxLengthModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .onChange(of: text) { oldValue, newValue in
                    if newValue.count > maxLength {
                        text = oldValue
                    }
                }
        }
    }
}

extension TextEditor {
    func maxLength(text: Binding<String>, _ maxLength: Int) -> some View {
        return ModifiedContent(content: self,
                modifier: MaxLengthModifier(text: text,maxLength: maxLength))
    }
}


extension Color {
    init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255)
    }
}

