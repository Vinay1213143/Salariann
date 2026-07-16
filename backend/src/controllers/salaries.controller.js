import { supabase } from '../config/supabase.js';

export async function getSalariesByCompany(req, res) {
  try {
    const { company_id } = req.params;
    const { role, limit = 20, offset = 0 } = req.query;

    let query = supabase
      .from('salaries')
      .select(
        `
        id,
        company_id,
        role,
        annual_ctc,
        experience_years,
        is_anonymous,
        created_at
      `,
        { count: 'exact' }
      )
      .eq('company_id', company_id)
      .order('created_at', { ascending: false });

    if (role) {
      query = query.ilike('role', `%${role}%`);
    }

    query = query.range(parseInt(offset), parseInt(offset) + parseInt(limit) - 1);

    const { data, error, count } = await query;

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json({
      data,
      pagination: {
        total: count,
        limit: parseInt(limit),
        offset: parseInt(offset),
      },
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

export async function createSalary(req, res) {
  try {
    const { company_id, role, annual_ctc, experience_years, is_anonymous } = req.body;

    const user_id = req.user?.sub;

    if (!user_id) {
      return res.status(401).json({ error: 'User not authenticated' });
    }

    const { data, error } = await supabase.from('salaries').insert([
      {
        user_id,
        company_id,
        role,
        annual_ctc,
        experience_years,
        is_anonymous: is_anonymous !== false,
      },
    ]);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.status(201).json(data);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}

export async function getSalaryStats(req, res) {
  try {
    const { company_id, role } = req.query;

    let query = supabase.from('salaries').select('annual_ctc, role, experience_years');

    if (company_id) {
      query = query.eq('company_id', company_id);
    }

    if (role) {
      query = query.ilike('role', `%${role}%`);
    }

    const { data, error } = await query;

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    if (!data || data.length === 0) {
      return res.json({
        count: 0,
        avg: null,
        min: null,
        max: null,
      });
    }

    const salaries = data.map((s) => s.annual_ctc);
    const avg = salaries.reduce((a, b) => a + b, 0) / salaries.length;
    const min = Math.min(...salaries);
    const max = Math.max(...salaries);

    return res.json({
      count: data.length,
      avg: Math.round(avg),
      min,
      max,
    });
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}
