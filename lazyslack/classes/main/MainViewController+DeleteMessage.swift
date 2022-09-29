//
//  MainViewController+DeleteMessage.swift
//

import AppKit

import NOFoundation

import lazyapi

extension MainViewController {
  
  func deleteMessageAction(context: SlackHTTPClient.Context,
                           _ ts: String) {
    
    guard let channelID = context.channel else { return }
    
    slackHTTPClient.chatDelete(channel: channelID,
                               ts: ts,
                               token: context.token,
                               cookie: context.cookie) { [weak self] response in
      
      guard let `self` = self else { return }
      
      NOSTDOUT.display(response)
      
      DispatchQueue.main.async { [weak self] in
        
        guard let `self` = self else { return }
        
        NOSTDOUT.display(response)
      }
    }
  }
}
