class TmfsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @tmf = Tmf.find(params[:id])
  end

  def edit; end

  def update
    @tmf = Tmf.find(params[:id])

    respond_to do |format|
      if @tmf.update(params[:lit_kom])
        format.html { redirect_to(@tmf, :notice => 'Tmf was successfully updated.') }
        format.json { respond_with_bip(@tmf) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@tmf) }
      end
    end
  end

  def parsing
    TmfJob.perform_later
    redirect_to tmfs_path, notice: 'Запущен парсинг Tmf'
  end
end
