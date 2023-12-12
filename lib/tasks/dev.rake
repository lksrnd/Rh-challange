namespace :dev do
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib','tmp')

  desc "Configura ambiente de desenvolvimento"
  #rails dev:setup
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD..."){%x(rails db:drop)}
      show_spinner("Criando BD..."){%x(rails db:create)}      
      show_spinner("Migrando BD..."){%x(rails db:migrate)}
      show_spinner("Adicionando Lotações"){%x(rails dev:add_workspaces)}
      show_spinner("Adicionando Cargos"){%x(rails dev:add_job_roles)}
      show_spinner("Adicionando Pessoas"){%x(rails dev:add_employees)}
    end
  end
  desc "Adiciona funcionário padrão"
  task add_default_employee: :environment do
    Employee.create!(
      id: rand(1..9999),
      full_name: "Lucas Cesar",
      workspace_id: Workspace.all.sample.id,
      job_role_id: JobRole.all.sample.id
    )
    end

  desc "Adiciona Lotações"
  # rails dev:add_workspaces
  task add_workspaces: :environment do
    file_name = 'workspaces.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
    
    File.open(file_path, 'r').each do |line|
      Workspace.create!(title: line.strip)
    end
  end
  desc "Adiciona Cargos"
  # rails dev:add_job_roles
  task add_job_roles: :environment do
    file_name = 'job_roles.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
    
    File.open(file_path, 'r').each do |line|
      JobRole.create!(title: line.strip)
    end
  end
  desc "Adiciona pessoas"
  # rails 'dev:add_employees[qtd_workspace]'
  task :add_employees, [:qtd_workspace] => [:environment] do |t, args|
    number_workspaces = 3
    number_workspaces = args.qtd_workspace if args.qtd_workspace.to_i > 0
    Workspace.first(number_workspaces).each do |workspace|
      JobRole.all.each do |job_role|
        next if Employee.where(workspace_id: workspace.id).where(job_role_id: job_role.id).present?
        
        params = create_employee_params(workspace, job_role)
        contacts_array = params[:employee][:contacts_attributes]

        add_contacts(contacts_array)

        Employee.create!(params[:employee])
      end
    end  
  end

  private

  def create_employee_params(workspace, job_role)
    {employee: {
      id: rand(1..9999),
      full_name: Faker::Name.name,
      birth_date: Faker::Date.birthday(min_age: 16, max_age: 59),
      sex: Employee::SEXES.sample,
      marital_status: Employee::MARITAL_STATUSES.sample,
      workspace_id: workspace.id,
      job_role_id: job_role.id,
      contacts_attributes:[]
    }}
  end

  def create_contacts_params
    {phone: Faker::Number.number(digits: 8), mobile_phone: Faker::Number.number(digits: 9), email: Faker::Internet.email}
  end

  def add_contacts(contacts_array = [])
    rand(1..2).times do |j|
      contacts_array.push(
        create_contacts_params
      )
    end
  end

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")  
  end
end