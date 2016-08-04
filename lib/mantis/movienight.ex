defmodule Mantis.MovieNight do
  alias Mantis.Model.Movie

  def name do
    "MovieNight"
  end

  def url do
    "http://movienight.ws"
  end

  def all do
    for page_number <- 1..30 do
      {status, body} = Mantis.get("#{url}/page/#{page_number}/")

      IO.puts "#{url}/page/#{page_number}/"

      body
      |> Floki.find(".movie a")
      |> Floki.attribute("href")
      |> Enum.take(10)
      |> Enum.map(fn(url) -> process_movie(url) end)
    end
  end

  def most_viewed do
    {status, body} = Mantis.get(url)

    body
    |> Floki.find(".links a")
    |> Floki.attribute("href")
    |> Enum.take(20)
    |> Enum.map(fn(url) -> process_movie(url) end)
  end

  def recommended do
    {status, body} = Mantis.get(url)

    body
    |> Floki.find(".random a")
    |> Floki.attribute("href")
    |> Enum.take(20)
    |> Enum.map(fn(url) -> process_movie(url) end)
  end

  def latest do
    {status, body} = Mantis.get(url)

    body
    |> Floki.find(".movie a")
    |> Floki.attribute("href")
    |> Enum.take(10)
    |> Enum.map(fn(url) -> process_movie(url) end)
  end

  def search(query) do
    {status, body} = Mantis.get("#{url}/?s=#{URI.encode(query)}")

    movies_html = Floki.find(body, ".movie")

    for movie_html <- movies_html do
      link = Floki.find(movie_html, "a") |> Floki.attribute("href")
      process_movie(link)
    end
  end

  defp process_movie(movie_url) do
    {status, body} = Mantis.get(movie_url)

    name = Floki.find(body, "#movie h1") |> Floki.text
    iframe_url = grab_iframe(body)
    rating = Floki.find(body, "div.rank") |> Floki.text

    # IO.puts "name #{name}, iframe_url #{iframe_url}, rating #{rating}"

    %Movie{name: name, url: iframe_url, rating: rating}
  end

  defp grab_iframe(body) do
    ~r/iframe\s+src="([^"]+)/
    |> Regex.run(body)
    |> case do
      nil -> "No video available"
      match -> match |> Enum.at(1)
    end
  end
end
