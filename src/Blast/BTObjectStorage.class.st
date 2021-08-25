"
A BTObjectStorage is an storage that can store any kind of Object using an OrderedCollection as a backend, or equivalently, it's an adapter for an OrderedCollection to the BTStorage protocol.

Instance Variables
	objects		<OrderedCollection>

objects
	- xxxxx

"
Class {
	#name : #BTObjectStorage,
	#superclass : #BTStorage,
	#instVars : [
		'objects'
	],
	#category : #'Blast-Storage'
}

{ #category : #'instance creation' }
BTObjectStorage class >> adjustCapacity: aCapacity [

	^ 32 max: ((aCapacity/8) ceiling * 8)
]

{ #category : #'instance creation' }
BTObjectStorage class >> new: aCapacity preloadedWith: aCollection [

	^ (self new: aCapacity)
		addAll: aCollection;
		yourself
	
]

{ #category : #'instance creation' }
BTObjectStorage class >> preloadedWith: aCollection [

	^ (self new: (self adjustCapacity: aCollection size))
		addAll: aCollection;
		yourself
	
]

{ #category : #storing }
BTObjectStorage >> addAll: aCollection [
	objects addAll: aCollection

]

{ #category : #accesing }
BTObjectStorage >> capacity [
	^ objects capacity
]

{ #category : #accesing }
BTObjectStorage >> indexOf: anObject ifAbsent: aBlock [
	^ objects identityIndexOf: anObject ifAbsent: aBlock
]

{ #category : #initialization }
BTObjectStorage >> initialize: aCapacity [
	objects := OrderedCollection new: aCapacity
]

{ #category : #accesing }
BTObjectStorage >> lastIndex [
	^ objects size
]

{ #category : #accesing }
BTObjectStorage >> objectAt: anIndex [
	^ objects at: anIndex
]

{ #category : #private }
BTObjectStorage >> objects [
	^objects
]

{ #category : #storing }
BTObjectStorage >> store: anObject [
	objects addLast: anObject.
	^ self lastIndex
]
