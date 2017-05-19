class V1 < Grape::API
  version "v1", using: :path

  desc "Return the current API version - V1."
  get do
    {version: "v1"}
  end
end
