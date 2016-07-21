defmodule HTTPoison.Response do
  defstruct body: nil, headers: nil, status_code: nil
end

defmodule AuthenticationClientMock do
  def post(params) do
    { :ok, _successful_response }
  end

  defp _successful_response do
    %HTTPoison.Response{
      body: "{\"access_token\":\"access_token\",\"token_type\":\"Bearer\",\"expires_in\":3600,\"refresh_token\":\"refresh_token\",\"scope\":\"playlist-read-private\"}",
      headers: [{"Server", "nginx"}, {"Date", "Thu, 21 Jul 2016 16:52:38 GMT"},
        {"Content-Type", "application/json"}, {"Content-Length", "397"},
        {"Connection", "keep-alive"}, {"Keep-Alive", "timeout=10"},
        {"Vary", "Accept-Encoding"}, {"Vary", "Accept-Encoding"},
        {"X-UA-Compatible", "IE=edge"}, {"X-Frame-Options", "deny"},
        {"Content-Security-Policy",
          "default-src 'self'; script-src 'self' foo"},
        {"X-Content-Security-Policy",
          "default-src 'self'; script-src 'self' foo"},
        {"Cache-Control", "no-cache, no-store, must-revalidate"},
        {"Pragma", "no-cache"}, {"X-Content-Type-Options", "nosniff"},
        {"Strict-Transport-Security", "max-age=31536000;"}],
      status_code: 200
    }
  end
end
