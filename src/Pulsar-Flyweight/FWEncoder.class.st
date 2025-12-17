"
A visitor to convert RB ASTs to Bonsai ASTs.
"
Class {
	#name : 'FWEncoder',
	#superclass : 'OCProgramNodeVisitor',
	#category : 'Pulsar-Flyweight-Conversion',
	#package : 'Pulsar-Flyweight',
	#tag : 'Conversion'
}

{ #category : 'converting' }
FWEncoder class >> encode: aNode [
	^ self new visitNode: aNode
]

{ #category : 'parsing' }
FWEncoder class >> parseExpression: aString [
	^ self encode: (OCParser parseExpression: aString) 
]

{ #category : 'parsing' }
FWEncoder class >> parseMethod: aString [
	^ self encode: (OCParser parseMethod: aString) 
]

{ #category : 'visiting' }
FWEncoder >> visitArrayNode: anArrayNode [ 
	^ FWArrayNode expressions: (anArrayNode children collect: [ :each | self visitNode: each ] as: Array)
]

{ #category : 'visiting' }
FWEncoder >> visitAssignmentNode: anAssignmentNode [
	^ FWAssignmentNode
		variable: (self visitNode: anAssignmentNode variable)
		expression: (self visitNode: anAssignmentNode value)
]

{ #category : 'visiting' }
FWEncoder >> visitBlockNode: aBlockNode [ 
	^ FWBlockNode
		arguments: (aBlockNode arguments collect: [ :argument | self visitNode: argument ] as: Array) 
		temporaries: (aBlockNode temporaries collect: [ :temporary | self visitNode: temporary ] as: Array) 
		expressions: (aBlockNode statements collect: [ :argument | self visitNode: argument ] as: Array)
		hasReturn: (aBlockNode statements size > 0 and: [ aBlockNode statements last isReturn  ])
]

{ #category : 'visiting' }
FWEncoder >> visitCascadeNode: aCascadeNode [ 
	^ FWCascadeNode messages: (aCascadeNode messages collect: [ :message | self visitNode: message ] as: Array)
]

{ #category : 'visiting' }
FWEncoder >> visitLiteralArrayNode: aRBLiteralArrayNode [ 
	^ self visitLiteralNode: aRBLiteralArrayNode
]

{ #category : 'visiting' }
FWEncoder >> visitLiteralNode: aLiteralNode [
	^ FWLiteralNode value: aLiteralNode value
]

{ #category : 'visiting' }
FWEncoder >> visitMessageNode: aMessageNode [
	^ FWMessageNode
		receiver: (self visitNode: aMessageNode receiver)
		selector: aMessageNode selector
		arguments: (aMessageNode arguments collect: [ :argument | self visitNode: argument ] as: Array)
]

{ #category : 'visiting' }
FWEncoder >> visitMethodNode: aMethodNode [
	^ FWMethod
		selector: aMethodNode selector
		pragmas: (aMethodNode pragmas collect: [ :pragma | self visitNode: pragma ])
		body: (self visitBlockNode: aMethodNode)
]

{ #category : 'visiting' }
FWEncoder >> visitPragmaNode: aPragmaNode [
	^ FWPragmaNode
		selector: aPragmaNode selector
		arguments: (aPragmaNode arguments collect: [ :argument | self visitNode: argument ] as: Array)
]

{ #category : 'visiting' }
FWEncoder >> visitSelfNode: aSelfNode [
	^ FWPseudoVariableNode self
]

{ #category : 'visiting' }
FWEncoder >> visitSuperNode: aThisContextNode [
	^ FWPseudoVariableNode super
]

{ #category : 'visiting' }
FWEncoder >> visitThisContextNode: aThisContextNode [
	^ FWPseudoVariableNode thisContext
]

{ #category : 'visiting' }
FWEncoder >> visitVariableNode: aVariableNode [
	^ FWVariableNode name: aVariableNode name asSymbol
]
