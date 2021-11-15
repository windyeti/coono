class DimsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @dim = Dim.find(params[:id])
  end

  def edit; end

  def update
    @dim = Dim.find(params[:id])

    respond_to do |format|
      if @dim.update(permit_params)
        format.html { redirect_to(@dim, :notice => 'Dim was successfully updated.') }
        format.json { respond_with_bip(@dim) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@dim) }
      end
    end
  end

  def parsing
    DimJob.perform_later
    redirect_to dims_path, notice: 'Запущен парсинг Dim'

  end
end
