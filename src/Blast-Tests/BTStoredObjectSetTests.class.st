Class {
	#name : #BTStoredObjectSetTests,
	#superclass : #TestCase,
	#instVars : [
		'set',
		'emptySet',
		'storageWithObjects',
		'emptyStorage'
	],
	#category : #'Blast-Tests'
}

{ #category : #running }
BTStoredObjectSetTests >> setUp [
	storageWithObjects := BTObjectStorage new: 10.
	emptyStorage := BTObjectStorage new.
	
	storageWithObjects storeAll: #(foo bar baz qux quux corge grault garply thud).

	emptySet := BTStoredObjectSet for: BTObjectStorage new.
	set := BTStoredObjectSet for: storageWithObjects
]

{ #category : #'tests - adding' }
BTStoredObjectSetTests >> testAddDuplicated [
	| oldSize firstIndex secondIndex |
	
	oldSize := set size.
	firstIndex := set add: 5.
	secondIndex := set add: 5.
	
	self assert: set size equals: oldSize +1.
	self assert: firstIndex equals: secondIndex.
]

{ #category : #'tests - adding' }
BTStoredObjectSetTests >> testAddToSet [
	| oldSize |
	
	oldSize := set size.
	set add: 3.
	set add: 'Hello'.
	set add: 3.5.
	
	self assert: set size equals: oldSize +3.
	self assert: (set includes: 3).
	self assert: (set includes: 'Hello').
	self assert: (set includes: 3.5).
	
	emptySet add: 'Hi!'.
	
	self assert: emptySet size equals: 1.
	self assert: (emptySet includes: 'Hi!').
]

{ #category : #'tests - adding' }
BTStoredObjectSetTests >> testAddWithOccurrencesBehavesLikeAdd [
	|oldSize|
	oldSize := set size.
	
	set
		add: 3 withOccurrences: 1; 
		add: 'Hello' withOccurrences: 10; 
		add: 3 withOccurrences: 5.
	
	self assert: set size equals: oldSize +2.
	self assert: (set includes: 3).
	self assert: (set includes: 'Hello')
]

{ #category : #'tests - removing' }
BTStoredObjectSetTests >> testDoNotAllowClearingSet [

	self should: [ set removeAll ] raise: ShouldNotImplement
]

{ #category : #'tests - removing' }
BTStoredObjectSetTests >> testDoNotAllowRemovingElements [

	self should: [ set remove: #foo ifAbsent: [] ] raise: ShouldNotImplement
]

{ #category : #'tests - indexes' }
BTStoredObjectSetTests >> testIndexesIndexesForIvalidElementRaisesError [

	self should: [ set indexFor: 'An element not present' ] raise: KeyNotFound.
      self assert: (set indexFor: 'Another element not present' ifAbsent: 0) equals: 0
]

{ #category : #'tests - initialization' }
BTStoredObjectSetTests >> testInitializeForAStorage [
	| newSet  |
	newSet := BTStoredObjectSet for: storageWithObjects.
	
	self assert: newSet capacity >= storageWithObjects capacity.
	self assert: newSet storage equals: storageWithObjects.
	
	self assert: newSet size equals: storageWithObjects lastIndex. 
	newSet do: [ :storedObj | self assert: (newSet includes: storedObj) ]
]

{ #category : #'tests - initialization' }
BTStoredObjectSetTests >> testInitializeWithAStorageAndCapacity [
	| newSet capacity |
	capacity := 19.
	newSet := BTStoredObjectSet new: capacity for: emptyStorage.
	
	self assert: newSet capacity equals: capacity.
	self assert: newSet storage equals: emptyStorage.
	
]

{ #category : #'tests - initialization' }
BTStoredObjectSetTests >> testInitializeWithNoStorageShouldFail [
	
	self should: [ BTStoredObjectSet new ] raise: Error description: 'Must provide a storage'.
	self should: [ BTStoredObjectSet new: 10 ] raise: Error description: 'Must provide a storage'.
]

{ #category : #'tests - indexes' }
BTStoredObjectSetTests >> testValidIndexesCorrespondToStorageIndexes [
	| newIndex |
	
	self assert: (set indexFor: #bar) equals: (set storage indexOf: #bar).
	self assert: (set add: #bar) equals: (set storage indexOf: #bar).
	
	newIndex := set add: #aCompletelyNewElement.
	
	self assert: (set indexFor: #aCompletelyNewElement) equals: (set storage indexOf: #aCompletelyNewElement).
	self assert: (set add: #aCompletelyNewElement) equals: (set storage indexOf: #aCompletelyNewElement).
]

{ #category : #'tests - enumerating' }
BTStoredObjectSetTests >> testsDoIteratesOverStorareElements [

	| setElements storageElements |
	setElements := OrderedCollection new.
	storageElements := OrderedCollection new.
	
	set do: [ :each | setElements add: each ].
	set storage do: [ :each | storageElements add: each ].
	
	self assert: setElements equals: storageElements.
]
