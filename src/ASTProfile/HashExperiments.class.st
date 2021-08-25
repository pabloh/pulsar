"
A HashExperiments is collection of experiments over hash tables.

"
Class {
	#name : #HashExperiments,
	#superclass : #Object,
	#classInstVars : [
		'sample'
	],
	#category : #ASTProfile
}

{ #category : #'as yet unclassified' }
HashExperiments class >> clearSample [
	sample := nil
]

{ #category : #'as yet unclassified' }
HashExperiments class >> meassureFor: aSample [
	| sample set array|
	
	sample := self sampleOf: aSample .
	set := sample asIdentitySet compact.
	array := sample asArray.
	"el := array at: (array size + 1 / 2 )."

	^ {[ array do: [ :el | set like: el ] ] bench . 
		[ array do: [ :el | array identityIndexOf: el] ] bench.}.
	


]

{ #category : #'as yet unclassified' }
HashExperiments class >> sample [
	sample ifNil: [ sample := (BSMessageNode select: [ :n | n selector numArgs == 0 ] thenCollect: #selector) shuffled first: 10240 ].
	^ sample
]

{ #category : #'as yet unclassified' }
HashExperiments class >> sampleOf: aNumber [
	^ SelectorKeys shuffled first: aNumber
]
