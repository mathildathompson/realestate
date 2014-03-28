# == Schema Information
#
# Table name: properties
#
#  id              :integer          not null, primary key
#  style           :string(255)
#  price           :decimal(, )
#  sqr_ft          :integer
#  bedrooms        :integer
#  bathrooms       :integer
#  garages         :integer
#  description     :text
#  map_image       :text
#  sale_status     :boolean
#  date_listed     :date
#  address_number  :string(255)
#  address_street  :string(255)
#  address_city    :string(255)
#  address_suburb  :string(255)
#  address_state   :string(255)
#  address_code    :string(255)
#  address_country :string(255)
#  user_id         :integer
#

class Property < ActiveRecord::Base
    attr_accessible :style, :price, :sqr_ft, :bedrooms, :bathrooms, :garages,
    :description, :map_image, :sale_status, :date_listed, :address_number, 
    :address_street, :address_suburb, :address_city, :address_state, :address_code, :address_country, :user_id

    scope :by_style, -> style { where(:style => style) }
    scope :by_garages, -> garages { where(:garages => garages) }
    scope :by_bedrooms, -> bedrooms { where(:bedrooms => bedrooms) }
    scope :by_bathrooms, -> bathrooms { where(:bathrooms => bathrooms) }
    scope :by_price, -> started_at, ended_at { where("started_at = ? AND ended_at = ?", started_at, ended_at) }

    belongs_to :user
    has_many :photos

    def self.search_query(params)
        conditions  = []
        arguments = {}
     
        unless params[:address_suburb].blank?
          conditions << 'address_suburb = :address_suburb'
          arguments[:address_suburb] = params[:address_suburb]
        end
       
        unless params[:bathrooms].blank?
          conditions << 'bathrooms = :bathrooms'
          arguments[:bathrooms] = params[:bathrooms]
        end

        unless params[:bedrooms].blank?
          conditions << 'bedrooms = :bedrooms'
          arguments[:bedrooms] = params[:bedrooms]
        end
       
        unless params[:garages].blank?
          conditions << 'garages = :garages'
          arguments[:garages] = params[:garages]
        end

        unless params[:price].blank?
          conditions << 'price <= :price'
          arguments[:price] = params[:price]
        end
       
        all_conditions = conditions.join(' AND ')
        results = Property.find(:all, :conditions => [all_conditions, arguments])
    end
end
