chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'Poco:', ->
  poco_module = require('../src/poco')

  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()
    @msg =
      send: sinon.spy()
      random: sinon.spy()
    @poco_module = poco_module(@robot)

  describe 'display correct response', ->

    it 'should register a hear listener', ->
      expect(@robot.respond).to.have.been.calledWith(/poco/)
