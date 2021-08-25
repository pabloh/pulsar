"
A BlastNodeVisitor is base class for visitors over the Blast AST nodes class hierarchy.

"
Class {
	#name : #BSNodeVisitor,
	#superclass : #Object,
	#category : #'Bonsai-Visitor'
}

{ #category : #visitor }
BSNodeVisitor >> visitArrayNode: anArrayNode [

	self visitNodeCollection: anArrayNode expressions
]

{ #category : #visitor }
BSNodeVisitor >> visitAssignmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode expression
]

{ #category : #visitor }
BSNodeVisitor >> visitBlockNode: aBlockNode [

	self visitNodeCollection: aBlockNode arguments.
	self visitNodeCollection: aBlockNode temporaries.
	self visitNodeCollection: aBlockNode expressions
]

{ #category : #visitor }
BSNodeVisitor >> visitCascadeNode: aCascadeNode [

	aCascadeNode messages do: [ :each |
		self visitNodeCollection: each arguments ]
]

{ #category : #visitor }
BSNodeVisitor >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode value
]

{ #category : #visitor }
BSNodeVisitor >> visitMessageNode: aMessageNode [

	self visitNode: aMessageNode receiver.
	self visitNodeCollection: aMessageNode arguments
]

{ #category : #visitor }
BSNodeVisitor >> visitMethodNode: aMethodNode [

	self visitNodeCollection: aMethodNode pragmas.
	self visitNode: aMethodNode body 
]

{ #category : #visitor }
BSNodeVisitor >> visitNode: aNode [

	^ aNode acceptVisitor: self
]

{ #category : #visitor }
BSNodeVisitor >> visitNodeCollection: aNodeCollection [

	^ aNodeCollection collect: [ :aNode |  aNode acceptVisitor: self ]
]

{ #category : #visitor }
BSNodeVisitor >> visitPragmaNode: aPragmaNode [

	self visitNodeCollection: aPragmaNode arguments
]

{ #category : #visitor }
BSNodeVisitor >> visitPseudoVariablelNode: aPseudoVariableNode [

	self visitVariablelNode: aPseudoVariableNode  
]

{ #category : #visitor }
BSNodeVisitor >> visitVariablelNode: aVariableNode [

	^ aVariableNode name
]
