class TmfsController < ApplicationController

  authorize_resource

  def index
    @search = Tmf.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @tmfs = @search.result.paginate(page: params[:page], per_page: 100)
    # if params['otchet_type'] == 'selected'
    #   Product.csv_param_selected( params['selected_products'], params['otchet_type'])
    #   new_file = "#{Rails.public_path}"+'/ins_detail_selected.csv'
    #   send_file new_file, :disposition => 'attachment'
    # end
  end

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
