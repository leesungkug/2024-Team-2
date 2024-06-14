//
//  newCardViewModel.swift
//  13jo
//
//  Created by Shim Hyeonhee on 6/15/24.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
struct MaxLengthModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int

    @available(iOS 17.0, *)
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

@available(iOS 17.0, *)
extension TextField {
    func maxLength(text: Binding<String>, _ maxLength: Int) -> some View {
        return ModifiedContent(content: self,
                               modifier: MaxLengthModifier(text: text,
                                                           maxLength: maxLength))
    }
}
