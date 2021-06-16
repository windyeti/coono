class NkaminsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @nkamin = Nkamin.find(params[:id])
  end

  def edit; end

  def update
    @nkamin = Nkamin.find(params[:id])

    respond_to do |format|
      if @nkamin.update(params[:lit_kom])
        format.html { redirect_to(@nkamin, :notice => 'Nkamin was successfully updated.') }
        format.json { respond_with_bip(@nkamin) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@nkamin) }
      end
    end
  end

  def parsing
    NkaminJob.perform_later
    redirect_to nkamins_path, notice: 'Запущен парсинг Nkamin'
  end
end
