"
A BonsaiExperiments is a class consisting of AST memory footpring making use of the Bonsai framework.
"
Class {
	#name : 'FWExperiments',
	#superclass : 'Object',
	#category : 'Blast-AST-Experiments',
	#package : 'Blast-AST-Experiments'
}

{ #category : 'nodes' }
FWExperiments class >> allUniqueNodesByClass [
	^ (FWFlyweightNode subclasses collect: [:class | class  -> class cache ] ) asDictionary
]

{ #category : 'nodes' }
FWExperiments class >> allUniqueNodesByClassCountAndPercentages [
	^ AstMemoryExperiments countAndPercentangesFor: (self allUniqueNodesByClass collect: #size)
]

{ #category : 'nodes' }
FWExperiments class >> avgUniqueNodes [ 
	^(self totalUniqueNodes / AstMemoryExperiments methodsBonsaiAsts size)
		printShowingDecimalPlaces: 5
]

{ #category : 'nodes iteration' }
FWExperiments class >> eachBSNodeThat: aCondition do: aBlock [
	AstMemoryExperiments methodsBonsaiAsts do: [ :methodNode |
		FWNodeProcessor forEachNodeThat: aCondition at: methodNode do: aBlock ]
]

{ #category : 'nodes' }
FWExperiments class >> medianUniqueNodes [
	| counters |
	counters := AstMemoryExperiments methodsBonsaiAsts collect: [ :methodNode |
		|total|
		total := 0.
		FWNodeProcessor forEachNodeAt: methodNode	 do: [ :n | total := total + 1 ].
		total		
	].
	counters sort.
	^counters at: (counters size //2)
]

{ #category : 'messages' }
FWExperiments class >> messagesByArity [
	^ (FWMessageNode cache groupedBy: [ :node | node selector numArgs ])
]

{ #category : 'messages' }
FWExperiments class >> messagesByArityCountAndPercentanges [
	^ ((AstMemoryExperiments countAndPercentangesFor: (self messagesByArity collect: #size))
		associations
		sorted: [ :a :b | 			
			(a value at: 1) >= (b value at: 1)
		]) asOrderedDictionary 
	
]

{ #category : 'messages' }
FWExperiments class >> messagesByArityCountAndPercentangesAcumulated [
	^ AstMemoryExperiments countAndPercentangesAcumulatedFor: (self messagesByArity collect: #size)
	
]

{ #category : 'selectors' }
FWExperiments class >> selectorsByArity [
	^ (FWMessageNode cache collect: #selector) groupedBy: #numArgs
]

{ #category : 'selectors' }
FWExperiments class >> selectorsByArityCount [
	^ self selectorsByArity collect: #size
]

{ #category : 'selectors' }
FWExperiments class >> selectorsByArityCountAndPercentages [
	^ AstMemoryExperiments countAndPercentangesFor: (self selectorsByArityCount)
]

{ #category : 'variables' }
FWExperiments class >> tempVariablesFrecuency [
	| result addVars |
	result := Dictionary new.
	addVars := [ :var| result at: var name put: 1 + (result at: var name ifPresent: #yourself ifAbsent: 0) ] .
	
	FWBlockNode cache do: [ :block | block temporaries do: addVars ].
	^ result
]

{ #category : 'variables' }
FWExperiments class >> tempVariablesNames [

	^ FWBlockNode cache 
		inject: Set new
		into: [ :result :block | result addAll: (block temporaries collect: #name) ; yourself ].
]

{ #category : 'nodes' }
FWExperiments class >> totalUniqueNodes [
	|total|
	total := 0.
	AstMemoryExperiments methodsBonsaiAsts do: [ :methodNode |
		FWNodeProcessor forEachNodeAt: methodNode	 do: [ :n | total := total + 1 ].		
	].

	^total
]

{ #category : 'variables' }
FWExperiments class >> variablesFrecuency [
	| result  |
	result := Dictionary new.
	
	self eachBSNodeThat: #isVariableNode do:  [ :var |
		result at: var name put: 1 + (result at: var name ifPresent: #yourself ifAbsent: 0) ].	
	^ result
]
