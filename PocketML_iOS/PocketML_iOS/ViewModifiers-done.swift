//
//  ViewModifiers.swift
//  PocketML_iOS
//
//  Created by Michael Ngo on 4/19/24.
//

import SwiftUI

extension Color {
    static let main = Color(red: 0.32941176470588235, green: 0.16470588235294117, blue: 0.4588235294117647)
    static let background = Color(red:0.984313725490196, green: 0.9411764705882353, blue:1.0)
    static let background2 = Color(red:0.8862745098039215, green:0.8156862745098039, blue:0.9764705882352941)
    // Define more custom colors here if needed
}

// formatting for main Title
struct MainTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
            .padding(.leading)
            .monospaced()
            .foregroundStyle(Color.main)
    }
}


// formatting for BigTitles
struct BigTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .monospaced()
            .font(.largeTitle)
            .foregroundStyle(Color.main)
    }
}

// formatting for Title1
struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .monospaced()
            .font(.title)
            .foregroundColor(Color.main)
            .padding(.top)
            .padding(.bottom)
    }
}

// formatting for Title2
struct Title2Modifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .monospaced()
            .padding(.top)
            .padding(.bottom)
            .font(.title2)
            .foregroundColor(Color.main)
    }
}

// formatting for Title3
struct Title3Modifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .monospaced()
            .font(.title3)
            .foregroundColor(Color.main)
    }
}

// formatting for Title3
struct SectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .monospaced()
            .font(.title3)
            .foregroundColor(Color.main)
            .bold()
    }
}

// Regular text
struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .monospaced()
            .foregroundStyle(Color.main)
    }
}
// Subheadlines
struct SubheadlineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.main)
            .font(.subheadline)
    }
}

// main background
struct MainVStackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background)
    }
}

// VStacks that contains a list
struct ListVStackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.background2))
            .padding(.leading)
            .padding(.trailing)
            .scrollContentBackground(.hidden)
    }
}
