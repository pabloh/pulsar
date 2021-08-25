Class {
	#name : #BTAssignmentBinaryFormat,
	#superclass : #BTNodeBinaryFormat,
	#category : #'Blast-BinaryFormats'
}

{ #category : #'format selection' }
BTAssignmentBinaryFormat class >> defaultFormat [
	^ BTDefaultAssignmentBinaryFormat 
]
