defmodule Mantis.TwoDDL do
  def name do
    "2DDL"
  end

  def url do
    "http://2ddl.ag"
  end

  def search(query) do
    {:ok, body} = Mantis.get("#{url}/search/#{URI.encode(query)}")

    results = Floki.find(body, ".post")

    for result <- results do
      name = Floki.find(result, "h2") |> Floki.text
      links = Floki.find(result, "a") |> Floki.attribute("href")
      link = links |> Enum.at(0)

      IO.inspect links
      IO.puts "Name: #{name} | link: #{link}"
    end
  end
end
