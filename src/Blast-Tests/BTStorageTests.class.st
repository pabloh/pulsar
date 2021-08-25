Class {
	#name : #BTStorageTests,
	#superclass : #TestCase,
	#instVars : [
		'emptyStorage',
		'storageWith2Elements',
		'objectStorage'
	],
	#category : #'Blast-Tests'
}

{ #category : #running }
BTStorageTests >> setUp [
	emptyStorage := BTDummyStorage new.
	
	storageWith2Elements := BTDummyStorage new.
	storageWith2Elements store: #aSymbol.
	storageWith2Elements store: 'aString'.
	
	objectStorage := BTObjectStorage new.
]

{ #category : #'tests - template methods' }
BTStorageTests >> testAddAll [
	storageWith2Elements addAll: { 3.  1. 'Hi!'. 2.3 }.
	
	self assert: (storageWith2Elements includes: 3).
	self assert: (storageWith2Elements includes: 1).
	self assert: (storageWith2Elements includes: 'Hi!').
	self assert: (storageWith2Elements includes: 2.3).
	
	self assert: storageWith2Elements lastIndex equals: 6.
]

{ #category : #'tests - template methods' }
BTStorageTests >> testAddAllResultValue [
	| items result |
	items := { 3.  1. 'Hi!'. 2.3 }.
	result := storageWith2Elements addAll: items.
	
	self assert: result == items.
]

{ #category : #'tests - template methods' }
BTStorageTests >> testEnumeration [
	| values  enumerated |
	values := { 3.  1. 'Hi!'. 2.3 }.

	emptyStorage storeAll: values.

	enumerated := Set new.
	emptyStorage do: [ :each | enumerated add: each ].
	
	self assert: enumerated equals: values asSet.
]

{ #category : #'tests - template methods' }
BTStorageTests >> testEnumerationWithIndex [
	| values index enumerated |
	values := { 3.  1. 'Hi!'. 2.3 }.

	emptyStorage storeAll: values.

	index := 0.
	enumerated := Set new.
	
	emptyStorage withIndexDo: [ :each :storageIndex |
		index := index + 1. 
		enumerated add: each.
		self assert: storageIndex equals: index.
		self assert: (emptyStorage objectAt: index) equals: each].
	
	self assert: enumerated equals: values asSet.
]

{ #category : #'tests - template methods' }
BTStorageTests >> testIncludes [
	emptyStorage store: 1.0.
	emptyStorage store: 'Hello'.
	
	self assert: (emptyStorage includes: 1.0).
	self deny: (emptyStorage includes: 1).
	self deny: (emptyStorage includes: 2.0).
	self assert: (emptyStorage includes: 'Hello').
	self deny: (emptyStorage includes: #Hello)
	
]

{ #category : #'tests - template methods' }
BTStorageTests >> testIndexOf [
	| index1 index3 |
	index1 := emptyStorage store: 1.0.
	emptyStorage store: 'Hello'.
	index3 := emptyStorage store: 'Howdy!'.
	
	self assert: (emptyStorage indexOf:  1.0) equals: index1.
	self assert: (emptyStorage indexOf:  1) equals: 0.
	self assert: (emptyStorage indexOf:  1.3) equals: 0.
	self assert: (emptyStorage indexOf:  'Howdy!') equals: index3.
	self assert: (emptyStorage indexOf:  #Hello) equals: 0.
]

{ #category : #'tests - object storage' }
BTStorageTests >> testIndexOfifAbsent [

	objectStorage storeAll: { 'A string'.  #aSymbol. 1. }.
	
	self assert: (objectStorage indexOf:  'A string' ifAbsent: 0) equals: 1.
	self assert: (objectStorage indexOf:  1 ifAbsent: 0) equals: 3.
	self assert: (objectStorage indexOf:  1.0 ifAbsent: 0) equals: 0.
]

{ #category : #'tests - template methods' }
BTStorageTests >> testInitializationWithCapacity [
	| storage capacity |
	
	capacity := 15.
	storage := BTDummyStorage new: capacity.
	
	self assert: storage capacity >= capacity
]

{ #category : #'tests - object storage' }
BTStorageTests >> testObjectAt [

	objectStorage storeAll: { 'A string'.  #aSymbol. 1. }.
	
	self assert: (objectStorage objectAt: 1) equals: 'A string'.
	self assert: (objectStorage objectAt: 2) equals: #aSymbol.
	self assert: (objectStorage objectAt: 3) equals: 1.
]

{ #category : #'tests - object storage' }
BTStorageTests >> testObjectsAtReturnsObjectInTheCorrectOrder [

	objectStorage storeAll: { 'A string'.  #aSymbol. 1. }.
	
	self assert: (objectStorage objectsAt: #(1 2 3)) equals: {'A string'.  #aSymbol. 1.}.
	self assert: (objectStorage objectsAt: #(2 3 1)) equals: {#aSymbol. 1. 'A string'.}.
]

{ #category : #'tests - object storage' }
BTStorageTests >> testObjectsAtReturnsObjectsInAnArray [

	self assert: ((storageWith2Elements objectsAt: #(1)) isKindOf: Array).
	self assert: (storageWith2Elements objectsAt: #(1)) equals: { #aSymbol }
]

{ #category : #'tests - object storage' }
BTStorageTests >> testObjectsInitialization [
	| storage capacity |
	
	capacity := 15.
	storage := BTObjectStorage new: capacity.
	
	self assert: (storage objects isKindOf: OrderedCollection).
	self assert: storage lastIndex equals: 0.
	self assert: storage capacity equals: capacity
]

{ #category : #'tests - object storage' }
BTStorageTests >> testStore [

	objectStorage store: 'A string'.
	objectStorage store: #aSymbol.
	objectStorage store: 1.
	
	self assert: objectStorage lastIndex equals: 3.	
	self assert: (objectStorage includes: #aSymbol).
	self assert: (objectStorage includes: 1).
	self deny: (objectStorage includes: 1.0)
]

{ #category : #'tests - template methods' }
BTStorageTests >> testStoreAll [
	storageWith2Elements storeAll: { 3.  1. 'Hi!'. 2.3 }.
	
	self assert: (storageWith2Elements includes: 3).
	self assert: (storageWith2Elements includes: 1).
	self assert: (storageWith2Elements includes: 'Hi!').
	self assert: (storageWith2Elements includes: 2.3).
	
	self assert: storageWith2Elements lastIndex equals: 6.
]

{ #category : #'tests - template methods' }
BTStorageTests >> testStoreAllResult [
	| items result |
	items := { 3.  1. 'Hi!'. 2.3 }.
	result := storageWith2Elements storeAll: items.
	
	self assert: (result isKindOf: Array).
	self assert: result size equals: items size.
	
	items doWithIndex: [ :item :idx | 
		self assert: (storageWith2Elements objectAt: (result at: idx)) equals: item ]
]
