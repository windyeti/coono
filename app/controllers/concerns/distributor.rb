module Distributor
  extend ActiveSupport::Concern

  def index
    if params[:q].present?
      @params = params[:q]
      # @params[:combinator] = 'or'

      # @params.delete(:product_id_null) if @params[:product_id_null] == "0"
      # @params.delete(:product_id_not_null) if @params[:product_id_not_null] == "0"

      @params_q_to_csv = @params.permit(:id_eq, :title_or_sku_cont, :quantity_eq, :quantity_gt, :product_id_null, :product_id_not_null, :price_gteq, :price_lteq, :combinator)
    else
      @params = {}
    end

    # данные для «кнопки создать csv по фильтру», все данные в отличии от @products, который ограничен 100
    @search_id_by_q = set_klass.ransack(@params).result.includes(:product).pluck(:id)

    @search = set_klass.ransack(@params)
    @search.sorts = 'id desc' if @search.sorts.empty?

    set_instance_var

    if params['otchet_type'] == 'selected'
      Services::CsvSelectedDistributor.call(@search_id_by_q, "#{controller_name}")
      redirect_to "/#{controller_name.classify}_selected.csv"
    end
  end

  private

  def set_klass
    controller_name.classify.constantize
  end

  def set_instance_var
    instance_var_name = "@#{controller_name.singularize}s".to_sym
    instance_variable_set(instance_var_name, @search.result.includes(:product).paginate(page: params[:page], per_page: 100))
  end

  def permit_params
    params.require("@#{controller_name.singularize}s".to_sym).permit(:price, :quantity)
  end
end
