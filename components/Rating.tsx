'use client'
import { useState } from 'react'
export function Rating({ initialRating=0, onRate }: { initialRating?: number; onRate:(r:number)=>void }) {
  const [hover, setHover] = useState(0)
  return (
    <div className="flex gap-1">
      {[1,2,3,4,5,6,7,8,9,10].map(star => (
        <button key={star} onClick={() => onRate(star)} onMouseEnter={() => setHover(star)} onMouseLeave={() => setHover(0)}
          className={`text-xl ${star <= (hover||initialRating) ? 'text-yellow-400' : 'text-gray-500'}`}>★</button>
      ))}
    </div>
  )
}
