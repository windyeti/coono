class KovchegsController < ApplicationController

  authorize_resource

  def index
    @search = Kovcheg.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @kovchegs = @search.result.paginate(page: params[:page], per_page: 100)
    # if params['otchet_type'] == 'selected'
    #   Product.csv_param_selected( params['selected_products'], params['otchet_type'])
    #   new_file = "#{Rails.public_path}"+'/ins_detail_selected.csv'
    #   send_file new_file, :disposition => 'attachment'
    # end
  end

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
