class RealflamesController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @realflame = Realflame.find(params[:id])
  end

  def edit; end

  def update
    @realflame = Realflame.find(params[:id])

    respond_to do |format|
      if @realflame.update(params[:lit_kom])
        format.html { redirect_to(@realflame, :notice => 'Realflame was successfully updated.') }
        format.json { respond_with_bip(@realflame) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@realflame) }
      end
    end
  end

  def destroy
    @realflame = Realflame.find(params[:id])
    @realflame.destroy
  end

  def parsing
    RealflameJob.perform_later
    redirect_to realflames_path, notice: 'Запущен парсинг Realflame'
  end
end
