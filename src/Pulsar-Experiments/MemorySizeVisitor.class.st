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

{ #category : #visiting }
MemorySizeVisitor >> visitLiteralArrayNode:  aLiteralArrayNode [
	
	measuredSize := measuredSize 
		+ aLiteralArrayNode sizeInMemory + aLiteralArrayNode contents sizeInMemory
		+ (aLiteralArrayNode isForByteArray
			ifTrue: [ 0 ]
			 ifFalse: [ (aLiteralArrayNode contents instVarNamed: #array) sizeInMemory  "Breaks encapsulation"  ])
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  aLiteralArrayNode start sizeInMemory + aLiteralArrayNode stop sizeInMemory ] 
			ifFalse: [ 0 ]).
	
	"Call recursively on child nodes"
	aLiteralArrayNode contents do: [  :each |  self visit: each ]
]

{ #category : #visiting }
MemorySizeVisitor >> visitLiteralValueNode:  aLiteralNode [

	measuredSize := measuredSize 
		+ aLiteralNode sizeInMemory + aLiteralNode value sizeInMemory
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  
				aLiteralNode start sizeInMemory + aLiteralNode stop sizeInMemory
			] ifFalse: [ 0 ])
		 
]

{ #category : #visiting }
MemorySizeVisitor >> visitReturnNode:  aReturnNode [

	measuredSize := measuredSize + aReturnNode sizeInMemory
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  aReturnNode return sizeInMemory] ifFalse: [ 0 ]).
						
	self visit: aReturnNode value
]

{ #category : #visiting }
MemorySizeVisitor >> visitVariableNode:  aVariableNode [

	measuredSize := measuredSize 
		+ aVariableNode sizeInMemory + aVariableNode name sizeInMemory + aVariableNode variable sizeInMemory
		+ (includeFormatingValues "This is formating information"
			ifTrue: [  
				aVariableNode start sizeInMemory
			] ifFalse: [ 0 ])
		 
]
