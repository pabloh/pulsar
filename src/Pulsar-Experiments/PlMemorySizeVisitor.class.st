Class {
	#name : 'PlMemorySizeVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'measuredSize',
		'includeWhitespace'
	],
	#category : 'Pulsar-Experiments-Visitors',
	#package : 'Pulsar-Experiments',
	#tag : 'Visitors'
}

{ #category : 'measure' }
PlMemorySizeVisitor class >> measureCode: aString [
	^ self measureNode: (RBParser parseExpression: aString)
]

{ #category : 'measure' }
PlMemorySizeVisitor class >> measureCodeInQuadWords: aString [
	^ (self measureCode: aString)/8
]

{ #category : 'measure' }
PlMemorySizeVisitor class >> measureMethod: aCompiledMethod [
	^ self measureNode: aCompiledMethod ast
]

{ #category : 'measure' }
PlMemorySizeVisitor class >> measureMethodSource: aString [
	^ self measureNode: (RBParser parseMethod: aString)
]

{ #category : 'measure' }
PlMemorySizeVisitor class >> measureNode: aNode [
	^ self new
		visitNode: aNode;
		measuredSize
]

{ #category : 'measure' }
PlMemorySizeVisitor class >> measureNodeInQuadWords: aNode [
	^ (self measureNode: aNode)/8
]

{ #category : 'accessing' }
PlMemorySizeVisitor class >> newWithWhitespace [
	^ self new
		includeWhitespace: true;
		yourself
]

{ #category : 'controlling' }
PlMemorySizeVisitor >> ifWhitespaceIncluded: aBlock [

	 includeWhitespace ifTrue: aBlock
]

{ #category : 'accessing' }
PlMemorySizeVisitor >> includeWhitespace [

	^ includeWhitespace
]

{ #category : 'accessing' }
PlMemorySizeVisitor >> includeWhitespace: anBoolean [

	includeWhitespace := anBoolean
]

{ #category : 'initialization' }
PlMemorySizeVisitor >> initialize [ 
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	

	measuredSize := 0.
	includeWhitespace := false.
]

{ #category : 'testing' }
PlMemorySizeVisitor >> isImmediateOrSingletonObject: anObject [

	^ anObject isImmediateObject or: [ 
		  anObject isSymbol or: [ 
			  (anObject isKindOf: Boolean) or: [ anObject isNil ] ] ]
]

{ #category : 'testing' }
PlMemorySizeVisitor >> isNonRecursiveObject: anObject [

	^ ((anObject isKindOf: String ) and: [ (anObject isKindOf: Symbol) not ]) 
		or: [  (anObject isKindOf: LargeInteger)
			or: [ (anObject isKindOf: Fraction)
				or: [ (anObject isKindOf: Interval) 
					or: [ (anObject isKindOf: IntegerArray ) ] ] ] ] .
]

{ #category : 'measuring' }
PlMemorySizeVisitor >> measureCollectionWithoutItsChilds: aCollectionOfNodes [
	"Measure the size of the collecion ignoring the space taken by its child objects"

	measuredSize := measuredSize
		+ aCollectionOfNodes sizeInMemory
		+ ((aCollectionOfNodes isMemberOf: OrderedCollection) 
			ifTrue: [ (aCollectionOfNodes  instVarNamed: #array) sizeInMemory ] ifFalse: 0)
		+ ((aCollectionOfNodes isMemberOf: SmallDictionary) 
			ifTrue: [ (aCollectionOfNodes  instVarNamed: #keys) sizeInMemory 
						+ (aCollectionOfNodes  instVarNamed: #values) sizeInMemory ]
			ifFalse: 0)
]

{ #category : 'measuring' }
PlMemorySizeVisitor >> measureComment: aCommentNode [

	measuredSize := measuredSize + aCommentNode sizeInMemory + aCommentNode contents sizeInMemory.
	
]

{ #category : 'measuring' }
PlMemorySizeVisitor >> measureComments: aNode [

	aNode propertyAt: #comments
		ifPresent: [ :comments | 
			self measureCollectionWithoutItsChilds: (aNode instVarNamed: #properties).
			measuredSize := measuredSize + comments sizeInMemory.
			comments do: [ :each | self measureComment: each ] ]
		ifAbsent: [ ].
]

{ #category : 'measuring' }
PlMemorySizeVisitor >> measureMemoryLayout:  aNode [

	measuredSize := measuredSize + aNode sizeInMemory
]

{ #category : 'measuring' }
PlMemorySizeVisitor >> measureMethod: aCompiledMethod [

	self visitNode: aCompiledMethod ast
]

{ #category : 'measuring' }
PlMemorySizeVisitor >> measureParentheses: aNode [

	"'aNode parentheses' returns a structure even when the instance variable in the object is actually 'nil'"
	aNode hasParentheses ifTrue: [ self measureRecursiveStructure: aNode parentheses ]

]

{ #category : 'measuring' }
PlMemorySizeVisitor >> measureRecursiveStructure: anObject [

	measuredSize := measuredSize + (self sizeForRecursiveStructure: anObject)

]

{ #category : 'measuring' }
PlMemorySizeVisitor >> measuredAttachedWhitespaceElements: aNode [

	aNode isValue ifTrue: [ self measureParentheses: aNode ].
	self measureComments: aNode.

]

{ #category : 'accessing' }
PlMemorySizeVisitor >> measuredSize [

	^ measuredSize
]

{ #category : 'size-calculation' }
PlMemorySizeVisitor >> sizeForRecursiveStructure: anObject [

	(self isImmediateOrSingletonObject: anObject)
		ifTrue: [ ^ 0 ].
	(self isNonRecursiveObject: anObject)
		ifTrue: [ ^ anObject sizeInMemory ].
	(anObject isArray)
		ifTrue: [ ^ anObject sizeInMemory + (anObject sumNumbers: [ :each |  self sizeForRecursiveStructure: each ]) ].
	(anObject isMemberOf: OrderedCollection)
		ifTrue: [ ^ anObject sizeInMemory + (self sizeForRecursiveStructure: (anObject instVarNamed: #array)) ].

	self error: 'Unexpected Type: ', anObject className
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitArrayNode: anArrayNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: anArrayNode periods ].

	self measureMemoryLayout: anArrayNode.		
	self measureCollectionWithoutItsChilds: anArrayNode statements.
	
	super visitArrayNode: anArrayNode

]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitAssignmentNode:  anAssignmentNode [

	self measureMemoryLayout: anAssignmentNode.	
	
	super visitAssignmentNode: anAssignmentNode
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitBlockNode:  aBlockNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aBlockNode colons ].

	self measureMemoryLayout: aBlockNode.	
	self measureCollectionWithoutItsChilds: aBlockNode arguments.
	
	super visitBlockNode:  aBlockNode
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitCascadeNode: aCascadeNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aCascadeNode semicolons ].

	self measureMemoryLayout: aCascadeNode.
	self measureCollectionWithoutItsChilds: aCascadeNode messages.	

	super visitCascadeNode: aCascadeNode 
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitLiteralArrayNode:  aLiteralArrayNode [
	
	measuredSize := measuredSize 
		+ aLiteralArrayNode sizeInMemory + aLiteralArrayNode contents sizeInMemory
		+ (aLiteralArrayNode isForByteArray
			ifTrue: 0
			ifFalse: [ (aLiteralArrayNode contents instVarNamed: #array) sizeInMemory ]).
	
	super visitLiteralArrayNode: aLiteralArrayNode 
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitLiteralValueNode: aLiteralNode [
	| value |
	value := aLiteralNode value.
	
	self ifWhitespaceIncluded: [ aLiteralNode sourceText ifNotNil: [ self measureRecursiveStructure: aLiteralNode sourceText ] ].
	
	measuredSize := measuredSize
		+ aLiteralNode sizeInMemory
	        + ((value isSymbol or: [ (value isKindOf: Boolean) or: [ value isNil ]]) "Symbols boolean and undefined are a special case" 
		       ifTrue: 0  ifFalse: [ value sizeInMemory ])
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitMessageNode: aMessageNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aMessageNode keywordsPositions  ].

	self measureMemoryLayout: aMessageNode.
	self measureCollectionWithoutItsChilds: aMessageNode arguments.
			
	super visitMessageNode: aMessageNode

]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitMethodNode: aMethodNode [
	"Ignore measuring: 
		- scope: specific for semantic analisys	
		- selector: is a Symbol
		- source: because we want to reproduce it
		- replacements and nodeReplacements: specific for refactoring
		- compilationToContext: specific for compiler
		- bcToASTCache: specific for debugger"
		
	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aMethodNode keywordsPositions  ].

	self measureMemoryLayout: aMethodNode.
	self measureCollectionWithoutItsChilds: aMethodNode arguments.
	self measureCollectionWithoutItsChilds: aMethodNode pragmas.
	
	super visitMethodNode:  aMethodNode
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitNode:  aNode [

	self ifWhitespaceIncluded: [ self measuredAttachedWhitespaceElements: aNode ].
	
	super visitNode: aNode
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitPragmaNode:  aPragmaNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aPragmaNode keywordsPositions  ].

	self measureMemoryLayout: aPragmaNode.
	self measureCollectionWithoutItsChilds: aPragmaNode  arguments .
	
	super visitPragmaNode: aPragmaNode


]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitReturnNode:  aReturnNode [

	self measureMemoryLayout: aReturnNode.
						
	super visitReturnNode: aReturnNode
]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitSelectorNode: aSelectorNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aSelectorNode keywordPositions  ].

	"Ignore 'measuredSize value' since is a Symbol"
	self measureMemoryLayout: aSelectorNode.

]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitSequenceNode: aSequenceNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aSequenceNode periods   ].

	self measureMemoryLayout: aSequenceNode.
	self measureCollectionWithoutItsChilds: aSequenceNode  statements.	
	self measureCollectionWithoutItsChilds: aSequenceNode  temporaries.	

	super visitSequenceNode: aSequenceNode.

]

{ #category : 'visiting' }
PlMemorySizeVisitor >> visitVariableNode:  aVariableNode [

	"Ignore Symbol at 'aVariableNode name' because it should be already at 'Symbol>>SymbolTable'"
	"Ignore variable at 'aVariableNode variable' since is only relevant for Semantic Analisys"
	self measureMemoryLayout: aVariableNode 
]
