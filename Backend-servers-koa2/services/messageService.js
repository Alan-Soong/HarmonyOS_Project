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
      `SELECT 
        m.message_id, 
        m.sender_id, 
        m.receiver_id, 
        m.content, 
        m.sent_at, 
        m.is_read,
        sender.username as sender_username,
        receiver.username as receiver_username,
        sender.avatar_url as sender_avatar_url,
        receiver.avatar_url as receiver_avatar_url
      FROM Messages m 
      JOIN users sender ON m.sender_id = sender.user_id
      JOIN users receiver ON m.receiver_id = receiver.user_id
      WHERE m.receiver_id = ? 
      ORDER BY m.sent_at DESC`,
      [receiver_id]
    );
    return rows;
  }

  async getMessages() {
    const [rows] = await pool.query(
      `SELECT 
        m.message_id, 
        m.sender_id, 
        m.receiver_id, 
        m.content, 
        m.sent_at, 
        m.is_read,
        sender.username as sender_username,
        receiver.username as receiver_username
      FROM Messages m 
      JOIN users sender ON m.sender_id = sender.user_id
      JOIN users receiver ON m.receiver_id = receiver.user_id
      ORDER BY m.sent_at DESC`
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

  async getMessagesBySender(sender_id) {
    const [rows] = await pool.query(
      `SELECT 
        m.message_id, 
        m.sender_id, 
        m.receiver_id, 
        m.content, 
        m.sent_at, 
        m.is_read,
        sender.username as sender_username,
        receiver.username as receiver_username,
        sender.avatar_url as sender_avatar_url,
        receiver.avatar_url as receiver_avatar_url
      FROM Messages m 
      JOIN users sender ON m.sender_id = sender.user_id
      JOIN users receiver ON m.receiver_id = receiver.user_id
      WHERE m.sender_id = ? 
      ORDER BY m.receiver_id, m.sent_at DESC`,
      [sender_id]
    );
    return rows;
  }

  async getChatMessages(user1_id, user2_id) {
    const [rows] = await pool.query(
      `SELECT 
        m.message_id, 
        m.sender_id, 
        m.receiver_id, 
        m.content, 
        m.sent_at, 
        m.is_read,
        sender.username as sender_username,
        receiver.username as receiver_username,
        sender.avatar_url as sender_avatar_url,
        receiver.avatar_url as receiver_avatar_url
      FROM Messages m 
      JOIN users sender ON m.sender_id = sender.user_id
      JOIN users receiver ON m.receiver_id = receiver.user_id
      WHERE (m.sender_id = ? AND m.receiver_id = ?) 
         OR (m.sender_id = ? AND m.receiver_id = ?) 
      ORDER BY m.sent_at ASC`,
      [user1_id, user2_id, user2_id, user1_id]
    );
    return rows;
  }

}

module.exports = new MessageService();