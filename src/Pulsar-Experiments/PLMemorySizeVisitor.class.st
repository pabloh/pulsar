Class {
	#name : #PLMemorySizeVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'measuredSize',
		'includeWhitespace'
	],
	#category : #'Pulsar-Experiments-Visitors'
}

{ #category : #measure }
PLMemorySizeVisitor class >> measureCode: aString [
	^ self measureNode: (RBParser parseExpression: aString)
]

{ #category : #measure }
PLMemorySizeVisitor class >> measureCodeInQuadWords: aString [
	^ (self measureCode: aString)/8
]

{ #category : #measure }
PLMemorySizeVisitor class >> measureMethod: aCompiledMethod [
	^ self measureNode: aCompiledMethod ast
]

{ #category : #measure }
PLMemorySizeVisitor class >> measureMethodSource: aString [
	^ self measureNode: (RBParser parseMethod: aString)
]

{ #category : #measure }
PLMemorySizeVisitor class >> measureNode: aNode [
	^ self new
		visitNode: aNode;
		measuredSize
]

{ #category : #measure }
PLMemorySizeVisitor class >> measureNodeInQuadWords: aNode [
	^ (self measureNode: aNode)/8
]

{ #category : #accessing }
PLMemorySizeVisitor class >> newWithWhitespace [
	^ self new
		includeWhitespace: true;
		yourself
]

{ #category : #controlling }
PLMemorySizeVisitor >> ifWhitespaceIncluded: aBlock [

	 includeWhitespace ifTrue: aBlock
]

{ #category : #accessing }
PLMemorySizeVisitor >> includeWhitespace [

	^ includeWhitespace
]

{ #category : #accessing }
PLMemorySizeVisitor >> includeWhitespace: anBoolean [

	includeWhitespace := anBoolean
]

{ #category : #initialization }
PLMemorySizeVisitor >> initialize [ 
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	

	measuredSize := 0.
	includeWhitespace := false.
]

{ #category : #testing }
PLMemorySizeVisitor >> isImmediateOrSingletonObject: anObject [

	^ anObject isImmediateObject or: [ 
		  anObject isSymbol or: [ 
			  (anObject isKindOf: Boolean) or: [ anObject isNil ] ] ]
]

{ #category : #testing }
PLMemorySizeVisitor >> isNonRecursiveObject: anObject [

	^ ((anObject isKindOf: String ) and: [ (anObject isKindOf: Symbol) not ]) 
		or: [  (anObject isKindOf: LargeInteger)
			or: [ (anObject isKindOf: Fraction)
				or: [ (anObject isKindOf: Interval) 
					or: [ (anObject isKindOf: IntegerArray ) ] ] ] ] .
]

{ #category : #measuring }
PLMemorySizeVisitor >> measureCollectionWithoutItsChilds: aCollectionOfNodes [
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

{ #category : #measuring }
PLMemorySizeVisitor >> measureComment: aCommentNode [

	measuredSize := measuredSize + aCommentNode sizeInMemory + aCommentNode contents sizeInMemory.
	
]

{ #category : #measuring }
PLMemorySizeVisitor >> measureComments: aNode [

	aNode propertyAt: #comments
		ifPresent: [ :comments | 
			self measureCollectionWithoutItsChilds: (aNode instVarNamed: #properties).
			measuredSize := measuredSize + comments sizeInMemory.
			comments do: [ :each | self measureComment: each ] ]
		ifAbsent: [ ].
]

{ #category : #measuring }
PLMemorySizeVisitor >> measureMemoryLayout:  aNode [

	measuredSize := measuredSize + aNode sizeInMemory
]

{ #category : #measuring }
PLMemorySizeVisitor >> measureMethod: aCompiledMethod [

	self visitNode: aCompiledMethod ast
]

{ #category : #measuring }
PLMemorySizeVisitor >> measureParentheses: aNode [

	aNode hasParentheses ifTrue: [ self measureRecursiveStructure: aNode parentheses ]

]

{ #category : #measuring }
PLMemorySizeVisitor >> measureRecursiveStructure: anObject [

	measuredSize := measuredSize + (self sizeForRecursiveStructure: anObject)

]

{ #category : #measuring }
PLMemorySizeVisitor >> measuredAttachedWhitespaceElements: aNode [

	aNode isValue ifTrue: [ self measureParentheses: aNode ].
	self measureComments: aNode.

]

{ #category : #accessing }
PLMemorySizeVisitor >> measuredSize [

	^ measuredSize
]

{ #category : #'size-calculation' }
PLMemorySizeVisitor >> sizeForRecursiveStructure: anObject [

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

{ #category : #visiting }
PLMemorySizeVisitor >> visitArrayNode: anArrayNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: anArrayNode periods ].

	self measureMemoryLayout: anArrayNode.		
	self measureCollectionWithoutItsChilds: anArrayNode statements.
	
	super visitArrayNode: anArrayNode

]

{ #category : #visiting }
PLMemorySizeVisitor >> visitAssignmentNode:  anAssignmentNode [

	self measureMemoryLayout: anAssignmentNode.	
	
	super visitAssignmentNode: anAssignmentNode
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitBlockNode:  aBlockNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aBlockNode colons ].

	self measureMemoryLayout: aBlockNode.	
	self measureCollectionWithoutItsChilds: aBlockNode arguments.
	
	super visitBlockNode:  aBlockNode
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitCascadeNode: aCascadeNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aCascadeNode semicolons ].

	self measureMemoryLayout: aCascadeNode.
	self measureCollectionWithoutItsChilds: aCascadeNode messages.	

	super visitCascadeNode: aCascadeNode 
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitLiteralArrayNode:  aLiteralArrayNode [
	
	measuredSize := measuredSize 
		+ aLiteralArrayNode sizeInMemory + aLiteralArrayNode contents sizeInMemory
		+ (aLiteralArrayNode isForByteArray
			ifTrue: 0
			ifFalse: [ (aLiteralArrayNode contents instVarNamed: #array) sizeInMemory ]).
	
	super visitLiteralArrayNode: aLiteralArrayNode 
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitLiteralValueNode: aLiteralNode [
	| value |
	value := aLiteralNode value.
	
	self ifWhitespaceIncluded: [ aLiteralNode sourceText ifNotNil: [ self measureRecursiveStructure: aLiteralNode sourceText ] ].
	
	measuredSize := measuredSize
		+ aLiteralNode sizeInMemory
	        + ((value isSymbol or: [ (value isKindOf: Boolean) or: [ value isNil ]]) "Symbols boolean and undefined are a special case" 
		       ifTrue: 0  ifFalse: [ value sizeInMemory ])
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitMessageNode: aMessageNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aMessageNode keywordsPositions  ].

	self measureMemoryLayout: aMessageNode.
	self measureCollectionWithoutItsChilds: aMessageNode arguments.
			
	super visitMessageNode: aMessageNode

]

{ #category : #visiting }
PLMemorySizeVisitor >> visitMethodNode: aMethodNode [
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

{ #category : #visiting }
PLMemorySizeVisitor >> visitNode:  aNode [

	self ifWhitespaceIncluded: [ self measuredAttachedWhitespaceElements: aNode ].
	
	super visitNode: aNode
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitPragmaNode:  aPragmaNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aPragmaNode keywordsPositions  ].

	self measureMemoryLayout: aPragmaNode.
	self measureCollectionWithoutItsChilds: aPragmaNode  arguments .
	
	super visitPragmaNode: aPragmaNode


]

{ #category : #visiting }
PLMemorySizeVisitor >> visitReturnNode:  aReturnNode [

	self measureMemoryLayout: aReturnNode.
						
	super visitReturnNode: aReturnNode
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitSelectorNode: aSelectorNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aSelectorNode keywordPositions  ].

	"Ignore 'measuredSize value' since is a Symbol"
	self measureMemoryLayout: aSelectorNode.

]

{ #category : #visiting }
PLMemorySizeVisitor >> visitSequenceNode: aSequenceNode [

	self ifWhitespaceIncluded: [ self measureRecursiveStructure: aSequenceNode periods   ].

	self measureMemoryLayout: aSequenceNode.
	self measureCollectionWithoutItsChilds: aSequenceNode  statements.	
	self measureCollectionWithoutItsChilds: aSequenceNode  temporaries.	

	super visitSequenceNode: aSequenceNode.

]

{ #category : #visiting }
PLMemorySizeVisitor >> visitVariableNode:  aVariableNode [

	"Ignore Symbol at 'aVariableNode name' "
	measuredSize := measuredSize + aVariableNode sizeInMemory + aVariableNode variable sizeInMemory
]
