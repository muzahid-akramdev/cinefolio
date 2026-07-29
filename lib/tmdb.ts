const TMDB_BASE = 'https://api.themoviedb.org/3'
const API_KEY = process.env.NEXT_PUBLIC_TMDB_API_KEY!
async function fetchTMDB(path: string, params: Record<string, string> = {}) {
  const url = new URL(`${TMDB_BASE}${path}`)
  url.searchParams.set('api_key', API_KEY)
  Object.entries(params).forEach(([k, v]) => url.searchParams.set(k, v))
  const res = await fetch(url.toString(), { next: { revalidate: 3600 } })
  if (!res.ok) throw new Error(`TMDB fetch failed: ${res.status}`)
  return res.json()
}
export const tmdb = {
  trending: (media: 'movie'|'tv', time: 'day'|'week') => fetchTMDB(`/trending/${media}/${time}`),
  discoverMovie: (params: Record<string, string>) => fetchTMDB('/discover/movie', params),
  discoverTV: (params: Record<string, string>) => fetchTMDB('/discover/tv', params),
  movieDetails: (id: number) => fetchTMDB(`/movie/${id}`, { append_to_response: 'credits' }),
  tvDetails: (id: number) => fetchTMDB(`/tv/${id}`, { append_to_response: 'credits' }),
  seasonDetails: (tvId: number, seasonNumber: number) => fetchTMDB(`/tv/${tvId}/season/${seasonNumber}`),
  searchMulti: (query: string) => fetchTMDB('/search/multi', { query }),
  personDetails: (id: number) => fetchTMDB(`/person/${id}`, { append_to_response: 'combined_credits' }),
}
