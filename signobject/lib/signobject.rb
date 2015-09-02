require "signobject/engine"

module Signobject

  module Strategies
    autoload :Signable, 'signobject/strategies/signable'
  end

  def self.setup
    puts "*** SIGNOBJECT SETUP ***",self
    yield self
  end
 
  ALL         = []

  #mattr_accessor :signable
  #@@signable = nil

end

require 'signobject/models'
#require 'signobject/modules'
#require 'signobject/rails'

