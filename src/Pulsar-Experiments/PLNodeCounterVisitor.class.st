Class {
	#name : #PLNodeCounterVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'nodeCount'
	],
	#category : #'Pulsar-Experiments-Visitors'
}

{ #category : #measure }
PLNodeCounterVisitor class >> measureCode: aString [
	^ self measureNode: (RBParser parseExpression: aString)
]

{ #category : #measure }
PLNodeCounterVisitor class >> measureMethod: aCompiledMethod [
	^ self measureNode: aCompiledMethod ast
]

{ #category : #measure }
PLNodeCounterVisitor class >> measureMethodSource: aString [
	^ self measureNode: (RBParser parseMethod: aString)
]

{ #category : #measure }
PLNodeCounterVisitor class >> measureNode: aNode [
	^ self new
		visitNode: aNode;
		nodeCount 
]

{ #category : #initialization }
PLNodeCounterVisitor >> initialize [ 
	nodeCount := 0
]

{ #category : #measuring }
PLNodeCounterVisitor >> measureMethod: aCompiledMethod [

	self visitNode: aCompiledMethod ast
]

{ #category : #accessing }
PLNodeCounterVisitor >> nodeCount [

	^ nodeCount
]

{ #category : #visiting }
PLNodeCounterVisitor >> visitArrayNode: anArrayNode [
	
	nodeCount  := nodeCount + 1.	
	super visitArrayNode: anArrayNode

]

{ #category : #visiting }
PLNodeCounterVisitor >> visitAssignmentNode:  anAssignmentNode [

	nodeCount  := nodeCount + 1.
	super visitAssignmentNode: anAssignmentNode
]

{ #category : #visiting }
PLNodeCounterVisitor >> visitBlockNode:  aBlockNode [

	nodeCount  := nodeCount + 1.	
	super visitBlockNode:  aBlockNode
]

{ #category : #visiting }
PLNodeCounterVisitor >> visitCascadeNode: aCascadeNode [

	nodeCount  := nodeCount + 1.
	super visitCascadeNode: aCascadeNode 
]

{ #category : #visiting }
PLNodeCounterVisitor >> visitLiteralArrayNode:  aLiteralArrayNode [
	
	nodeCount  := nodeCount +1.
	
	super visitLiteralArrayNode: aLiteralArrayNode 
]

{ #category : #visiting }
PLNodeCounterVisitor >> visitLiteralValueNode: aLiteralNode [
		
	nodeCount  := nodeCount + 1.
]

{ #category : #visiting }
PLNodeCounterVisitor >> visitMessageNode: aMessageNode [

	nodeCount  := nodeCount + 1.			
	super visitMessageNode: aMessageNode

]

{ #category : #visiting }
PLNodeCounterVisitor >> visitMethodNode: aMethodNode [
	nodeCount  := nodeCount + 1.
	super visitMethodNode:  aMethodNode
]

{ #category : #visiting }
PLNodeCounterVisitor >> visitPragmaNode:  aPragmaNode [
	
	nodeCount  := nodeCount + 1.	
	super visitPragmaNode: aPragmaNode


]

{ #category : #visiting }
PLNodeCounterVisitor >> visitReturnNode:  aReturnNode [

	nodeCount  := nodeCount + 1.
	super visitReturnNode: aReturnNode
]

{ #category : #visiting }
PLNodeCounterVisitor >> visitSelectorNode: aSelectorNode [

	nodeCount  := nodeCount + 1.

]

{ #category : #visiting }
PLNodeCounterVisitor >> visitSequenceNode: aSequenceNode [

	nodeCount  := nodeCount + 1.
	super visitSequenceNode: aSequenceNode.

]

{ #category : #visiting }
PLNodeCounterVisitor >> visitVariableNode:  aVariableNode [

	nodeCount  := nodeCount + 1.
]
