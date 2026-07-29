import { NextResponse } from 'next/server'
import { supabaseAdmin } from '@/lib/supabaseAdmin'
export async function GET(request: Request) {
  const authHeader = request.headers.get('authorization')
  if (authHeader !== `Bearer ${process.env.CRON_SECRET}`) {
    return new Response('Unauthorized', { status: 401 })
  }
  // skeleton – full sync logic would upsert from TMDB
  await supabaseAdmin.from('sync_logs').insert({ source:'tmdb', started_at: new Date().toISOString(), status:'success' })
  return NextResponse.json({ success: true })
}
