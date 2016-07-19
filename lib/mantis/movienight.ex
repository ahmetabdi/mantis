defmodule Mantis.MovieNight do
  def url do
    "http://movienight.ws"
  end

  def most_viewed do
    {:ok, body} = Mantis.get(url)

    body
    |> Floki.find(".links a")
    |> Floki.attribute("href")
    |> Enum.take(20)
    |> Enum.map(fn(url) -> process_movie(url) end)
  end

  def recommended do
    {:ok, body} = Mantis.get(url)

    body
    |> Floki.find(".random a")
    |> Floki.attribute("href")
    |> Enum.take(20)
    |> Enum.map(fn(url) -> process_movie(url) end)
  end

  def latest do
    {:ok, body} = Mantis.get(url)

    body
    |> Floki.find(".movie a")
    |> Floki.attribute("href")
    |> Enum.take(10)
    |> Enum.map(fn(url) -> process_movie(url) end)
  end

  def search(query) do
    {:ok, body} = Mantis.get("#{url}/?s=#{URI.encode(query)}")

    movies_html = Floki.find(body, ".movie")

    for movie_html <- movies_html do
      name = Floki.find(movie_html, "h2") |> Floki.text
      link = Floki.find(movie_html, "a") |> Floki.attribute("href")
      IO.puts "Name: #{name} | link: #{link}"
    end
  end

  defp process_movie(movie_url) do
    {:ok, body} = Mantis.get(movie_url)

    name = Floki.find(body, "#movie h1") |> Floki.text
    iframe_url = Regex.run(~r/iframe\s+src="([^"]+)/, body) |> Enum.at(1)
    rating = Floki.find(body, "div.rank") |> Floki.text

    IO.inspect {name, iframe_url, rating}
  end
end
