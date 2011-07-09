class NetworksController < ApplicationController

  def show
    render :template => "network/show", :layout => false
  end

end
