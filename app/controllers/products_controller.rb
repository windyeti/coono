class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  authorize_resource

  # GET /products
  # GET /products.json
  # TODO NewDistributor
  def index
    if params[:q]
      @params = params[:q]
      # @params[:combinator] = 'or'

      @params.delete(:lit_kom_id_not_null) if @params[:lit_kom_id_not_null] == '0'
      @params.delete(:kovcheg_id_not_null) if @params[:kovcheg_id_not_null] == '0'
      @params.delete(:nkamin_id_not_null) if @params[:nkamin_id_not_null] == '0'
      @params.delete(:tmf_id_not_null) if @params[:tmf_id_not_null] == '0'
      @params.delete(:shulepov_id_not_null) if @params[:shulepov_id_not_null] == '0'
      @params.delete(:realflame_id_not_null) if @params[:realflame_id_not_null] == '0'
      @params.delete(:dim_id_not_null) if @params[:dim_id_not_null] == '0'
      @params.delete(:sawo_id_not_null) if @params[:sawo_id_not_null] == '0'
      @params.delete(:saunaru_id_not_null) if @params[:saunaru_id_not_null] == '0'
      @params.delete(:teplodar_id_not_null) if @params[:teplodar_id_not_null] == '0'
      @params.delete(:contact_id_not_null) if @params[:contact_id_not_null] == '0'
      @params.delete(:teplomarket_id_not_null) if @params[:teplomarket_id_not_null] == '0'
      @params.delete(:dantexgroup_id_not_null) if @params[:dantexgroup_id_not_null] == '0'
      @params.delete(:wellfit_id_not_null) if @params[:wellfit_id_not_null] == '0'
      @params.delete(:lit_kom_id_or_kovcheg_id_or_nkamin_id_or_tmf_id_or_shulepov_id_or_realflame_id_or_dim_id_or_sawo_id_or_saunaru_id_or_teplodar_id_or_contact_id_or_teplomarket_id_or_dantexgroup_id_not_null) if @params[:lit_kom_id_or_kovcheg_id_or_nkamin_id_or_tmf_id_or_shulepov_id_or_realflame_id_or_dim_id_or_sawo_id_or_saunaru_id_or_teplodar_id_or_contact_id_or_teplomarket_id_or_dantexgroup_id_or_wellfit_id_not_null] == '0'
      @params.delete(:lit_kom_id_and_kovcheg_id_and_nkamin_id_and_tmf_id_and_shulepov_id_and_realflame_id_and_dim_id_and_sawo_id_and_saunaru_id_and_teplodar_id_and_contact_id_and_teplomarket_id_and_dantexgroup_id_null) if @params[:lit_kom_id_and_kovcheg_id_and_nkamin_id_and_tmf_id_and_shulepov_id_and_realflame_id_and_dim_id_and_sawo_id_and_saunaru_id_and_teplodar_id_and_contact_id_and_teplomarket_id_and_dantexgroup_id_and_wellfit_id_null] == '0'

      # делаем доступные параметры фильтров, чтобы их поместить их в параметр q «кнопки создать csv по фильтру»
      @params_q_to_csv = @params.permit(:sku_or_title_cont,
                                        :distributor_eq,
                                        :quantity_gteq,
                                        :lit_kom_id_or_kovcheg_id_or_nkamin_id_or_tmf_id_or_shulepov_id_or_realflame_id_or_dim_id_or_sawo_id_or_saunaru_id_or_teplodar_id_or_contact_id_or_teplomarket_id_or_dantexgroup_id_or_wellfit_id_eq,
                                        :lit_kom_id_not_null,
                                        :kovcheg_id_not_null,
                                        :nkamin_id_not_null,
                                        :tmf_id_not_null,
                                        :shulepov_id_not_null,
                                        :realflame_id_not_null,
                                        :dim_id_not_null,
                                        :sawo_id_not_null,
                                        :saunaru_id_not_null,
                                        :teplodar_id_not_null,
                                        :contact_id_not_null,
                                        :teplomarket_id_not_null,
                                        :dantexgroup_id_not_null,
                                        :wellfit_id_not_null,
                                        :lit_kom_id_and_kovcheg_id_and_nkamin_id_and_tmf_id_and_shulepov_id_and_realflame_id_and_dim_id_and_sawo_id_and_saunaru_id_and_teplodar_id_and_contact_id_and_teplomarket_id_and_dantexgroup_and_wellfit_id_null,
                                        :lit_kom_id_or_kovcheg_id_or_nkamin_id_or_tmf_id_or_shulepov_id_or_realflame_id_or_dim_id_or_sawo_id_or_saunaru_id_or_teplodar_id_or_contact_id_or_teplomarket_id_or_dantexgroup_id_or_wellfit_id_not_null
                                        # :combinator
                                        )
    else
      @params = []
    end

    @search = Product.ransack(@params)
    @search.sorts = 'id desc' if @search.sorts.empty?

    # данные для «кнопки создать csv по фильтру», все данные в отличии от @products, который ограничен 100
    @search_id_by_q = Product.ransack(@params).result.pluck(:id)

    @products = @search.result.paginate(page: params[:page], per_page: 100)

    if params['otchet_type'] == 'selected'
      Services::CsvSelected.call(@search_id_by_q)
      redirect_to '/product_selected.csv'
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)

        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_multiple
    puts params[:product_ids].present?
    if params[:product_ids].present?
			@products = Product.find(params[:product_ids])
			respond_to do |format|
			  format.js
			end
		else
			redirect_to products_url
		end
  end

  def update_multiple
    @products = Product.find(params[:product_ids])
		@products.each do |pr|
			attr = params[:product_attr]
			attr.each do |key,value|
				if key.to_s == 'picture'
					# if value.to_i == 1
					# product_id = pr.id
					#puts product_id
					# Product.productimage(product_id)
					# end
				end
				if key.to_s != 'picture'
					if !value.blank?
					pr.update_attributes(key => value)
            if key.to_s == 'pricepr'
              Product.update_pricepr(pr.id)
            end
					end
				end
			end
		end
		flash[:notice] = 'Данные обновлены'
		redirect_to :back
  end

  def delete_selected
    @products = Product.find(params[:ids])
		@products.each do |product|
		    product.destroy
		end
		respond_to do |format|
		  format.html { redirect_to products_url, notice: 'Товары удалёны' }
		  format.json { render json: {:status => "ok", :message => "Товары удалёны"} }
		end
  end

  def csv_not_sku
    CsvNotSkuJob.perform_later
    flash[:notice] = 'Задача создания csv с товарами без артикула запущена'
    redirect_to products_path
  end

  def linking
    LinkingJob.perform_later
    flash[:notice] = 'Задача ЛИНКИНГ запущена'
    redirect_to products_path
  end

  def syncronaize
    SyncronaizeJob.perform_later
    flash[:notice] = 'Задача синхронизации каталога запущена'
    redirect_to products_path
  end

  def import_insales_xml
    # ActionCable.server.broadcast 'start_process', {process_name: "Обновление Товаров InSales"}
    ProductImportInsalesXmlJob.perform_later
    redirect_to products_path, notice: 'Запущен процесс Обновление Товаров InSales'
  end


  def export_csv
    ExportCsvJob.perform_later
    redirect_to products_path, notice: 'Запущен процесс создания файла'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  # TODO NewDistributor
  def set_product
    @product = Product.includes(:lit_kom, :kovcheg).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  # TODO NewDistributor
  def product_params
    params.require(:product).permit(:sku, :title, :desc, :cat, :oldprice, :price, :quantity, :image, :url,
                                    :lit_kom_id,
                                    :kovcheg_id,
                                    :nkamin_id,
                                    :tmf_id,
                                    :shulepov_id,
                                    :realflame_id,
                                    :dim_id,
                                    :sawo_id,
                                    :saunaru_id,
                                    :teplodar_id,
                                    :contact_id,
                                    :teplomarket_id,
                                    :dantexgroup_id,
                                    :wellfit_id
                                    )
  end

  def make_symbol(combinator, ending)
    body = Product::DISTRIBUTOR.map do |distributor|
      distributor[0]
    end.join("_#{combinator}_")
    "#{body}_#{ending}"
  end
end
