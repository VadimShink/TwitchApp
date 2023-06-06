//
//  MainViewModel.swift
//  TwitchApp
//
//  Created by Vadim Shinkarenko on 6.06.2023.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    let action: PassthroughSubject<Action, Never> = .init()
    
    @Published var items: [GameCellViewModel] = []
    
    let screenData: CurrentValueSubject<GameListModel?, Never> = .init(nil)
    
    private let model: Model
    private var bindings = Set<AnyCancellable>()
    
    init(model: Model) {
        self.model = model
        
        Task {
            await loadScreenData()
        }
        
        bind()
    }
    
    // MARK: - Bind
    private func bind() {
        screenData
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] screenData in
                
                guard let screenData else { return }
                
                let newItems = createItems(from: screenData)
                self.items.append(contentsOf: newItems)
                
            }
            .store(in: &bindings)
    }
    
    func loadScreenData() async {
        
        do {
            self.screenData.value = try await model.handleGetStreamList(pagination: "")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - func createItems
    func createItems(from model: GameListModel) -> [GameCellViewModel] {
        
        var items: [GameCellViewModel] = []
        
        items = model.data.map { GameCellViewModel(game: $0) { [weak self] gameID in
            self?.action.send(MainViewModelAction.OpenDetailGame(id: gameID))
        }}
        
        return items
    }
    
    /// Загружает дополнительное содержимое и добавляет его в список данных экрана screenData.value.
    ///
    /// Функция проверяет текущую игру currentGame и осуществляет загрузку дополнительного содержимого,
    /// если текущая игра является последней в списке данных экрана.
    ///
    /// Если условие выполняется, функция асинхронно вызывает функцию getMoreGame(pagination:), передавая ей значение пагинации pagination
    /// из списка данных экрана screenData.value. Пагинация используется для запроса следующей порции данных игры.
    ///
    /// В результате выполнения функции getMoreGame(pagination:), новые данные игры будут получены и добавлены в конец списка данных экрана.
    ///
    /// - Parameter currentGame: Модель представления ячейки игры, определяющая текущую игру.
    func loadMoreContent(currentGame game: GameCellViewModel) {
        guard let lastIndex = screenData.value?.data.count, lastIndex > 0,
              let currentIndex = screenData.value?.data.firstIndex(where: { $0.id == game.id }) else { return }

        let pagination = screenData.value?.pagination.cursor

        if currentIndex == lastIndex - 1 {
            Task {
                await getMoreGame(pagination: pagination ?? "")
            }
        }
    }
    
    // MARK: - func getMoreGame
    func getMoreGame(pagination: String) async {
        do {
            let newsGames = try await model.handleGetStreamList(pagination: pagination)
            screenData.value = newsGames
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Action
    enum MainViewModelAction {
        
        struct OpenDetailGame: Action {
            let id: String
        }
    }
}
