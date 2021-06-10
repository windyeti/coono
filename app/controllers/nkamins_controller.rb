class NkaminsController < ApplicationController

  authorize_resource

  def index
    @search = Nkamin.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @nkamins = @search.result.paginate(page: params[:page], per_page: 100)
    # if params['otchet_type'] == 'selected'
    #   Product.csv_param_selected( params['selected_products'], params['otchet_type'])
    #   new_file = "#{Rails.public_path}"+'/ins_detail_selected.csv'
    #   send_file new_file, :disposition => 'attachment'
    # end
  end

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
