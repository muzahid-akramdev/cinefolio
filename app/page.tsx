import { tmdb } from '@/lib/tmdb'
import { MovieCard } from '@/components/MovieCard'
import { TVShowCard } from '@/components/TVShowCard'
export const revalidate = 3600
export default async function Home() {
  const movies = await tmdb.trending('movie','week')
  const tvs = await tmdb.trending('tv','week')
  return (
    <div>
      <h1 className="text-3xl font-bold mb-6">Trending Movies</h1>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
        {movies.results.map((m:any) => <MovieCard key={m.id} movie={m} />)}
      </div>
      <h1 className="text-3xl font-bold mt-12 mb-6">Trending TV</h1>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
        {tvs.results.map((s:any) => <TVShowCard key={s.id} show={s} />)}
      </div>
    </div>
  )
}
