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
}

module.exports = new MessageController();