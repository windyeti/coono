class TeplomarketsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @teplomarket = Teplomarket.find(params[:id])
  end

  def edit; end

  def update
    @teplomarket = Teplomarket.find(params[:id])

    respond_to do |format|
      if @teplomarket.update(params[:lit_kom])
        format.html { redirect_to(@teplomarket, :notice => 'Teplomarket was successfully updated.') }
        format.json { respond_with_bip(@teplomarket) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@teplomarket) }
      end
    end
  end

  def parsing
    TeplomarketJob.perform_later
    redirect_to teplomarkets_path, notice: 'Запущен парсинг Teplomarket'
  end
end
