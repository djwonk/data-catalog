# A user account. A User may be an administrator of a Catalog.
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :confirmable, :recoverable,
    :registerable, :rememberable, :trackable, :validatable
  
  # === Fields ===
  field :uid,  :type => String
  field :name, :type => String
  field :bio,  :type => String
  # field :email, :type => String (created by devise)
  
  # === Associations ===
  references_many :data_source_notes
  references_many :tags
  references_many :curated_catalogs, :class_name => 'Catalog',
    :inverse_of => :curators, :stored_as => :array, :index => true
  references_many :owned_catalogs, :class_name => 'Catalog',
    :inverse_of => :owners, :stored_as => :array, :index => true
  references_many :watched_data_sources, :class_name => 'DataSource',
    :inverse_of => :watchers, :stored_as => :array, :index => true

  # === Indexes ===
  index :uid, :unique => true

  # === Validations ===
  validates_uniqueness_of :uid
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false

  # === Class Methods ===
  def self.find_duplicate(params)
    ModelHelper.find_duplicate(self, params, [:uid])
  end

  def self.ensure(params)
    ModelHelper.ensure(self, params)
  end

  # === Instance Methods ===
  def to_param; uid end

end
