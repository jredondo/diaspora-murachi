// @license magnet:?xt=urn:btih:0b31508aeb0634b347b8270c7bee4d411b5d4109&dn=agpl-3.0.txt AGPL-v3-or-Later

app.models.Post = Backbone.Model.extend(_.extend({}, app.models.formatDateMixin, {
  urlRoot : "/posts",

  initialize : function() {
    this.interactions = new app.models.Post.Interactions(_.extend({post : this}, this.get("interactions")));
    this.delegateToInteractions();
  },

  /////////////////////////////////////////////
  // Murachí
  /////////////////////////////////////////////
  containerId :  function(){
    return this.get("container_id");
  },
  presign : function(){
    return this.get("presign");
  },
  setSign : function(sign){
    return this.set({presign: sign});
  },
  /////////////////////////////////////////////
  /////////////////////////////////////////////

  delegateToInteractions : function(){
    this.comments = this.interactions.comments;
    this.likes = this.interactions.likes;

    this.comment = function(){
      this.interactions.comment.apply(this.interactions, arguments);
    };
  },

  interactedAt : function() {
    return this.timeOf("interacted_at");
  },

  reshare : function(){
    this._reshare = this._reshare || new app.models.Reshare({root_guid : this.get("guid")});
    return this._reshare;
  },

  reshareAuthor : function(){
    return this.get("author");
  },

  blockAuthor: function() {
    var personId = this.get("author").id;
    var block = new app.models.Block();

    return block.save({block : {person_id : personId}})
             .done(function(){ app.events.trigger('person:block:'+personId); });
  },

  headline : function() {
    var headline = this.get("text").trim()
      , newlineIdx = headline.indexOf("\n");
    return (newlineIdx > 0 ) ? headline.substr(0, newlineIdx) : headline;
  },

  body : function(){
    var body = this.get("text").trim()
      , newlineIdx = body.indexOf("\n");
    return (newlineIdx > 0 ) ? body.substr(newlineIdx+1, body.length) : "";
  },

  //returns a promise
  preloadOrFetch : function(){
    var action = app.hasPreload("post") ? this.set(app.parsePreload("post")) : this.fetch();
    return $.when(action);
  }
}));
// @license-end

