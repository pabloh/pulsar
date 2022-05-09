Class {
	#name : #MemorySizeVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'measuredSize',
		'includeFormatingValues'
	],
	#category : #'Pulsar-Experiments-Visitors'
}

{ #category : #measure }
MemorySizeVisitor class >> measureCode: aString [
	^ self measureNode: (RBParser parseExpression: aString)
]

{ #category : #measure }
MemorySizeVisitor class >> measureCodeInQuadWords: aString [
	^ (self measureCode: aString)/8
]

{ #category : #measure }
MemorySizeVisitor class >> measureNode: aNode [
	^ self new
		visit: aNode;
		measuredSize 
]

{ #category : #measure }
MemorySizeVisitor class >> measureNodeInQuadWords: aNode [
	^ (self measureNode: aNode)/8
]

{ #category : #accessing }
MemorySizeVisitor class >> newIncludingFormatValues [
	self new
		includeFormatingValues: true
]

{ #category : #'memory measuring' }
MemorySizeVisitor >> calculateParenthesesSizeInMemory: aNode [

	^ aNode ifNil: [ 0 ]
		ifNotNil: [ 
			aNode ifEmpty: [ 0 ]
			 ifNotEmpty: [ self notYetImplemented ]
	 	] 
]

{ #category : #accessing }
MemorySizeVisitor >> includeFormatingValues [

	^ includeFormatingValues
]

{ #category : #accessing }
MemorySizeVisitor >> includeFormatingValues: anBoolean [

	includeFormatingValues := anBoolean
]

{ #category : #initialization }
MemorySizeVisitor >> initialize [ 
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	

	measuredSize := 0.
	includeFormatingValues := false.
]

{ #category : #'memory measuring' }
MemorySizeVisitor >> measureCollection: aCollectionOfNodes [

	measuredSize := measuredSize
		+ aCollectionOfNodes sizeInMemory
		+ (aCollectionOfNodes isArray ifTrue: [ 0 ] ifFalse: [ (aCollectionOfNodes  instVarNamed: #array) sizeInMemory ])
		 
	
]

{ #category : #accessing }
MemorySizeVisitor >> measuredSize [

	^ measuredSize
]

{ #category : #'memory measuring' }
MemorySizeVisitor >> shallowMeasureNode: aNode [

	measuredSize := measuredSize + aNode sizeInMemory
]

{ #category : #visiting }
MemorySizeVisitor >> visitArrayNode:   anArrayNode [

	measuredSize := measuredSize + anArrayNode sizeInMemory.
	
	self measureCollection: anArrayNode statements.
	super visitArrayNode: anArrayNode

]

{ #category : #visiting }
MemorySizeVisitor >> visitAssignmentNode:  anAssignmentNode [

	measuredSize := measuredSize + anAssignmentNode sizeInMemory.
	
	super visitAssignmentNode:  anAssignmentNode
]

{ #category : #visiting }
MemorySizeVisitor >> visitBlockNode:  aBlockNode [

	measuredSize := measuredSize + aBlockNode sizeInMemory.	
	self measureCollection: aBlockNode arguments.
	
	super visitBlockNode:  aBlockNode
]

{ #category : #visiting }
MemorySizeVisitor >> visitCascadeNode: aCascadeNode [

	measuredSize := measuredSize + aCascadeNode sizeInMemory.
	self measureCollection: aCascadeNode messages.	

	super visitCascadeNode: aCascadeNode 
]

{ #category : #visiting }
MemorySizeVisitor >> visitLiteralArrayNode:  aLiteralArrayNode [
	
	measuredSize := measuredSize 
		+ aLiteralArrayNode sizeInMemory + aLiteralArrayNode contents sizeInMemory
		+ (aLiteralArrayNode isForByteArray
			ifTrue: [ 0 ]
			 ifFalse: [ (aLiteralArrayNode contents instVarNamed: #array) sizeInMemory  "Breaks encapsulation"  ])
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  aLiteralArrayNode start sizeInMemory + aLiteralArrayNode stop sizeInMemory ] 
			ifFalse: [ 0 ]).
	
	"Call recursively on child nodes"
	aLiteralArrayNode contents do: [  :each |  self visit: each ]
]

{ #category : #visiting }
MemorySizeVisitor >> visitLiteralValueNode: aLiteralNode [
	| value |
	value := aLiteralNode value.
	
	measuredSize := measuredSize
		+ aLiteralNode sizeInMemory
	        + ((value isSymbol or: [ (value isKindOf: Boolean) or: [ value isNil ]]) 	"Symbols boolean and undefiened are a special case" 
		       ifTrue: [ 0 ]  ifFalse: [ value sizeInMemory ])
	        + (includeFormatingValues "This is formating information"
	              "TODO: add sourceText"
		       ifTrue: [ aLiteralNode start sizeInMemory + aLiteralNode stop sizeInMemory ]  ifFalse: [ 0 ])
]

{ #category : #visiting }
MemorySizeVisitor >> visitMessageNode:   aMessageNode [

	measuredSize := measuredSize + aMessageNode sizeInMemory.	
	self measureCollection: aMessageNode arguments.
			
	super visitMessageNode: aMessageNode

]

{ #category : #visiting }
MemorySizeVisitor >> visitMethodNode:   aMethodNode [

	measuredSize := measuredSize + aMethodNode sizeInMemory.
	self measureCollection: aMethodNode arguments.
	self measureCollection: aMethodNode pragmas.
	
	super visitMethodNode:  aMethodNode
]

{ #category : #visiting }
MemorySizeVisitor >> visitPragmaNode:  aPragmaNode [

	measuredSize := measuredSize + aPragmaNode sizeInMemory.
	self measureCollection: aPragmaNode  arguments .
	
	super visitPragmaNode: aPragmaNode


]

{ #category : #visiting }
MemorySizeVisitor >> visitReturnNode:  aReturnNode [

	measuredSize := measuredSize + aReturnNode sizeInMemory
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  (self calculateParenthesesSizeInMemory: aReturnNode ) +  aReturnNode return sizeInMemory ] ifFalse: [ 0 ]).
						
	self visit: aReturnNode value
]

{ #category : #visiting }
MemorySizeVisitor >> visitSelectorNode:   aSelectorNode [

	measuredSize := measuredSize + aSelectorNode sizeInMemory.	
	"Ignore 'measuredSize value' since is a Symbol"

]

{ #category : #visiting }
MemorySizeVisitor >> visitSequenceNode:   aSequenceNode [

	measuredSize := measuredSize + aSequenceNode sizeInMemory.
	self measureCollection: aSequenceNode  statements.	
	self measureCollection: aSequenceNode  temporaries.	

	aSequenceNode  statements do: [ :each | self visitNode: each ].
	aSequenceNode  temporaries do: [ :each | self visitNode: each ].

]

{ #category : #visiting }
MemorySizeVisitor >> visitVariableNode:  aVariableNode [

	measuredSize := measuredSize 
		+ aVariableNode sizeInMemory + aVariableNode name sizeInMemory + aVariableNode variable sizeInMemory
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  aVariableNode start sizeInMemory ] ifFalse: [ 0 ])
]
