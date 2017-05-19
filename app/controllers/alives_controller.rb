class AlivesController < ApplicationController
  def show
    render status: 200, plain: "It works!"
  end
end
