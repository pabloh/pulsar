Class {
	#name : #PLMemoryExperiments,
	#superclass : #Object,
	#classVars : [
		'navigation'
	],
	#category : #'Pulsar-Experiments-Measurements'
}

{ #category : #accessing }
PLMemoryExperiments class >> allBehaviors [

	^ self navigation allBehaviors
]

{ #category : #accessing }
PLMemoryExperiments class >> allBehaviorsDo:  aBlock [

	self navigation allBehaviorsDo: aBlock
]

{ #category : #accessing }
PLMemoryExperiments class >> allMethodsDo: aBlock [

	self allBehaviorsDo: [ :aBehavior | 
		aBehavior methodDictionary do: [ :aMethod |
			aMethod isFromTrait ifFalse: [ aBlock value: aMethod ] ] ]
]

{ #category : #measure }
PLMemoryExperiments class >> countAllRBParserASTMethods [
	| number |
	
	number := 0.
	self allMethodsDo: [ :each | number := number +1].	
	^ number
]

{ #category : #measure }
PLMemoryExperiments class >> measureAllRBParserASTMethods [
	| visitor |
	
	visitor := PLMemorySizeVisitor new.
	
	"TODO Add Symbols and variable names"
	self allMethodsDo: [ :each | visitor measureMethod: each ] .
	
	^ visitor measuredSize.	
	
	

]

{ #category : #accessing }
PLMemoryExperiments class >> navigation [

	^ navigation ifNil: [ navigation := SystemNavigation new ]
]
