defmodule MusicDB.Playground do
  import Ecto
  import Ecto.Query
  import Ecto.Changeset
  alias MusicDB.{Repo, Artist, Track, Album, Genre}

  def run() do
    from(a in "albums",
      join: ar in "artists",
      on: a.artist_id == ar.id,
      where: ar.id == 2,
      select: %{album: a.title, album_id: a.id, artist_name: ar.name, artist_id: ar.id}
    )
  end

  def new_artist() do
    params = %{
      name: "Joni Mitchel",
      albums: [
        %{
          title: "Blue",
          tracks: [%{title: "blue, track 1", index: 0}, %{title: "blue, track 2", index: 1}]
        },
        %{
          title: "Some Title",
          tracks: [
            %{title: "some title, track 1", index: 0},
            %{title: "some title, track 2", index: 1}
          ]
        }
      ]
    }

    %Artist{}
    |> cast(params, [:name])
    |> cast_assoc(:albums)
  end

  def new_track() do
    query = from t in Track, where: t.album_id == 12
    tracks = Repo.all(query) 
    
    changeset = Repo.get_by(Album, id: 12)
     |> Repo.preload(:tracks)
     |> change()
     |> put_assoc(:tracks, [%{title: "Track 3", index: 2} | tracks])

    changeset

  end

  def new_track_hard() do
    album = Repo.get_by(Album, id: 12)
    |> Repo.preload(:tracks)
    |> Repo.preload(:artist)
    |> Repo.preload(:genres)

    album
    |> change()
    |> put_assoc(:tracks, [%Track{title: "blue, track 5", index: 4} | album.tracks])
    |> Repo.update()

  end

  def new_track_simple() do
    params = %{title: "blue, track 5", index: 4, album_id: 12} 

    %Track{}
    |> cast(params, [:title, :index, :album_id])
    |> Repo.insert()

  end

  def new_track_best() do
    album = Repo.get_by(Album, id: 12)
    |> Repo.preload(:tracks)

    album
    |> build_assoc(:tracks, %Track{title: "blue, track 6", index: 5, duration: 5, duration_string: "5 minutes", number_of_plays: 12})
    |> Repo.insert()
  end

  def update_track() do
    track = Repo.get_by(Track, id: 55)

    track
    |> Map.put(:title, track.title <> "!!")
    |> change()
    |> Repo.update()
  end

  def new_artist_two() do
    %Artist{
      name: "Eric Wolf",
      albums: [
        %Album{
          title: "Hell on Wheels",
          genres: [%Genre{name: "hip hop", wiki_tag: "hip hop"}],
          tracks: [
            %Track{
              title: "Hell yeah!",
              duration: 761,
              index: 1
            },
            %Track{
              title: "Fuckin' A!",
              duration: 647,
              index: 2
            }
          ]
        }
      ]
    }
  end

  def test do
    "albums"
    |> join(:inner, [a], ar in "artists", on: a.artist_id == ar.id)
    |> where([a, ar], ar.id == 2)
    |> select([a, ar], %{
      album_title: a.title,
      album_id: a.id,
      artist_name: ar.name,
      artist_id: ar.id
    })
    |> Repo.all()
    |> Enum.reduce(%{}, fn r, acc ->
      case Map.has_key?(acc, :artist) do
        false ->
          acc = Map.put(acc, :artist, r.artist_name)
          Map.put(acc, :albums, [%{album_id: r.album_id, title: r.album_title}])

        true ->
          Map.put(acc, :albums, [%{album_id: r.album_id, title: r.album_title} | acc.albums])
      end
    end)
  end
end
