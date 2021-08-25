"
A BTSetIndexedStorage uses a BTStoredObjectSet to avoid adding the same object twice the decorated BTStorage .

Instance Variables
	storedSet:		<Object>

storedSet
	- xxxxx

"
Class {
	#name : #BTSetIndexedStorage,
	#superclass : #BTIndexedStorage,
	#instVars : [
		'storedSet'
	],
	#category : #'Blast-Storage'
}

{ #category : #accessing }
BTSetIndexedStorage >> storage: anStorage [
	super storage: anStorage.
	storedSet := BTStoredObjectSet for: anStorage
]

{ #category : #storing }
BTSetIndexedStorage >> store: anObject [
	^ storedSet add: anObject
]
