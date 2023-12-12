class Employee < ApplicationRecord
  belongs_to :workspace
  belongs_to :job_role
  has_many :contacts, inverse_of: :employee, dependent: :delete_all

  accepts_nested_attributes_for :contacts
  #Constants
  MARITAL_STATUSES = ['Casado', 'Solteiro', 'Viúvo']
  SEXES = ['Masculino', 'Feminino']
  CEP = Cep.instance
  ##

  #Validations
  validate :cep_validations
  validates :id, presence: true, uniqueness: true
  validates :full_name, presence: true, length: {minimum: 3} 
  validates :job_role_id, uniqueness: {scope: :workspace_id}
  ##

  #Search
  scope :filter_by_term, ->(term){ where("lower(full_name) LIKE ? ", "%#{term.downcase}%")}
  scope :filter_by_id, ->(id){ where("id LIKE ? ", "%#{id}%")}
  scope :filter_by_sex, ->(sex){where sex: sex if sex.present?}
  scope :filter_by_workspace_id, ->(workspace_id){where workspace_id: workspace_id if workspace_id.present?}
  scope :filter_by_job_role_id, ->(job_role_id){where job_role_id: job_role_id if job_role_id.present?}
  #Will Paginate
  self.per_page = 5
  ##
  scope :includes_workspace_and_job_role, ->(page){
    includes(:workspace, :job_role)
    .paginate(page: page)
  }
  private
  def city_state_validations
    errors.add(:origin_city, 'errors.invalid') unless CEP.does_city_exist?
    errors.add(:home_state, 'errors.invalid') unless CEP.does_state_exist?
    errors.add(:origin_city, 'errors.city_not_in_state') unless CEP.does_city_belong?
  end

  def cep_validations
    return unless origin_city.present? && home_state.present?

    CEP.city = origin_city
    CEP.state = home_state
    city_state_validations
  end

end