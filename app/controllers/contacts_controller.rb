class ContactsController < ApplicationController
  include Distributor

  authorize_resource

  def show
    @contact = Contact.find(params[:id])
  end

  def edit; end

  def update
    @contact = Contact.find(permit_params)

    respond_to do |format|
      if @contact.update(permit_params)
        format.html { redirect_to(@contact, :notice => 'Contact was successfully updated.') }
        format.json { respond_with_bip(@contact) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@contact) }
      end
    end
  end

  def parsing
    ContactJob.perform_later
    redirect_to contacts_path, notice: 'Запущен парсинг Contact'

  end
end
