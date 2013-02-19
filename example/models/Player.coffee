mongoose = require 'mongoose'

namespace models:

  class Player

    @schema =
      pseudo: String
      x:
        type: Number
        default: 0
      y:
        type: Number
        default: 0

    @model = mongoose.model 'Player', new mongoose.Schema @schema

    @all: (cb) ->
      @model.find null, (err, docs) ->
        if err then throw err
        cb docs

    @create: (doc, cb) ->
      new @model(doc).save (err) ->
        if err then throw err
        do cb

    @read: (_id, cb) ->
      @model.findById _id, (err, doc) ->
        if err then throw err
        cb doc

    @update: (_id, doc, cb) ->
      @model.findByIdAndUpdate _id, doc, (err) ->
        if err then throw err
        do cb

    @delete: (_id, cb) ->
      @model.findByIdAndRemove _id, (err) ->
        if err then throw err
        do cb