class WellfitsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @wellfit = Wellfit.find(params[:id])
  end

  def edit; end

  def update
    @wellfit = Wellfit.find(params[:id])

    respond_to do |format|
      if @wellfit.update(params[:lit_kom])
        format.html { redirect_to(@wellfit, :notice => 'Wellfit was successfully updated.') }
        format.json { respond_with_bip(@wellfit) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@wellfit) }
      end
    end
  end

  def parsing
    WellfitJob.perform_later
    redirect_to wellfits_path, notice: 'Запущен парсинг Wellfit'
  end
end
