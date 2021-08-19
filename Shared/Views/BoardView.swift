import SwiftUI

struct BoardView: View {
    
    @ObservedObject var board: Board
    
    var body: some View {
        VStack {
            ForEach(0..<Int(board.size.height), id: \.self) { row in
                HStack {
                    ForEach(0..<Int(board.size.width), id: \.self) { col in
                        CellView(cell: board.cells[row][col])
                    }
                }
            }
        }
    }
}

struct CellView: View {
    
    @ObservedObject var cell: Cell
    
    var body: some View {
//        RoundedRectangle(cornerRadius: 10)
//            .foregroundColor(cellState.color)
        Button {
            if cell.state == .alive {
                cell.state = .dead
            } else {
                cell.state = .alive
            }
        } label: {
            Text("")
        }
        .background(cell.state.color)
    
    }
}

extension CellState {
    var color: Color {
        switch self {
        case .alive: return .green
        case .dead: return .gray
        }
    }
}
