class Account::PropertiesController < Account::ApplicationController
  account_load_and_authorize_resource :property, through: :team, through_association: :properties

  # GET /account/teams/:team_id/properties
  # GET /account/teams/:team_id/properties.json
  def index
    delegate_json_to_api
  end

  # GET /account/properties/:id
  # GET /account/properties/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/properties/new
  def new
  end

  # GET /account/properties/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/properties
  # POST /account/teams/:team_id/properties.json
  def create
    respond_to do |format|
      if @property.save
        format.html { redirect_to [:account, @property], notice: I18n.t("properties.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @property] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/properties/:id
  # PATCH/PUT /account/properties/:id.json
  def update
    respond_to do |format|
      if @property.update(property_params)
        format.html { redirect_to [:account, @property], notice: I18n.t("properties.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @property] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/properties/:id
  # DELETE /account/properties/:id.json
  def destroy
    @property.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :properties], notice: I18n.t("properties.notifications.destroyed") }
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
