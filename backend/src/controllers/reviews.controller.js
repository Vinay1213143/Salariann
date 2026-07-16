import { supabase } from '../config/supabase.js';

export async function getReviewsByCompany(req, res) {
  try {
    const { company_id } = req.params;
    const { limit = 20, offset = 0 } = req.query;

    const { data, error, count } = await supabase
      .from('reviews')
      .select(
        `
        id,
        user_id,
        company_id,
        overall_rating,
        work_life_balance,
        skill_development,
        management,
        pros,
        cons,
        created_at
      `,
        { count: 'exact' }
      )
      .eq('company_id', company_id)
      .order('created_at', { ascending: false })
      .range(parseInt(offset), parseInt(offset) + parseInt(limit) - 1);

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

export async function createReview(req, res) {
  try {
    const {
      company_id,
      overall_rating,
      work_life_balance,
      skill_development,
      management,
      pros,
      cons,
    } = req.body;

    const user_id = req.user?.sub;

    if (!user_id) {
      return res.status(401).json({ error: 'User not authenticated' });
    }

    const { data, error } = await supabase.from('reviews').insert([
      {
        user_id,
        company_id,
        overall_rating,
        work_life_balance,
        skill_development,
        management,
        pros,
        cons,
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

export async function updateReview(req, res) {
  try {
    const { id } = req.params;
    const {
      overall_rating,
      work_life_balance,
      skill_development,
      management,
      pros,
      cons,
    } = req.body;

    const user_id = req.user?.sub;

    const { data: review, error: fetchError } = await supabase
      .from('reviews')
      .select('user_id')
      .eq('id', id)
      .single();

    if (fetchError || review.user_id !== user_id) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    const { data, error } = await supabase
      .from('reviews')
      .update({
        overall_rating,
        work_life_balance,
        skill_development,
        management,
        pros,
        cons,
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
