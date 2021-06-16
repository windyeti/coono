class ShulepovsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @shulepov = Shulepov.find(params[:id])
  end

  def edit; end

  def update
    @shulepov = Shulepov.find(params[:id])

    respond_to do |format|
      if @shulepov.update(params[:lit_kom])
        format.html { redirect_to(@shulepov, :notice => 'Shulepov was successfully updated.') }
        format.json { respond_with_bip(@shulepov) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@shulepov) }
      end
    end
  end

  def parsing
    ShulepovJob.perform_later
    redirect_to shulepovs_path, notice: 'Запущен парсинг Shulepov'
  end
end
