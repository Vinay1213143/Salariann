-- ============================================================================
-- SEED DATA FOR SALARIANN - TECH JOBS IN INDIA
-- Run this in Supabase SQL Editor
-- ============================================================================

-- Disable RLS on public tables (companies and jobs should be readable by all)
ALTER TABLE public.companies DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.city_metrics DISABLE ROW LEVEL SECURITY;

-- ============================================================================
-- SEED COMPANIES (Top Tech Companies in India)
-- ============================================================================
INSERT INTO public.companies (name, logo_url, website, employee_count, description, city, founded_year, industry, rating, total_reviews)
VALUES
  ('TCS', 'https://via.placeholder.com/100?text=TCS', 'https://www.tcs.com', 500000, 'Tata Consultancy Services - India''s largest IT company', 'Bangalore', 1968, 'IT Services', 4.2, 5000),
  ('Infosys', 'https://via.placeholder.com/100?text=Infosys', 'https://www.infosys.com', 300000, 'Leading global IT services and consulting company', 'Bangalore', 1981, 'IT Services', 4.1, 4500),
  ('Wipro', 'https://via.placeholder.com/100?text=Wipro', 'https://www.wipro.com', 250000, 'IT services and consulting company', 'Bangalore', 1980, 'IT Services', 4.0, 4000),
  ('HCL Technologies', 'https://via.placeholder.com/100?text=HCL', 'https://www.hcltech.com', 210000, 'IT services, software, and consulting', 'Noida', 1976, 'IT Services', 3.9, 3500),
  ('Tech Mahindra', 'https://via.placeholder.com/100?text=TechM', 'https://www.techmahindra.com', 150000, 'IT services and digital transformation', 'Pune', 1986, 'IT Services', 3.8, 3000),
  ('Cognizant', 'https://via.placeholder.com/100?text=Cognizant', 'https://www.cognizant.com', 340000, 'IT services and consulting', 'Hyderabad', 1994, 'IT Services', 4.0, 3800),
  ('Accenture', 'https://via.placeholder.com/100?text=Accenture', 'https://www.accenture.com', 750000, 'Global IT services and consulting', 'Bangalore', 1989, 'IT Services', 4.3, 5500),
  ('IBM India', 'https://via.placeholder.com/100?text=IBM', 'https://www.ibm.com/in', 100000, 'IT infrastructure and cloud services', 'Bangalore', 1992, 'IT Services', 4.1, 4200),
  ('Google India', 'https://via.placeholder.com/100?text=Google', 'https://www.google.com/careers/locations/india', 15000, 'Search, advertising, and cloud services', 'Bangalore', 2004, 'Technology', 4.6, 6000),
  ('Microsoft India', 'https://via.placeholder.com/100?text=Microsoft', 'https://careers.microsoft.com/us/en/search-results', 12000, 'Cloud computing and software solutions', 'Hyderabad', 1998, 'Technology', 4.5, 5800),
  ('Amazon India', 'https://via.placeholder.com/100?text=Amazon', 'https://www.amazon.jobs', 18000, 'E-commerce and cloud services', 'Bangalore', 2005, 'Technology', 4.4, 5500),
  ('Flipkart', 'https://via.placeholder.com/100?text=Flipkart', 'https://www.flipkart.com', 35000, 'E-commerce and fintech', 'Bangalore', 2007, 'E-commerce', 4.2, 4800),
  ('Swiggy', 'https://via.placeholder.com/100?text=Swiggy', 'https://www.swiggy.com', 8000, 'Food delivery and logistics', 'Bangalore', 2014, 'On-demand Services', 4.0, 3200),
  ('Ola', 'https://via.placeholder.com/100?text=Ola', 'https://www.olacabs.com', 12000, 'Ride-sharing and mobility', 'Bangalore', 2010, 'Mobility', 3.9, 3500),
  ('Paytm', 'https://via.placeholder.com/100?text=Paytm', 'https://paytm.com', 15000, 'Digital payments and fintech', 'Noida', 2010, 'Fintech', 3.8, 3300),
  ('PhonePe', 'https://via.placeholder.com/100?text=PhonePe', 'https://www.phonepe.com', 5000, 'Digital payments platform', 'Bangalore', 2015, 'Fintech', 4.3, 4500),
  ('Byju''s', 'https://via.placeholder.com/100?text=Byjus', 'https://www.byjus.com', 10000, 'EdTech and online learning', 'Bangalore', 2011, 'Education', 3.7, 2800),
  ('Unacademy', 'https://via.placeholder.com/100?text=Unacademy', 'https://unacademy.com', 3000, 'Online learning platform', 'Bangalore', 2015, 'Education', 4.1, 3500),
  ('Zerodha', 'https://via.placeholder.com/100?text=Zerodha', 'https://zerodha.com', 2500, 'Stock trading and fintech', 'Bangalore', 2010, 'Fintech', 4.5, 4800),
  ('Razorpay', 'https://via.placeholder.com/100?text=Razorpay', 'https://razorpay.com', 1500, 'Payment gateway and fintech', 'Bangalore', 2014, 'Fintech', 4.4, 4200);

-- ============================================================================
-- SEED JOBS (Tech Jobs across India - Multiple Cities)
-- ============================================================================

-- Get company IDs (we'll use the names to reference them)
WITH company_ids AS (
  SELECT id, name FROM public.companies
)

INSERT INTO public.jobs (company_id, title, description, city, annual_ctc_min, annual_ctc_max, tech_stack, ats_url, employment_type, experience_required, is_active)
SELECT 
  (SELECT id FROM company_ids WHERE name = 'TCS'), 
  'Senior Software Engineer', 
  'We are looking for experienced software engineers to join our development team. Work on cutting-edge technologies and build scalable solutions.',
  'Bangalore',
  1200000, 1800000,
  ARRAY['Java', 'Spring Boot', 'Microservices', 'Docker', 'Kubernetes'],
  'https://careers.tcs.com/jobs/senior-software-engineer',
  'Full-time',
  5
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'TCS'),
  'Full Stack Developer',
  'Join our agile team to develop web applications using modern tech stack. Work with React, Node.js, and cloud technologies.',
  'Hyderabad',
  900000, 1400000,
  ARRAY['React', 'Node.js', 'MongoDB', 'AWS', 'Docker'],
  'https://careers.tcs.com/jobs/full-stack-developer',
  'Full-time',
  3
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Infosys'),
  'Cloud Architect',
  'Design and implement cloud infrastructure solutions. Lead cloud migration projects for enterprise clients.',
  'Bangalore',
  1500000, 2200000,
  ARRAY['AWS', 'Azure', 'Kubernetes', 'Terraform', 'Python'],
  'https://careers.infosys.com/jobs/cloud-architect',
  'Full-time',
  7
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Infosys'),
  'Data Engineer',
  'Build data pipelines and ETL processes. Work with big data technologies and analytics platforms.',
  'Pune',
  1000000, 1600000,
  ARRAY['Spark', 'Hadoop', 'Python', 'SQL', 'Kafka'],
  'https://careers.infosys.com/jobs/data-engineer',
  'Full-time',
  4
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Wipro'),
  'DevOps Engineer',
  'Manage CI/CD pipelines and infrastructure automation. Ensure system reliability and performance.',
  'Bangalore',
  1100000, 1700000,
  ARRAY['Jenkins', 'Docker', 'Kubernetes', 'AWS', 'Terraform'],
  'https://careers.wipro.com/jobs/devops-engineer',
  'Full-time',
  4
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'HCL Technologies'),
  'QA Automation Engineer',
  'Develop automated test scripts and frameworks. Ensure product quality across platforms.',
  'Noida',
  800000, 1300000,
  ARRAY['Selenium', 'Java', 'TestNG', 'Jenkins', 'Git'],
  'https://careers.hcltech.com/jobs/qa-automation-engineer',
  'Full-time',
  3
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Tech Mahindra'),
  'AI/ML Engineer',
  'Develop machine learning models and AI solutions. Work on NLP, computer vision, and predictive analytics.',
  'Pune',
  1300000, 2000000,
  ARRAY['Python', 'TensorFlow', 'PyTorch', 'Scikit-learn', 'SQL'],
  'https://careers.techmahindra.com/jobs/ai-ml-engineer',
  'Full-time',
  5
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Cognizant'),
  'Mobile App Developer',
  'Build iOS and Android applications. Create engaging mobile experiences for millions of users.',
  'Hyderabad',
  950000, 1500000,
  ARRAY['Swift', 'Kotlin', 'React Native', 'Firebase', 'REST APIs'],
  'https://careers.cognizant.com/jobs/mobile-app-developer',
  'Full-time',
  3
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Accenture'),
  'Solutions Architect',
  'Design enterprise solutions and lead technical implementations. Engage with clients and drive innovation.',
  'Bangalore',
  1600000, 2400000,
  ARRAY['Cloud', 'Microservices', 'Enterprise Architecture', 'Agile', 'Leadership'],
  'https://careers.accenture.com/jobs/solutions-architect',
  'Full-time',
  8
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'IBM India'),
  'Systems Engineer',
  'Support and maintain enterprise systems. Provide technical solutions to complex infrastructure challenges.',
  'Bangalore',
  1000000, 1500000,
  ARRAY['Linux', 'Windows Server', 'Networking', 'Virtualization', 'Scripting'],
  'https://careers.ibm.com/jobs/systems-engineer',
  'Full-time',
  4
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Google India'),
  'Software Engineer',
  'Build products used by billions. Work on challenging problems in search, ads, and cloud.',
  'Bangalore',
  2000000, 3500000,
  ARRAY['C++', 'Java', 'Python', 'Go', 'Distributed Systems'],
  'https://careers.google.com/jobs/results/bangalore-software-engineer',
  'Full-time',
  3
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Microsoft India'),
  'Cloud Solutions Architect',
  'Design and implement Azure cloud solutions. Help customers achieve their digital transformation goals.',
  'Hyderabad',
  1800000, 2700000,
  ARRAY['Azure', 'C#', '.NET', 'PowerShell', 'SQL Server'],
  'https://careers.microsoft.com/jobs/cloud-solutions-architect',
  'Full-time',
  6
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Amazon India'),
  'Backend Engineer',
  'Build scalable backend systems. Work on high-traffic services handling millions of requests.',
  'Bangalore',
  1700000, 2600000,
  ARRAY['Java', 'Python', 'DynamoDB', 'S3', 'Lambda'],
  'https://www.amazon.jobs/en/jobs/backend-engineer-bangalore',
  'Full-time',
  4
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Flipkart'),
  'Senior Frontend Engineer',
  'Build responsive web applications. Optimize performance and user experience for millions of users.',
  'Bangalore',
  1400000, 2200000,
  ARRAY['React', 'JavaScript', 'TypeScript', 'Redux', 'CSS'],
  'https://www.flipkart.careers/jobs/senior-frontend-engineer',
  'Full-time',
  5
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Swiggy'),
  'Backend Engineer',
  'Build APIs and services for food delivery platform. Handle real-time order processing and logistics.',
  'Bangalore',
  1200000, 1900000,
  ARRAY['Node.js', 'Python', 'PostgreSQL', 'Redis', 'RabbitMQ'],
  'https://www.swiggycareers.com/jobs/backend-engineer',
  'Full-time',
  3
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Ola'),
  'Data Scientist',
  'Analyze ride data and build predictive models. Optimize pricing, routing, and customer experience.',
  'Bangalore',
  1300000, 2000000,
  ARRAY['Python', 'SQL', 'Spark', 'Tableau', 'Statistics'],
  'https://www.olacareers.com/jobs/data-scientist',
  'Full-time',
  4
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Paytm'),
  'Full Stack Engineer',
  'Build payment and fintech solutions. Work on secure, scalable systems handling millions of transactions.',
  'Noida',
  1100000, 1700000,
  ARRAY['Java', 'React', 'PostgreSQL', 'Redis', 'Kafka'],
  'https://www.paytm.careers/jobs/full-stack-engineer',
  'Full-time',
  3
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'PhonePe'),
  'Senior Backend Engineer',
  'Build high-performance payment systems. Handle millions of transactions per day with zero downtime.',
  'Bangalore',
  1500000, 2300000,
  ARRAY['Java', 'Kotlin', 'Spring Boot', 'PostgreSQL', 'Cassandra'],
  'https://www.phonepe.careers/jobs/senior-backend-engineer',
  'Full-time',
  5
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Byju''s'),
  'Frontend Engineer',
  'Build engaging educational interfaces. Create interactive learning experiences for students.',
  'Bangalore',
  900000, 1400000,
  ARRAY['React', 'Vue.js', 'JavaScript', 'WebGL', 'Canvas'],
  'https://www.byjus.careers/jobs/frontend-engineer',
  'Full-time',
  2
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Unacademy'),
  'Backend Engineer',
  'Build scalable video streaming and learning platform. Handle millions of concurrent users.',
  'Bangalore',
  1000000, 1600000,
  ARRAY['Python', 'Django', 'PostgreSQL', 'Redis', 'WebRTC'],
  'https://www.unacademy.careers/jobs/backend-engineer',
  'Full-time',
  3
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Zerodha'),
  'Systems Engineer',
  'Build high-frequency trading systems. Ensure low-latency, reliable infrastructure for stock trading.',
  'Bangalore',
  1400000, 2100000,
  ARRAY['C++', 'Python', 'Linux', 'Networking', 'Databases'],
  'https://www.zerodha.careers/jobs/systems-engineer',
  'Full-time',
  4
UNION ALL
SELECT 
  (SELECT id FROM company_ids WHERE name = 'Razorpay'),
  'Payment Systems Engineer',
  'Build secure payment processing systems. Work on PCI-DSS compliant infrastructure.',
  'Bangalore',
  1300000, 2000000,
  ARRAY['Go', 'Python', 'PostgreSQL', 'Redis', 'Kubernetes'],
  'Full-time',
  'https://www.razorpay.careers/jobs/payment-systems-engineer',
  4;

-- ============================================================================
-- SEED CITY METRICS (Cost of Living Data for Indian Cities)
-- ============================================================================
INSERT INTO public.city_metrics (city_name, country, rent_1bhk, food_monthly, utilities_monthly, transportation_monthly, miscellaneous_monthly, average_salary)
VALUES
  ('Bangalore', 'India', 25000, 8000, 2500, 2000, 3000, 1200000),
  ('Hyderabad', 'India', 18000, 7000, 2000, 1500, 2500, 1000000),
  ('Pune', 'India', 20000, 7500, 2200, 1800, 2800, 1050000),
  ('Noida', 'India', 16000, 6500, 2000, 1500, 2300, 950000),
  ('Mumbai', 'India', 35000, 9000, 3000, 2500, 3500, 1300000),
  ('Delhi', 'India', 22000, 7500, 2300, 2000, 2800, 1100000),
  ('Gurgaon', 'India', 28000, 8000, 2600, 2200, 3200, 1250000),
  ('Kolkata', 'India', 14000, 6000, 1800, 1200, 2000, 850000),
  ('Chennai', 'India', 18000, 7000, 2000, 1500, 2500, 950000),
  ('Ahmedabad', 'India', 15000, 6500, 1900, 1300, 2200, 900000);

-- ============================================================================
-- ENABLE RLS BACK WITH PROPER POLICIES
-- ============================================================================
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.city_metrics ENABLE ROW LEVEL SECURITY;

-- Allow public read access to companies, jobs, and city_metrics
CREATE POLICY "Companies are readable by all" ON public.companies FOR SELECT USING (true);
CREATE POLICY "Jobs are readable by all" ON public.jobs FOR SELECT USING (true);
CREATE POLICY "City metrics are readable by all" ON public.city_metrics FOR SELECT USING (true);

-- Only service role can insert/update/delete (via backend)
CREATE POLICY "Only service role can manage companies" ON public.companies FOR INSERT WITH CHECK (false);
CREATE POLICY "Only service role can update companies" ON public.companies FOR UPDATE WITH CHECK (false);
CREATE POLICY "Only service role can delete companies" ON public.companies FOR DELETE USING (false);

CREATE POLICY "Only service role can manage jobs" ON public.jobs FOR INSERT WITH CHECK (false);
CREATE POLICY "Only service role can update jobs" ON public.jobs FOR UPDATE WITH CHECK (false);
CREATE POLICY "Only service role can delete jobs" ON public.jobs FOR DELETE USING (false);
