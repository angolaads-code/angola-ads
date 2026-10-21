-- ANGOLA ADS: esquema inicial do Supabase
-- No Supabase, abre SQL Editor > New query, cola este conteúdo e carrega em Run.

create extension if not exists pgcrypto;

create table if not exists public.ads (
  id uuid primary key default gen_random_uuid(),
  seller_name text not null check (char_length(seller_name) between 2 and 80),
  title text not null check (char_length(title) between 3 and 90),
  category text not null check (category in ('Eletrónica','Moda','Casa','Serviços','Outros')),
  price_kz numeric(14,2) null check (price_kz is null or price_kz >= 0),
  description text not null check (char_length(description) between 5 and 600),
  province text not null check (char_length(province) between 2 and 60),
  whatsapp text not null check (whatsapp ~ '^[0-9]{9,15}$'),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);

create table if not exists public.angola_ads_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.ads enable row level security;
alter table public.angola_ads_admins enable row level security;

create or replace function public.is_angola_ads_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.angola_ads_admins a
    where a.user_id = (select auth.uid())
  );
$$;

revoke all on function public.is_angola_ads_admin() from public;
grant execute on function public.is_angola_ads_admin() to authenticated;

drop policy if exists "Anyone can read approved ads" on public.ads;
create policy "Anyone can read approved ads"
on public.ads for select to anon, authenticated
using (status = 'approved' or public.is_angola_ads_admin());

drop policy if exists "Anyone can submit pending ads" on public.ads;
create policy "Anyone can submit pending ads"
on public.ads for insert to anon, authenticated
with check (status = 'pending');

drop policy if exists "Admins can update ads" on public.ads;
create policy "Admins can update ads"
on public.ads for update to authenticated
using (public.is_angola_ads_admin())
with check (public.is_angola_ads_admin());

drop policy if exists "Admins can delete ads" on public.ads;
create policy "Admins can delete ads"
on public.ads for delete to authenticated
using (public.is_angola_ads_admin());

-- A tabela de administradores não deve ser legível ou editável pelo público.
drop policy if exists "Admins can read admin list" on public.angola_ads_admins;
create policy "Admins can read admin list"
on public.angola_ads_admins for select to authenticated
using (public.is_angola_ads_admin());

grant select, insert on public.ads to anon, authenticated;
grant update, delete on public.ads to authenticated;
grant select on public.angola_ads_admins to authenticated;

-- Depois de criares o utilizador do administrador em Authentication > Users,
-- copia o respetivo User UID e executa esta linha substituindo o UUID:
-- insert into public.angola_ads_admins (user_id) values ('COLOCA-AQUI-O-USER-UID');
