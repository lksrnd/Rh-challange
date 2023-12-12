json.extract! employee, :id, :full_name, :birth_date, :origin_city, :home_state, :sex, :workspace_id, :job_role_id, :created_at, :updated_at
json.url employee_url(employee, format: :json)
