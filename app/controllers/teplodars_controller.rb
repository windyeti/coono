class TeplodarsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @teplodar = Teplodar.find(params[:id])
  end

  def edit; end

  def update
    @teplodar = Teplodar.find(params[:id])

    respond_to do |format|
      if @teplodar.update(permit_params)
        format.html { redirect_to(@teplodar, :notice => 'Teplodar was successfully updated.') }
        format.json { respond_with_bip(@teplodar) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@teplodar) }
      end
    end
  end

  def parsing
    TeplodarJob.perform_later
    redirect_to teplodars_path, notice: 'Запущен парсинг Teplodar'
  end
end
