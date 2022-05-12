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

	self allBehaviorsDo: [ :class | 
		class methodDict do: [ :each | aBlock value: each ]	] 
]

{ #category : #measure }
PLMemoryExperiments class >> measureAllRBParserASTMethods [
	| visitor |
	
	visitor := PLMemorySizeVisitor new.
	
	"TODO Add Symbols and variable names"
	self allMethodsDo: [ :each | visitor measureMethod: each ] .
	
	^ visitor measuredSize 

]

{ #category : #accessing }
PLMemoryExperiments class >> navigation [

	^ navigation ifNil: [ navigation := SystemNavigation new ]
]
