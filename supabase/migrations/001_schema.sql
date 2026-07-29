-- Enable moddatetime extension
create extension if not exists moddatetime schema extensions;

-- Users
create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique not null,
  avatar_url text,
  bio text,
  created_at timestamptz default now()
);

-- Movies
create table public.movies (
  id bigserial primary key,
  tmdb_id integer unique not null,
  imdb_id text,
  title text not null,
  original_title text,
  original_language text,
  overview text,
  release_date date,
  runtime integer,
  genres text[],
  countries text[],
  poster_path text,
  backdrop_path text,
  tmdb_rating real,
  tmdb_vote_count integer,
  updated_at timestamptz default now()
);

-- TV Shows
create table public.tv_shows (
  id bigserial primary key,
  tmdb_id integer unique not null,
  imdb_id text,
  name text not null,
  original_name text,
  original_language text,
  overview text,
  first_air_date date,
  genres text[],
  origin_country text[],
  poster_path text,
  backdrop_path text,
  number_of_seasons integer,
  number_of_episodes integer,
  status text,
  tmdb_rating real,
  tmdb_vote_count integer,
  updated_at timestamptz default now()
);

-- Seasons
create table public.seasons (
  id bigserial primary key,
  tv_show_id bigint references tv_shows(id) on delete cascade,
  tmdb_id integer unique not null,
  season_number integer not null,
  name text,
  air_date date,
  episode_count integer,
  poster_path text
);

-- Episodes
create table public.episodes (
  id bigserial primary key,
  season_id bigint references seasons(id) on delete cascade,
  tmdb_id integer unique not null,
  episode_number integer not null,
  name text,
  air_date date,
  overview text,
  runtime integer,
  tmdb_rating real,
  tmdb_vote_count integer
);

-- People
create table public.people (
  id bigserial primary key,
  tmdb_id integer unique not null,
  name text not null,
  profile_path text,
  known_for_department text
);

-- Credits
create table public.credits (
  id bigserial primary key,
  person_id bigint references people(id) on delete cascade,
  movie_id bigint references movies(id) on delete cascade,
  tv_show_id bigint references tv_shows(id) on delete cascade,
  role text check (role in ('cast','crew')) not null,
  character_name text,
  job text,
  sort_order integer,
  constraint one_media check ( (movie_id is not null and tv_show_id is null) or (tv_show_id is not null and movie_id is null) )
);

-- Watchlist
create table public.watchlist (
  id bigserial primary key,
  user_id uuid references users(id) on delete cascade,
  movie_id bigint references movies(id) on delete cascade,
  tv_show_id bigint references tv_shows(id) on delete cascade,
  added_at timestamptz default now(),
  constraint one_media check ( (movie_id is not null and tv_show_id is null) or (tv_show_id is not null and movie_id is null) ),
  unique(user_id, movie_id, tv_show_id)
);

-- Watched (movies)
create table public.watched (
  user_id uuid references users(id) on delete cascade,
  movie_id bigint references movies(id) on delete cascade,
  watched_at timestamptz default now(),
  rating smallint check (rating >= 1 and rating <= 10),
  rewatch_count integer default 0,
  primary key (user_id, movie_id)
);

-- Show progress (series-level)
create table public.show_progress (
  user_id uuid references users(id) on delete cascade,
  tv_show_id bigint references tv_shows(id) on delete cascade,
  rating smallint check (rating >= 1 and rating <= 10),
  status text check (status in ('watching','completed','dropped','plan_to_watch')) default 'plan_to_watch',
  updated_at timestamptz default now(),
  primary key (user_id, tv_show_id)
);

-- Episode watched (episode-level)
create table public.episode_watched (
  user_id uuid references users(id) on delete cascade,
  episode_id bigint references episodes(id) on delete cascade,
  watched_at timestamptz default now(),
  rating smallint check (rating >= 1 and rating <= 10),
  rewatch_count integer default 0,
  primary key (user_id, episode_id)
);

-- Reviews
create table public.reviews (
  id bigserial primary key,
  user_id uuid references users(id) on delete cascade,
  movie_id bigint references movies(id) on delete cascade,
  tv_show_id bigint references tv_shows(id) on delete cascade,
  rating smallint check (rating >= 1 and rating <= 10) not null,
  body text not null,
  has_spoilers boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  constraint one_media check ( (movie_id is not null and tv_show_id is null) or (tv_show_id is not null and movie_id is null) )
);

-- Review likes
create table public.review_likes (
  review_id bigint references reviews(id) on delete cascade,
  user_id uuid references users(id) on delete cascade,
  primary key (review_id, user_id)
);

-- Lists
create table public.lists (
  id bigserial primary key,
  user_id uuid references users(id) on delete cascade,
  name text not null,
  description text,
  is_public boolean default true
);

-- List items
create table public.list_items (
  id bigserial primary key,
  list_id bigint references lists(id) on delete cascade,
  movie_id bigint references movies(id) on delete cascade,
  tv_show_id bigint references tv_shows(id) on delete cascade,
  position integer not null,
  constraint one_media check ( (movie_id is not null and tv_show_id is null) or (tv_show_id is not null and movie_id is null) )
);

-- Follows
create table public.follows (
  follower_id uuid references users(id) on delete cascade,
  followee_id uuid references users(id) on delete cascade,
  primary key (follower_id, followee_id)
);

-- Sync logs
create table public.sync_logs (
  id bigserial primary key,
  source text,
  started_at timestamptz default now(),
  finished_at timestamptz,
  rows_processed integer,
  status text
);

-- Missing title requests
create table public.missing_title_requests (
  id bigserial primary key,
  user_id uuid references users(id) on delete set null,
  title text not null,
  note text,
  status text check (status in ('pending','added','rejected')) default 'pending',
  created_at timestamptz default now()
);

-- Auto-update triggers
create trigger handle_movies_updated before update on movies for each row execute procedure moddatetime(updated_at);
create trigger handle_tv_updated before update on tv_shows for each row execute procedure moddatetime(updated_at);
create trigger handle_show_progress_updated before update on show_progress for each row execute procedure moddatetime(updated_at);
create trigger handle_reviews_updated before update on reviews for each row execute procedure moddatetime(updated_at);

-- RLS policies
alter table watchlist enable row level security;
alter table watched enable row level security;
alter table show_progress enable row level security;
alter table episode_watched enable row level security;
alter table reviews enable row level security;
alter table review_likes enable row level security;
alter table lists enable row level security;
alter table list_items enable row level security;
alter table missing_title_requests enable row level security;

create policy "Users manage own watchlist" on watchlist for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users manage own watched" on watched for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users manage own show_progress" on show_progress for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users manage own episode_watched" on episode_watched for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users manage own reviews" on reviews for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users manage own review likes" on review_likes for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users manage own lists" on lists for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Users manage own list items" on list_items for all using (
  exists (select 1 from lists where id = list_items.list_id and user_id = auth.uid())
) with check (
  exists (select 1 from lists where id = list_items.list_id and user_id = auth.uid())
);

-- Public read access
create policy "Public read movies" on movies for select using (true);
create policy "Public read tv_shows" on tv_shows for select using (true);
create policy "Public read people" on people for select using (true);
create policy "Public read credits" on credits for select using (true);
create policy "Public read public lists" on lists for select using (is_public);
create policy "Public read list items" on list_items for select using (
  exists (select 1 from lists where id = list_items.list_id and is_public)
);

-- Missing title insert by auth users
create policy "Auth users can insert missing titles" on missing_title_requests for insert with check (auth.role() = 'authenticated');
