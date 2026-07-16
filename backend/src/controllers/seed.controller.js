import { createClient } from '@supabase/supabase-js';

// Use service role key for seeding (bypasses RLS)
const supabaseAdmin = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

const companies = [
  { name: 'TCS', logo_url: 'https://via.placeholder.com/100?text=TCS', website: 'https://www.tcs.com', employee_count: 500000, description: 'Tata Consultancy Services - India\'s largest IT company', city: 'Bangalore', founded_year: 1968, industry: 'IT Services', rating: 4.2, total_reviews: 5000 },
  { name: 'Infosys', logo_url: 'https://via.placeholder.com/100?text=Infosys', website: 'https://www.infosys.com', employee_count: 300000, description: 'Leading global IT services and consulting company', city: 'Bangalore', founded_year: 1981, industry: 'IT Services', rating: 4.1, total_reviews: 4500 },
  { name: 'Wipro', logo_url: 'https://via.placeholder.com/100?text=Wipro', website: 'https://www.wipro.com', employee_count: 250000, description: 'IT services and consulting company', city: 'Bangalore', founded_year: 1980, industry: 'IT Services', rating: 4.0, total_reviews: 4000 },
  { name: 'HCL Technologies', logo_url: 'https://via.placeholder.com/100?text=HCL', website: 'https://www.hcltech.com', employee_count: 210000, description: 'IT services, software, and consulting', city: 'Noida', founded_year: 1976, industry: 'IT Services', rating: 3.9, total_reviews: 3500 },
  { name: 'Tech Mahindra', logo_url: 'https://via.placeholder.com/100?text=TechM', website: 'https://www.techmahindra.com', employee_count: 150000, description: 'IT services and digital transformation', city: 'Pune', founded_year: 1986, industry: 'IT Services', rating: 3.8, total_reviews: 3000 },
  { name: 'Cognizant', logo_url: 'https://via.placeholder.com/100?text=Cognizant', website: 'https://www.cognizant.com', employee_count: 340000, description: 'IT services and consulting', city: 'Hyderabad', founded_year: 1994, industry: 'IT Services', rating: 4.0, total_reviews: 3800 },
  { name: 'Accenture', logo_url: 'https://via.placeholder.com/100?text=Accenture', website: 'https://www.accenture.com', employee_count: 750000, description: 'Global IT services and consulting', city: 'Bangalore', founded_year: 1989, industry: 'IT Services', rating: 4.3, total_reviews: 5500 },
  { name: 'IBM India', logo_url: 'https://via.placeholder.com/100?text=IBM', website: 'https://www.ibm.com/in', employee_count: 100000, description: 'IT infrastructure and cloud services', city: 'Bangalore', founded_year: 1992, industry: 'IT Services', rating: 4.1, total_reviews: 4200 },
  { name: 'Google India', logo_url: 'https://via.placeholder.com/100?text=Google', website: 'https://www.google.com/careers', employee_count: 15000, description: 'Search, advertising, and cloud services', city: 'Bangalore', founded_year: 2004, industry: 'Technology', rating: 4.6, total_reviews: 6000 },
  { name: 'Microsoft India', logo_url: 'https://via.placeholder.com/100?text=Microsoft', website: 'https://careers.microsoft.com', employee_count: 12000, description: 'Cloud computing and software solutions', city: 'Hyderabad', founded_year: 1998, industry: 'Technology', rating: 4.5, total_reviews: 5800 },
  { name: 'Amazon India', logo_url: 'https://via.placeholder.com/100?text=Amazon', website: 'https://www.amazon.jobs', employee_count: 18000, description: 'E-commerce and cloud services', city: 'Bangalore', founded_year: 2005, industry: 'Technology', rating: 4.4, total_reviews: 5500 },
  { name: 'Flipkart', logo_url: 'https://via.placeholder.com/100?text=Flipkart', website: 'https://www.flipkart.com', employee_count: 35000, description: 'E-commerce and fintech', city: 'Bangalore', founded_year: 2007, industry: 'E-commerce', rating: 4.2, total_reviews: 4800 },
  { name: 'Swiggy', logo_url: 'https://via.placeholder.com/100?text=Swiggy', website: 'https://www.swiggy.com', employee_count: 8000, description: 'Food delivery and logistics', city: 'Bangalore', founded_year: 2014, industry: 'On-demand Services', rating: 4.0, total_reviews: 3200 },
  { name: 'Ola', logo_url: 'https://via.placeholder.com/100?text=Ola', website: 'https://www.olacabs.com', employee_count: 12000, description: 'Ride-sharing and mobility', city: 'Bangalore', founded_year: 2010, industry: 'Mobility', rating: 3.9, total_reviews: 3500 },
  { name: 'Paytm', logo_url: 'https://via.placeholder.com/100?text=Paytm', website: 'https://paytm.com', employee_count: 15000, description: 'Digital payments and fintech', city: 'Noida', founded_year: 2010, industry: 'Fintech', rating: 3.8, total_reviews: 3300 },
  { name: 'PhonePe', logo_url: 'https://via.placeholder.com/100?text=PhonePe', website: 'https://www.phonepe.com', employee_count: 5000, description: 'Digital payments platform', city: 'Bangalore', founded_year: 2015, industry: 'Fintech', rating: 4.3, total_reviews: 4500 },
  { name: 'Zerodha', logo_url: 'https://via.placeholder.com/100?text=Zerodha', website: 'https://zerodha.com', employee_count: 2500, description: 'Stock trading and fintech', city: 'Bangalore', founded_year: 2010, industry: 'Fintech', rating: 4.5, total_reviews: 4800 },
];

const jobTemplates = [
  { title: 'Senior Software Engineer', description: 'Experienced software engineers to join our development team. Work on cutting-edge technologies.', tech_stack: ['Java', 'Spring Boot', 'Microservices', 'Docker', 'Kubernetes'], experience_required: 5, salary_min: 1200000, salary_max: 1800000 },
  { title: 'Full Stack Developer', description: 'Develop web applications using modern tech stack. Work with React, Node.js, and cloud technologies.', tech_stack: ['React', 'Node.js', 'MongoDB', 'AWS', 'Docker'], experience_required: 3, salary_min: 900000, salary_max: 1400000 },
  { title: 'Cloud Architect', description: 'Design and implement cloud infrastructure solutions. Lead cloud migration projects.', tech_stack: ['AWS', 'Azure', 'Kubernetes', 'Terraform', 'Python'], experience_required: 7, salary_min: 1500000, salary_max: 2200000 },
  { title: 'Data Engineer', description: 'Build data pipelines and ETL processes. Work with big data technologies.', tech_stack: ['Spark', 'Hadoop', 'Python', 'SQL', 'Kafka'], experience_required: 4, salary_min: 1000000, salary_max: 1600000 },
  { title: 'DevOps Engineer', description: 'Manage CI/CD pipelines and infrastructure automation. Ensure system reliability.', tech_stack: ['Jenkins', 'Docker', 'Kubernetes', 'AWS', 'Terraform'], experience_required: 4, salary_min: 1100000, salary_max: 1700000 },
  { title: 'QA Automation Engineer', description: 'Develop automated test scripts and frameworks. Ensure product quality.', tech_stack: ['Selenium', 'Java', 'TestNG', 'Jenkins', 'Git'], experience_required: 3, salary_min: 800000, salary_max: 1300000 },
  { title: 'AI/ML Engineer', description: 'Develop machine learning models and AI solutions. Work on NLP and computer vision.', tech_stack: ['Python', 'TensorFlow', 'PyTorch', 'Scikit-learn', 'SQL'], experience_required: 5, salary_min: 1300000, salary_max: 2000000 },
  { title: 'Mobile App Developer', description: 'Build iOS and Android applications. Create engaging mobile experiences.', tech_stack: ['Swift', 'Kotlin', 'React Native', 'Firebase', 'REST APIs'], experience_required: 3, salary_min: 950000, salary_max: 1500000 },
  { title: 'Backend Engineer', description: 'Build scalable backend systems. Work on high-traffic services.', tech_stack: ['Java', 'Python', 'PostgreSQL', 'Redis', 'Kafka'], experience_required: 3, salary_min: 1100000, salary_max: 1700000 },
  { title: 'Frontend Engineer', description: 'Build responsive web applications. Optimize performance and UX.', tech_stack: ['React', 'JavaScript', 'TypeScript', 'Redux', 'CSS'], experience_required: 3, salary_min: 1000000, salary_max: 1600000 },
];

const cities = ['Bangalore', 'Hyderabad', 'Pune', 'Noida', 'Mumbai', 'Delhi', 'Gurgaon', 'Kolkata', 'Chennai', 'Ahmedabad'];

export const seedDatabase = async (req, res) => {
  try {
    // 1. Seed Companies (upsert to handle duplicates)
    const { data: companiesData, error: companiesError } = await supabaseAdmin
      .from('companies')
      .upsert(companies, { onConflict: 'name' })
      .select();

    if (companiesError) throw companiesError;

    console.log(`✓ Seeded ${companiesData.length} companies`);

    // 2. Seed Jobs
    let jobsCreated = 0;
    for (const company of companiesData) {
      for (let i = 0; i < 2; i++) {
        const job = jobTemplates[Math.floor(Math.random() * jobTemplates.length)];
        const city = cities[Math.floor(Math.random() * cities.length)];
        
        const { error: jobError } = await supabaseAdmin
          .from('jobs')
          .insert({
            company_id: company.id,
            title: job.title,
            description: job.description,
            city: city,
            annual_ctc_min: job.salary_min,
            annual_ctc_max: job.salary_max,
            tech_stack: job.tech_stack,
            ats_url: `https://careers.${company.name.toLowerCase().replace(/\s+/g, '')}.com/jobs/${job.title.toLowerCase().replace(/\s+/g, '-')}`,
            employment_type: 'Full-time',
            experience_required: job.experience_required,
            is_active: true,
          });

        if (!jobError) jobsCreated++;
      }
    }

    console.log(`✓ Seeded ${jobsCreated} jobs`);

    // 3. Seed City Metrics (for both single and family lifestyles)
    const cityMetricsBase = [
      { city_name: 'Bangalore', avg_rent: 25000, avg_food: 8000, avg_utilities: 2500, avg_commute: 2000, avg_entertainment: 3000, avg_healthcare: 2000 },
      { city_name: 'Hyderabad', avg_rent: 18000, avg_food: 7000, avg_utilities: 2000, avg_commute: 1500, avg_entertainment: 2500, avg_healthcare: 1500 },
      { city_name: 'Pune', avg_rent: 20000, avg_food: 7500, avg_utilities: 2200, avg_commute: 1800, avg_entertainment: 2800, avg_healthcare: 1800 },
      { city_name: 'Noida', avg_rent: 16000, avg_food: 6500, avg_utilities: 2000, avg_commute: 1500, avg_entertainment: 2300, avg_healthcare: 1500 },
      { city_name: 'Mumbai', avg_rent: 35000, avg_food: 9000, avg_utilities: 3000, avg_commute: 2500, avg_entertainment: 3500, avg_healthcare: 2500 },
      { city_name: 'Delhi', avg_rent: 22000, avg_food: 7500, avg_utilities: 2300, avg_commute: 2000, avg_entertainment: 2800, avg_healthcare: 2000 },
      { city_name: 'Gurgaon', avg_rent: 28000, avg_food: 8000, avg_utilities: 2600, avg_commute: 2200, avg_entertainment: 3200, avg_healthcare: 2200 },
      { city_name: 'Kolkata', avg_rent: 14000, avg_food: 6000, avg_utilities: 1800, avg_commute: 1200, avg_entertainment: 2000, avg_healthcare: 1200 },
      { city_name: 'Chennai', avg_rent: 18000, avg_food: 7000, avg_utilities: 2000, avg_commute: 1500, avg_entertainment: 2500, avg_healthcare: 1500 },
      { city_name: 'Ahmedabad', avg_rent: 15000, avg_food: 6500, avg_utilities: 1900, avg_commute: 1300, avg_entertainment: 2200, avg_healthcare: 1300 },
    ];

    // Create entries for both single and family lifestyles
    const cityMetrics = [];
    for (const city of cityMetricsBase) {
      cityMetrics.push({ ...city, lifestyle: 'single' });
      cityMetrics.push({ ...city, lifestyle: 'family', avg_rent: city.avg_rent * 1.5, avg_food: city.avg_food * 1.3, avg_entertainment: city.avg_entertainment * 1.2 });
    }

    const { data: metricsData, error: metricsError } = await supabaseAdmin
      .from('city_metrics')
      .upsert(cityMetrics, { onConflict: 'city_name,lifestyle' })
      .select();

    if (metricsError) throw metricsError;

    console.log(`✓ Seeded ${metricsData.length} city metrics`);

    res.json({
      message: 'Database seeded successfully',
      companies: companiesData.length,
      jobs: jobsCreated,
      cities: metricsData.length,
    });
  } catch (error) {
    console.error('Seed error:', error);
    res.status(500).json({ error: error.message });
  }
};
