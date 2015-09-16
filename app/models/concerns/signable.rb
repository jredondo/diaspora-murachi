# Firmas para sistema de puntos de cuenta
# Jorge Redondo Flames. CENDITEL


# Siguiendo la siguiente documentación:
# 1) https://richonrails.com/articles/rails-4-code-concerns-in-active-record-models
# 2) http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
# 3) http://guides.rubyonrails.org/association_basics.html#polymorphic-associations
# 4) http://guides.rubyonrails.org/association_basics.html#the-has-many-through-association
require 'net/http/post/multipart'
require 'json'


module Signable
  module Controllers
    extend ActiveSupport::Concern

    def update
      @post = Post.find_by_id(params[:id])

      if not @post
        render json: { message: "Post #{params[:id]} does not exist", status: :not_found }
      else
        @post.update! presign: params[:post][:presign]
        @post.postsign!
        render json: @post.to_json
      end
    end
  end

  module Models
    extend ActiveSupport::Concern

    included do
      has_many :signs, as: :signable, dependent: :destroy
    end

    def verify!
      begin
        logger.info "=!=!=!=!=!=!=!=!=!=!=!=!=!"
        @bdoc_text = get_text_from_container!
        logger.info @bdoc_text
        logger.info text
        if @bdoc_text != text
          logger.info "ALERTA: Los datos firmados no coinciden\n con los almacenados en la base de datos"
          update!(verify: "ALERTA: Los datos firmados no coinciden\n con los almacenados en la base de datos")
          return
        end
        logger.info "=@#=@#=@#=@#=@#=@#=@#=@#=@#"
        @uri = URI.parse 'https://murachi.cenditel.gob.ve/Murachi/0.1/archivos/%s' % container_id
        @req = Net::HTTP::Get.new @uri.path
        @http = self.config_request(@uri)
        @req['Authorization'] = 'Basic YWRtaW46YWRtaW4='
        @res = @http.request(@req)
        logger.info "=·=·=·=·=·=·=·=·=·"
        logger.info JSON.parse(@res.body)['signatures']
        update!(verify: JSON.parse(@res.body)['signatures'])
        if verify == nil 
          update!(verify: "ALERTA: La publicación NO fue firmada")
        end
      rescue Exception => e
        raise e
      rescue e
        raise e
      end
    end

    def postsign!
      begin
        @parameters = {"containerId" => container_id,
                       "signature" => presign}
        @headers = { "Content-Type" => 'application/json',
                     "Authorization" => 'Basic YWRtaW46YWRtaW4='}
        #@uri = URI.parse("https://192.168.12.125:8443/Murachi/0.1/archivos/bdocs/firmas/pre")
        @uri = URI.parse("https://murachi.cenditel.gob.ve/Murachi/0.1/archivos/bdocs/firmas/post")
        @http = self.config_request(@uri)
        @res = @http.post(@uri.path,@parameters.to_json,@headers)
        signs << Sign.create!(body: presign)
        return
      rescue Exception => e
        raise e
      rescue e
        raise e
      end
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

    def presign!
      begin
        @parameters = {"fileId" => container_id,
                       "certificate" => certificate,
                       "city" => "Rubio",
                       "state" => "Tachira",
                       "postalCode" => "1234",
                       "country" => "Venezuela",
                       "role" => "Militar",
                       "addSignature" => "false"}
        @headers = { "Content-Type" => 'application/json',
                     "Authorization" => 'Basic YWRtaW46YWRtaW4='}
        #@uri = URI.parse("https://192.168.12.125:8443/Murachi/0.1/archivos/bdocs/firmas/pre")
        @uri = URI.parse("https://murachi.cenditel.gob.ve/Murachi/0.1/archivos/bdocs/firmas/pre")
        @http = self.config_request(@uri)
        @res = @http.post(@uri.path,@parameters.to_json,@headers)
        update!( presign: (JSON.parse @res.body)["hash"])
        logger.info "\n\n\n\n\n###########################"
      rescue Exception => e
        raise e
      rescue e
        raise e
      end
    end

    def build_and_set_container!
      begin
        #@uri = URI.parse('https://192.168.12.125:8443/Murachi/0.1/archivos/bdocs/cargas')
        @uri = URI.parse('https://murachi.cenditel.gob.ve/Murachi/0.1/archivos/bdocs/cargas')
        @req = Net::HTTP::Post::Multipart.new @uri.path,
          "data" => UploadIO.new(StringIO.new(text), "text/plain","diaspora_post_"+guid)
        @req['Authorization'] = 'Basic YWRtaW46YWRtaW4='
        @http = self.config_request(@uri)
        @res = @http.request(@req)
        update!(container_id: JSON.parse(@res.body)['containerId'])
        return
      rescue Exception => e
        raise e
      end
      
    end 

    def get_text_from_container!
      begin
        @uri = URI.parse "https://murachi.cenditel.gob.ve/Murachi/0.1/archivos/bdocs/archivos/%s/0" % container_id
        @req = Net::HTTP::Get.new @uri.path
        @http = self.config_request(@uri)
        @req['Authorization'] = 'Basic YWRtaW46YWRtaW4='
        @res = @http.request(@req)
        @res.body
      rescue Exception => e
        raise e
      end
    end 

    def config_request(uri)
      @http = Net::HTTP.new(uri.host, uri.port)
      @http.use_ssl = true
      @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @http
    end
  
  end
end
