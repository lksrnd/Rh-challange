class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show edit update destroy ]
  before_action :set_cities_and_states, :set_sexes, :set_marital_statuses, only: %i[new create edit update destroy]
  before_action :set_workspaces, :set_job_roles, only: %i[index new create edit update search]

  # GET /employees or /employees.json
  def index
    @employees = Employee.includes(:workspace, :job_role).paginate(page: params[:page]).order('created_at desc')
    add_breadcrumb('Pessoas')
  end

  # GET /employees/1 or /employees/1.json
  def show
    add_breadcrumb('Pessoas', employees_path)
    add_breadcrumb('Visualizar Pessoa')
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    add_breadcrumb('Pessoas', employees_path)
    add_breadcrumb('Cadastrar Pessoa')
  end

  # GET /employees/1/edit
  def edit
    add_breadcrumb('Pessoas', employees_path)
    add_breadcrumb('Editar Pessoa')
  end
  #GET /employees/params/search
  def search
    add_breadcrumb('Pessoas', employees_path)
    add_breadcrumb('Pesquisar Pessoa')
    @employees = Employee.includes_workspace_and_job_role(params[:page]).where(nil)
    filtering_params(params).each do |key, value|
      @employees = @employees.public_send("filter_by_#{key}", value) if value.present?
    end
  end 
  # POST /employees or /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employee_url(@employee), notice: "Pessoa criada com sucesso." }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employee_url(@employee), notice: "Pessoa editada com sucesso." }
        format.json { render :show, status: :ok, location: @employee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Pessoa excluída com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:id, :full_name, :birth_date, :origin_city, :home_state, :marital_status, :sex, :workspace_id, :job_role_id,
                                       contacts_attributes: [:id, :phone, :mobile_phone, :email])
    end

    def set_sexes
      @sexes = Employee::SEXES.map do |sex| sex
      end
    end
  
    def set_marital_statuses
      @marital_statuses = Employee::MARITAL_STATUSES.map do |marital_status| marital_status
      end
    end

    def set_workspaces
      @workspaces = Workspace.all.pluck(:title, :id)
    end

    def set_job_roles
      @job_roles = JobRole.all.pluck(:title, :id)
    end

    def set_cities_and_states
      cep = Cep.instance
      @cities = cep.cities.uniq.map { |city| [city, city] }
      @states = cep.states.map { |state| [state, state] }
    end

    def filtering_params(params)
      params.slice(:term, :id, :sex, :workspace_id, :job_role_id)
    end
end
