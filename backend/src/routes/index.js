import express from 'express';
import { verifyToken, optionalAuth } from '../middleware/auth.middleware.js';
import * as jobsController from '../controllers/jobs.controller.js';
import * as companiesController from '../controllers/companies.controller.js';
import * as reviewsController from '../controllers/reviews.controller.js';
import * as salariesController from '../controllers/salaries.controller.js';
import * as interviewsController from '../controllers/interviews.controller.js';
import * as adminController from '../controllers/admin.controller.js';
import * as liveJobsController from '../controllers/liveJobs.controller.js';
import * as costOfLivingController from '../controllers/costOfLiving.controller.js';
import * as messagingController from '../controllers/messaging.controller.js';
import * as notificationsController from '../controllers/notifications.controller.js';
import * as authController from '../controllers/auth.controller.js';
import * as seedController from '../controllers/seed.controller.js';
import * as indianJobsController from '../controllers/indianJobs.controller.js';
import * as indianCompaniesController from '../controllers/indianCompanies.controller.js';

const router = express.Router();

router.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Auth - signup/signin via backend (bypasses Supabase email rate limit)
router.post('/auth/signup', authController.signUp);
router.post('/auth/signin', authController.signIn);

// Seed database with companies, jobs, and city metrics
router.post('/seed', seedController.seedDatabase);

router.get('/jobs', optionalAuth, jobsController.getJobs);
router.get('/jobs/:id', optionalAuth, jobsController.getJobById);
router.post('/jobs/click', optionalAuth, jobsController.logJobClick);

router.get('/companies', companiesController.getCompanies);
router.get('/companies/:id', companiesController.getCompanyById);

router.get('/companies/:company_id/reviews', reviewsController.getReviewsByCompany);
router.post('/reviews', verifyToken, reviewsController.createReview);
router.put('/reviews/:id', verifyToken, reviewsController.updateReview);

router.get('/companies/:company_id/salaries', salariesController.getSalariesByCompany);
router.post('/salaries', verifyToken, salariesController.createSalary);
router.get('/salaries/stats', salariesController.getSalaryStats);

router.get('/companies/:company_id/interviews', interviewsController.getInterviewsByCompany);
router.post('/interviews', verifyToken, interviewsController.createInterview);
router.put('/interviews/:id', verifyToken, interviewsController.updateInterview);

// Admin endpoints for seeding data
router.post('/admin/seed/companies', adminController.seedCompanies);
router.post('/admin/seed/jobs', adminController.seedJobsDirect);
router.post('/admin/seed/reviews', adminController.seedReviews);
router.post('/admin/seed/salaries', adminController.seedSalaries);
router.post('/admin/seed/interviews', adminController.seedInterviews);
router.post('/admin/seed/all', adminController.seedAll);

// Live Jobs - Dynamic API (JSearch/RapidAPI)
router.get('/live/jobs', liveJobsController.fetchLiveJobs);
router.get('/live/jobs/city/:city', liveJobsController.fetchJobsByCity);
router.get('/live/jobs/company/:company', liveJobsController.fetchJobsByCompany);
router.get('/live/companies', liveJobsController.getCompanyList);
router.get('/live/cities', liveJobsController.getCityList);
router.post('/live/sync', liveJobsController.syncLiveJobs);
router.get('/live/sources', liveJobsController.getSourceStatus);

// Cost of Living - City affordability data
router.get('/cost-of-living/cities', costOfLivingController.getSupportedCities);
router.get('/cost-of-living/:city', costOfLivingController.getCostOfLivingHandler);
router.get('/cost-of-living', costOfLivingController.getAllCostOfLiving);
router.get('/affordability', costOfLivingController.calculateAffordability);

// Messaging - Conversations and messages
router.get('/conversations', verifyToken, messagingController.getConversations);
router.get('/conversations/:conversationId/messages', verifyToken, messagingController.getMessages);
router.post('/messages', verifyToken, messagingController.sendMessage);
router.delete('/messages/:messageId', verifyToken, messagingController.deleteMessage);
router.put('/conversations/:conversationId/read', verifyToken, messagingController.markConversationAsRead);

// Notifications
router.get('/notifications', verifyToken, notificationsController.getNotifications);
router.get('/notifications/unread/count', verifyToken, notificationsController.getUnreadCount);
router.put('/notifications/:notificationId/read', verifyToken, notificationsController.markAsRead);
router.put('/notifications/read/all', verifyToken, notificationsController.markAllAsRead);
router.delete('/notifications/:notificationId', verifyToken, notificationsController.deleteNotification);
router.post('/notifications/send', verifyToken, notificationsController.sendNotification);

// Indian IT Jobs & Companies
router.get('/india/jobs', optionalAuth, indianJobsController.getIndianJobs);
router.get('/india/jobs/:id', optionalAuth, indianJobsController.getIndianJobById);
router.get('/india/jobs/company/:company', optionalAuth, indianJobsController.getIndianJobsByCompany);
router.get('/india/companies', indianCompaniesController.getIndianITCompanies);
router.get('/india/companies/:id', indianCompaniesController.getIndianCompanyById);
router.get('/india/companies/city/:city', indianCompaniesController.getIndianCompaniesByCity);
router.get('/india/cities', indianCompaniesController.getIndianCitiesWithCompanies);

export default router;
