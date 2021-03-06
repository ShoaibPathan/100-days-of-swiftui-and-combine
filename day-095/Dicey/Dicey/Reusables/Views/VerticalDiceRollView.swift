//
//  VerticalDiceRollView.swift
//  Dicey
//
//  Created by CypherPoet on 2/2/20.
// ✌️
//

import SwiftUI
import CypherPoetSwiftUIKit_BindingUtils


struct VerticalDiceRollView<Content: View> {
    var diceCollection: [Dice]
    
    let content: (Int, Dice, CGPoint, CGFloat) -> Content
    
    
    init(
        diceCollection: [Dice] = [],
        @ViewBuilder content: @escaping ((Int, Dice, CGPoint, CGFloat) -> Content)
    ) {
        self.diceCollection = diceCollection
        self.content = content
    }
}


// MARK: - View
extension VerticalDiceRollView: View {

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(self.diceCollection.indexed(), id: \.0.self) { (index, dice) in
//                    EmptyView()
                    self.content(
                        index,
                        dice,
                        self.position(forDiceAt: index, in: geometry),
                        self.sideLength(forDiceIn: geometry)
                    )
//                    DiceView(dice: dice)
//                        .frame(
//                            width: self.sideLength(forDiceIn: geometry),
//                            height: self.sideLength(forDiceIn: geometry)
//                        )
//                        .position(self.position(forDiceAt: index, in: geometry))
//                        .animation(Animation.linear(duration: 0.3).delay(1.0 * Double(index)))
//                        .animation(Animation.linear.delay(1.0 * index))
                }
            }
            .frame(
                width: self.frameHorizontalSpace(in: geometry),
                height: self.frameVerticalSpace(in: geometry)
            )
        }
    }
}


// MARK: - Computeds
extension VerticalDiceRollView {
    var rowSpacing: CGFloat { 12.0 }
    var columnSpacing: CGFloat { 16.0 }

    var rowCount: Int { ((diceCollection.count - 1) / 2) + 1 }
    var columnCount: Int { diceCollection.count < 2 ? 1 : 2 }
}


// MARK: - View Variables
extension VerticalDiceRollView {
}


// MARK: - Private Helpers
private extension VerticalDiceRollView {
    
    func columnNumber(forDiceAt index: Int) -> Int {
        index % columnCount
    }

    func columnSpacingOffset(forDiceAt index: Int) -> CGFloat {
        columnSpacing * CGFloat(columnNumber(forDiceAt: index))
    }

    
    func rowNumber(forDiceAt index: Int) -> Int {
        index / columnCount
    }
    
    func rowSpacingOffset(forDiceAt index: Int) -> CGFloat {
        rowSpacing * CGFloat(rowNumber(forDiceAt: index))
    }
    
    
    func frameHorizontalSpace(in geometry: GeometryProxy) -> CGFloat {
        sideLength(forDiceIn: geometry) * CGFloat(columnCount) + (columnSpacing * CGFloat(columnCount - 1))
    }
    
    func frameVerticalSpace(in geometry: GeometryProxy) -> CGFloat {
        sideLength(forDiceIn: geometry) * CGFloat(rowCount) + (rowSpacing * CGFloat(rowCount - 1))
    }
    
    
    func sideLength(forDiceIn geometry: GeometryProxy) -> CGFloat {
        let availableVerticalSpace = geometry.size.height - (rowSpacing * CGFloat(rowCount - 1))
        let availableHorizontalSpace = geometry.size.width - (columnSpacing * CGFloat(columnCount - 1))

        if availableHorizontalSpace < availableVerticalSpace {
            return availableHorizontalSpace / CGFloat(max(rowCount, columnCount))
        } else {
            return availableVerticalSpace / CGFloat(max(rowCount, columnCount))
        }
    }
    
    
    
    func position(forDiceAt index: Int, in geometry: GeometryProxy) -> CGPoint {
        let sideLength = self.sideLength(forDiceIn: geometry)
        let columnNumber: CGFloat = CGFloat(self.columnNumber(forDiceAt: index))
        let rowNumber: CGFloat = CGFloat(self.rowNumber(forDiceAt: index))
        
        let columnSpacingOffset = self.columnSpacingOffset(forDiceAt: index)
        let rowSpacingOffset = self.rowSpacingOffset(forDiceAt: index)
            
        
        let centerX = (columnNumber * sideLength) + columnSpacingOffset
            + (sideLength / 2)
        
        let centerY = (rowNumber * sideLength) + rowSpacingOffset
            + (sideLength / 2)
        
        
        return CGPoint(x: centerX, y: centerY)
    }
}



// MARK: - Preview
struct VerticalDiceRollView_Previews: PreviewProvider {

    static var previews: some View {
        VStack(alignment: .center) {
            VerticalDiceRollView(
//                    diceCollection: [.one, .two, .three, .four]
//                diceCollection: [.one, .two, .three, .four, .five,]
//                diceCollection: [.one, .two, .three, .four, .five, .six]
//                    diceCollection: [.one, .two,]
//                    diceCollection: [.one]
                    diceCollection: [.one, .two, .three]
            ) { (index, dice, position, sideLength) in
                DiceView(dice: dice)
                    .frame(
                        width: sideLength,
                        height: sideLength
                    )
                    .position(position)
            }
            
            Spacer()
            
            Text("Dice")
        }
        
    }
}
