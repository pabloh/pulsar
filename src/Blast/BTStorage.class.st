"
A BTNodeTable represents a list of AST nodes in a compacted format.
"
Class {
	#name : #BTStorage,
	#superclass : #Object,
	#category : #'Blast-Storage'
}

{ #category : #'as yet unclassified' }
BTStorage class >> defaultStorageSize [
	^ 1024
]

{ #category : #'class initialization' }
BTStorage class >> new: aCapacity [

	^ self basicNew 
		initialize: aCapacity;
		yourself
]

{ #category : #storing }
BTStorage >> addAll: aCollection [
	^ aCollection do: [ :each | self store: each ]
	
]

{ #category : #accessing }
BTStorage >> capacity [
	self subclassResponsibility
]

{ #category : #enumerating }
BTStorage >> do: aBlock [
	1 to: self lastIndex do: [ :index | aBlock value: (self objectAt: index) ]
]

{ #category : #accessing }
BTStorage >> includes: anObject [
	^(self indexOf: anObject) ~= 0.
]

{ #category : #accessing }
BTStorage >> indexOf: anObject [
	^ self indexOf: anObject ifAbsent: 0
]

{ #category : #accessing }
BTStorage >> indexOf: anObject ifAbsent:aBlock [
	self subclassResponsibility
]

{ #category : #initialization }
BTStorage >> initialize [
	self initialize: self class defaultStorageSize
]

{ #category : #accessing }
BTStorage >> lastIndex [
	self subclassResponsibility
]

{ #category : #accessing }
BTStorage >> objectAt: anIndex [
	self subclassResponsibility
]

{ #category : #accesing }
BTStorage >> objectsAt: anIndexList [
	^ anIndexList collect: [ :index | self objectAt: index ] as: Array
]

{ #category : #storing }
BTStorage >> store: anObject [
	self subclassResponsibility
]

{ #category : #storing }
BTStorage >> storeAll: aCollection [
	^ aCollection collect: [ :each | self store: each ] as: Array
]

{ #category : #enumerating }
BTStorage >> withIndexDo: elementAndIndexBlock [ 
	1 to: self lastIndex do: [:index |
		elementAndIndexBlock	value: (self objectAt: index) value: index]
]
