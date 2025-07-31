module API
class Base < Grape::API
    helpers AuthHelpers
    format :json
    prefix :api
    require_relative 'v1/base'

    mount API::V1::Base

    add_swagger_documentation(
    info: {
        title: 'Blog API',
        description: 'API documentation'
    }
    )
end
end
  