"
A BTCascadePart represents a message sent in a cascaded message send series.

Instance Variables
	arguments:		<Object>
	selector:		<Object>

arguments
	- xxxxx

selector
	- xxxxx

"
Class {
	#name : #BTCascadePartNode,
	#superclass : #BTEncodedNode,
	#traits : 'TKeywordedNode',
	#classTraits : 'TKeywordedNode classTrait',
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'Blast-Nodes'
}

{ #category : #'instance creation' }
BTCascadePartNode class >> selector: aSelector arguments: anArgumentList [

	self new
		selector: aSelector;
		arguments: anArgumentList;
		yourself
]

{ #category : #visitor }
BTCascadePartNode >> acceptVisitor: aBlastNodeVisitor [

	^ aBlastNodeVisitor visitCascadePartNode: self
]

{ #category : #accessing }
BTCascadePartNode >> arguments [
	^ arguments
]

{ #category : #accessing }
BTCascadePartNode >> arguments: anObject [
	arguments := anObject
]

{ #category : #printing }
BTCascadePartNode >> printOn: aStream [
	self printKeywordsAndArgumentsOn: aStream.

]

{ #category : #accessing }
BTCascadePartNode >> selector [
	^ selector
]

{ #category : #accessing }
BTCascadePartNode >> selector: aSelector [
	selector := aSelector
]
