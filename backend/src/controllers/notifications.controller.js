import { supabase } from '../config/supabase.js';

// Get all notifications for a user
export async function getNotifications(req, res) {
  try {
    const userId = req.user?.id;
    const { limit = 20, offset = 0, unread_only = false } = req.query;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    let query = supabase
      .from('notifications')
      .select('*', { count: 'exact' })
      .eq('user_id', userId);

    if (unread_only === 'true') {
      query = query.eq('is_read', false);
    }

    const { data, error, count } = await query
      .order('created_at', { ascending: false })
      .range(parseInt(offset), parseInt(offset) + parseInt(limit) - 1);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({
      success: true,
      data: data || [],
      pagination: {
        total: count,
        limit: parseInt(limit),
        offset: parseInt(offset),
        unread_count: count ? count : 0
      }
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Get unread notification count
export async function getUnreadCount(req, res) {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const { data, error, count } = await supabase
      .from('notifications')
      .select('*', { count: 'exact' })
      .eq('user_id', userId)
      .eq('is_read', false);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({
      success: true,
      unread_count: count || 0
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Mark notification as read
export async function markAsRead(req, res) {
  try {
    const { notificationId } = req.params;
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    // Verify notification belongs to user
    const { data: notification, error: notifError } = await supabase
      .from('notifications')
      .select('user_id')
      .eq('id', notificationId)
      .single();

    if (notifError || !notification) {
      return res.status(404).json({ error: 'Notification not found' });
    }

    if (notification.user_id !== userId) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    // Mark as read
    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('id', notificationId);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({ success: true, message: 'Notification marked as read' });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Mark all notifications as read
export async function markAllAsRead(req, res) {
  try {
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    const { error } = await supabase
      .from('notifications')
      .update({ is_read: true })
      .eq('user_id', userId)
      .eq('is_read', false);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({ success: true, message: 'All notifications marked as read' });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Delete a notification
export async function deleteNotification(req, res) {
  try {
    const { notificationId } = req.params;
    const userId = req.user?.id;

    if (!userId) {
      return res.status(401).json({ error: 'Unauthorized' });
    }

    // Verify notification belongs to user
    const { data: notification, error: notifError } = await supabase
      .from('notifications')
      .select('user_id')
      .eq('id', notificationId)
      .single();

    if (notifError || !notification) {
      return res.status(404).json({ error: 'Notification not found' });
    }

    if (notification.user_id !== userId) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    // Delete notification
    const { error } = await supabase
      .from('notifications')
      .delete()
      .eq('id', notificationId);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({ success: true, message: 'Notification deleted' });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Create a notification (internal use)
export async function createNotification(userId, type, title, message, relatedId = null) {
  try {
    const { data, error } = await supabase
      .from('notifications')
      .insert({
        user_id: userId,
        type: type,
        title: title,
        message: message,
        related_id: relatedId,
        is_read: false
      })
      .select()
      .single();

    if (error) {
      console.error('Error creating notification:', error.message);
      return null;
    }

    return data;
  } catch (error) {
    console.error('Error creating notification:', error.message);
    return null;
  }
}

// Send notification to user (for internal use)
export async function sendNotification(req, res) {
  try {
    const { userId, type, title, message, relatedId } = req.body;

    if (!userId || !type || !title || !message) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const notification = await createNotification(userId, type, title, message, relatedId);

    if (!notification) {
      return res.status(500).json({ error: 'Failed to create notification' });
    }

    return res.status(201).json({
      success: true,
      data: notification
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

// Notification types
export const NOTIFICATION_TYPES = {
  JOB_APPLIED: 'job_applied',
  JOB_SAVED: 'job_saved',
  REVIEW_RECEIVED: 'review_received',
  MESSAGE_RECEIVED: 'message_received',
  PROFILE_VIEWED: 'profile_viewed',
  SALARY_DATA_ADDED: 'salary_data_added',
  INTERVIEW_EXPERIENCE: 'interview_experience',
  COMPANY_UPDATE: 'company_update'
};
