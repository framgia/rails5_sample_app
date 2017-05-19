class API < Grape::API
  include BaseAPI

  mount API::V1
end
