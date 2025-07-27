//
//  Theme.swift
//  BedSolution
//
//  Created by 이재호 on 7/26/25.
//

import Foundation
import SwiftUI

public struct Theme {
    let colorTheme: ColorTheme
    let textTheme: TextTheme
}

public extension Theme {
    static let _default = Theme(colorTheme: ._default, textTheme: ._default)
}

public extension EnvironmentValues {
    @Entry var theme: Theme = ._default
}
