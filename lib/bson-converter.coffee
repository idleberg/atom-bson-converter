module.exports = BsonConverter =
  config:
    whiteSpace:
      title: "White Space"
      description: "A String or Number object that's used to insert white space into the output JSON string for readability purposes"
      type: "integer"
      default: 2
      minimum: 0
      maximum: 4
    autoSetSyntax:
      title: "Automatically Set Syntax"
      description: "A String or Number object that's used to insert white space into the output JSON string for readability purposes"
      type: "boolean"
      default: true
  subscriptions: null

  activate: ->
    { CompositeDisposable } = require "atom"

    # Events subscribed to in Atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add "atom-workspace", "bson:encode": => @encode()
    @subscriptions.add atom.commands.add "atom-workspace", "bson:decode": => @decode()

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

    try
      output = bson.serialize(JSON.parse input)
    catch e
      atom.notifications.addError("**#{name}**", detail: e, dismissable: false)

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

    try
      buffer = Buffer.from(input, "utf8")
      output = bson.deserialize(buffer)
    catch e
      atom.notifications.addError("**#{name}**", detail: e, dismissable: false)

    editor.setText(JSON.stringify output, null, atom.config.get("#{name}.whiteSpace"))

    if atom.config.get("#{name}.autoSetSyntax")
      editor.setGrammar(atom.grammars.grammarForScopeName('source.json'))
