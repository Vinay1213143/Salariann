-- Seed data for Salariann platform
-- Companies
INSERT INTO public.companies (name, logo_url, website, employee_count, city, description) VALUES
('TCS', 'https://via.placeholder.com/100?text=TCS', 'https://www.tcs.com', 500000, 'Bangalore', 'Tata Consultancy Services - India''s largest IT company'),
('Infosys', 'https://via.placeholder.com/100?text=Infosys', 'https://www.infosys.com', 300000, 'Bangalore', 'Leading global IT services and consulting company'),
('Wipro', 'https://via.placeholder.com/100?text=Wipro', 'https://www.wipro.com', 250000, 'Bangalore', 'IT services and consulting company'),
('HCL Technologies', 'https://via.placeholder.com/100?text=HCL', 'https://www.hcltech.com', 210000, 'Noida', 'IT services, software, and consulting'),
('Tech Mahindra', 'https://via.placeholder.com/100?text=TechM', 'https://www.techmahindra.com', 150000, 'Pune', 'IT services and digital transformation'),
('Cognizant', 'https://via.placeholder.com/100?text=Cognizant', 'https://www.cognizant.com', 340000, 'Hyderabad', 'IT services and consulting'),
('Accenture', 'https://via.placeholder.com/100?text=Accenture', 'https://www.accenture.com', 750000, 'Bangalore', 'Global IT services and consulting'),
('IBM India', 'https://via.placeholder.com/100?text=IBM', 'https://www.ibm.com/in', 100000, 'Bangalore', 'IT infrastructure and cloud services');

-- Jobs
INSERT INTO public.jobs (company_id, title, description, city, salary_min, salary_max, tech_stack, ats_url, is_active) VALUES
((SELECT id FROM public.companies WHERE name = 'TCS' LIMIT 1), 'Senior Software Engineer', 'Looking for experienced software engineer with 5+ years experience in Java and Spring Boot', 'Bangalore', 1200000, 1800000, 'Java,Spring Boot,Microservices,Docker', 'https://tcs.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'Infosys' LIMIT 1), 'Full Stack Developer', 'Full stack developer needed for React and Node.js projects', 'Bangalore', 1000000, 1600000, 'React,Node.js,MongoDB,AWS', 'https://infosys.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'Wipro' LIMIT 1), 'Python Developer', 'Python developer for data analytics and automation projects', 'Hyderabad', 900000, 1400000, 'Python,Django,PostgreSQL,Linux', 'https://wipro.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'HCL Technologies' LIMIT 1), 'DevOps Engineer', 'DevOps engineer with Kubernetes and CI/CD experience', 'Noida', 1100000, 1700000, 'Kubernetes,Docker,Jenkins,AWS', 'https://hcl.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'Tech Mahindra' LIMIT 1), 'Cloud Architect', 'Cloud architect for AWS and Azure solutions', 'Pune', 1500000, 2200000, 'AWS,Azure,Terraform,Docker', 'https://techmahindra.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'Cognizant' LIMIT 1), 'Data Engineer', 'Data engineer for big data and analytics platform', 'Hyderabad', 1100000, 1800000, 'Spark,Hadoop,Python,SQL', 'https://cognizant.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'Accenture' LIMIT 1), 'Frontend Developer', 'Frontend developer with React and TypeScript expertise', 'Bangalore', 950000, 1550000, 'React,TypeScript,CSS,JavaScript', 'https://accenture.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'IBM India' LIMIT 1), 'Java Developer', 'Java developer for enterprise applications', 'Bangalore', 1000000, 1600000, 'Java,Spring,Oracle,Linux', 'https://ibm.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'TCS' LIMIT 1), 'QA Automation Engineer', 'QA automation engineer with Selenium and TestNG', 'Bangalore', 800000, 1300000, 'Selenium,TestNG,Java,CI/CD', 'https://tcs.com/careers/apply', true),
((SELECT id FROM public.companies WHERE name = 'Infosys' LIMIT 1), 'Solutions Architect', 'Solutions architect for enterprise solutions', 'Bangalore', 1600000, 2400000, 'Architecture,Cloud,Microservices,AWS', 'https://infosys.com/careers/apply', true);

-- Sample Reviews
INSERT INTO public.reviews (company_id, user_id, overall_rating, work_life_balance_rating, skill_development_rating, management_rating, pros, cons) VALUES
((SELECT id FROM public.companies WHERE name = 'TCS' LIMIT 1), NULL, 4, 3, 4, 3, 'Good learning opportunities, stable company', 'Slow decision making, bureaucracy'),
((SELECT id FROM public.companies WHERE name = 'Infosys' LIMIT 1), NULL, 4, 4, 4, 4, 'Great work-life balance, good projects', 'Salary growth could be better'),
((SELECT id FROM public.companies WHERE name = 'Wipro' LIMIT 1), NULL, 3, 3, 3, 3, 'Decent company, good benefits', 'Limited growth opportunities'),
((SELECT id FROM public.companies WHERE name = 'HCL Technologies' LIMIT 1), NULL, 4, 4, 4, 4, 'Excellent management, good projects', 'Competitive market'),
((SELECT id FROM public.companies WHERE name = 'Tech Mahindra' LIMIT 1), NULL, 4, 4, 4, 4, 'Great culture, good learning', 'Work pressure during deadlines');

-- Sample Salaries
INSERT INTO public.salaries (company_id, role, annual_ctc, years_of_experience, is_anonymous) VALUES
((SELECT id FROM public.companies WHERE name = 'TCS' LIMIT 1), 'Senior Software Engineer', 1500000, 5, true),
((SELECT id FROM public.companies WHERE name = 'TCS' LIMIT 1), 'Senior Software Engineer', 1600000, 6, true),
((SELECT id FROM public.companies WHERE name = 'Infosys' LIMIT 1), 'Full Stack Developer', 1200000, 3, true),
((SELECT id FROM public.companies WHERE name = 'Infosys' LIMIT 1), 'Full Stack Developer', 1400000, 4, true),
((SELECT id FROM public.companies WHERE name = 'Wipro' LIMIT 1), 'Python Developer', 1000000, 2, true),
((SELECT id FROM public.companies WHERE name = 'Wipro' LIMIT 1), 'Python Developer', 1200000, 3, true),
((SELECT id FROM public.companies WHERE name = 'HCL Technologies' LIMIT 1), 'DevOps Engineer', 1300000, 4, true),
((SELECT id FROM public.companies WHERE name = 'Cognizant' LIMIT 1), 'Data Engineer', 1400000, 5, true),
((SELECT id FROM public.companies WHERE name = 'Accenture' LIMIT 1), 'Frontend Developer', 1100000, 3, true),
((SELECT id FROM public.companies WHERE name = 'IBM India' LIMIT 1), 'Java Developer', 1200000, 4, true);

-- Sample Interviews
INSERT INTO public.interviews (company_id, role, difficulty_level, questions, experience, result) VALUES
((SELECT id FROM public.companies WHERE name = 'TCS' LIMIT 1), 'Senior Software Engineer', 'Medium', 'System design, Java questions, SQL queries', 'Good experience, friendly interviewers', 'Selected'),
((SELECT id FROM public.companies WHERE name = 'Infosys' LIMIT 1), 'Full Stack Developer', 'Medium', 'React questions, Node.js, database design', 'Smooth process, 3 rounds', 'Selected'),
((SELECT id FROM public.companies WHERE name = 'Wipro' LIMIT 1), 'Python Developer', 'Easy', 'Python basics, algorithms, problem solving', 'Easy and quick process', 'Selected'),
((SELECT id FROM public.companies WHERE name = 'HCL Technologies' LIMIT 1), 'DevOps Engineer', 'Hard', 'Kubernetes, Docker, CI/CD pipelines', 'Challenging but fair', 'Selected'),
((SELECT id FROM public.companies WHERE name = 'Cognizant' LIMIT 1), 'Data Engineer', 'Medium', 'Spark, Hadoop, SQL optimization', 'Good technical questions', 'Selected');
