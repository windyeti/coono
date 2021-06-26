class SawosController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @sawo = Sawo.find(params[:id])
  end

  def edit; end

  def update
    @sawo = Sawo.find(params[:id])

    respond_to do |format|
      if @sawo.update(params[:lit_kom])
        format.html { redirect_to(@sawo, :notice => 'Sawo was successfully updated.') }
        format.json { respond_with_bip(@sawo) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@sawo) }
      end
    end
  end

  def parsing
    SawoJob.perform_later
    redirect_to sawos_path, notice: 'Запущен парсинг Sawo'
  end
end
