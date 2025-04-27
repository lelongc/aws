import React, { useState, useEffect, useRef } from 'react';
import { ChatAlt2Icon, XIcon } from '@heroicons/react/24/outline';
import { useAuthStore } from '@/store/authStore';

interface Message {
  id: string;
  content: string;
  isUser: boolean;
  timestamp: Date;
}

export default function LiveChat() {
  const [isOpen, setIsOpen] = useState(false);
  const [message, setMessage] = useState('');
  const [messages, setMessages] = useState<Message[]>([]);
  const [isTyping, setIsTyping] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const { user } = useAuthStore();

  // Simulate initial welcome message
  useEffect(() => {
    if (isOpen && messages.length === 0) {
      setMessages([
        {
          id: '1',
          content: 'Xin chào! Chúng tôi có thể giúp gì cho bạn?',
          isUser: false,
          timestamp: new Date()
        }
      ]);
    }
  }, [isOpen, messages]);

  // Scroll to bottom when new messages arrive
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!message.trim()) return;

    // Add user message
    const userMessage = {
      id: Date.now().toString(),
      content: message,
      isUser: true,
      timestamp: new Date()
    };
    
    setMessages(prevMessages => [...prevMessages, userMessage]);
    setMessage('');
    
    // Simulate customer support typing
    setIsTyping(true);
    
    // Simulate response after delay
    setTimeout(() => {
      setIsTyping(false);
      
      // Generate a simple automated response
      let responseContent = '';
      const lowerCaseMessage = message.toLowerCase();
      
      if (lowerCaseMessage.includes('chào') || lowerCaseMessage.includes('hello')) {
        responseContent = 'Chào bạn! Tôi có thể giúp gì cho bạn?';
      } else if (lowerCaseMessage.includes('giá') || lowerCaseMessage.includes('price')) {
        responseContent = 'Giá sản phẩm của chúng tôi dao động từ 500.000đ đến 5.000.000đ tùy mẫu. Bạn cần tư vấn mẫu kính nào?';
      } else if (lowerCaseMessage.includes('sale') || lowerCaseMessage.includes('khuyến mãi') || lowerCaseMessage.includes('giảm giá')) {
        responseContent = 'Hiện tại chúng tôi đang có chương trình giảm giá 20% cho tất cả kính râm. Bạn có thể xem chi tiết tại trang Khuyến mãi.';
      } else {
        responseContent = 'Cảm ơn bạn đã liên hệ. Nhân viên của chúng tôi sẽ phản hồi sớm nhất có thể!';
      }
      
      setMessages(prevMessages => [
        ...prevMessages,
        {
          id: Date.now().toString(),
          content: responseContent,
          isUser: false,
          timestamp: new Date()
        }
      ]);
    }, 1500);
  };

  return (
    <div className="fixed bottom-6 right-6 z-50">
      {/* Chat button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        className={`${
          isOpen ? 'hidden' : 'flex'
        } items-center justify-center w-14 h-14 rounded-full bg-indigo-600 text-white shadow-lg hover:bg-indigo-700 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500`}
      >
        <ChatAlt2Icon className="h-6 w-6" />
      </button>
      
      {/* Chat window */}
      {isOpen && (
        <div className="bg-white rounded-lg shadow-xl w-80 sm:w-96 flex flex-col overflow-hidden h-96">
          {/* Chat header */}
          <div className="bg-indigo-600 text-white px-4 py-3 flex justify-between items-center">
            <h3 className="font-medium">Hỗ trợ trực tuyến</h3>
            <button
              onClick={() => setIsOpen(false)}
              className="text-white hover:text-indigo-100 focus:outline-none"
            >
              <XIcon className="h-5 w-5" />
            </button>
          </div>
          
          {/* Chat messages */}
          <div className="flex-1 overflow-y-auto p-4 space-y-3">
            {messages.map((msg) => (
              <div
                key={msg.id}
                className={`max-w-xs px-4 py-2 rounded-lg ${
                  msg.isUser
                    ? 'bg-indigo-600 text-white ml-auto'
                    : 'bg-gray-100 text-gray-800'
                }`}
              >
                <p className="text-sm">{msg.content}</p>
                <span className="block text-xs mt-1 opacity-70">
                  {msg.timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                </span>
              </div>
            ))}
            
            {isTyping && (
              <div className="bg-gray-100 text-gray-800 max-w-xs px-4 py-2 rounded-lg">
                <div className="flex space-x-1">
                  <div className="w-2 h-2 rounded-full bg-gray-500 animate-bounce"></div>
                  <div className="w-2 h-2 rounded-full bg-gray-500 animate-bounce" style={{ animationDelay: '0.2s' }}></div>
                  <div className="w-2 h-2 rounded-full bg-gray-500 animate-bounce" style={{ animationDelay: '0.4s' }}></div>
                </div>
              </div>
            )}
            
            <div ref={messagesEndRef} />
          </div>
          
          {/* Chat input */}
          <form onSubmit={handleSubmit} className="border-t border-gray-200 p-3">
            <div className="flex items-center">
              <input
                type="text"
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                className="flex-1 border border-gray-300 rounded-l-md py-2 px-3 text-sm focus:ring-indigo-500 focus:border-indigo-500"
                placeholder="Nhập tin nhắn..."
              />
              <button
                type="submit"
                disabled={!message.trim()}
                className="bg-indigo-600 text-white rounded-r-md py-2 px-4 text-sm disabled:bg-indigo-300 hover:bg-indigo-700"
              >
                Gửi
              </button>
            </div>
          </form>
        </div>
      )}
    </div>
  );
}
