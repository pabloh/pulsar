"
A BlastNodeVisitor is base class for visitors over the Blast AST nodes class hierarchy.

"
Class {
	#name : #BTNodeVisitor,
	#superclass : #Object,
	#category : #'Blast-Visitor'
}

{ #category : #visitor }
BTNodeVisitor >> visitArrayNode: anArrayNode [

	self visitNodeCollection: anArrayNode expressions
]

{ #category : #visitor }
BTNodeVisitor >> visitAssigmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode expression
]

{ #category : #visitor }
BTNodeVisitor >> visitBlockNode: aBlockNode [

	self visitNodeCollection: aBlockNode arguments.
	self visitNodeCollection: aBlockNode temporaries.
	self visitNodeCollection: aBlockNode statements
]

{ #category : #visitor }
BTNodeVisitor >> visitCascadeNode: aCascadeNode [

	self visitNodeCollection: aCascadeNode parts
]

{ #category : #visitor }
BTNodeVisitor >> visitCascadePartNode: aCascadePartNode [

	self visitNodeCollection: aCascadePartNode arguments
]

{ #category : #visitor }
BTNodeVisitor >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode value
]

{ #category : #visitor }
BTNodeVisitor >> visitMessageNode: aMessageNode [

	self visitNode: aMessageNode receiver.
	self visitNodeCollection: aMessageNode arguments
]

{ #category : #visitor }
BTNodeVisitor >> visitMethodNode: aMethodNode [

	self visitNodeCollection: aMethodNode pragmas.
	self visitNode: aMethodNode body  
]

{ #category : #visitor }
BTNodeVisitor >> visitNode: aNode [

	^ aNode acceptVisitor: self
]

{ #category : #visitor }
BTNodeVisitor >> visitNodeCollection: aNodeCollection [

	^ aNodeCollection collect: [ :aNode |  aNode acceptVisitor: self ]
]

{ #category : #visitor }
BTNodeVisitor >> visitPragmaNode: aPragmaNode [

	self visitNodeCollection: aPragmaNode arguments
]

{ #category : #visitor }
BTNodeVisitor >> visitVariablelNode: aVariableNode [

	^ aVariableNode name
]
