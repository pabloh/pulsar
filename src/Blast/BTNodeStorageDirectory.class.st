"
A BTNodeStorageDirectory is a directory which holds a reference to every node storage been used to store a set of methods
"
Class {
	#name : #BTNodeStorageDirectory,
	#superclass : #BTStorageDirectory,
	#instVars : [
		'arrayNodeStorage',
		'assignmentNodeStorage',
		'variableNodeStorage',
		'literalNodeStorage',
		'cascadePartNodeStorage',
		'blockNodeStorage',
		'messageNodeStorage',
		'tempVariableNodeStorage',
		'cascadeMessageNodeStorage',
		'pragmaNodeStorage',
		'selectorStorage',
		'unaryPragmaNodeStorage',
		'keywordPragmaNodeStorage',
		'pragmaSelectorStorage'
	],
	#classInstVars : [
		'default'
	],
	#category : #'Blast-Storage'
}

{ #category : #'default instance' }
BTNodeStorageDirectory class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : #'class initialization' }
BTNodeStorageDirectory class >> initialize [

	Smalltalk
		addToShutDownList: self
]

{ #category : #'default instance' }
BTNodeStorageDirectory class >> shutDown: quitting [

	quitting ifTrue: [ self default pruneDeletedEntries ]
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> arrayEncodingFormat [
	^ BTNodeTranslator
		encoderClass: BTArrayEncoder 
		decoderClass: BTArrayDecoder 
		directory: self
]

{ #category : #accessing }
BTNodeStorageDirectory >> arrayNodeStorage [
	^ arrayNodeStorage
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> assignmentEncodingFormat [
	^ BTNodeTranslator
		encoderClass: BTAssignmentEncoder 
		decoderClass: BTAssignmentDecoder 
		directory: self
]

{ #category : #accessing }
BTNodeStorageDirectory >> assignmentNodeStorage [
	^ assignmentNodeStorage
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> blockEncodingFormat [
	^ BTNodeTranslator
		encoderClass: BTBlockEncoder 
		decoderClass: BTBlockDecoder 
		directory: self
]

{ #category : #accessing }
BTNodeStorageDirectory >> blockNodeStorage [
	^ blockNodeStorage 
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> cascadeMessageEncodingFormat [
	^ BTNodeTranslator
		encoderClass: BTCascadeMessageEncoder 
		decoderClass: BTCascadeMessageDecoder 
		directory: self
]

{ #category : #accessing }
BTNodeStorageDirectory >> cascadeMessageNodeStorage [
	^ cascadeMessageNodeStorage
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> cascadePartEncodingFormat [
	^ BTNodeTranslator
		encoderClass: BTCascadePartEncoder 
		decoderClass: BTCascadePartDecoder 
		directory: self
]

{ #category : #accessing }
BTNodeStorageDirectory >> cascadePartNodeStorage [
	^ cascadePartNodeStorage
]

{ #category : #clearing }
BTNodeStorageDirectory >> clearStorages [
	self createStorages
]

{ #category : #'storage creation' }
BTNodeStorageDirectory >> createKeywordPragaNodeStorage [
	^ self createBinaryStorageUsing: self pragmaEncodingFormat
]

{ #category : #'storage creation' }
BTNodeStorageDirectory >> createPragmaSelectorStorage [

	^ BTIndexedStorage indexed:
		(BTObjectStorage preloadedWith: self preloadedPragmaKeywordSelectors)
]

{ #category : #'storage creation' }
BTNodeStorageDirectory >> createSelectorStorage [

	^ BTSetIndexedStorage for: BTObjectStorage new
]

{ #category : #'storage creation' }
BTNodeStorageDirectory >> createUnaryPragaNodeStorage [
	
	^ self createEncodedStorageUsing: self unaryPragmaEncodingFormat 
		wrapping: (BTObjectStorage preloadedWith: self preloadedPragmaUnarySelectors)
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> identifierEncodingFormat [
	^ BTNodeTranslator
		encoderBlock: [ :node | node name ]
		decoderBlock: [ :value | BTVariableNode name: value ]
]

{ #category : #initialization }
BTNodeStorageDirectory >> initialize [
	variableNodeStorage := self createObjectStorageUsing: self identifierEncodingFormat.
	literalNodeStorage := self createObjectStorageUsing: self literalEncodingFormat.
	tempVariableNodeStorage := self createObjectStorageUsing: self identifierEncodingFormat.
	selectorStorage := self createSelectorStorage.
	pragmaSelectorStorage := self createPragmaSelectorStorage.
	
	assignmentNodeStorage := self createBinaryStorageUsing: self assignmentEncodingFormat.
	arrayNodeStorage := self createBinaryStorageUsing: self arrayEncodingFormat.
	cascadePartNodeStorage := self createBinaryStorageUsing: self cascadePartEncodingFormat.
	cascadeMessageNodeStorage := self createBinaryStorageUsing: self cascadeMessageEncodingFormat.
	blockNodeStorage := self createBinaryStorageUsing: self blockEncodingFormat.
	messageNodeStorage := self createBinaryStorageUsing: self messageEncodingFormat.
	
	unaryPragmaNodeStorage := self createUnaryPragaNodeStorage.
	keywordPragmaNodeStorage := self createKeywordPragaNodeStorage.
]

{ #category : #accessing }
BTNodeStorageDirectory >> keywordPragmaNodeStorage [
	^ keywordPragmaNodeStorage
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> literalEncodingFormat [
	^ BTNodeTranslator
		encoderBlock: [ :node | node value ]
		decoderBlock: [ :value | BTLiteralNode value: value ]
]

{ #category : #accessing }
BTNodeStorageDirectory >> literalNodeStorage [
	^ literalNodeStorage
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> messageEncodingFormat [
	^ BTNodeTranslator
		encoderClass: BTMessageEncoder 
		decoderClass: BTMessageDecoder 
		directory: self
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> pragmaEncodingFormat [
	^ BTNodeTranslator
		encoderClass: BTPragmaEncoder 
		decoderClass: BTPragmaDecoder 
		directory: self
]

{ #category : #accessing }
BTNodeStorageDirectory >> pragmaSelectorStorage [
	^ pragmaSelectorStorage
]

{ #category : #'preloaded data' }
BTNodeStorageDirectory >> preloadedPragmaKeywordSelectors [

	^ #(wikiStyleHelp:
		primitive: timeout: version: api: pragma: defaultSymbolicVersion:
		reflective: spec: styleTable: symbolicVersion: inline: sepc:
		version:imports: primitive:module: var:declareC:
		api:getter: primitive:error: primitive:module:error:
		api:getter:registration: api:min:max:getter: api:min:max:getter:registration:)
]

{ #category : #'preloaded data' }
BTNodeStorageDirectory >> preloadedPragmaUnarySelectors [

	^ #(processBrowserStackListMenu
		textEditorShiftedMenu nautilusGlobalProtocolMenu
		contextMenuDebuggingAction systemHelp versionsBrowserListMenu
		nautilusGlobalSourceCodeMenu instVarCommand nautilusGlobalMethodMenu
		nautilusGlobalPackageFixMenu fileService dualChangeSorterClassListMenu
		primitive nautilusGlobalGroupMenu dualChangeSorteChangesListMenu
		spec systemEventRegistration classVarCommand
		nautilusGlobalPackageTreeFixMenu newVersionBrowserListMenu nautilusGlobalGroupFixMenu
		dualChangeSorterMessageListMenu contextMenu sourceCodeCommand
		smalltalkEditorMenu settingPragmaProcessor classCommand
		specDebuggerStackMenuNew systemsettings processBrowserProcessListMenu
		assignmentCommand changeSorterMessageListMenu nautilusGlobalPackageMenu
		TimeProfilerFullReportMenu changeSorterClassListMenu expectedFailure
		worldMenu fileListContentMenu baseline
		publicTest RubSmalltalkEditorMenu keymap
		smalltalkEditorShiftedMenu directoryService apiDocumentation
		ignoreForCoverage contextMenuCodeDebuggingAction nautilusGlobalClassFixMenu
		windowMenu changeSorterChangeSetList1Menu methodCommand
		tempVarCommand messageBrowserListMenu changeSorterChangeSetList2Menu
		shortcut command literalCommand
		debuggingAction changeListMenu nautilusGlobalClassMenu
		worldMenuExample messageCommand specDebuggerCodeContextMenu
		textEditorMenu preDebuggingAction)
]

{ #category : #'preloaded data' }
BTNodeStorageDirectory >> preloadedSelectors [
	self flag: #TODO
]

{ #category : #'preloaded data' }
BTNodeStorageDirectory >> preloadedVariableNames [
	self flag: #TODO
]

{ #category : #maintenance }
BTNodeStorageDirectory >> pruneDeletedEntries [
	"TODO: prune deleted entries on every storage and compact them"
	self flag: #TODO
]

{ #category : #accessing }
BTNodeStorageDirectory >> selectorStorage [
	^ selectorStorage
]

{ #category : #accessing }
BTNodeStorageDirectory >> tempVariableNodeStorage [
	^ tempVariableNodeStorage
]

{ #category : #'encoding formats' }
BTNodeStorageDirectory >> unaryPragmaEncodingFormat [
	^ BTNodeTranslator
		encoderBlock: [ :node | node selector ]
		decoderBlock: [ :value | BTPragmaNode selector: value ]
]

{ #category : #accessing }
BTNodeStorageDirectory >> unaryPragmaNodeStorage [
	^ unaryPragmaNodeStorage
]

{ #category : #accessing }
BTNodeStorageDirectory >> variableNodeStorage [
	^ variableNodeStorage
]
