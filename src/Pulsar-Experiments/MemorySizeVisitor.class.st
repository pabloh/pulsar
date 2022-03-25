Class {
	#name : #MemorySizeVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'measuredSize',
		'includeFormatingValues'
	],
	#category : #'Pulsar-Experiments'
}

{ #category : #accessing }
MemorySizeVisitor class >> newIncludingFormatValues [
	self new
		includeFormatingValues: true
]

{ #category : #accessing }
MemorySizeVisitor >> includeFormatingValues [

	^ includeFormatingValues
]

{ #category : #accessing }
MemorySizeVisitor >> includeFormatingValues: anBoolean [

	includeFormatingValues := anBoolean
]

{ #category : #initialization }
MemorySizeVisitor >> initialize [ 
	"comment stating purpose of instance-side method"
	"scope: class-variables  &  instance-variables"	
			
	measuredSize := 0.
	includeFormatingValues := false.
]

{ #category : #accessing }
MemorySizeVisitor >> measuredSize [

	^ measuredSize
]

{ #category : #initialization }
MemorySizeVisitor >> visitLiteralArrayNode:  aLiteralArrayNode [
	
	measuredSize := measuredSize 
		+ aLiteralArrayNode sizeInMemory + aLiteralArrayNode contents sizeInMemory
		+ (aLiteralArrayNode contents instVarNamed: #array) sizeInMemory  "Breaks encapsulation"
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  aLiteralArrayNode start sizeInMemory + aLiteralArrayNode stop sizeInMemory ] 
			ifFalse: [ 0 ]).
	
	"Call recursively on child nodes"
	aLiteralArrayNode contents do: [  :each |  self visit: each ]
]

{ #category : #initialization }
MemorySizeVisitor >> visitLiteralValueNode:  aLiteralNode [

	measuredSize := measuredSize 
		+ aLiteralNode sizeInMemory + aLiteralNode value sizeInMemory
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  
				aLiteralNode value sizeInMemory +	aLiteralNode start sizeInMemory + aLiteralNode stop sizeInMemory
			] ifFalse: [ 0 ])
		 
]
