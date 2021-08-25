"
A BTIndexedStorage adds an index to an existing BTStorage.

"
Class {
	#name : #BTIndexedStorage,
	#superclass : #BTStorageWrapper,
	#category : #'Blast-Storage'
}

{ #category : #'instance creation' }
BTIndexedStorage class >> indexed: anStorage [
	| storageClass |
	storageClass := ((anStorage capacity isZero) or: [ anStorage capacity > BTLinearIndexedStorage upperLimit ])
		ifTrue: [ BTSetIndexedStorage ]
		ifFalse: [ BTLinearIndexedStorage ].
		
	^ storageClass for: anStorage.
]

{ #category : #storing }
BTIndexedStorage >> store: anObject [
	^ self subclassResponsibility
]
