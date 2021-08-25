Class {
	#name : #BTDefaultAssignmentBinaryFormat,
	#superclass : #BTAssignmentBinaryFormat,
	#category : #'Blast-BinaryFormats'
}

{ #category : #'format testing' }
BTDefaultAssignmentBinaryFormat class >> appliesFor: aStrategyContext [
	^ true
]

{ #category : #building }
BTDefaultAssignmentBinaryFormat >> buildResultFor: anEncoder [
	anEncoder result
		append: anEncoder encodedHeader;
		append: anEncoder encodedVariable;
		append: anEncoder encodedAssignedExpression
]
