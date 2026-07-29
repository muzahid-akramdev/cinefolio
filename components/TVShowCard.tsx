import Link from 'next/link'
import Image from 'next/image'
export function TVShowCard({ show }: { show: any }) {
  return (
    <Link href={`/tv/${show.id}`} className="group block">
      <div className="relative aspect-[2/3] overflow-hidden rounded-lg bg-gray-800">
        {show.poster_path ? (
          <Image src={`https://image.tmdb.org/t/p/w500${show.poster_path}`} alt={show.name} fill className="object-cover transition-transform group-hover:scale-105" sizes="(max-width: 768px) 50vw, 20vw" />
        ) : (
          <div className="flex h-full items-center justify-center text-gray-500">No Poster</div>
        )}
      </div>
      <h3 className="mt-2 font-medium line-clamp-1">{show.name}</h3>
      <p className="text-sm text-gray-400">{show.first_air_date?.slice(0, 4)}</p>
    </Link>
  )
}
