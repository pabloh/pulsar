"
A BTStorageWrapper is helper class for subclassing BTStorage decorators and adapters.

Instance Variables
	storage:		<Object>

storage
	- xxxxx

"
Class {
	#name : #BTStorageWrapper,
	#superclass : #Object,
	#instVars : [
		'storage'
	],
	#category : #'Blast-Storage'
}

{ #category : #'instance creation' }
BTStorageWrapper class >> for: anStorage [
	^ self new
		storage: anStorage;
		yourself.
]

{ #category : #storing }
BTStorageWrapper >> addAll: aCollection [
	^ storage addAll: aCollection
	
]

{ #category : #accessing }
BTStorageWrapper >> capacity [
	^ storage capacity
]

{ #category : #enumerating }
BTStorageWrapper >> do: aBlock [
	storage do: aBlock
]

{ #category : #testing }
BTStorageWrapper >> includes: anObject [
	^ storage includes: anObject
]

{ #category : #accessing }
BTStorageWrapper >> indexOf: anObject ifAbsent:aBlock [
	^ storage indexOf: anObject ifAbsent:aBlock
]

{ #category : #accessing }
BTStorageWrapper >> lastIndex [
	^ storage lastIndex
]

{ #category : #accessing }
BTStorageWrapper >> objectAt: anIndex [
	^ storage objectAt: anIndex
]

{ #category : #accessing }
BTStorageWrapper >> objectsAt: anIndexList [
	^ storage objectsAt: anIndexList
]

{ #category : #'private ' }
BTStorageWrapper >> storage [
	^ storage
]

{ #category : #'private ' }
BTStorageWrapper >> storage: anStorage [
	storage := anStorage
]

{ #category : #storing }
BTStorageWrapper >> store: anObject [
	^ storage store: anObject
]

{ #category : #storing }
BTStorageWrapper >> storeAll: aCollection [
	^ storage storeAll: aCollection
	
]

{ #category : #enumerating }
BTStorageWrapper >> withIndexDo: elementAndIndexBlock [ 
	storage withIndexDo: elementAndIndexBlock
]
