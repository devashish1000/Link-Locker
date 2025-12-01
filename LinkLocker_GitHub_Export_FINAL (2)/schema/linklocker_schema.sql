-- Supabase Schema for Link Locker

alter table if exists public.users enable row level security;
alter table if exists public.categories enable row level security;
alter table if exists public.links enable row level security;

create table if not exists public.users (
    id uuid primary key,
    email text unique,
    created_at timestamp default now()
);

create table if not exists public.categories (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references public.users(id) on delete cascade,
    name text not null,
    created_at timestamp default now()
);

create table if not exists public.links (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references public.users(id) on delete cascade,
    category_id uuid references public.categories(id),
    url text not null,
    title text,
    notes text,
    tags text[],
    favorited boolean default false,
    created_at timestamp default now(),
    updated_at timestamp default now()
);

create policy "Users can access their own profile"
  on public.users for select
  using (auth.uid() = id);

create policy "User can view own categories"
  on public.categories for select
  using (auth.uid() = user_id);

create policy "User can manage own categories"
  on public.categories for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "User can view own links"
  on public.links for select
  using (auth.uid() = user_id);

create policy "User can manage own links"
  on public.links for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
