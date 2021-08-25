"
A BTDummyStorage is subclass of BTStorage tailored for testing BTStorage methods.

Instance Variables
	dictionary:		<Object>

dictionary
	- xxxxx

"
Class {
	#name : #BTDummyStorage,
	#superclass : #BTStorage,
	#instVars : [
		'dictionary'
	],
	#category : #'Blast-Tests'
}

{ #category : #accessing }
BTDummyStorage >> capacity [
	^dictionary capacity
]

{ #category : #accessing }
BTDummyStorage >> indexOf: anObject ifAbsent: aBlock [
	^dictionary keyAtIdentityValue: anObject ifAbsent: aBlock
]

{ #category : #initialization }
BTDummyStorage >> initialize: capacity [
	dictionary := IdentityDictionary new: capacity.
]

{ #category : #accessing }
BTDummyStorage >> lastIndex [
	^dictionary size
]

{ #category : #accessing }
BTDummyStorage >> objectAt: anIndex [
	^dictionary at: anIndex 
]

{ #category : #storing }
BTDummyStorage >> store: anObject [
	dictionary at: dictionary size + 1 put: anObject.
	^ dictionary size
]
