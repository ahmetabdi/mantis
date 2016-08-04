defmodule Mantis.Alluc do

  def name do
    "ALLUC"
  end

  def url do
    "http://www.alluc.ee"
  end

  def search(query) do
    {status, body} = Mantis.get("#{url}/api/search/stream/?query=#{URI.encode(query)}&count=100&from=0&getmeta=0")

    IO.inspect body
  end
end
