class ShulepovsController < ApplicationController

  authorize_resource

  def index
    @search = Shulepov.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @shulepovs = @search.result.paginate(page: params[:page], per_page: 100)
    # if params['otchet_type'] == 'selected'
    #   Product.csv_param_selected( params['selected_products'], params['otchet_type'])
    #   new_file = "#{Rails.public_path}"+'/ins_detail_selected.csv'
    #   send_file new_file, :disposition => 'attachment'
    # end
  end

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
