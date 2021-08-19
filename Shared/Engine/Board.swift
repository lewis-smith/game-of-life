//
//  Board.swift
//  Game of Life
//
//  Created by Lewis Smith on 02/08/2021.
//
import SwiftUI
import Foundation

public enum CellState: Character {
    case dead = "-", alive = "X"
    
    public var isAlive: Bool { return self == .alive }
    
    public static func random() -> CellState {
        return Bool.random() ? .alive : .dead
    }
}

// Not sure I need Cell & CellState in the end, might be able to merge them
public class Cell: ObservableObject, Equatable {
    
    @Published var state: CellState = .dead
    
    public init(state: CellState) {
        self.state = state
    }
    
    public static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.state == rhs.state
    }
    
}

public class Board: ObservableObject {

    @Published public var cells: [[Cell]]
    
    @Published public var stuck: Bool = false
    
    public init(cells: [[Cell]]) {
        self.cells = cells
    }
    
    public init(randomSize size: CGSize) {
        let rows = Self.random(size: size)
        self.cells = rows
    }
    
    public init(emptySize size: CGSize) {
        let rows = Self.empty(size: size)
        self.cells = rows
    }
    
    public var size: CGSize {
        return CGSize(width: cells[0].count, height: cells.count)
    }
    
    public init?(string input: String) {
        var gridWidth = 0
        guard input.last == "\n" else {
            assertionFailure("Must end with newline")
            return nil
        }
        
        for char in input {
            guard char == CellState.alive.rawValue || char == CellState.dead.rawValue || char == "\n"  else {
                assertionFailure("Unexpected character: \(char)")
                return nil
            }
            if char == "\n" {
                break
            }
            gridWidth += 1
        }
        
        guard gridWidth > 3 else {
            assertionFailure("Expected grid to be wider than 3, was actually: \(gridWidth)")
            return nil }
        
        var xPos = 0, yPos = 0
        var row = [Cell](repeating: Cell(state: .dead), count: gridWidth)
        var grid = [[Cell]]()
        
        for char in input {
            guard char == CellState.alive.rawValue || char == CellState.dead.rawValue || char == "\n"  else {
                assertionFailure("Unexpected character: \(char)")
                return nil
            }
            
            if char == "\n" {
                guard xPos == gridWidth else {
                    assertionFailure("Line is wrong width")
                    return nil
                }
                grid.append(row)
                row = [Cell](repeating: Cell(state: .dead), count: gridWidth)
                xPos = 0
                yPos += 1
                continue
            }
            guard let state = CellState(rawValue: char) else {
                assertionFailure("Unexpected character: \(char)")
                return nil
            }
            row[xPos] = Cell(state: state)
            
            xPos += 1
        }
        cells = grid
    }
    
    static func random(size: CGSize) -> [[Cell]] {
        var rows = [[Cell]]()
        for _ in 0..<Int(size.height) {
            var row = [Cell]()
            for _ in 0..<Int(size.width) {
                row.append(Cell(state: CellState.random()))
            }
            rows.append(row)
        }
        return rows
    }
    
    static func empty(size: CGSize) -> [[Cell]] {
        var rows = [[Cell]]()
        for _ in 0..<Int(size.height) {
            var row = [Cell]()
            for _ in 0..<Int(size.width) {
                row.append(Cell(state: .dead))
            }
            rows.append(row)
        }
        return rows
    }
    
    public func reset(toRandom: Bool) {
        if toRandom {
            self.cells = Self.random(size: self.size)
        } else {
            self.cells = Self.empty(size: self.size)
        }
        stuck = false
    }
    
    public func isExtinct() -> Bool {
        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width) {
                if cells[y][x].state == .alive { return false }
            }
        }
        return true
    }
}

extension Board: CustomDebugStringConvertible {
    public var debugDescription: String {
        var returnString = ""
        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width) {
                returnString += "\(cells[y][x].state.rawValue)"
            }
            returnString += "\n"
        }
        return returnString
    }
}

extension Board: Equatable {
    public static func == (lhs: Board, rhs: Board) -> Bool {
        return lhs.cells == rhs.cells
    }
}

extension Board {
    public func nextGeneration() {
        var newCells = self.cells
        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width) {
                newCells[y][x] = Cell(state: nextStateForPosition(x: x, y: y))
            }
        }
        return cells = newCells
    }
    
    private func nextStateForPosition(x inX: Int, y inY: Int) -> CellState {
        var liveNeighbours = 0
        for y in -1...1 {
            for x in -1...1 {
                
                if x == 0, y == 0 { /* This cell */ continue }
                let globalX = x + inX
                let globalY = y + inY
                if globalX < 0 || globalY < 0 {
                    /* Edge of board, assume dead */
                    continue                    
                }
                //                  print("\(globalX), \(globalY)")
                if globalX >= Int(size.width) || globalY >= Int(size.height) {
                    /* Edge of board, assume dead */ continue
                }
                
                if cells[globalY][globalX].state.isAlive {
                    liveNeighbours += 1
                }
                
            }
        }
        
        let me = cells[inY][inX]
        if me.state.isAlive {
            if liveNeighbours < 2 || liveNeighbours > 3 {
                return .dead
            } else {
                return .alive
            }
        } else {
            if liveNeighbours == 3 {
                return .alive
            } else {
                return .dead
            }
        }
    }
    
}

