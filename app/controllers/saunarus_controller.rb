class SaunarusController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @saunaru = Saunaru.find(params[:id])
  end

  def edit; end

  def update
    @saunaru = Saunaru.find(params[:id])

    respond_to do |format|
      if @saunaru.update(permit_params)
        format.html { redirect_to(@saunaru, :notice => 'Saunaru was successfully updated.') }
        format.json { respond_with_bip(@saunaru) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@saunaru) }
      end
    end
  end

  def parsing
    SaunaruJob.perform_later
    redirect_to saunarus_path, notice: 'Запущен парсинг Saunaru'
  end
end
