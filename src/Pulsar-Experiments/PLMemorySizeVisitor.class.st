Class {
	#name : #PLMemorySizeVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'measuredSize',
		'includeFormatingValues'
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
		visit: aNode;
		measuredSize 
]

{ #category : #measure }
PLMemorySizeVisitor class >> measureNodeInQuadWords: aNode [
	^ (self measureNode: aNode)/8
]

{ #category : #accessing }
PLMemorySizeVisitor class >> newIncludingFormatValues [
	self new
		includeFormatingValues: true
]

{ #category : #accessing }
PLMemorySizeVisitor >> includeFormatingValues [

	^ includeFormatingValues
]

{ #category : #accessing }
PLMemorySizeVisitor >> includeFormatingValues: anBoolean [

	includeFormatingValues := anBoolean
]

{ #category : #initialization }
PLMemorySizeVisitor >> initialize [ 
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	

	measuredSize := 0.
	includeFormatingValues := false.
]

{ #category : #measuring }
PLMemorySizeVisitor >> measureCollection: aCollectionOfNodes [

	measuredSize := measuredSize
		+ aCollectionOfNodes sizeInMemory
		+ (aCollectionOfNodes isArray ifTrue: [ 0 ] ifFalse: [ (aCollectionOfNodes  instVarNamed: #array) sizeInMemory ])
		 
	
]

{ #category : #measuring }
PLMemorySizeVisitor >> measureMethod: aCompiledMethod [

	self visit: aCompiledMethod ast
]

{ #category : #measuring }
PLMemorySizeVisitor >> measureNodeParentheses: aNode [

	measuredSize := measuredSize + 
		aNode ifNil: [ 0 ]
				ifNotNil: [ 
					aNode ifEmpty: [ 0 ]
					 ifNotEmpty: [ self notYetImplemented ]	 ] 
]

{ #category : #accessing }
PLMemorySizeVisitor >> measuredSize [

	^ measuredSize
]

{ #category : #measuring }
PLMemorySizeVisitor >> shallowMeasure: anObject [

	measuredSize := measuredSize + anObject sizeInMemory
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitArrayNode: anArrayNode [

	measuredSize := measuredSize + anArrayNode sizeInMemory.	
	self measureCollection: anArrayNode statements.
	
	super visitArrayNode: anArrayNode

]

{ #category : #visiting }
PLMemorySizeVisitor >> visitAssignmentNode:  anAssignmentNode [

	measuredSize := measuredSize + anAssignmentNode sizeInMemory.
	
	super visitAssignmentNode:  anAssignmentNode
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitBlockNode:  aBlockNode [

	measuredSize := measuredSize + aBlockNode sizeInMemory.	
	self measureCollection: aBlockNode arguments.
	
	super visitBlockNode:  aBlockNode
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitCascadeNode: aCascadeNode [

	measuredSize := measuredSize + aCascadeNode sizeInMemory.
	self measureCollection: aCascadeNode messages.	

	super visitCascadeNode: aCascadeNode 
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitLiteralArrayNode:  aLiteralArrayNode [
	
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
PLMemorySizeVisitor >> visitLiteralValueNode: aLiteralNode [
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
PLMemorySizeVisitor >> visitMessageNode:   aMessageNode [

	measuredSize := measuredSize + aMessageNode sizeInMemory.	
	self measureCollection: aMessageNode arguments.
			
	super visitMessageNode: aMessageNode

]

{ #category : #visiting }
PLMemorySizeVisitor >> visitMethodNode: aMethodNode [

	measuredSize := measuredSize + aMethodNode sizeInMemory.
	self measureCollection: aMethodNode arguments.
	self measureCollection: aMethodNode pragmas.
	
	super visitMethodNode:  aMethodNode
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitPragmaNode:  aPragmaNode [

	measuredSize := measuredSize + aPragmaNode sizeInMemory.
	self measureCollection: aPragmaNode  arguments .
	
	super visitPragmaNode: aPragmaNode


]

{ #category : #visiting }
PLMemorySizeVisitor >> visitReturnNode:  aReturnNode [

	measuredSize := measuredSize + aReturnNode sizeInMemory
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  (self measureNodeParentheses: aReturnNode ) . aReturnNode return sizeInMemory ] ifFalse: [ 0 ]).
						
	self visit: aReturnNode value
]

{ #category : #visiting }
PLMemorySizeVisitor >> visitSelectorNode:   aSelectorNode [

	measuredSize := measuredSize + aSelectorNode sizeInMemory.	
	"Ignore 'measuredSize value' since is a Symbol"

]

{ #category : #visiting }
PLMemorySizeVisitor >> visitSequenceNode: aSequenceNode [

	measuredSize := measuredSize + aSequenceNode sizeInMemory.
	self measureCollection: aSequenceNode  statements.	
	self measureCollection: aSequenceNode  temporaries.	

	super visitSequenceNode: aSequenceNode.

]

{ #category : #visiting }
PLMemorySizeVisitor >> visitVariableNode:  aVariableNode [

	measuredSize := measuredSize 
		+ aVariableNode sizeInMemory + aVariableNode variable sizeInMemory "Ignore Symbol at 'aVariableNode name' "
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  aVariableNode start sizeInMemory ] ifFalse: [ 0 ])
]
