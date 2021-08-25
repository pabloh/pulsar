"
A BonsaiExperiments is a class consisting of AST memory footpring making use of the Bonsai framework.
"
Class {
	#name : #BSExperiments,
	#superclass : #Object,
	#category : #ASTProfile
}

{ #category : #nodes }
BSExperiments class >> allUniqueNodesByClass [
	^ (BSFlyweightNode subclasses collect: [:class | class  -> class cache ] ) asDictionary
]

{ #category : #nodes }
BSExperiments class >> allUniqueNodesByClassCountAndPercentages [
	^ AstMemoryExperiments countAndPercentangesFor: (self allUniqueNodesByClass collect: #size)
]

{ #category : #'nodes iteration' }
BSExperiments class >> eachBSNodeThat: aCondition do: aBlock [
	AstMemoryExperiments methodsBonsaiAsts do: [ :methodNode |
		BSNodeProcessor forEachNodeThat: aCondition at: methodNode do: aBlock ]
]

{ #category : #messages }
BSExperiments class >> messagesByArity [
	^ BSMessageNode cache groupedBy: [ :node | node selector numArgs ]
]

{ #category : #messages }
BSExperiments class >> messagesByArityCountAndPercentanges [
	^ AstMemoryExperiments countAndPercentangesFor: (self messagesByArity collect: #size)
	
]

{ #category : #messages }
BSExperiments class >> messagesByArityCountAndPercentangesAcumulated [
	^ AstMemoryExperiments countAndPercentangesAcumulatedFor: (self messagesByArity collect: #size)
	
]

{ #category : #selectors }
BSExperiments class >> selectorsByArity [
	^ (BSMessageNode cache collect: #selector) groupedBy: #numArgs
]

{ #category : #selectors }
BSExperiments class >> selectorsByArityCount [
	^ self selectorsByArity collect: #size
]

{ #category : #selectors }
BSExperiments class >> selectorsByArityCountAndPercentages [
	^ AstMemoryExperiments countAndPercentangesFor: (self selectorsByArityCount)
]

{ #category : #variables }
BSExperiments class >> tempVariablesFrecuency [
	| result addVars |
	result := Dictionary new.
	addVars := [ :var| result at: var name put: 1 + (result at: var name ifPresent: #yourself ifAbsent: 0) ] .
	
	BSBlockNode cache do: [ :block | block temporaries do: addVars ].
	^ result
]

{ #category : #variables }
BSExperiments class >> tempVariablesNames [

	^ BSBlockNode cache 
		inject: Set new
		into: [ :result :block | result addAll: (block temporaries collect: #name) ; yourself ].
]

{ #category : #variables }
BSExperiments class >> variablesFrecuency [
	| result  |
	result := Dictionary new.
	
	self eachBSNodeThat: #isVariableNode do:  [ :var |
		result at: var name put: 1 + (result at: var name ifPresent: #yourself ifAbsent: 0) ].	
	^ result
]
