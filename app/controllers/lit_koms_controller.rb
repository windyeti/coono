class LitKomsController < ApplicationController
  include Distributor

  before_action :set_lit_kom, only: [:update, :show]

  authorize_resource

  def show
  end

  def edit; end

  def update
    respond_to do |format|
      if @lit_kom.update(params[:lit_kom])
        format.html { redirect_to(@lit_kom, :notice => 'Lit-kom was successfully updated.') }
        format.json { respond_with_bip(@lit_kom) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@lit_kom) }
      end
    end
  end

  def parsing
    LitKomJob.perform_later
    redirect_to lit_koms_path, notice: 'Запущен парсинг Lit-kom'
  end

  private

  def set_lit_kom
    @lit_kom = LitKom.find(params[:id])
  end
end
