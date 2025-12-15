Class {
	#name : 'BTCommonAssignmentBinaryFormat',
	#superclass : 'BTAssignmentBinaryFormat',
	#category : 'Blast-BinaryFormats',
	#package : 'Blast',
	#tag : 'BinaryFormats'
}

{ #category : 'format testing' }
BTCommonAssignmentBinaryFormat class >> appliesFor: anEncoder [
	^ anEncoder node expression isMessageNode and: 
		[ anEncoder assignedExpressionCode isMediumRange and: [  
			anEncoder variableNameCode isMediumRange ] ]
]
