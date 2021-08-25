"
A BTMethodNode is the AST node representing a method.

Instance Variables
	body:		<Object>
	pragmas:		<Object>
	selector:		<Object>

body
	- xxxxx

pragmas
	- xxxxx

selector
	- xxxxx

"
Class {
	#name : #BTMethodNode,
	#superclass : #BTEncodedNode,
	#traits : 'TKeywordedNode',
	#classTraits : 'TKeywordedNode classTrait',
	#instVars : [
		'selector',
		'pragmas',
		'body'
	],
	#category : #'Blast-Nodes'
}

{ #category : #'instance creation' }
BTMethodNode class >> selector: aSelector pragmas: aPragmaList body: aSequenceNode [
	
	^self new
		selector: aSelector;
		pragmas: aPragmaList;
		body: aSequenceNode;
		yourself
]

{ #category : #visitor }
BTMethodNode >> acceptVisitor: aBTNodeVisitor [

	^ aBTNodeVisitor visitMethodNode: self
]

{ #category : #accessing }
BTMethodNode >> arguments [
	^self body arguments
]

{ #category : #accessing }
BTMethodNode >> body [
	^ body
]

{ #category : #accessing }
BTMethodNode >> body: aBlockNode [
	body := aBlockNode
]

{ #category : #accessing }
BTMethodNode >> pragmas [
	^ pragmas
]

{ #category : #accessing }
BTMethodNode >> pragmas: aPragmaList [
	pragmas := aPragmaList
]

{ #category : #printing }
BTMethodNode >> printOn: aStream [
	self printKeywordsAndArgumentsOn: aStream.
	aStream cr.
	self printPragmasOn: aStream.
	self body printBodyOn: aStream
]

{ #category : #printing }
BTMethodNode >> printPragmasOn: aStream [
	self pragmas
		do: [ :pragma | aStream print: pragma; cr ]
]

{ #category : #accessing }
BTMethodNode >> selector [
	^ selector
]

{ #category : #accessing }
BTMethodNode >> selector: aSelector [
	selector := aSelector
]
