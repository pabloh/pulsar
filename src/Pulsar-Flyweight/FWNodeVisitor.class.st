"
A BlastNodeVisitor is base class for visitors over the Blast AST nodes class hierarchy.

"
Class {
	#name : 'FWNodeVisitor',
	#superclass : 'Object',
	#category : 'Pulsar-Flyweight-Visitor',
	#package : 'Pulsar-Flyweight',
	#tag : 'Visitor'
}

{ #category : 'visitor' }
FWNodeVisitor >> visitArrayNode: anArrayNode [

	self visitNodeCollection: anArrayNode expressions
]

{ #category : 'visitor' }
FWNodeVisitor >> visitAssignmentNode: anAssignmentNode [

	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode expression
]

{ #category : 'visitor' }
FWNodeVisitor >> visitBlockNode: aBlockNode [

	self visitNodeCollection: aBlockNode arguments.
	self visitNodeCollection: aBlockNode temporaries.
	self visitNodeCollection: aBlockNode expressions
]

{ #category : 'visitor' }
FWNodeVisitor >> visitCascadeNode: aCascadeNode [

	aCascadeNode messages do: [ :each |
		self visitNodeCollection: each arguments ]
]

{ #category : 'visitor' }
FWNodeVisitor >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode value
]

{ #category : 'visitor' }
FWNodeVisitor >> visitMessageNode: aMessageNode [

	self visitNode: aMessageNode receiver.
	self visitNodeCollection: aMessageNode arguments
]

{ #category : 'visitor' }
FWNodeVisitor >> visitMethodNode: aMethodNode [

	self visitNodeCollection: aMethodNode pragmas.
	self visitNode: aMethodNode body 
]

{ #category : 'visitor' }
FWNodeVisitor >> visitNode: aNode [

	^ aNode acceptVisitor: self
]

{ #category : 'visitor' }
FWNodeVisitor >> visitNodeCollection: aNodeCollection [

	^ aNodeCollection collect: [ :aNode |  aNode acceptVisitor: self ]
]

{ #category : 'visitor' }
FWNodeVisitor >> visitPragmaNode: aPragmaNode [

	self visitNodeCollection: aPragmaNode arguments
]

{ #category : 'visitor' }
FWNodeVisitor >> visitPseudoVariablelNode: aPseudoVariableNode [

	self visitVariablelNode: aPseudoVariableNode  
]

{ #category : 'visitor' }
FWNodeVisitor >> visitVariablelNode: aVariableNode [

	^ aVariableNode name
]
