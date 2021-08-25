"
A BTStorageDirectory is a base class for more specific kinds of storage directories.

"
Class {
	#name : #BTStorageDirectory,
	#superclass : #Object,
	#category : #'Blast-Storage'
}

{ #category : #clearing }
BTStorageDirectory >> clearStorages [
	^ self subclassResponsibility
]

{ #category : #'storage creation' }
BTStorageDirectory >> createBinaryStorageUsing: aTranscoder [

	^ self createEncodedStorageUsing: aTranscoder wrapping: BTBinaryStorage new

]

{ #category : #'storage creation' }
BTStorageDirectory >> createEncodedStorageUsing: aTranscoder wrapping: anStorage [

	^ BTEncodedObjectStorage
		for: (BTIndexedStorage indexed: anStorage)
		using: aTranscoder
]

{ #category : #'storage creation' }
BTStorageDirectory >> createObjectStorageUsing: aTranscoder [

	^ self createEncodedStorageUsing: aTranscoder wrapping: BTObjectStorage new
]
