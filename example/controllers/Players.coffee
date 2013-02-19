namespace controllers:

  class Players

    # Import Player model from models namespace
    {Player} = models

    # GET /players
    @index: =>
      Player.all (players) =>
        @res.send players

    # GET /players/:id
    @show: =>
      Player.read @req.params.id, (player) =>
        @res.send player

    # GET /players/new
    @new: =>
      @res.render 'newForm'

    # GET /players/:id/edit
    @edit: =>
      Player.read @req.params.id, (player) =>
        @res.render 'editForm'
          player: player

    # POST /players
    @create: =>
      Player.create @req.param('player'), =>
        @res.send 'New player successfully created !'

    # PUT /players/:id
    @update: =>
      Player.update @req.params.id, @req.param('player'), =>
        @res.send "Player #{@req.param('id')} successfully updated !"

    # DELETE /players/:id
    @delete: =>
      Player.delete @req.params.id, ->
        @res.send "Player #{@req.param('id')} successfully deleted !"