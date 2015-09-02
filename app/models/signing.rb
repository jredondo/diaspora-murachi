# Firmas para sistema de puntos de cuenta
# Jorge Redondo Flames. CENDITEL

class Signing < ActiveRecord::Base
  belongs_to :post
  belongs_to :sign
end
