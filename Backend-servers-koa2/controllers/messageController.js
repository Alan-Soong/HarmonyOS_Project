const messageService = require('../services/messageService');

class MessageController {
  async createMessage(ctx) {
    try {
      const messageData = ctx.request.body;
      const message = await messageService.createMessage(messageData);
      ctx.body = { success: true, data: message };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getMessagesByReceiver(ctx) {
    try {
      const { receiver_id } = ctx.params;
      const messages = await messageService.getMessagesByReceiver(receiver_id);
      ctx.body = { success: true, data: messages };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getMessages(ctx) {
    try {
      const messages = await messageService.getMessages();
      ctx.body = { success: true, data: messages };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async markMessageAsRead(ctx) {
    try {
      const { message_id } = ctx.params;
      await messageService.markMessageAsRead(message_id);
      ctx.body = { success: true, message: 'Message marked as read' };
    } catch (error) {
      ctx.status = 404;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getMessagesBySender(ctx) {
    try {
      const { sender_id } = ctx.params;
      const messages = await messageService.getMessagesBySender(sender_id);
      ctx.body = { success: true, data: messages };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

  async getChatMessages(ctx) {
    try {
      const { user1_id, user2_id } = ctx.params;
      
      // 验证参数
      if (!user1_id || !user2_id) {
        ctx.status = 400;
        ctx.body = { success: false, message: 'Both user1_id and user2_id are required' };
        return;
      }
      
      const messages = await messageService.getChatMessages(user1_id, user2_id);
      ctx.body = { 
        success: true, 
        data: messages,
        message: `Chat history between user ${user1_id} and user ${user2_id}`
      };
    } catch (error) {
      ctx.status = 400;
      ctx.body = { success: false, message: error.message };
    }
  }

}

module.exports = new MessageController();