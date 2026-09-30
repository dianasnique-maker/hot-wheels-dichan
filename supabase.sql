-- HOT WHEELS DiChan - Supabase
-- Ejecuta todo este archivo en Supabase > SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.cars (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  series text default '',
  category text default 'Colección',
  price text default 'Consultar',
  year text default '',
  number text default '',
  description text default '',
  status text not null default 'Disponible' check (status in ('Disponible','Vendido')),
  whatsapp text default '',
  image_url text,
  image_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.cars enable row level security;

drop policy if exists "Public can read cars" on public.cars;
create policy "Public can read cars"
on public.cars for select
to anon, authenticated
using (true);

drop policy if exists "Authenticated can insert cars" on public.cars;
create policy "Authenticated can insert cars"
on public.cars for insert
to authenticated
with check (true);

drop policy if exists "Authenticated can update cars" on public.cars;
create policy "Authenticated can update cars"
on public.cars for update
to authenticated
using (true)
with check (true);

drop policy if exists "Authenticated can delete cars" on public.cars;
create policy "Authenticated can delete cars"
on public.cars for delete
to authenticated
using (true);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists cars_updated_at on public.cars;
create trigger cars_updated_at
before update on public.cars
for each row execute function public.set_updated_at();

insert into storage.buckets (id, name, public)
values ('hot-wheels', 'hot-wheels', true)
on conflict (id) do update set public = true;

drop policy if exists "Public can view Hot Wheels images" on storage.objects;
create policy "Public can view Hot Wheels images"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'hot-wheels');

drop policy if exists "Authenticated can upload Hot Wheels images" on storage.objects;
create policy "Authenticated can upload Hot Wheels images"
on storage.objects for insert
to authenticated
with check (bucket_id = 'hot-wheels');

drop policy if exists "Authenticated can update Hot Wheels images" on storage.objects;
create policy "Authenticated can update Hot Wheels images"
on storage.objects for update
to authenticated
using (bucket_id = 'hot-wheels')
with check (bucket_id = 'hot-wheels');

drop policy if exists "Authenticated can delete Hot Wheels images" on storage.objects;
create policy "Authenticated can delete Hot Wheels images"
on storage.objects for delete
to authenticated
using (bucket_id = 'hot-wheels');

-- Datos iniciales. Se insertan solo si la tabla está vacía.
insert into public.cars (name, series, category, price, year, number, description, status)
select * from (values
('Maserati Tipo 61','Hot Wheels','Colección','S/ 15','2026','','Modelo negro · pieza de colección','Disponible'),
('Porsche Carrera ''96','Hot Wheels','Colección','S/ 15','2026','','Rojo · Porsche Carrera ''96','Disponible'),
('Plymouth — Fast & Furious','Fast & Furious','Fast & Furious','S/ 20','2026','','Modelo de la saga Fast & Furious','Disponible'),
('Ferrari 12Cilindri','Hot Wheels','Premium / Especial','S/ 20','2026','','Modelo especial Ferrari','Disponible'),
('Monster High Ghoul Mobile','Hot Wheels','Colección','S/ 18','2026','48/250','','Disponible'),
('Batman Hot Wheels','Hot Wheels','Batman','Consultar','2026','','Modelo Batman Hot Wheels','Disponible')
) as v(name,series,category,price,year,number,desc,status)
where not exists (select 1 from public.cars);
