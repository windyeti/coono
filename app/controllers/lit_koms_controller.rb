class LitKomsController < ApplicationController

  authorize_resource

  def index
    @search = LitKom.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @lit_koms = @search.result.paginate(page: params[:page], per_page: 100)
    # if params['otchet_type'] == 'selected'
    #   Product.csv_param_selected( params['selected_products'], params['otchet_type'])
    #   new_file = "#{Rails.public_path}"+'/ins_detail_selected.csv'
    #   send_file new_file, :disposition => 'attachment'
    # end
  end

  def show
    @lit_kom = LitKom.find(params[:id])
  end

  def edit; end

  def update
    @lit_kom = LitKom.find(params[:id])

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

  # def lit_kom_params
  #   params.require(:lit_kom).permit(:sku, :title, :desc, :cat, :charact, :oldprice, :price, :quantity, :image, :url, :lit_kom_id)
  # end
end
