"
An AstNodeProcessor is a helper class that allows iterating over every node onver an RBParse subtree.

Instance Variables
	block:		<Object>

block
	- xxxxx

"
Class {
	#name : 'CleanUpNodeVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#category : 'Blast-AST-Experiments',
	#package : 'Blast-AST-Experiments'
}

{ #category : 'as yet unclassified' }
CleanUpNodeVisitor class >> cleanUpNode: astTree [

self new visitNode: astTree 
]

{ #category : 'processing' }
CleanUpNodeVisitor >> removeComments: aNode [
	aNode removeProperty: #comments ifAbsent: [  ]
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitAnnotationMarkNode: aAnnotationValueNode [
	self removeComments: aAnnotationValueNode.
	super visitAnnotationMarkNode: aAnnotationValueNode.
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitArrayNode: anArrayNode [
	self removeComments: anArrayNode.
	super visitArrayNode: anArrayNode.
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitAssignmentNode: anAssignmentNode [

	self removeComments: anAssignmentNode.
	super visitAssignmentNode: anAssignmentNode.
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitBlockNode: aBlockNode [ 

	self removeComments: aBlockNode.
	super visitBlockNode: aBlockNode 
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitCascadeNode: aCascadeNode [ 
	self removeComments: aCascadeNode.
	super visitCascadeNode: aCascadeNode 
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [ 
	self removeComments: aRBLiteralArrayNode.
	super visitLiteralArrayNode: aRBLiteralArrayNode 
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitLiteralValueNode: aLiteralValueNode [
	self removeComments: aLiteralValueNode.

]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitMessageNode: aMessageNode [ 
	self removeComments: aMessageNode.
	super visitMessageNode: aMessageNode 
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitMethodNode: aMethodNode [ 
	self removeComments: aMethodNode.
	aMethodNode source: nil;		
		compilationContext: nil;
 	 	scope: nil.
		
	aMethodNode compiledMethod ifNotNil: [ :cm |
		cm removeKey: #code ifAbsent: []
	].
	
	super  visitMethodNode: aMethodNode 
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitPragmaNode: aPragmaNode [
	self removeComments: aPragmaNode.
	super visitPragmaNode: aPragmaNode
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitReturnNode: aReturnNode [ 
	self removeComments: aReturnNode.
	super visitReturnNode: aReturnNode 
]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitSequenceNode: aSequenceNode [ 
	self removeComments: aSequenceNode.
	
	super visitSequenceNode: aSequenceNode 

]

{ #category : 'visiting' }
CleanUpNodeVisitor >> visitVariableNode: aVariableNode [
	self removeComments: aVariableNode.

]
