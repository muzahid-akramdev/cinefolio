'use client'
import { useState } from 'react'
import { supabase } from '@/lib/supabaseClient'
export function WatchlistButton({ mediaId, mediaType, userId }: { mediaId: number; mediaType:'movie'|'tv'; userId:string }) {
  const [inWatchlist, setInWatchlist] = useState(false)
  const toggle = async () => {
    if (!userId) return
    const col = mediaType==='movie'?'movie_id':'tv_show_id'
    if (inWatchlist) {
      await supabase.from('watchlist').delete().eq('user_id', userId).eq(col, mediaId)
      setInWatchlist(false)
    } else {
      await supabase.from('watchlist').insert({ user_id: userId, [col]: mediaId })
      setInWatchlist(true)
    }
  }
  return (
    <button onClick={toggle} className="px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white">
      {inWatchlist ? 'Remove' : 'Add to Watchlist'}
    </button>
  )
}
