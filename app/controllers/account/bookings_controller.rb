class Account::BookingsController < Account::ApplicationController
  account_load_and_authorize_resource :booking, through: :property, through_association: :bookings

  # GET /account/properties/:property_id/bookings
  # GET /account/properties/:property_id/bookings.json
  def index
    delegate_json_to_api
  end

  # GET /account/bookings/:id
  # GET /account/bookings/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/properties/:property_id/bookings/new
  def new
  end

  # GET /account/bookings/:id/edit
  def edit
  end

  # POST /account/properties/:property_id/bookings
  # POST /account/properties/:property_id/bookings.json
  def create
    respond_to do |format|
      if @booking.save
        format.html { redirect_to [:account, @booking], notice: I18n.t("bookings.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @booking] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/bookings/:id
  # PATCH/PUT /account/bookings/:id.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to [:account, @booking], notice: I18n.t("bookings.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @booking] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/bookings/:id
  # DELETE /account/bookings/:id.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @property, :bookings], notice: I18n.t("bookings.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
