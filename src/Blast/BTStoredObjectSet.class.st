"
A BTStoredObjetSet is an set implementation that keeps its objects on a BTStorage.

Instance Variables
	indexes:		<Object>

indexedTable
	- xxxxx

"
Class {
	#name : #BTStoredObjectSet,
	#superclass : #HashedCollection,
	#instVars : [
		'storage'
	],
	#category : #'Blast-Storage'
}

{ #category : #'instance creation' }
BTStoredObjectSet class >> for: anStorage [
	^ self basicNew
		initializeFor: anStorage;
		yourself
]

{ #category : #'instance creation' }
BTStoredObjectSet class >> new: aCapacity for: anStorage [
	^ self basicNew
		initializeWith: aCapacity for: anStorage;
		yourself
]

{ #category : #adding }
BTStoredObjectSet >> add: anObject [
	| index |
	index := self scanFor: anObject.
	
	(array at: index)
		ifNil: [ | storageIndex |
			storageIndex := storage store: anObject.
			self atNewIndex: index put: storageIndex.
			^ storageIndex ]
		ifNotNil: [ :storageIndex | ^ storageIndex ]
]

{ #category : #adding }
BTStoredObjectSet >> add: newObject withOccurrences: anInteger [
	^ self add: newObject
]

{ #category : #private }
BTStoredObjectSet >> addAllFromStorage [
	storage withIndexDo: [ :each :storageIndex | self atNewIndex: (self scanForEmptySlotFor: each) put: storageIndex ]
]

{ #category : #enumerating }
BTStoredObjectSet >> do: aBlock [
	storage do: [ :each | aBlock value: each ]
]

{ #category : #private }
BTStoredObjectSet >> fixCollisionsFrom: start [
	"The element at start has been removed and replaced by nil.
	This method moves forward from there, relocating any entries
	that had been placed below due to collisions with this one"

	| storageIndex index |
	index := start.
	[ (storageIndex := array at: (index := index \\ array size + 1)) == nil ] whileFalse: [
		| newIndex |
		(newIndex := self scanFor: (storage objectAt: storageIndex)) = index ifFalse: [
			array swap: index with: newIndex ] ]
]

{ #category : #private }
BTStoredObjectSet >> grow [
	self growTo: (HashTableSizes atLeast: array size * 2).
]

{ #category : #private }
BTStoredObjectSet >> growTo: anInteger [
	"Grow the elements array and reinsert the old elements"
	
	super initialize: anInteger.
	self addAllFromStorage
]

{ #category : #indexes }
BTStoredObjectSet >> indexFor: anObject [
	^ self indexFor: anObject ifAbsent: [ KeyNotFound signalFor: anObject ].
]

{ #category : #indexes }
BTStoredObjectSet >> indexFor: anObject ifAbsent: aBlock [
	^ (array at: (self scanFor: anObject))
		ifNil: aBlock
		ifNotNil: [ :index | index ]
]

{ #category : #initialization }
BTStoredObjectSet >> initialize: n [
	self error: 'Must provide a storage'
]

{ #category : #initialization }
BTStoredObjectSet >> initializeFor: aStorage [
	self initializeWith: (HashTableSizes atLeast: aStorage capacity) for: aStorage.
]

{ #category : #initialization }
BTStoredObjectSet >> initializeWith: aCapacity for: anStorage [
	super initialize: aCapacity.
	storage := anStorage.
	self addAllFromStorage
]

{ #category : #private }
BTStoredObjectSet >> noCheckAdd: anObject [
	self shouldBeImplemented
]

{ #category : #private }
BTStoredObjectSet >> noCheckNoGrowFillFrom: anArray [
	self shouldBeImplemented
]

{ #category : #copying }
BTStoredObjectSet >> postCopy [
	super postCopy.
	storage := storage copy
]

{ #category : #private }
BTStoredObjectSet >> rehash [
	self growTo: self capacity
]

{ #category : #removing }
BTStoredObjectSet >> remove: anObject ifAbsent: exceptionBlock [

	self shouldNotImplement
]

{ #category : #removing }
BTStoredObjectSet >> removeAll [

	self shouldNotImplement
]

{ #category : #private }
BTStoredObjectSet >> scanFor: anObject [
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or raise an error if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	
	| index start |
	index := start := anObject hash \\ array size + 1.
	[ 
		| storageIndex |
		((storageIndex := array at: index) == nil or: [ (storage objectAt: storageIndex) = anObject ])
			ifTrue: [ ^index ].
		(index := index \\ array size + 1) = start ] whileFalse.
	self errorNoFreeSpace
]

{ #category : #accessing }
BTStoredObjectSet >> storage [
	^storage
]
