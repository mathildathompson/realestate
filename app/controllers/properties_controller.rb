class PropertiesController < ApplicationController
  has_scope :by_bedrooms
  has_scope :by_bathrooms
  has_scope :by_style
  has_scope :by_garages
  has_scope :by_price, :using => [:started_at, :ended_at], :type => :hash

  def index
    @properties = apply_scopes(Property).all
    api = HTTParty.get('https://api.bitcoinaverage.com/ticker/global/AUD/')
    @last_traded_price = api['last']
  end

  def create
    property = Property.create params[:property]
    redirect_to new_photo_path(:property_id => property.id)
  end

  def new
    @property = Property.new
  end

  def edit
    @property = Property.find params[:id]
  end

  def show
    @property = Property.find params[:id]

    api = HTTParty.get('https://api.bitcoinaverage.com/ticker/global/AUD/')
    @last_traded_price = api['last']
  end

  def search
    api = HTTParty.get('https://api.bitcoinaverage.com/ticker/global/AUD/')
    @last_traded_price = api['last']

    conditions  = []
    arguments = {}
 
    unless params[:bedrooms].blank?
      conditions << 'bedrooms LIKE :bedrooms'
      arguments[:bedrooms] = "%#{params[:bedrooms]}%"
    end
   
    unless params[:hobby].blank?
      conditions << 'hobby = :hobby'
      arguments[:hobby] = params[:hobby]
    end
   
    unless params[:age].blank?
      conditions << 'age >= :age'
      arguments[:age] = params[:age]
    end
   
    all_conditions = conditions.join(' AND ')
   
    @search_results = Property.find(:all, :conditions => [all_conditions, arguments])
    
    v1 = Property.where(:bedrooms => params[:bedrooms])
    v2 = v1.where(:bathrooms => params[:bathrooms])
    v3 = v2.where(:address_suburb => params[:address_suburb])
    v4 = v3.where(:price => params[:price].to_i)
    @v5 = v4.where(:garages => params[:garages])
  end

  def update
    property = Property.find params[:id]
    property.update_attributes(params[:property])
    redirect_to property
  end

  def destroy
    property = Property.find params[:id]
    property.destroy
    redirect_to properties_path
  end
end
