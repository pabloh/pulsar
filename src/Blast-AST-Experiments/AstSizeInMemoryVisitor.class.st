"
An AstNodeProcessor is a helper class that allows iterating over every node onver an RBParse subtree.

Instance Variables
	block:		<Object>

block
	- xxxxx

"
Class {
	#name : 'AstSizeInMemoryVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'result'
	],
	#category : 'Blast-AST-Experiments',
	#package : 'Blast-AST-Experiments'
}

{ #category : 'as yet unclassified' }
AstSizeInMemoryVisitor class >> sizeInMemoryFor: aNodeTree [

	^(self new
		visitNode: aNodeTree)
		result
]

{ #category : 'accessing' }
AstSizeInMemoryVisitor >> addCollectionSizeToResult: aCollection [

	result := result + aCollection sizeInMemory
		+ ((aCollection isMemberOf: OrderedCollection) 
			ifTrue: [ (aCollection  instVarNamed: #array) sizeInMemory ] ifFalse: 0)
		+ ((aCollection isMemberOf: SmallDictionary) 
			ifTrue: [ (aCollection  instVarNamed: #keys) sizeInMemory 
						+ (aCollection  instVarNamed: #values) sizeInMemory ]
			ifFalse: 0)
	
	
]

{ #category : 'accessing' }
AstSizeInMemoryVisitor >> addNodeSizeToResult: aTreeNode [
	result := result + aTreeNode sizeInMemory 
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> addValueSizeToResult:  aValue [
	
	result := result + 
		"Symbols boolean and undefined (nil) are a special case" 
	        ((aValue isSymbol or: [ (aValue isKindOf: Boolean) or: [ aValue isNil ]]) 
		       ifTrue: 0  ifFalse: [ aValue sizeInMemory ])
]

{ #category : 'accessing' }
AstSizeInMemoryVisitor >> initialize [
	result := 0
]

{ #category : 'accessing' }
AstSizeInMemoryVisitor >> result [
	^ result
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitAnnotationMarkNode: aAnnotationValueNode [
	self addNodeSizeToResult: aAnnotationValueNode.	
	self addCollectionSizeToResult: aAnnotationValueNode arguments.
	
	"NOT IMPLEMENTED: super visitAnnotationMarkNode: aAnnotationValueNode."
	(aAnnotationValueNode isCascaded not or: [ aAnnotationValueNode isFirstCascaded ])
		ifTrue: [ self visitNode: aAnnotationValueNode receiver ].
	
	self visitNode: aAnnotationValueNode selector.
	aAnnotationValueNode arguments do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitArrayNode: anArrayNode [
	self addNodeSizeToResult: anArrayNode.
	self addCollectionSizeToResult: anArrayNode statements.
	
	super visitArrayNode: anArrayNode.
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitAssignmentNode: anAssignmentNode [
	self addNodeSizeToResult: anAssignmentNode.
		
	super visitAssignmentNode: anAssignmentNode.
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitBlockNode: aBlockNode [ 
	self addNodeSizeToResult: aBlockNode.
	self  addCollectionSizeToResult: aBlockNode arguments.
	
	super visitBlockNode: aBlockNode 
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitCascadeNode: aCascadeNode [ 
	self addNodeSizeToResult: aCascadeNode.
	self addCollectionSizeToResult: aCascadeNode messages. 
	
	super visitCascadeNode: aCascadeNode 
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [ 
	self addNodeSizeToResult: aRBLiteralArrayNode.
	self addCollectionSizeToResult: aRBLiteralArrayNode contents.
	
	super visitLiteralArrayNode: aRBLiteralArrayNode 
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitLiteralValueNode: aLiteralValueNode [
	self addNodeSizeToResult: aLiteralValueNode.
	
	self addValueSizeToResult: aLiteralValueNode value.
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitMessageNode: aMessageNode [ 
	self addNodeSizeToResult: aMessageNode.
	self addCollectionSizeToResult: aMessageNode arguments.
	
	super visitMessageNode: aMessageNode 
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitMethodNode: aMethodNode [
	"Ignore measuring: 
		- scope: specific for semantic analisys	
		- selector: is a Symbol
		- source: because we want to reproduce it
		- replacements and nodeReplacements: specific for refactoring
		- compilationToContext: specific for compiler
		- bcToASTCache: specific for debugger"

	self addNodeSizeToResult: aMethodNode.
	self addCollectionSizeToResult: aMethodNode arguments.
	self addCollectionSizeToResult: aMethodNode pragmas.
	
	super visitMethodNode: aMethodNode 
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitPragmaNode: aPragmaNode [
	self addNodeSizeToResult: aPragmaNode.
	self addCollectionSizeToResult: aPragmaNode  arguments.
	
	super visitPragmaNode: aPragmaNode
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitReturnNode: aReturnNode [ 
	self addNodeSizeToResult: aReturnNode.
	
	super visitReturnNode: aReturnNode 
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitSelectorNode: aSelectorNode [

	"Ignore 'measuredSize value' since is a Symbol"
	self addNodeSizeToResult:  aSelectorNode.
]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitSequenceNode: aSequenceNode [ 
	self addNodeSizeToResult: aSequenceNode.
	self addCollectionSizeToResult: aSequenceNode  statements.	
	self addCollectionSizeToResult: aSequenceNode  temporaries.
	
	super visitSequenceNode: aSequenceNode 

]

{ #category : 'visiting' }
AstSizeInMemoryVisitor >> visitVariableNode: aVariableNode [

	"Ignore Symbol at 'aVariableNode name' because it should be already at 'Symbol>>SymbolTable'"
	"Ignore variable at 'aVariableNode variable' since is only relevant for Semantic Analisys"
	self addNodeSizeToResult: aVariableNode.

]
