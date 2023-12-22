//
//  UIStackView+Convenience.swift
//  CardTransition-Example
//
//  Created by Sun on 2023/12/19.
//

import UIKit

@resultBuilder
public struct StackViewBuilder {
    
    public typealias Expression = UIView
    public typealias Component = [UIView]
    
    public static func buildExpression(_ expression: Expression) -> Component {
        return [expression]
    }
    
    public static func buildBlock(_ components: Component...) -> Component {
        return components.flatMap { $0 }
    }
    
    public static func buildBlock(_ components: UIView...) -> Component {
        return components.map { $0 }
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? []
    }
    
    public static func buildEither(first component: Component) -> Component {
        return component
    }
    
    public static func buildEither(second component: Component) -> Component {
        return component
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        Array(components.joined())
    }
}

public class HStack: UIStackView {
    
    public convenience init(
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0,
        @StackViewBuilder views: () -> [UIView]
    ) {
        self.init(arrangedSubviews: views())
        
        self.axis = .horizontal
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
}

public class VStack: UIStackView {
    
    public convenience init(
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0,
        @StackViewBuilder views: () -> [UIView]
    ) {
        self.init(arrangedSubviews: views())
        
        self.axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
}
