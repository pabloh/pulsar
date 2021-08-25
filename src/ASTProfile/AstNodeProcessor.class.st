"
An AstNodeProcessor is a helper class that allows iterating over every node onver an RBParse subtree.

Instance Variables
	block:		<Object>

block
	- xxxxx

"
Class {
	#name : #AstNodeProcessor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'block'
	],
	#category : #ASTProfile
}

{ #category : #'as yet unclassified' }
AstNodeProcessor class >> collectNodesThat: aCondition at: aNodeTree [
	| result |
	result := IdentitySet new.
	
	self forEachNodeThat: aCondition at: aNodeTree do: [:aNode | result add: aNode ] .
			
	^ result
]

{ #category : #'as yet unclassified' }
AstNodeProcessor class >> countNodesThat: aCondition at: aNodeTree [
	| result |
	result := 0.
	
	self forEachNodeThat: aCondition at: aNodeTree do: [ result := result + 1 ].
		
	^ result
]

{ #category : #'as yet unclassified' }
AstNodeProcessor class >> forEachNodeAt: aNodeTree do: aBlock [

	self new
		block: aBlock;
		visitNode: aNodeTree.
]

{ #category : #'as yet unclassified' }
AstNodeProcessor class >> forEachNodeThat: aCondition at: aNodeTree do: aBlock [

	self forEachNodeAt: aNodeTree do: [:aNode | (aCondition value: aNode) ifTrue:  [ aBlock cull: aNode ] ].
]

{ #category : #'as yet unclassified' }
AstNodeProcessor class >> iterateOver: aNodeTree with: aBlock [

	self forEachNodeAt: aNodeTree do: aBlock.
]

{ #category : #accessing }
AstNodeProcessor >> block [
	^ block
]

{ #category : #accessing }
AstNodeProcessor >> block: anObject [
	block := anObject
]

{ #category : #processing }
AstNodeProcessor >> process: aNode [
	block cull: aNode
]

{ #category : #visiting }
AstNodeProcessor >> visitArrayNode: anArrayNode [
	self process: anArrayNode.
	super visitArrayNode: anArrayNode.
]

{ #category : #visiting }
AstNodeProcessor >> visitAssignmentNode: anAssignmentNode [

	self process: anAssignmentNode.
	super visitAssignmentNode: anAssignmentNode.
]

{ #category : #visiting }
AstNodeProcessor >> visitBlockNode: aBlockNode [ 

	self process: aBlockNode.
	super visitBlockNode: aBlockNode 
]

{ #category : #visiting }
AstNodeProcessor >> visitCascadeNode: aCascadeNode [ 
	self process: aCascadeNode.
	super visitCascadeNode: aCascadeNode 
]

{ #category : #visiting }
AstNodeProcessor >> visitLiteralArrayNode: aRBLiteralArrayNode [ 
	self process: aRBLiteralArrayNode.
	super visitLiteralArrayNode: aRBLiteralArrayNode 
]

{ #category : #visiting }
AstNodeProcessor >> visitLiteralNode: aLiteralNode [
	self process: aLiteralNode.

]

{ #category : #visiting }
AstNodeProcessor >> visitMessageNode: aMessageNode [ 
	self process: aMessageNode.
	super visitMessageNode: aMessageNode 
]

{ #category : #visiting }
AstNodeProcessor >> visitMethodNode: aMethodNode [ 
	self process: aMethodNode.
	super visitMethodNode: aMethodNode 
]

{ #category : #visiting }
AstNodeProcessor >> visitPragmaNode: aPragmaNode [
	self process: aPragmaNode.
	super visitPragmaNode: aPragmaNode
]

{ #category : #visiting }
AstNodeProcessor >> visitReturnNode: aReturnNode [ 
	self process: aReturnNode.
	super visitReturnNode: aReturnNode 
]

{ #category : #visiting }
AstNodeProcessor >> visitSequenceNode: aSequenceNode [ 
	self process: aSequenceNode.
	
	super visitSequenceNode: aSequenceNode 

]

{ #category : #visiting }
AstNodeProcessor >> visitVariableNode: aVariableNode [
	self process: aVariableNode.

]
