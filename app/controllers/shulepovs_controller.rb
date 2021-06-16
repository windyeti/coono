class ShulepovsController < ApplicationController
  include Distributor

  authorize_resource

  # def index
  #   if params[:q].present?
  #     @params = params[:q]
  #     @params.delete(:product_id_null) if @params[:product_id_null] == '0'
  #
  #     @params_q_to_csv = @params.permit(:id_eq, :title_or_sku_cont, :quantity_eq, :quantity_gt, :product_id_null)
  #   else
  #     @params = {}
  #   end
  #
  #   # данные для «кнопки создать csv по фильтру», все данные в отличии от @products, который ограничен 100
  #   @search_id_by_q = Shulepov.ransack(@params).result.includes(:product).pluck(:id)
  #
  #   @search = Shulepov.ransack(@params)
  #   @search.sorts = 'id desc' if @search.sorts.empty?
  #
  #
  #
  #   # @shulepovs = @search.result.includes(:product).paginate(page: params[:page], per_page: 100)
  #
  #   p instance_var_name = "@#{controller_name.singularize}s".to_sym
  #   instance_variable_set(instance_var_name, @search.result.includes(:product).paginate(page: params[:page], per_page: 100))
  #
  #   if params['otchet_type'] == 'selected'
  #     p @shulepovs
  #     # Services::CsvSelectedDistributor.call(@search_id_by_q, "#{controller_name}")
  #     # redirect_to "/#{controller_name.classify}_selected.csv"
  #   end
  # end

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
