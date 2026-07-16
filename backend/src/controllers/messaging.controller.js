import { supabase } from '../config/supabase.js';

// Get all conversations for a user
export async function getConversations(req, res) {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const { data, error } = await supabase
      .from('conversations')
      .select(`
        id,
        participant_1_id,
        participant_2_id,
        last_message,
        last_message_at,
        created_at,
        users!conversations_participant_1_id_fkey (id, email, display_name),
        users!conversations_participant_2_id_fkey (id, email, display_name)
      `)
      .or(`participant_1_id.eq.${userId},participant_2_id.eq.${userId}`)
      .order('last_message_at', { ascending: false });

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({
      success: true,
      data: data || []
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Get messages in a conversation
export async function getMessages(req, res) {
  try {
    const { conversationId } = req.params;
    const userId = req.user?.id;
    const { limit = 50, offset = 0 } = req.query;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    // Verify user is part of conversation
    const { data: conversation, error: convError } = await supabase
      .from('conversations')
      .select('id, participant_1_id, participant_2_id')
      .eq('id', conversationId)
      .single();

    if (convError || !conversation) {
      return res.status(404).json({ error: 'Conversation not found' });
    }

    if (conversation.participant_1_id !== userId && conversation.participant_2_id !== userId) {
      return res.status(403).json({ error: 'Unauthorized access to conversation' });
    }

    // Get messages
    const { data: messages, error: msgError, count } = await supabase
      .from('messages')
      .select('*', { count: 'exact' })
      .eq('conversation_id', conversationId)
      .order('created_at', { ascending: false })
      .range(parseInt(offset), parseInt(offset) + parseInt(limit) - 1);

    if (msgError) {
      return res.status(400).json({ error: msgError.message });
    }

    // Mark messages as read
    await supabase
      .from('messages')
      .update({ is_read: true })
      .eq('conversation_id', conversationId)
      .neq('sender_id', userId);

    return res.json({
      success: true,
      data: messages || [],
      pagination: {
        total: count,
        limit: parseInt(limit),
        offset: parseInt(offset)
      }
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Send a message
export async function sendMessage(req, res) {
  try {
    const userId = req.user?.id;
    const { conversationId, recipientId, content } = req.body;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    if (!content || !content.trim()) {
      return res.status(400).json({ error: 'Message content cannot be empty' });
    }

    // Find or create conversation
    let conversation;
    if (conversationId) {
      const { data, error } = await supabase
        .from('conversations')
        .select('id')
        .eq('id', conversationId)
        .single();

      if (error || !data) {
        return res.status(404).json({ error: 'Conversation not found' });
      }
      conversation = data;
    } else if (recipientId) {
      // Find existing conversation or create new one
      const { data: existing } = await supabase
        .from('conversations')
        .select('id')
        .or(
          `and(participant_1_id.eq.${userId},participant_2_id.eq.${recipientId}),and(participant_1_id.eq.${recipientId},participant_2_id.eq.${userId})`
        )
        .single();

      if (existing) {
        conversation = existing;
      } else {
        // Create new conversation
        const { data: newConv, error: convError } = await supabase
          .from('conversations')
          .insert({
            participant_1_id: userId,
            participant_2_id: recipientId
          })
          .select()
          .single();

        if (convError) {
          return res.status(400).json({ error: convError.message });
        }
        conversation = newConv;
      }
    } else {
      return res.status(400).json({ error: 'Either conversationId or recipientId is required' });
    }

    // Insert message
    const { data: message, error: msgError } = await supabase
      .from('messages')
      .insert({
        conversation_id: conversation.id,
        sender_id: userId,
        content: content.trim()
      })
      .select()
      .single();

    if (msgError) {
      return res.status(400).json({ error: msgError.message });
    }

    // Update conversation last message
    await supabase
      .from('conversations')
      .update({
        last_message: content.trim(),
        last_message_at: new Date().toISOString()
      })
      .eq('id', conversation.id);

    return res.status(201).json({
      success: true,
      data: message
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Delete a message
export async function deleteMessage(req, res) {
  try {
    const { messageId } = req.params;
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    // Verify user is the sender
    const { data: message, error: msgError } = await supabase
      .from('messages')
      .select('sender_id')
      .eq('id', messageId)
      .single();

    if (msgError || !message) {
      return res.status(404).json({ error: 'Message not found' });
    }

    if (message.sender_id !== userId) {
      return res.status(403).json({ error: 'Unauthorized to delete this message' });
    }

    // Delete message
    const { error: deleteError } = await supabase
      .from('messages')
      .delete()
      .eq('id', messageId);

    if (deleteError) {
      return res.status(400).json({ error: deleteError.message });
    }

    return res.json({ success: true, message: 'Message deleted' });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Mark conversation as read
export async function markConversationAsRead(req, res) {
  try {
    const { conversationId } = req.params;
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    // Mark all messages in conversation as read
    const { error } = await supabase
      .from('messages')
      .update({ is_read: true })
      .eq('conversation_id', conversationId)
      .neq('sender_id', userId);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({ success: true, message: 'Conversation marked as read' });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}
