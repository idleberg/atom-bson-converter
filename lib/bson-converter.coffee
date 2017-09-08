module.exports = BsonConverter =
  config:
    decodingTarget:
      title: "Decoding Target"
      description: "Specify the default target format when decoding BSON"
      default: "JSON"
      type: "string"
      enum: [
        "CSON",
        "JSON"
      ]
      order: 0
    whiteSpace:
      title: "White Space"
      description: "A String or Number object that's used to insert white space into the output string for readability purposes"
      type: "integer"
      default: 2
      minimum: 0
      maximum: 4
      order: 1
    autoSetSyntax:
      title: "Automatically Set Syntax"
      description: "Upon successful conversion, automatically set syntax scope"
      type: "boolean"
      default: true
      order: 2
  subscriptions: null

  activate: ->
    { CompositeDisposable } = require "atom"

    # Events subscribed to in Atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add "atom-workspace", "BSON:encode": => @encode()
    @subscriptions.add atom.commands.add "atom-workspace", "BSON:decode": => @decode()

  deactivate: ->
    @subscriptions?.dispose()
    @subscriptions = null

  encode: ->
    name = require('../package.json').name

    editor = atom.workspace.getActiveTextEditor()
    unless editor?
      return atom.notifications.addWarning("**#{name}**: No active text editor", dismissable: false)

    BSON = require "bson"
    bson = new BSON()

    input = editor.getText()
    scope = editor.getGrammar().scopeName

    if scope is "source.coffee"
      Converter = require "cson"
    else
      Converter = JSON

    try
      output = bson.serialize(Converter.parse input)
    catch e
      return atom.notifications.addError("**#{name}**", detail: e, dismissable: false)

    editor.setText(output.toString())

    if atom.config.get("#{name}.autoSetSyntax")
      editor.setGrammar(atom.grammars.grammarForScopeName('text.plain'))

  decode: ->
    name = require('../package.json').name

    editor = atom.workspace.getActiveTextEditor()
    unless editor?
      return atom.notifications.addWarning("**#{name}**: No active text editor", dismissable: false)

    BSON = require "bson"
    bson = new BSON()

    input = editor.getText()
    decodingTarget = atom.config.get("#{name}.decodingTarget")

    if decodingTarget is "CSON"
      Converter = require "cson"
    else
      Converter = JSON

    try
      buffer = Buffer.from(input, "utf8")
      output = bson.deserialize(buffer)
    catch e
      return atom.notifications.addError("**#{name}**", detail: e, dismissable: false)

    editor.setText(Converter.stringify output, null, atom.config.get("#{name}.whiteSpace"))

    if atom.config.get("#{name}.autoSetSyntax")
      if decodingTarget is "CSON"
        editor.setGrammar(atom.grammars.grammarForScopeName('source.coffee'))
      else
        editor.setGrammar(atom.grammars.grammarForScopeName('source.json'))

