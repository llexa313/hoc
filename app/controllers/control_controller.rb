class ControlController < ApplicationController

  def index
    render 'control/index', locals: { char: character }
  end

  def new
    all = character.run(params[:count].to_i, params[:concurency].to_i)
    render locals: { all: all.collect{ |r| JSON.parse r.response.body } }
  end

  def character
    @@character ||= Character.new({
        na_id: '196732238',
        mobile_id: '963d09b21fa6057da8f16a493cba0541',
        world: 25,
        uid: 1910869
    })
  end
end