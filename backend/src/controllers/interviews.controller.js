import { supabase } from '../config/supabase.js';

export async function getInterviewsByCompany(req, res) {
  try {
    const { company_id } = req.params;
    const { role, limit = 20, offset = 0 } = req.query;

    let query = supabase
      .from('interviews')
      .select(
        `
        id,
        user_id,
        company_id,
        role,
        difficulty,
        questions,
        experience_text,
        result,
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

export async function createInterview(req, res) {
  try {
    const { company_id, role, difficulty, questions, experience_text, result } = req.body;

    const user_id = req.user?.sub;

    if (!user_id) {
      return res.status(401).json({ error: 'User not authenticated' });
    }

    const { data, error } = await supabase.from('interviews').insert([
      {
        user_id,
        company_id,
        role,
        difficulty,
        questions,
        experience_text,
        result,
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

export async function updateInterview(req, res) {
  try {
    const { id } = req.params;
    const { difficulty, questions, experience_text, result } = req.body;

    const user_id = req.user?.sub;

    const { data: interview, error: fetchError } = await supabase
      .from('interviews')
      .select('user_id')
      .eq('id', id)
      .single();

    if (fetchError || interview.user_id !== user_id) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    const { data, error } = await supabase
      .from('interviews')
      .update({
        difficulty,
        questions,
        experience_text,
        result,
      })
      .eq('id', id);

    if (error) {
      return res.status(400).json({ error: error.message });
    }

    return res.json(data);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
}
