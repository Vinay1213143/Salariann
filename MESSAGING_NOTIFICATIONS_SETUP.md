# Messaging & Notifications System Setup

**Date**: June 17, 2026  
**Status**: ✅ **BACKEND IMPLEMENTED**

---

## 🎯 What's Been Added

### Backend Implementation
✅ Messaging Controller  
✅ Notifications Controller  
✅ API Routes  
✅ Database Queries  

---

## 📊 Database Tables Required

### 1. Conversations Table

```sql
CREATE TABLE conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  participant_1_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  participant_2_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  last_message TEXT,
  last_message_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_conversations_participant_1 ON conversations(participant_1_id);
CREATE INDEX idx_conversations_participant_2 ON conversations(participant_2_id);
```

### 2. Messages Table

```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_created_at ON messages(created_at DESC);
```

### 3. Notifications Table

```sql
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  related_id UUID,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
```

---

## 🚀 API Endpoints

### Messaging Endpoints

#### Get All Conversations
```
GET /api/conversations
Authorization: Bearer {token}
```

**Response**:
```json
{
  "success": true,
  "data": [
    {
      "id": "conv-id",
      "participant_1_id": "user-1",
      "participant_2_id": "user-2",
      "last_message": "Hello!",
      "last_message_at": "2026-06-17T14:30:00Z",
      "created_at": "2026-06-17T10:00:00Z"
    }
  ]
}
```

#### Get Messages in Conversation
```
GET /api/conversations/{conversationId}/messages?limit=50&offset=0
Authorization: Bearer {token}
```

**Response**:
```json
{
  "success": true,
  "data": [
    {
      "id": "msg-id",
      "conversation_id": "conv-id",
      "sender_id": "user-1",
      "content": "Hello!",
      "is_read": true,
      "created_at": "2026-06-17T14:30:00Z"
    }
  ],
  "pagination": {
    "total": 100,
    "limit": 50,
    "offset": 0
  }
}
```

#### Send Message
```
POST /api/messages
Authorization: Bearer {token}
Content-Type: application/json

{
  "conversationId": "conv-id",
  "content": "Hello!"
}
```

Or create new conversation:
```json
{
  "recipientId": "user-2",
  "content": "Hello!"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "id": "msg-id",
    "conversation_id": "conv-id",
    "sender_id": "user-1",
    "content": "Hello!",
    "is_read": false,
    "created_at": "2026-06-17T14:30:00Z"
  }
}
```

#### Delete Message
```
DELETE /api/messages/{messageId}
Authorization: Bearer {token}
```

#### Mark Conversation as Read
```
PUT /api/conversations/{conversationId}/read
Authorization: Bearer {token}
```

---

### Notifications Endpoints

#### Get All Notifications
```
GET /api/notifications?limit=20&offset=0&unread_only=false
Authorization: Bearer {token}
```

**Response**:
```json
{
  "success": true,
  "data": [
    {
      "id": "notif-id",
      "user_id": "user-1",
      "type": "message_received",
      "title": "New Message",
      "message": "You have a new message from John",
      "related_id": "msg-id",
      "is_read": false,
      "created_at": "2026-06-17T14:30:00Z"
    }
  ],
  "pagination": {
    "total": 50,
    "limit": 20,
    "offset": 0,
    "unread_count": 5
  }
}
```

#### Get Unread Count
```
GET /api/notifications/unread/count
Authorization: Bearer {token}
```

**Response**:
```json
{
  "success": true,
  "unread_count": 5
}
```

#### Mark Notification as Read
```
PUT /api/notifications/{notificationId}/read
Authorization: Bearer {token}
```

#### Mark All Notifications as Read
```
PUT /api/notifications/read/all
Authorization: Bearer {token}
```

#### Delete Notification
```
DELETE /api/notifications/{notificationId}
Authorization: Bearer {token}
```

#### Send Notification (Admin)
```
POST /api/notifications/send
Authorization: Bearer {token}
Content-Type: application/json

{
  "userId": "user-1",
  "type": "message_received",
  "title": "New Message",
  "message": "You have a new message",
  "relatedId": "msg-id"
}
```

---

## 📝 Notification Types

```javascript
const NOTIFICATION_TYPES = {
  JOB_APPLIED: 'job_applied',
  JOB_SAVED: 'job_saved',
  REVIEW_RECEIVED: 'review_received',
  MESSAGE_RECEIVED: 'message_received',
  PROFILE_VIEWED: 'profile_viewed',
  SALARY_DATA_ADDED: 'salary_data_added',
  INTERVIEW_EXPERIENCE: 'interview_experience',
  COMPANY_UPDATE: 'company_update'
};
```

---

## 🔧 Setup Instructions

### Step 1: Create Database Tables

Run the SQL queries above in Supabase to create:
- conversations table
- messages table
- notifications table

### Step 2: Backend is Ready

The backend controllers and routes are already implemented:
- ✅ `messaging.controller.js`
- ✅ `notifications.controller.js`
- ✅ Routes in `routes/index.js`

### Step 3: Frontend Integration

Update Flutter screens to use the new API endpoints:

```dart
// In messaging_screen.dart
Future<void> fetchConversations() async {
  final response = await http.get(
    Uri.parse('http://localhost:3001/api/conversations'),
    headers: {'Authorization': 'Bearer $token'},
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    conversations = data['data'];
  }
}

// Send message
Future<void> sendMessage(String content) async {
  final response = await http.post(
    Uri.parse('http://localhost:3001/api/messages'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    },
    body: jsonEncode({
      'conversationId': conversationId,
      'content': content
    }),
  );
}
```

```dart
// In notifications_screen.dart
Future<void> fetchNotifications() async {
  final response = await http.get(
    Uri.parse('http://localhost:3001/api/notifications'),
    headers: {'Authorization': 'Bearer $token'},
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    notifications = data['data'];
  }
}

// Get unread count
Future<void> getUnreadCount() async {
  final response = await http.get(
    Uri.parse('http://localhost:3001/api/notifications/unread/count'),
    headers: {'Authorization': 'Bearer $token'},
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    unreadCount = data['unread_count'];
  }
}
```

---

## ✨ Features Implemented

### Messaging System
✅ Get all conversations  
✅ Get messages in conversation  
✅ Send messages  
✅ Delete messages  
✅ Mark conversation as read  
✅ Pagination support  
✅ User authentication  

### Notifications System
✅ Get all notifications  
✅ Get unread count  
✅ Mark as read  
✅ Mark all as read  
✅ Delete notifications  
✅ Send notifications  
✅ Notification types  
✅ User authentication  

---

## 🎯 Next Steps

1. **Create Database Tables**
   - Run SQL queries in Supabase
   - Create conversations, messages, notifications tables

2. **Update Flutter Screens**
   - Implement messaging_screen.dart with real API calls
   - Implement notifications_screen.dart with real API calls
   - Add notification badge to header

3. **Add Real-time Features** (Optional)
   - WebSocket for live messaging
   - Push notifications
   - Real-time notification updates

---

## 📊 Testing

### Test Messaging
```bash
# Get conversations
curl -H "Authorization: Bearer {token}" \
  http://localhost:3001/api/conversations

# Send message
curl -X POST \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -d '{"recipientId":"user-2","content":"Hello!"}' \
  http://localhost:3001/api/messages
```

### Test Notifications
```bash
# Get notifications
curl -H "Authorization: Bearer {token}" \
  http://localhost:3001/api/notifications

# Get unread count
curl -H "Authorization: Bearer {token}" \
  http://localhost:3001/api/notifications/unread/count
```

---

## 🎉 Summary

**Messaging & Notifications System is ready!**

✅ Backend controllers implemented  
✅ API routes configured  
✅ Database schema defined  
✅ Authentication integrated  
✅ Error handling implemented  

**Next: Create database tables and update Flutter screens!**

---

*Messaging & Notifications System Setup*  
*June 17, 2026*  
*Status: Backend Ready ✅*
