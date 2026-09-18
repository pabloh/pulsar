Class {
	#name : 'PlNodeCounterVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'nodeCount'
	],
	#category : 'Pulsar-Experiments-Visitors',
	#package : 'Pulsar-Experiments',
	#tag : 'Visitors'
}

{ #category : 'measure' }
PlNodeCounterVisitor class >> measureCode: aString [
	^ self measureNode: (RBParser parseExpression: aString)
]

{ #category : 'measure' }
PlNodeCounterVisitor class >> measureMethod: aCompiledMethod [
	^ self measureNode: aCompiledMethod ast
]

{ #category : 'measure' }
PlNodeCounterVisitor class >> measureMethodSource: aString [
	^ self measureNode: (RBParser parseMethod: aString)
]

{ #category : 'measure' }
PlNodeCounterVisitor class >> measureNode: aNode [
	^ self new
		visitNode: aNode;
		nodeCount 
]

{ #category : 'initialization' }
PlNodeCounterVisitor >> initialize [ 
	nodeCount := 0
]

{ #category : 'measuring' }
PlNodeCounterVisitor >> measureMethod: aCompiledMethod [

	self visitNode: aCompiledMethod ast
]

{ #category : 'accessing' }
PlNodeCounterVisitor >> nodeCount [

	^ nodeCount
]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitArrayNode: anArrayNode [
	
	nodeCount  := nodeCount + 1.	
	super visitArrayNode: anArrayNode

]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitAssignmentNode:  anAssignmentNode [

	nodeCount  := nodeCount + 1.
	super visitAssignmentNode: anAssignmentNode
]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitBlockNode:  aBlockNode [

	nodeCount  := nodeCount + 1.	
	super visitBlockNode:  aBlockNode
]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitCascadeNode: aCascadeNode [

	nodeCount  := nodeCount + 1.
	super visitCascadeNode: aCascadeNode 
]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitLiteralArrayNode:  aLiteralArrayNode [
	
	nodeCount  := nodeCount +1.
	
	super visitLiteralArrayNode: aLiteralArrayNode 
]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitLiteralValueNode: aLiteralNode [
		
	nodeCount  := nodeCount + 1.
]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitMessageNode: aMessageNode [

	nodeCount  := nodeCount + 1.			
	super visitMessageNode: aMessageNode

]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitMethodNode: aMethodNode [
	nodeCount  := nodeCount + 1.
	super visitMethodNode:  aMethodNode
]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitPragmaNode:  aPragmaNode [
	
	nodeCount  := nodeCount + 1.	
	super visitPragmaNode: aPragmaNode


]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitReturnNode:  aReturnNode [

	nodeCount  := nodeCount + 1.
	super visitReturnNode: aReturnNode
]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitSelectorNode: aSelectorNode [

	nodeCount  := nodeCount + 1.

]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitSequenceNode: aSequenceNode [

	nodeCount  := nodeCount + 1.
	super visitSequenceNode: aSequenceNode.

]

{ #category : 'visiting' }
PlNodeCounterVisitor >> visitVariableNode:  aVariableNode [

	nodeCount  := nodeCount + 1.
]
