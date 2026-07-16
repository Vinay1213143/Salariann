class ApiConfig {
  static const String baseUrl = 'http://localhost:3001/api';
  static const String supabaseUrl = 'https://ayvwifmobthpievoyzsx.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5dndpZm1vYnRocGlldm95enN4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIyMTU0ODIsImV4cCI6MjA5Nzc5MTQ4Mn0.wNgh5A3v_GvYcLBLuC5oOiTtiHiMtE2_Mj0KDtZWgHs';

  static const Duration requestTimeout = Duration(seconds: 30);
}
