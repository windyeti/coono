class DantexgroupsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @dantexgroup = Dantexgroup.find(params[:id])
  end

  def edit; end

  def update
    @dantexgroup = Dantexgroup.find(params[:id])

    respond_to do |format|
      if @dantexgroup.update(permit_params)
        format.html { redirect_to(@dantexgroup, :notice => 'Dantexgroup was successfully updated.') }
        format.json { respond_with_bip(@dantexgroup) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@dantexgroup) }
      end
    end
  end

  def parsing
    DantexgroupJob.perform_later
    redirect_to dantexgroups_path, notice: 'Запущен парсинг Dantexgroup'

  end
end
