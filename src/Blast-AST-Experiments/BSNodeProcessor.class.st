"
An AstNodeProcessor is a helper class that allows iterating over every node onver an RBParse subtree.

Instance Variables
	block:		<Object>

block
	- xxxxx

"
Class {
	#name : #BSNodeProcessor,
	#superclass : #BSNodeVisitor,
	#instVars : [
		'block'
	],
	#category : #'Blast-AST-Experiments'
}

{ #category : #'as yet unclassified' }
BSNodeProcessor class >> collectNodesThat: aCondition at: aNodeTree [
	| result |
	result := IdentitySet new.
	
	self forEachNodeThat: aCondition at: aNodeTree do: [:aNode | result add: aNode ] .
			
	^ result
]

{ #category : #'as yet unclassified' }
BSNodeProcessor class >> countNodesThat: aCondition at: aNodeTree [
	| result |
	result := 0.
	
	self forEachNodeThat: aCondition at: aNodeTree do: [ result := result + 1 ].
		
	^ result
]

{ #category : #accessing }
BSNodeProcessor class >> forEachNodeAt: aNodeTree do: aBlock [

	self new
		block: aBlock;
		visitNode: aNodeTree.
]

{ #category : #accessing }
BSNodeProcessor class >> forEachNodeThat: aCondition at: aNodeTree do: aBlock [

	self forEachNodeAt: aNodeTree do: [:aNode | (aCondition value: aNode) ifTrue:  [ aBlock cull: aNode ] ].
]

{ #category : #accessing }
BSNodeProcessor class >> iterateOver: aNodeTree with: aBlock [

	self forEachNodeAt: aNodeTree do: aBlock
]

{ #category : #accessing }
BSNodeProcessor >> block [
	^ block
]

{ #category : #accessing }
BSNodeProcessor >> block: anObject [
	block := anObject
]

{ #category : #processing }
BSNodeProcessor >> process: aNode [
	block cull: aNode
]

{ #category : #visiting }
BSNodeProcessor >> visitArrayNode: anArrayNode [

	self process: anArrayNode.
	super visitArrayNode: anArrayNode.
]

{ #category : #visiting }
BSNodeProcessor >> visitAssignmentNode: anAssignmentNode [

	self process: anAssignmentNode.
	super visitAssignmentNode: anAssignmentNode.
]

{ #category : #visiting }
BSNodeProcessor >> visitBlockNode: aBlockNode [ 

	self process: aBlockNode.
	super visitBlockNode: aBlockNode 
]

{ #category : #visiting }
BSNodeProcessor >> visitCascadeNode: aCascadeNode [

	self process: aCascadeNode.
	super visitCascadeNode: aCascadeNode 
]

{ #category : #visiting }
BSNodeProcessor >> visitLiteralNode: aLiteralNode [

	self process: aLiteralNode.

]

{ #category : #visiting }
BSNodeProcessor >> visitMessageNode: aMessageNode [

	self process: aMessageNode.
	super visitMessageNode: aMessageNode 
]

{ #category : #visiting }
BSNodeProcessor >> visitMethodNode: aMethodNode [

	self process: aMethodNode.
	super visitMethodNode: aMethodNode 
]

{ #category : #visiting }
BSNodeProcessor >> visitPragmaNode: aPragmaNode [

	self process: aPragmaNode.
	super visitPragmaNode: aPragmaNode
]

{ #category : #visiting }
BSNodeProcessor >> visitVariablelNode: aVariableNode [

	self process: aVariableNode.

]
