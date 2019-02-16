//
//  ViewController.swift
//  Chatbot
//
//  Created by BALAJI ABHISHEK on 2/16/19.
//  Copyright © 2019 BALAJI ABHISHEK. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import Photos

//This class contains basic functionality of chat with text and image messages.
class ViewController: MessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var messages: [Message] = []
    var member: Member!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        member = Member(name: "Balaji Abhishek", color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = UIColor.black
        cameraItem.image = UIImage.init(named: "camera")
        cameraItem.addTarget(self,action: #selector(cameraButtonPressed),for: .primaryActionTriggered)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
    
    //It will get called once user presses on camera icon to access camera/photo library.
    @objc func cameraButtonPressed()
    {
        let picker = UIImagePickerController()
        picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            picker.sourceType = .camera
        }
        else
        {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    //It will get called once user selects a particular image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        
        if let asset = info[.phAsset] as? PHAsset
        {
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
                guard let image = result else {
                    return
                }
                
                let message = Message(image: image, member: self.member, messageId: UUID().uuidString)
                self.insertMessage(message)
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
        else if let image = info[.originalImage] as? UIImage
        {
            let message = Message(image: image, member: self.member, messageId: UUID().uuidString)
            self.insertMessage(message)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Passing image here in the form of message object.
    func insertMessage(_ message: Message)
    {
        messages.append(message)
        messagesCollectionView.performBatchUpdates({messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2
            {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true
            {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    //Checking for last section available.
    func isLastSectionVisible() -> Bool
    {
        guard !messages.isEmpty else {
            return false
        }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
}

extension ViewController: MessagesDataSource
{
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int
    {
        return messages.count
    }
    
    func currentSender() -> Sender
    {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType
    {
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat
    {
        return 12
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString?
    {
        return NSAttributedString(string: message.sender.displayName, attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension ViewController: MessagesLayoutDelegate
{
    
}

extension ViewController: MessagesDisplayDelegate
{
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)
    {
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

extension ViewController: MessageInputBarDelegate
{
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String)
    {
        let newMessage = Message(text: text, member: member, messageId: UUID().uuidString)
        messages.append(newMessage)
        
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}


