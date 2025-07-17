const pool = require('../config/db');

class MessageService {
  async createMessage({ sender_id, receiver_id, content }) {
    if (!sender_id || !receiver_id || !content) throw new Error('Required fields missing');
    try {
      const [result] = await pool.query(
        'INSERT INTO Messages (sender_id, receiver_id, content) VALUES (?, ?, ?)',
        [sender_id, receiver_id, content]
      );
      return {
        message_id: result.insertId,
        sender_id,
        receiver_id,
        content,
        sent_at: new Date(),
        is_read: false
      };
    } catch (error) {
      throw error;
    }
  }

  async getMessagesByReceiver(receiver_id) {
    const [rows] = await pool.query(
      'SELECT message_id, sender_id, receiver_id, content, sent_at, is_read FROM Messages WHERE receiver_id = ? ORDER BY sent_at DESC',
      [receiver_id]
    );
    return rows;
  }

  async markMessageAsRead(message_id) {
    try {
      const [result] = await pool.query(
        'UPDATE Messages SET is_read = TRUE WHERE message_id = ?',
        [message_id]
      );
      if (result.affectedRows === 0) throw new Error('Message not found');
    } catch (error) {
      throw error;
    }
  }
}

module.exports = new MessageService();