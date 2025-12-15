Class {
	#name : 'BTAssignmentBinaryFormat',
	#superclass : 'BTNodeBinaryFormat',
	#category : 'Blast-BinaryFormats',
	#package : 'Blast',
	#tag : 'BinaryFormats'
}

{ #category : 'format selection' }
BTAssignmentBinaryFormat class >> defaultFormat [
	^ BTDefaultAssignmentBinaryFormat 
]
