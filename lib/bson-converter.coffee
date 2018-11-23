name = require('../package.json').name

module.exports = BsonConverter =
  config:
    autoSetSyntax:
      title: "Automatically Set Syntax"
      description: "Upon successful conversion, automatically set syntax scope"
      type: "boolean"
      default: true
      order: 0
    deserialization:
      title: "Deserialization"
      type: "object"
      order: 0
      properties:
        outputFormat:
          title: "Output Format"
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
        evalFunctions:
          title: "Eval Functions"
          description: "Evaluate functions in the BSON document scoped to the object deserialized"
          type: "boolean"
          default: false
          order: 2
        cacheFunctions:
          title: "Cache Functions"
          description: "Cache evaluated functions for reuse"
          type: "boolean"
          default: false
          order: 3
        cacheFunctionsCrc32:
          title: "Cache Functions CRC32"
          description: "Use a CRC32 code for caching, otherwise use the string of the function"
          type: "boolean"
          default: false
          order: 4
        promoteLongs:
          title: "Promote Longs"
          description: "When deserializing a Long will fit it into a Number if it's smaller than 53 bits"
          type: "boolean"
          default: true
          order: 5
        promoteBuffers:
          title: "Promote Buffers"
          description: "When deserializing a Binary will return it as a node.js Buffer instance"
          type: "boolean"
          default: false
          order: 7
        promoteValues:
          title: "Promote Values"
          description: "When deserializing will promote BSON values to their Node.js closest equivalent types"
          type: "boolean"
          default: false
          order: 8
        # fieldsAsRaw:
        #   title: "Fields as Raw"
        #   description: "Allow to specify if there what fields we wish to return as unserialized raw buffer."
        #   type: ""
        #   default: null
        #   order: 9
        bsonRegExp:
          title: "BSONRegExp"
          description: "Return BSON regular expressions as BSONRegExp instances"
          type: "boolean"
          default: false
          order: 9
    serialization:
      title: "Serialization"
      type: "object"
      order: 0
      properties:
        checkKeys:
          title: "Check Keys"
          description: "The serializer will check if keys are valid"
          type: "boolean"
          default: false
          order: 2
        serializeFunctions:
          title: "Serialize Functions"
          description: "Serialize the JavaScript functions"
          type: "boolean"
          default: false
          order: 3
        ignoreUndefined:
          title: "Ignore Undefined"
          description: "Ignore undefined fields"
          type: "boolean"
          default: true
          order: 4
        index:
          title: "Index"
          description: "The index in the buffer where we wish to start serializing into"
          type: "integer"
          default: 0
          minimum: 0
          order: 5
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
    editor = atom.workspace.getActiveTextEditor()
    unless editor?
      return atom.notifications.addWarning("**#{name}**: No active text editor", dismissable: false)

    BSON = require "bson"

    input = editor.getText()
    scope = editor.getGrammar().scopeName

    if scope is "source.coffee"
      Converter = require "cson"
    else
      Converter = JSON

    obj = Converter.parse input
    options = @encodingOptions

    try
      output = BSON.serialize(obj, options)
    catch e
      return atom.notifications.addError("**#{name}**", detail: e, dismissable: false)

    editor.setText(output.toString())

    if atom.config.get("#{name}.autoSetSyntax")
      editor.setGrammar(atom.grammars.grammarForScopeName('text.plain'))

  encodingOptions: ->
    options =
      checkKeys: atom.config.get "#{name}.serialization.checkKeys"
      serializeFunctions: atom.config.get "#{name}.serialization.serializeFunctions"
      ignoreUndefined: atom.config.get "#{name}.serialization.ignoreUndefined"
      index: atom.config.get "#{name}.serialization.index"

    return options

  decode: ->
    editor = atom.workspace.getActiveTextEditor()
    unless editor?
      return atom.notifications.addWarning("**#{name}**: No active text editor", dismissable: false)

    BSON = require "bson"

    input = editor.getText()
    outputFormat = atom.config.get("#{name}.deserialization.outputFormat")

    if outputFormat is "CSON"
      Converter = require "cson"
    else
      Converter = JSON

    options = @decodingOptions

    try
      buffer = Buffer.from(input, "utf8")
      output = BSON.deserialize(buffer, options)
    catch e
      return atom.notifications.addError("**#{name}**", detail: e, dismissable: false)

    editor.setText(Converter.stringify output, null, atom.config.get("#{name}.deserialization.whiteSpace"))

    if atom.config.get("#{name}.autoSetSyntax")
      if outputFormat is "CSON"
        editor.setGrammar(atom.grammars.grammarForScopeName('source.coffee'))
      else
        editor.setGrammar(atom.grammars.grammarForScopeName('source.json'))

  decodingOptions: ->
    options =
      evalFunctions: atom.config.get "#{name}.deserialization.evalFunctions"
      cacheFunctions: atom.config.get "#{name}.deserialization.cacheFunctions"
      cacheFunctionsCrc32: atom.config.get "#{name}.deserialization.cacheFunctionsCrc32"
      promoteLongs: atom.config.get "#{name}.deserialization.promoteLongs"
      promoteBuffers: atom.config.get "#{name}.deserialization.promoteBuffers"
      promoteValues: atom.config.get "#{name}.deserialization.promoteValues"
      # fieldsAsRaw: atom.config.get "#{name}.deserialization.fieldsAsRaw"
      bsonRegExp: atom.config.get "#{name}.deserialization.bsonRegExp"

    return options
