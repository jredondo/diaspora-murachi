# Firmas para sistema de puntos de cuenta
# Jorge Redondo Flames. CENDITEL

class Sign < ActiveRecord::Base
  #belongs_to :signable, :polymorphic => true
  has_one :signings
  has_one :posts, :through => :signings

  #attr_accessor :body 
end
