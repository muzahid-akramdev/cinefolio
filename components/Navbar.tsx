import Link from 'next/link'
export default function Navbar() {
  return (
    <nav className="bg-gray-900 border-b border-gray-800">
      <div className="container mx-auto flex items-center justify-between px-4 py-3">
        <Link href="/" className="text-xl font-bold">CineFolio</Link>
        <div className="flex gap-4">
          <Link href="/movies">Movies</Link>
          <Link href="/tv">TV</Link>
          <Link href="/search">Search</Link>
          <Link href="/login">Login</Link>
        </div>
      </div>
    </nav>
  )
}
