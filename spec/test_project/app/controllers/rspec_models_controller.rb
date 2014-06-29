class RspecModelsController < ApplicationController
  before_action :set_rspec_model, only: [:show, :edit, :update, :destroy]

  # GET /rspec_models
  # GET /rspec_models.json
  def index
    @rspec_models = RspecModel.all
  end

  # GET /rspec_models/1
  # GET /rspec_models/1.json
  def show
  end

  # GET /rspec_models/new
  def new
    @rspec_model = RspecModel.new
  end

  # GET /rspec_models/1/edit
  def edit
  end

  # POST /rspec_models
  # POST /rspec_models.json
  def create
    @rspec_model = RspecModel.new(rspec_model_params)

    respond_to do |format|
      if @rspec_model.save
        format.html { redirect_to @rspec_model, notice: 'Rspec model was successfully created.' }
        format.json { render :show, status: :created, location: @rspec_model }
      else
        format.html { render :new }
        format.json { render json: @rspec_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rspec_models/1
  # PATCH/PUT /rspec_models/1.json
  def update
    respond_to do |format|
      if @rspec_model.update(rspec_model_params)
        format.html { redirect_to @rspec_model, notice: 'Rspec model was successfully updated.' }
        format.json { render :show, status: :ok, location: @rspec_model }
      else
        format.html { render :edit }
        format.json { render json: @rspec_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rspec_models/1
  # DELETE /rspec_models/1.json
  def destroy
    @rspec_model.destroy
    respond_to do |format|
      format.html { redirect_to rspec_models_url, notice: 'Rspec model was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rspec_model
      @rspec_model = RspecModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rspec_model_params
      params.require(:rspec_model).permit(:name)
    end
end
