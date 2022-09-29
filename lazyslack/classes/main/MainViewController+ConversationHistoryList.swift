//
//  MainViewController+ConversationHistoryList.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func makeCoversationHistoryListView(
    context: SlackHTTPClient.Context,
    messages: [SlackHTTPAPIConversationHistoryMessageResponse], unique: Bool = false) {
    
    let indentifier = "conversationHistoryList" + (unique ? .unique : .empty)
    
    makeContentBox(container: grapchStackView,
                   value: .init(identifier: indentifier)) { view in
      
      view.actions = messages.compactMap( { .init(title: $0.text, value: $0) } )
      view.actionCallback = { [weak self] tags in
        
        guard let `self` = self else { return }
        
        guard let message = tags.first?.value as? SlackHTTPAPIConversationHistoryMessageResponse else {
          return
        }
        
        self.deleteMessageAction(context: context,
                                 message.ts)
      }
    }
  }
}
