# Firmas para sistema de puntos de cuenta
# Jorge Redondo Flames. CENDITEL


# Siguiendo la siguiente documentación:
# 1) https://richonrails.com/articles/rails-4-code-concerns-in-active-record-models
# 2) http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
# 3) http://guides.rubyonrails.org/association_basics.html#polymorphic-associations
# 4) http://guides.rubyonrails.org/association_basics.html#the-has-many-through-association

module Signable
  extend ActiveSupport::Concern

  included do
    has_many :signs, as: :signable, dependent: :destroy
  end

  def add_sign
    signs << Sign.create!(body: 'FIRMA:'+self.text)
  end 

  def retrieve_signs
    puts "SIGNABLE"
    puts signs.first.signable
    signs.all.each do |s|
      puts "s.body",s.body
    end
  end 

  def signable?
    true
  end
end
