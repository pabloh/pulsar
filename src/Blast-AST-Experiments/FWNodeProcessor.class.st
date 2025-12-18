"
An AstNodeProcessor is a helper class that allows iterating over every node onver an RBParse subtree.

Instance Variables
	block:		<Object>

block
	- xxxxx

"
Class {
	#name : 'FWNodeProcessor',
	#superclass : 'FWNodeVisitor',
	#instVars : [
		'block'
	],
	#category : 'Blast-AST-Experiments',
	#package : 'Blast-AST-Experiments'
}

{ #category : 'as yet unclassified' }
FWNodeProcessor class >> collectNodesThat: aCondition at: aNodeTree [
	| result |
	result := IdentitySet new.
	
	self forEachNodeThat: aCondition at: aNodeTree do: [:aNode | result add: aNode ] .
			
	^ result
]

{ #category : 'as yet unclassified' }
FWNodeProcessor class >> countNodesThat: aCondition at: aNodeTree [
	| result |
	result := 0.
	
	self forEachNodeThat: aCondition at: aNodeTree do: [ result := result + 1 ].
		
	^ result
]

{ #category : 'accessing' }
FWNodeProcessor class >> forEachNodeAt: aNodeTree do: aBlock [

	self new
		block: aBlock;
		visitNode: aNodeTree.
]

{ #category : 'accessing' }
FWNodeProcessor class >> forEachNodeThat: aCondition at: aNodeTree do: aBlock [

	self forEachNodeAt: aNodeTree do: [:aNode | (aCondition value: aNode) ifTrue:  [ aBlock cull: aNode ] ].
]

{ #category : 'accessing' }
FWNodeProcessor class >> iterateOver: aNodeTree with: aBlock [

	self forEachNodeAt: aNodeTree do: aBlock
]

{ #category : 'accessing' }
FWNodeProcessor >> block [
	^ block
]

{ #category : 'accessing' }
FWNodeProcessor >> block: anObject [
	block := anObject
]

{ #category : 'processing' }
FWNodeProcessor >> process: aNode [
	block cull: aNode
]

{ #category : 'visiting' }
FWNodeProcessor >> visitArrayNode: anArrayNode [

	self process: anArrayNode.
	super visitArrayNode: anArrayNode.
]

{ #category : 'visiting' }
FWNodeProcessor >> visitAssignmentNode: anAssignmentNode [

	self process: anAssignmentNode.
	super visitAssignmentNode: anAssignmentNode.
]

{ #category : 'visiting' }
FWNodeProcessor >> visitBlockNode: aBlockNode [ 

	self process: aBlockNode.
	super visitBlockNode: aBlockNode 
]

{ #category : 'visiting' }
FWNodeProcessor >> visitCascadeNode: aCascadeNode [

	self process: aCascadeNode.
	super visitCascadeNode: aCascadeNode 
]

{ #category : 'visiting' }
FWNodeProcessor >> visitLiteralNode: aLiteralNode [

	self process: aLiteralNode.

]

{ #category : 'visiting' }
FWNodeProcessor >> visitMessageNode: aMessageNode [

	self process: aMessageNode.
	super visitMessageNode: aMessageNode 
]

{ #category : 'visiting' }
FWNodeProcessor >> visitMethodNode: aMethodNode [

	self process: aMethodNode.
	super visitMethodNode: aMethodNode 
]

{ #category : 'visiting' }
FWNodeProcessor >> visitPragmaNode: aPragmaNode [

	self process: aPragmaNode.
	super visitPragmaNode: aPragmaNode
]

{ #category : 'visiting' }
FWNodeProcessor >> visitVariablelNode: aVariableNode [

	self process: aVariableNode.

]
