"
A BTBinaryStorage is a generic storage for binary data that returns and index for every stored BitList.

Instance Variables
	table:		<Object>

table
	- xxxxx

"
Class {
	#name : #BTBinaryStorage,
	#superclass : #BTStorage,
	#instVars : [
		'wordArray',
		'lastIndex'
	],
	#category : #'Blast-Storage'
}

{ #category : #accessing }
BTBinaryStorage >> capacity [
	 ^ wordArray capacity
]

{ #category : #'private ' }
BTBinaryStorage >> checkBoundsFor: anIndex [
	 anIndex > self lastIndex
		ifTrue: [SubscriptOutOfBounds signalFor: anIndex ]
]

{ #category : #initialization }
BTBinaryStorage >> initialize: aCapacity [
	lastIndex := 0.
	wordArray := WordArray new: aCapacity
]

{ #category : #accessing }
BTBinaryStorage >> lastIndex [
	^ lastIndex
]
