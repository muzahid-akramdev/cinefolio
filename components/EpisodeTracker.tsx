'use client'
import { useState } from 'react'
export function EpisodeTracker({ episode, userId, onMark }: { episode: any; userId: string; onMark: (epId: number, rating: number|null) => void }) {
  const [rating, setRating] = useState<number|null>(null)
  return (
    <div className="flex items-center gap-2">
      <input type="checkbox" onChange={e => { if(e.target.checked) onMark(episode.id, rating) }} />
      <span>{episode.name}</span>
      <select value={rating??''} onChange={e => setRating(e.target.value ? Number(e.target.value) : null)} className="bg-gray-800 p-1 rounded">
        <option value="">Rate</option>
        {[1,2,3,4,5,6,7,8,9,10].map(n => <option key={n} value={n}>{n}</option>)}
      </select>
    </div>
  )
}
