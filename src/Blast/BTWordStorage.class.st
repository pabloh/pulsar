"
A BTWordStorage is binary storage that stores its values as word binary objects.

"
Class {
	#name : #BTWordStorage,
	#superclass : #BTBinaryStorage,
	#category : #'Blast-Storage'
}

{ #category : #accessing }
BTWordStorage >> indexOf: anObject ifAbsent:aBlock [
	1 to: lastIndex do:
		[ :index | (self at: index) = anObject ifTrue: [ ^ index ] ].
	^ aBlock value
]

{ #category : #accessing }
BTWordStorage >> objectAt: anIndex [
	self checkBoundsFor: anIndex.
	^ wordArray at: anIndex
]
