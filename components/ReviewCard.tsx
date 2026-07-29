export function ReviewCard({ review }: { review: any }) {
  return (
    <div className="border border-gray-700 rounded p-4">
      <div className="flex items-center justify-between">
        <span className="font-bold">{review.user?.username}</span>
        <span className="text-yellow-400">{review.rating}/10</span>
      </div>
      {review.has_spoilers && <p className="text-red-400 text-xs">Contains spoilers</p>}
      <p className="mt-2">{review.body}</p>
    </div>
  )
}
