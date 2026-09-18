Class {
	#name : 'PlMemoryExperiments',
	#superclass : 'Object',
	#classVars : [
		'navigation'
	],
	#category : 'Pulsar-Experiments-Measurements',
	#package : 'Pulsar-Experiments',
	#tag : 'Measurements'
}

{ #category : 'accessing' }
PlMemoryExperiments class >> allBehaviors [

	^ self navigation allBehaviors
]

{ #category : 'accessing' }
PlMemoryExperiments class >> allBehaviorsDo:  aBlock [

	self navigation allBehaviorsDo: aBlock
]

{ #category : 'accessing' }
PlMemoryExperiments class >> allMethodsDo: aBlock [

	self allBehaviorsDo: [ :aBehavior | 
		aBehavior methodDictionary do: [ :aMethod |
			aMethod isFromTrait ifFalse: [ aBlock value: aMethod ] ] ]
]

{ #category : 'measure' }
PlMemoryExperiments class >> countAllRBParserASTMethods [
	| number |
	
	number := 0.
	self allMethodsDo: [ :each | number := number +1].	
	^ number
]

{ #category : 'measure' }
PlMemoryExperiments class >> countAllRBParserASTNodes [
	| visitor |
	
	visitor := PlNodeCounterVisitor new.
	
	"TODO Add Symbols and variable names"
	self allMethodsDo: [ :each | visitor measureMethod: each ] .
	
	^ visitor nodeCount.	
	
	

]

{ #category : 'measure' }
PlMemoryExperiments class >> measureAllRBParserASTMethods [
	| visitor |
	
	visitor := PlMemorySizeVisitor new.
	
	"TODO Add Symbols and variable names"
	self allMethodsDo: [ :each | visitor measureMethod: each ] .
	
	^ visitor measuredSize.	
	
	

]

{ #category : 'measure' }
PlMemoryExperiments class >> measureAllRBParserASTMethodsWithWhitespace [
	| visitor |
	
	visitor := PlMemorySizeVisitor newWithWhitespace.
	
	"TODO Add Symbols and variable names"
	self allMethodsDo: [ :each | visitor measureMethod: each ] .
	
	^ visitor measuredSize.	
	
	

]

{ #category : 'measure' }
PlMemoryExperiments class >> measureSymbolTable [	
	
	Symbol cleanUp .
	
	^ (Symbol classVarNamed: #SymbolTable) sizeInMemory +
		(Symbol classVarNamed: #SymbolTable) array sizeInMemory +
			((Symbol classVarNamed: #SymbolTable) sumNumbers: #sizeInMemory)
]

{ #category : 'accessing' }
PlMemoryExperiments class >> navigation [

	^ navigation ifNil: [ navigation := SystemNavigation new ]
]
