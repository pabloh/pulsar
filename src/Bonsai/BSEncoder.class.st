"
A visitor to convert RB ASTs to Bonsai ASTs.
"
Class {
	#name : #BSEncoder,
	#superclass : #RBProgramNodeVisitor,
	#category : #'Bonsai-Conversion'
}

{ #category : #converting }
BSEncoder class >> encode: aNode [
	^ self new visitNode: aNode
]

{ #category : #parsing }
BSEncoder class >> parseExpression: aString [
	^ self encode: (RBParser parseExpression: aString) 
]

{ #category : #parsing }
BSEncoder class >> parseMethod: aString [
	^ self encode: (RBParser parseMethod: aString) 
]

{ #category : #visiting }
BSEncoder >> visitArrayNode: anArrayNode [ 
	^ BSArrayNode expressions: (anArrayNode children collect: [ :each | self visitNode: each ] as: Array)
]

{ #category : #visiting }
BSEncoder >> visitAssignmentNode: anAssignmentNode [
	^ BSAssignmentNode
		variable: (self visitNode: anAssignmentNode variable)
		expression: (self visitNode: anAssignmentNode value)
]

{ #category : #visiting }
BSEncoder >> visitBlockNode: aBlockNode [ 
	^ BSBlockNode
		arguments: (aBlockNode arguments collect: [ :argument | self visitNode: argument ] as: Array) 
		temporaries: (aBlockNode temporaries collect: [ :temporary | self visitNode: temporary ] as: Array) 
		expressions: (aBlockNode statements collect: [ :argument | self visitNode: argument ] as: Array)
		hasReturn: (aBlockNode statements size > 0 and: [ aBlockNode statements last isReturn  ])
]

{ #category : #visiting }
BSEncoder >> visitCascadeNode: aCascadeNode [ 
	^ BSCascadeNode messages: (aCascadeNode messages collect: [ :message | self visitNode: message ] as: Array)
]

{ #category : #visiting }
BSEncoder >> visitLiteralArrayNode: aRBLiteralArrayNode [ 
	^ self visitLiteralNode: aRBLiteralArrayNode
]

{ #category : #visiting }
BSEncoder >> visitLiteralNode: aLiteralNode [
	^ BSLiteralNode value: aLiteralNode value
]

{ #category : #visiting }
BSEncoder >> visitMessageNode: aMessageNode [
	^ BSMessageNode
		receiver: (self visitNode: aMessageNode receiver)
		selector: aMessageNode selector
		arguments: (aMessageNode arguments collect: [ :argument | self visitNode: argument ] as: Array)
]

{ #category : #visiting }
BSEncoder >> visitMethodNode: aMethodNode [
	^ BSMethod
		selector: aMethodNode selector
		pragmas: (aMethodNode pragmas collect: [ :pragma | self visitNode: pragma ])
		body: (self visitBlockNode: aMethodNode)
]

{ #category : #visiting }
BSEncoder >> visitPragmaNode: aPragmaNode [
	^ BSPragmaNode
		selector: aPragmaNode selector
		arguments: (aPragmaNode arguments collect: [ :argument | self visitNode: argument ] as: Array)
]

{ #category : #visiting }
BSEncoder >> visitSelfNode: aSelfNode [
	^ BSPseudoVariableNode self
]

{ #category : #visiting }
BSEncoder >> visitSuperNode: aThisContextNode [
	^ BSPseudoVariableNode super
]

{ #category : #visiting }
BSEncoder >> visitThisContextNode: aThisContextNode [
	^ BSPseudoVariableNode thisContext
]

{ #category : #visiting }
BSEncoder >> visitVariableNode: aVariableNode [
	^ BSVariableNode name: aVariableNode name asSymbol
]
