//
//  ContentView.swift
//  SlideNumberPuzzle
//
//  Created by Pradipat Jareanporn on 19/11/2566 BE.
//

import SwiftUI

struct Tile: Identifiable {
    let id: Int
    var number: Int
}

struct ContentView: View {
    @State private var numbers: [[Int]] = [
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 10, 11, 12],
        [13, 14, 15, 0] // 0 represents an empty space
    ]
    @State private var moveCount = 0 // Track move count
    @State private var slideAnimation: Bool = false
    
    var body: some View {
        VStack {
            Text("New Game")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .onTapGesture {
                    shuffleCards()
                }
//            autosizing screen
            GeometryReader { geometry in
                let gridSize = min(geometry.size.width, geometry.size.height) - 20
                let cardSize = gridSize / 4 // Assuming a 4x4 grid
                
                VStack(spacing: 5) {
                    ForEach(0..<4, id: \.self) { row in
                        HStack(spacing: 5) {
                            ForEach(0..<4, id: \.self) { column in
                                let currentNumber = numbers[row][column]
                                
                                if currentNumber == 0 {
                                    Color.clear
                                        .frame(width: cardSize, height: cardSize)
                                        .onTapGesture {
                                            withAnimation{
                                                handleCardMovement(row:row,
                                                                   column:column)
                                                slideAnimation.toggle()
                                            }
                                        }
                                } else {
                                    Text("\(numbers[row][column])")
                                        .frame(width: cardSize, height: cardSize)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .font(
                                            .system(size: cardSize * 0.4,
                                                    weight:.bold))
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            withAnimation{
                                                handleCardMovement(row: row,
                                                                   column: column)
                                                slideAnimation.toggle()
                                            }
                                        }
                                        
                                }
                            }
                        }
                    }
                }
                .padding(2)
            }
            
            Text("You Won!!!")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .opacity(isWin() ? 1.0 : 0.0)
            Text("Move : \(moveCount)")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
            
        }
    }
    
    func shuffleCards() {
//        รวมเป็น array เดียวกันแล้วค่อยสุ่ม
        var flatNumbers = numbers.flatMap { $0 }
        flatNumbers.shuffle()
        
        moveCount = 0
        
//            จัด row and column
        numbers = (0..<4).map { row in
            Array(flatNumbers[row * 4..<(row + 1) * 4])
        }
    }
    
    func handleCardMovement(row: Int, column: Int) {
            let emptyRow = getEmptySpaceRow()
            let emptyColumn = getEmptySpaceColumn()
            
//            เช็คว่าใน same row or column มีช่องว่างไหม และ การ์ดอยู่ห่างจากช่องว่าง 1 ช่องไหม
            if (row == emptyRow && abs(column - emptyColumn) == 1) ||
               (column == emptyColumn && abs(row - emptyRow) == 1) {
                
//                เปลี่ยนค่า ใน array number
                let temp = numbers[row][column]
                numbers[row][column] = numbers[emptyRow][emptyColumn]
                numbers[emptyRow][emptyColumn] = temp
                
                // Increment move count
                moveCount += 1
            }
        }
        
//        หา index ของเลข 0 ใน row ว่ามีไหม
    func getEmptySpaceRow() -> Int {
        for (rowIndex, row) in numbers.enumerated() {
            if let columnIndex = row.firstIndex(of: 0) {
                return rowIndex
            }
        }
        return 0
    }
//        หา index ของเลข 0 ใน column ว่ามีไหม
    func getEmptySpaceColumn() -> Int {
        for (columnIndex, column) in numbers.enumerated() {
            if let columnIndex = column.firstIndex(of: 0) {
                return columnIndex
            }
        }
        return 0
    }
    
    
    func isWin() -> Bool {
        let solvedNumbers: [[Int]] = [
                [1, 2, 3, 4],
                [5, 6, 7, 8],
                [9, 10, 11, 12],
                [13, 14, 15, 0]
            ]
        return numbers == solvedNumbers
    }
}




#Preview {
    ContentView()
}
