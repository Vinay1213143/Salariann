import { supabase } from '../config/supabase.js';

// Seed companies
export const seedCompanies = async (req, res) => {
  try {
    const companies = [
      {
        name: 'TCS',
        logo_url: 'https://via.placeholder.com/100?text=TCS',
        website: 'https://www.tcs.com',
        employee_count: 500000,
        city: 'Bangalore',
        description: 'Tata Consultancy Services - India\'s largest IT company'
      },
      {
        name: 'Infosys',
        logo_url: 'https://via.placeholder.com/100?text=Infosys',
        website: 'https://www.infosys.com',
        employee_count: 300000,
        city: 'Bangalore',
        description: 'Leading global IT services and consulting company'
      },
      {
        name: 'Wipro',
        logo_url: 'https://via.placeholder.com/100?text=Wipro',
        website: 'https://www.wipro.com',
        employee_count: 250000,
        city: 'Bangalore',
        description: 'IT services and consulting company'
      },
      {
        name: 'HCL Technologies',
        logo_url: 'https://via.placeholder.com/100?text=HCL',
        website: 'https://www.hcltech.com',
        employee_count: 210000,
        city: 'Noida',
        description: 'IT services, software, and consulting'
      },
      {
        name: 'Tech Mahindra',
        logo_url: 'https://via.placeholder.com/100?text=TechM',
        website: 'https://www.techmahindra.com',
        employee_count: 150000,
        city: 'Pune',
        description: 'IT services and digital transformation'
      },
      {
        name: 'Cognizant',
        logo_url: 'https://via.placeholder.com/100?text=Cognizant',
        website: 'https://www.cognizant.com',
        employee_count: 340000,
        city: 'Hyderabad',
        description: 'IT services and consulting'
      },
      {
        name: 'Accenture',
        logo_url: 'https://via.placeholder.com/100?text=Accenture',
        website: 'https://www.accenture.com',
        employee_count: 750000,
        city: 'Bangalore',
        description: 'Global IT services and consulting'
      },
      {
        name: 'IBM India',
        logo_url: 'https://via.placeholder.com/100?text=IBM',
        website: 'https://www.ibm.com/in',
        employee_count: 100000,
        city: 'Bangalore',
        description: 'IT infrastructure and cloud services'
      }
    ];

    const { data, error } = await supabase
      .from('companies')
      .insert(companies)
      .select();

    if (error) throw error;

    res.json({
      success: true,
      message: `${data.length} companies created`,
      data
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Seed jobs
export const seedJobs = async (req, res) => {
  try {
    // First get all companies
    const { data: companies, error: compError } = await supabase
      .from('companies')
      .select('id, name');

    if (compError) throw compError;

    const jobsData = [
      {
        company_id: companies.find(c => c.name === 'TCS')?.id,
        title: 'Senior Software Engineer',
        description: 'Looking for experienced software engineer with 5+ years experience in Java and Spring Boot',
        city: 'Bangalore',
        annual_ctc_min: 1200000,
        annual_ctc_max: 1800000,
        tech_stack: ['Java', 'Spring Boot', 'Microservices', 'Docker'],
        ats_url: 'https://tcs.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'Infosys')?.id,
        title: 'Full Stack Developer',
        description: 'Full stack developer needed for React and Node.js projects',
        city: 'Bangalore',
        annual_ctc_min: 1000000,
        annual_ctc_max: 1600000,
        tech_stack: ['React', 'Node.js', 'MongoDB', 'AWS'],
        ats_url: 'https://infosys.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'Wipro')?.id,
        title: 'Python Developer',
        description: 'Python developer for data analytics and automation projects',
        city: 'Hyderabad',
        annual_ctc_min: 900000,
        annual_ctc_max: 1400000,
        tech_stack: ['Python', 'Django', 'PostgreSQL', 'Linux'],
        ats_url: 'https://wipro.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'HCL Technologies')?.id,
        title: 'DevOps Engineer',
        description: 'DevOps engineer with Kubernetes and CI/CD experience',
        city: 'Noida',
        annual_ctc_min: 1100000,
        annual_ctc_max: 1700000,
        tech_stack: ['Kubernetes', 'Docker', 'Jenkins', 'AWS'],
        ats_url: 'https://hcl.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'Tech Mahindra')?.id,
        title: 'Cloud Architect',
        description: 'Cloud architect for AWS and Azure solutions',
        city: 'Pune',
        annual_ctc_min: 1500000,
        annual_ctc_max: 2200000,
        tech_stack: ['AWS', 'Azure', 'Terraform', 'Docker'],
        ats_url: 'https://techmahindra.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'Cognizant')?.id,
        title: 'Data Engineer',
        description: 'Data engineer for big data and analytics platform',
        city: 'Hyderabad',
        annual_ctc_min: 1100000,
        annual_ctc_max: 1800000,
        tech_stack: ['Spark', 'Hadoop', 'Python', 'SQL'],
        ats_url: 'https://cognizant.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'Accenture')?.id,
        title: 'Frontend Developer',
        description: 'Frontend developer with React and TypeScript expertise',
        city: 'Bangalore',
        annual_ctc_min: 950000,
        annual_ctc_max: 1550000,
        tech_stack: ['React', 'TypeScript', 'CSS', 'JavaScript'],
        ats_url: 'https://accenture.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'IBM India')?.id,
        title: 'Java Developer',
        description: 'Java developer for enterprise applications',
        city: 'Bangalore',
        annual_ctc_min: 1000000,
        annual_ctc_max: 1600000,
        tech_stack: ['Java', 'Spring', 'Oracle', 'Linux'],
        ats_url: 'https://ibm.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'TCS')?.id,
        title: 'QA Automation Engineer',
        description: 'QA automation engineer with Selenium and TestNG',
        city: 'Bangalore',
        annual_ctc_min: 800000,
        annual_ctc_max: 1300000,
        tech_stack: ['Selenium', 'TestNG', 'Java', 'CI/CD'],
        ats_url: 'https://tcs.com/careers/apply',
        is_active: true
      },
      {
        company_id: companies.find(c => c.name === 'Infosys')?.id,
        title: 'Solutions Architect',
        description: 'Solutions architect for enterprise solutions',
        city: 'Bangalore',
        annual_ctc_min: 1600000,
        annual_ctc_max: 2400000,
        tech_stack: ['Architecture', 'Cloud', 'Microservices', 'AWS'],
        ats_url: 'https://infosys.com/careers/apply',
        is_active: true
      }
    ];

    const { data, error } = await supabase
      .from('jobs')
      .insert(jobsData)
      .select();

    if (error) throw error;

    res.json({
      success: true,
      message: `${data.length} jobs created`,
      data
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Seed reviews (requires user_id, so we'll skip for now)
export const seedReviews = async (req, res) => {
  try {
    res.json({
      success: true,
      message: 'Reviews require user authentication. Please create reviews through the app UI.',
      note: 'Use POST /reviews endpoint with authenticated user'
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Seed salaries
export const seedSalaries = async (req, res) => {
  try {
    const { data: companies } = await supabase
      .from('companies')
      .select('id, name');

    const salariesData = [
      {
        company_id: companies.find(c => c.name === 'TCS')?.id,
        role: 'Senior Software Engineer',
        annual_ctc: 1500000,
        years_of_experience: 5,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'TCS')?.id,
        role: 'Senior Software Engineer',
        annual_ctc: 1600000,
        years_of_experience: 6,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'Infosys')?.id,
        role: 'Full Stack Developer',
        annual_ctc: 1200000,
        years_of_experience: 3,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'Infosys')?.id,
        role: 'Full Stack Developer',
        annual_ctc: 1400000,
        years_of_experience: 4,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'Wipro')?.id,
        role: 'Python Developer',
        annual_ctc: 1000000,
        years_of_experience: 2,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'Wipro')?.id,
        role: 'Python Developer',
        annual_ctc: 1200000,
        years_of_experience: 3,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'HCL Technologies')?.id,
        role: 'DevOps Engineer',
        annual_ctc: 1300000,
        years_of_experience: 4,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'Cognizant')?.id,
        role: 'Data Engineer',
        annual_ctc: 1400000,
        years_of_experience: 5,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'Accenture')?.id,
        role: 'Frontend Developer',
        annual_ctc: 1100000,
        years_of_experience: 3,
        is_anonymous: true
      },
      {
        company_id: companies.find(c => c.name === 'IBM India')?.id,
        role: 'Java Developer',
        annual_ctc: 1200000,
        years_of_experience: 4,
        is_anonymous: true
      }
    ];

    const { data, error } = await supabase
      .from('salaries')
      .insert(salariesData)
      .select();

    if (error) throw error;

    res.json({
      success: true,
      message: `${data.length} salary records created`,
      data
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Seed interviews
export const seedInterviews = async (req, res) => {
  try {
    const { data: companies } = await supabase
      .from('companies')
      .select('id, name');

    const interviewsData = [
      {
        company_id: companies.find(c => c.name === 'TCS')?.id,
        role: 'Senior Software Engineer',
        difficulty_level: 'Medium',
        questions: 'System design, Java questions, SQL queries',
        experience: 'Good experience, friendly interviewers',
        result: 'Selected'
      },
      {
        company_id: companies.find(c => c.name === 'Infosys')?.id,
        role: 'Full Stack Developer',
        difficulty_level: 'Medium',
        questions: 'React questions, Node.js, database design',
        experience: 'Smooth process, 3 rounds',
        result: 'Selected'
      },
      {
        company_id: companies.find(c => c.name === 'Wipro')?.id,
        role: 'Python Developer',
        difficulty_level: 'Easy',
        questions: 'Python basics, algorithms, problem solving',
        experience: 'Easy and quick process',
        result: 'Selected'
      },
      {
        company_id: companies.find(c => c.name === 'HCL Technologies')?.id,
        role: 'DevOps Engineer',
        difficulty_level: 'Hard',
        questions: 'Kubernetes, Docker, CI/CD pipelines',
        experience: 'Challenging but fair',
        result: 'Selected'
      },
      {
        company_id: companies.find(c => c.name === 'Cognizant')?.id,
        role: 'Data Engineer',
        difficulty_level: 'Medium',
        questions: 'Spark, Hadoop, SQL optimization',
        experience: 'Good technical questions',
        result: 'Selected'
      }
    ];

    const { data, error } = await supabase
      .from('interviews')
      .insert(interviewsData)
      .select();

    if (error) throw error;

    res.json({
      success: true,
      message: `${data.length} interview records created`,
      data
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Direct seed jobs with hardcoded company IDs
export const seedJobsDirect = async (req, res) => {
  try {
    const jobsData = [
      {
        company_id: '79a5052f-b02f-4afc-bb73-f55d48606896', // TCS
        title: 'Senior Software Engineer',
        description: 'Looking for experienced software engineer with 5+ years experience in Java and Spring Boot',
        city: 'Bangalore',
        annual_ctc_min: 1200000,
        annual_ctc_max: 1800000,
        tech_stack: ['Java', 'Spring Boot', 'Microservices', 'Docker'],
        ats_url: 'https://tcs.com/careers/apply',
        is_active: true
      },
      {
        company_id: '11d500a2-8903-4769-8e03-537d7f25072a', // Infosys
        title: 'Full Stack Developer',
        description: 'Full stack developer needed for React and Node.js projects',
        city: 'Bangalore',
        annual_ctc_min: 1000000,
        annual_ctc_max: 1600000,
        tech_stack: ['React', 'Node.js', 'MongoDB', 'AWS'],
        ats_url: 'https://infosys.com/careers/apply',
        is_active: true
      },
      {
        company_id: '7b84a90d-d32e-48dd-a8c1-3bea561deba5', // Wipro
        title: 'Python Developer',
        description: 'Python developer for data analytics and automation projects',
        city: 'Hyderabad',
        annual_ctc_min: 900000,
        annual_ctc_max: 1400000,
        tech_stack: ['Python', 'Django', 'PostgreSQL', 'Linux'],
        ats_url: 'https://wipro.com/careers/apply',
        is_active: true
      },
      {
        company_id: 'cec1b865-4cb5-4363-8d42-6c872b009412', // HCL
        title: 'DevOps Engineer',
        description: 'DevOps engineer with Kubernetes and CI/CD experience',
        city: 'Noida',
        annual_ctc_min: 1100000,
        annual_ctc_max: 1700000,
        tech_stack: ['Kubernetes', 'Docker', 'Jenkins', 'AWS'],
        ats_url: 'https://hcl.com/careers/apply',
        is_active: true
      },
      {
        company_id: 'b494d689-64a6-4018-a509-0a17190355c9', // Tech Mahindra
        title: 'Cloud Architect',
        description: 'Cloud architect for AWS and Azure solutions',
        city: 'Pune',
        annual_ctc_min: 1500000,
        annual_ctc_max: 2200000,
        tech_stack: ['AWS', 'Azure', 'Terraform', 'Docker'],
        ats_url: 'https://techmahindra.com/careers/apply',
        is_active: true
      },
      {
        company_id: '1f2e339f-9fbb-4bc6-88d6-134dbf00a384', // Cognizant
        title: 'Data Engineer',
        description: 'Data engineer for big data and analytics platform',
        city: 'Hyderabad',
        annual_ctc_min: 1100000,
        annual_ctc_max: 1800000,
        tech_stack: ['Spark', 'Hadoop', 'Python', 'SQL'],
        ats_url: 'https://cognizant.com/careers/apply',
        is_active: true
      },
      {
        company_id: '0f363520-7ac2-4dab-87aa-9f13979f75a5', // Accenture
        title: 'Frontend Developer',
        description: 'Frontend developer with React and TypeScript expertise',
        city: 'Bangalore',
        annual_ctc_min: 950000,
        annual_ctc_max: 1550000,
        tech_stack: ['React', 'TypeScript', 'CSS', 'JavaScript'],
        ats_url: 'https://accenture.com/careers/apply',
        is_active: true
      },
      {
        company_id: '79a5052f-b02f-4afc-bb73-f55d48606896', // TCS
        title: 'QA Automation Engineer',
        description: 'QA automation engineer with Selenium and TestNG',
        city: 'Bangalore',
        annual_ctc_min: 800000,
        annual_ctc_max: 1300000,
        tech_stack: ['Selenium', 'TestNG', 'Java', 'CI/CD'],
        ats_url: 'https://tcs.com/careers/apply',
        is_active: true
      },
      {
        company_id: '11d500a2-8903-4769-8e03-537d7f25072a', // Infosys
        title: 'Solutions Architect',
        description: 'Solutions architect for enterprise solutions',
        city: 'Bangalore',
        annual_ctc_min: 1600000,
        annual_ctc_max: 2400000,
        tech_stack: ['Architecture', 'Cloud', 'Microservices', 'AWS'],
        ats_url: 'https://infosys.com/careers/apply',
        is_active: true
      }
    ];

    const { data, error } = await supabase
      .from('jobs')
      .insert(jobsData)
      .select();

    if (error) throw error;

    res.json({
      success: true,
      message: `${data.length} jobs created`,
      data
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Seed all data at once
export const seedAll = async (req, res) => {
  try {
    const results = {};

    // Seed companies
    const { data: companies, error: compError } = await supabase
      .from('companies')
      .insert([
        {
          name: 'TCS',
          logo_url: 'https://via.placeholder.com/100?text=TCS',
          website: 'https://www.tcs.com',
          employee_count: 500000,
          city: 'Bangalore',
          description: 'Tata Consultancy Services - India\'s largest IT company'
        },
        {
          name: 'Infosys',
          logo_url: 'https://via.placeholder.com/100?text=Infosys',
          website: 'https://www.infosys.com',
          employee_count: 300000,
          city: 'Bangalore',
          description: 'Leading global IT services and consulting company'
        },
        {
          name: 'Wipro',
          logo_url: 'https://via.placeholder.com/100?text=Wipro',
          website: 'https://www.wipro.com',
          employee_count: 250000,
          city: 'Bangalore',
          description: 'IT services and consulting company'
        },
        {
          name: 'HCL Technologies',
          logo_url: 'https://via.placeholder.com/100?text=HCL',
          website: 'https://www.hcltech.com',
          employee_count: 210000,
          city: 'Noida',
          description: 'IT services, software, and consulting'
        },
        {
          name: 'Tech Mahindra',
          logo_url: 'https://via.placeholder.com/100?text=TechM',
          website: 'https://www.techmahindra.com',
          employee_count: 150000,
          city: 'Pune',
          description: 'IT services and digital transformation'
        },
        {
          name: 'Cognizant',
          logo_url: 'https://via.placeholder.com/100?text=Cognizant',
          website: 'https://www.cognizant.com',
          employee_count: 340000,
          city: 'Hyderabad',
          description: 'IT services and consulting'
        },
        {
          name: 'Accenture',
          logo_url: 'https://via.placeholder.com/100?text=Accenture',
          website: 'https://www.accenture.com',
          employee_count: 750000,
          city: 'Bangalore',
          description: 'Global IT services and consulting'
        },
        {
          name: 'IBM India',
          logo_url: 'https://via.placeholder.com/100?text=IBM',
          website: 'https://www.ibm.com/in',
          employee_count: 100000,
          city: 'Bangalore',
          description: 'IT infrastructure and cloud services'
        }
      ])
      .select();

    if (compError) throw compError;
    results.companies = { count: companies.length, data: companies };

    res.json({
      success: true,
      message: 'All seed data created successfully',
      results
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
