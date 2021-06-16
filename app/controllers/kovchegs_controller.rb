class KovchegsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @kovcheg = Kovcheg.find(params[:id])
  end

  def edit; end

  def update
    @kovcheg = Kovcheg.find(params[:id])

    respond_to do |format|
      if @kovcheg.update(params[:lit_kom])
        format.html { redirect_to(@kovcheg, :notice => 'Kovcheg was successfully updated.') }
        format.json { respond_with_bip(@kovcheg) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@kovcheg) }
      end
    end
  end

  def parsing
    KovchegJob.perform_later
    redirect_to kovchegs_path, notice: 'Запущен парсинг Kovcheg'

  end
end
