"
A BTBlockNode is the AST node for blocks.

Instance Variables
	arguments:		<Object>
	statements:		<Object>
	temporaries:		<Object>

arguments
	- xxxxx

statements
	- xxxxx

temporaries
	- xxxxx

"
Class {
	#name : #BTBlockNode,
	#superclass : #BTEncodedNode,
	#instVars : [
		'arguments',
		'temporaries',
		'statements',
		'hasReturn'
	],
	#category : #'Blast-Nodes'
}

{ #category : #'instance creation' }
BTBlockNode class >> arguments: anArgumentList temporaries: aTemporaryList statements: aStatementList hasReturn: aBoolean [
	
	^self new
		arguments: anArgumentList;
		temporaries: aTemporaryList;
		statements: aStatementList;
		hasReturn: aBoolean;
		yourself
]

{ #category : #visitor }
BTBlockNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitBlockNode: self
]

{ #category : #accessing }
BTBlockNode >> arguments [
	^ arguments
]

{ #category : #accessing }
BTBlockNode >> arguments: anArgumentList [
	arguments := anArgumentList
]

{ #category : #accessing }
BTBlockNode >> hasReturn [
	^ hasReturn
]

{ #category : #accessing }
BTBlockNode >> hasReturn: anObject [
	hasReturn := anObject
]

{ #category : #printing }
BTBlockNode >> printArgumentsOn: aStream [
	self arguments ifNotEmptyDo: [ :args |
		args do: [ :arg |
			aStream << ':';  print: arg ; space ].
		aStream << '| ' ]
]

{ #category : #printing }
BTBlockNode >> printBodyOn: aStream [
	self printTemporariesOn: aStream.
	self	 printStatementsOn: aStream.
]

{ #category : #printing }
BTBlockNode >> printOn: aStream [
	aStream << '[ '.
	self printArgumentsOn: aStream.
	self printBodyOn: aStream.
	aStream << ' ]'.
]

{ #category : #printing }
BTBlockNode >> printStatementsOn: aStream [
	self statements allButLastDo: [ :expression | 
		expression printOn: aStream.
		aStream << '. '; cr ].

	self statements ifNotEmpty: [
		hasReturn ifTrue: [ aStream << '^' ].
		self statements last printOn: aStream].
]

{ #category : #printing }
BTBlockNode >> printTemporariesOn: aStream [
	self temporaries ifNotEmpty: [
		aStream << ' | '.
		self temporaries 
			do: [ :temp | temp printOn: aStream ]
			separatedBy: [ aStream << ' ' ].
		aStream << ' | ']
]

{ #category : #accessing }
BTBlockNode >> statements [
	^ statements
]

{ #category : #accessing }
BTBlockNode >> statements: anObject [
	statements := anObject
]

{ #category : #accessing }
BTBlockNode >> temporaries [
	^ temporaries
]

{ #category : #accessing }
BTBlockNode >> temporaries: anObject [
	temporaries := anObject
]
