import { NextResponse } from 'next/server'
import { supabaseAdmin } from '@/lib/supabaseAdmin'
export async function POST(request: Request) {
  const { title, note } = await request.json()
  const { data, error } = await supabaseAdmin.from('missing_title_requests').insert({ title, note })
  if (error) return NextResponse.json({ error: error.message }, { status: 400 })
  return NextResponse.json({ success: true, data })
}
