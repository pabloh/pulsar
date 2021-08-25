"
A BTLinearIndexedStorage adds check to the decorated BTStorage to avoid adding the same object twice.
"
Class {
	#name : #BTLinearIndexedStorage,
	#superclass : #BTIndexedStorage,
	#category : #'Blast-Storage'
}

{ #category : #config }
BTLinearIndexedStorage class >> upperLimit [
	^ 1024
]

{ #category : #storing }
BTLinearIndexedStorage >> store: anObject [
	^ storage indexFor: anObject ifAbsent: [ storage store: anObject ]
]
