defmodule Mantis do
  def reload! do
    Mix.Task.reenable "compile.elixir"
    Application.stop(Mix.Project.config[:app])
    Mix.Task.run "compile.elixir"
    Application.start(Mix.Project.config[:app], :permanent)
  end

  def get(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.puts "Status Code #{status_code} returned"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  # defp process do
  #   receive do
  #     %HTTPoison.AsyncStatus{code: code} ->
  #       inspect code
  #       IO.puts "AsyncStatus: #{code}"
  #     %HTTPoison.AsyncHeaders{headers: headers} ->
  #       inspect headers
  #       IO.puts "AsyncHeaders"
  #     %HTTPoison.AsyncChunk{chunk: chunk} ->
  #       inspect chunk
  #       IO.puts "AsyncChunk"
  #     %HTTPoison.AsyncEnd{} ->
  #       IO.puts "AsyncEnd"
  #     result ->
  #       {:error, "Expected %HTTPoison.Async*, got [#{inspect result}]"}
  #   after
  #     5_000 -> {:error, "Expected %HTTPoison.AsyncStatus, got nothing after 5s"}
  #   end
  # end
end
