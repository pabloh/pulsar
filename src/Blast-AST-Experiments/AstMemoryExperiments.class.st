"
An AstMemoryProfile is a class for helping profiling AST memory footpring.

"
Class {
	#name : 'AstMemoryExperiments',
	#superclass : 'Object',
	#classInstVars : [
		'browserEnvironment',
		'methodsSource',
		'methodsAsts',
		'methodsBonsaiAsts'
	],
	#category : 'Blast-AST-Experiments',
	#package : 'Blast-AST-Experiments'
}

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allClassesTraitsAndMetaClasesDo: aBlock [

	^ Smalltalk globals allBehaviorsDo: aBlock 
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allClassesTraitsAndMetaClasses [
	"There is no similar method at RBBrowserEnvironment 
		(also RBBrowserEnvironment>>allMetaClasses seems to be broken)"

	^ Smalltalk globals allBehaviors
]

{ #category : 'comments' }
AstMemoryExperiments class >> allCommentsCount [
	|count|
	
	count := 0.

	self nodesWithComments do: [:set| 
		set do: [ :node| 
			count := count + node comments size ] ].

	^count.
]

{ #category : 'comments' }
AstMemoryExperiments class >> allCommentsLength [
	|length|
	
	length := 0.

	self nodesWithComments do: [:set| 
		set do: [ :node|
			node comments do: [:comment | 
				length := length + comment last - comment first + 1 ] ] ].
	
	^length.
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allDefinedMethods [
	|res|
	res := OrderedCollection new: self allDefinedMethodsCount .
	self allDefinedMethodsDo: [ :aMethod | res add: aMethod ].
	^ res
	
	"^ self allClassesTraitsAndMetaClasses flatCollect: [ :class | class methodDict ] as: OrderedCollection"
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allDefinedMethodsCount [
	|result|
	result := 0.	
	self allDefinedMethodsDo: [ result := result + 1 ].
	^ result
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allDefinedMethodsDo: aBlock [
	self allClassesTraitsAndMetaClasesDo: [ :aBehavior | 
		aBehavior methodDictionary do: [ :aMethod |
			aMethod isFromTrait ifFalse: [ aBlock cull: aMethod ]
	]
]
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> allIdentifiersNames [
	"Instance variables, local variables and selectors names"
	|identifiers|
	identifiers := Set new.

	self selectorsByArity do: [:values| identifiers addAll: values ].
	identifiers	addAll: self tempVariablesNames; 
	 			addAll: self instanceVariablesNames.

	^identifiers
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allMethodsAsts [
	|res|
	res := OrderedCollection new: self allDefinedMethodsCount .
	self allMethodsAstsDo: [ :aMethod | res add: aMethod ].
	^ res
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allMethodsAstsDo: aBlock [
	self allDefinedMethods do: [ :aMethod |  
		aBlock cull: (OCParser parseMethod: aMethod  sourceCode)
	]
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allMethodsIncluding: aLiteralKind [
	^ self countMethodsMatching: (self literalsPatterns at: aLiteralKind)
]

{ #category : 'nodes' }
AstMemoryExperiments class >> allMethodsNodeCount [
	|count|	
	count := 0.

	self allMethodsAstsDo: [ :ast |
		AstNodeProcessor forEachNodeAt: ast do: [
			count := count + 1 ] ].
	
	^ count
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> allMethodsSizeInMemory [
	|res|
	res :=0.
	
	self allMethodsAstsDo: [ :ast |  	res := res + (AstSizeInMemoryVisitor sizeInMemoryFor: ast)	].
			
	^res
	
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allSourceCodeSizeInMemory [
	|result|
	result := 0.	
	self allDefinedMethodsDo: [ :aMethod  |
		result := result + aMethod sourceCode sizeInMemory 
	].
	^ result
]

{ #category : 'classes and traits' }
AstMemoryExperiments class >> allSourceCodeZippedSizeInMemory [
	|result|
	result := 0.	
	self allDefinedMethodsDo: [ :aMethod  |
		result := result + aMethod sourceCode zipped sizeInMemory 
	].
	^ result
]

{ #category : 'assignments' }
AstMemoryExperiments class >> assignments [	
	^ self allDefinedMethods flatCollect: [ :method |  
		AstNodeProcessor collectNodesThat: #isAssignment at: method ast ]
]

{ #category : 'assignments' }
AstMemoryExperiments class >> assignmentsCount [
	^ self assignments size
]

{ #category : 'nodes' }
AstMemoryExperiments class >> avgNodesPerMethod [
	
	^(self allMethodsNodeCount / self allMethodsCount) printShowingDecimalPlaces: 5 
]

{ #category : 'sequences' }
AstMemoryExperiments class >> blockNodesByReturn [
	| blocks |
	blocks := OrderedCollection new.
	
	self allDefinedMethods do: [ :method |
		blocks addAll: (AstNodeProcessor collectNodesThat: #isBlock at: method ast) ].

	^ blocks groupedBy: [ :m| m lastIsReturn ]
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> clearMethodsStructures [
	methodsSource := nil.
	methodsAsts := nil.
	methodsBonsaiAsts := nil.
	
	FWFlyweightNode resetAllCaches.
]

{ #category : 'literals' }
AstMemoryExperiments class >> countAndPercentagesForLiteralsAtMethodsFor: aLiteralKind [

	^  self countAndPercentangesFor: (self countLiteralsAtMethodsFor: aLiteralKind) using: self allMethodsCount.
]

{ #category : 'comments' }
AstMemoryExperiments class >> countAndPercentagesForMethodsWithComments [

	^ self countAndPercentangesFor: self countMethodsWithComments using: self allMethodsCount.
	
]

{ #category : 'helper methods' }
AstMemoryExperiments class >> countAndPercentangesAcumulatedFor: aDictionary [


	^self countAndPercentangesAcumulatedFor: aDictionary using: (aDictionary values sum)
]

{ #category : 'helper methods' }
AstMemoryExperiments class >> countAndPercentangesAcumulatedFor: aDictionary groupedBy: aBlock [
	| groupedDictionary |
	groupedDictionary := (aDictionary groupedBy: aBlock) collect: #size.

	^self countAndPercentangesAcumulatedFor: groupedDictionary using: (groupedDictionary values sum)
]

{ #category : 'helper methods' }
AstMemoryExperiments class >> countAndPercentangesAcumulatedFor: aDictionary using: aTotal [
|acum|
acum := 0.

	^aDictionary collect: [:count| acum := count + acum. 
		{count. (count / aTotal * 100) printShowingDecimalPlaces: 5. (acum / aTotal * 100) printShowingDecimalPlaces: 5 } ]
]

{ #category : 'helper methods' }
AstMemoryExperiments class >> countAndPercentangesAcumulatedOrderedFor: aDictionary [
	| list |
	
	list := aDictionary associations sort: [ :a :b | a value > b value ].

	^ (list collect: #key)
		with: (self countAndPercentangesAcumulatedFor: (list collect: #value) using: (list sum: #value)) 
		collect: [ :k :v| k -> v ] 
]

{ #category : 'helper methods' }
AstMemoryExperiments class >> countAndPercentangesFor: aDictionary [

	^ self countAndPercentangesFor: aDictionary using: (aDictionary values sum)
]

{ #category : 'helper methods' }
AstMemoryExperiments class >> countAndPercentangesFor: aDictionary using: aTotal [

	^aDictionary collect: [:count| {count. (count / aTotal * 100) printShowingDecimalPlaces: 5 } ]
]

{ #category : 'literals' }
AstMemoryExperiments class >> countLiteralsAtMethodsFor: aLiteralKind [

	^ (self allMethodsIncluding: aLiteralKind) collect: [ :dict | dict size ]
]

{ #category : 'literals' }
AstMemoryExperiments class >> countLiteralsByValueFor: aLiteralKind [

	^((AstMemoryExperiments nodesMatching: (AstMemoryExperiments literalsPatterns at: aLiteralKind ))
		groupedBy: [ :node | node value ]) collect: [:set | set size ]
]

{ #category : 'literals' }
AstMemoryExperiments class >> countMethodsMatching: aSourcePattern [
	| counter |
	^ self allDefinedMethods
		groupedBy: [ :method | 
			counter := 0.
			RBParseTreeSearcher new
				matches: aSourcePattern do: [ :node :owner | counter := counter + 1 ];
				executeTree: method ast.
			counter ]
]

{ #category : 'comments' }
AstMemoryExperiments class >> countMethodsWithComments [

	^self methodsWithComments collect: [:methods| methods size ]
]

{ #category : 'nodes' }
AstMemoryExperiments class >> countNodesMatching: aSourcePattern [
	|result|
	result := 0.

	self allDefinedMethods do: [ :method | 
			RBParseTreeSearcher new
				matches: aSourcePattern do: [ :node :owner | result := result + 1 ];
				executeTree: method ast ].
	^ result 
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> instanceVariablesClasses [
	| varNames |
	varNames := Dictionary new.
	
	AstMemoryExperiments
		allClassesTraitsAndMetaClasesDo: [ :klass |
			klass isClass
				ifTrue: [
					(klass instanceVariables ifNil: [ #() ])
						do: [ :varName | (varNames at: varName asSymbol ifAbsentPut: [ OrderedCollection new ]) addLast: klass ] ] ].
	^ varNames
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> instanceVariablesNames [
|varNames|
varNames := Set new.

AstMemoryExperiments allClassesTraitsAndMetaClasesDo: [:klass| 
	klass isClass ifTrue: [ 
		(klass instanceVariables ifNil: [ #() ]) do: [:varName|			
			varNames add: varName asSymbol ] ] ].

^ varNames
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> instanceVariablesRepetition [
	| varNames |
	varNames := self uniqInstanceVariables.
	^ varNames keys groupedBy: [ :key | (varNames at: key) size ]
]

{ #category : 'literals - integers' }
AstMemoryExperiments class >> integerNodesByBase [

	^ (self nodesMatching: (self literalsPatterns at: #integers)) 
		groupedBy: [ :node| 
			|rPos source|
			source := node token source. 
			rPos := source indexOf: $r.
		
			rPos isZero 
				ifTrue: [ #default ]
				ifFalse: [ 
					source first = $-			
						ifTrue: [ source := source allButFirst.  rPos := rPos -1 ].
					source first: (rPos - 1) ] ].
]

{ #category : 'literals - integers' }
AstMemoryExperiments class >> integerNodesByBaseCountAndPercentages [
	| totalIntegerNodes |
	totalIntegerNodes := self countNodesMatching: (self literalsPatterns at: #integers).

	^ self countAndPercentangesFor: (self integerNodesByBase collect: [:set| set size]) using: totalIntegerNodes.
	
	
]

{ #category : 'helper methods' }
AstMemoryExperiments class >> literalsPatterns [
	^ Dictionary new
		add: #literals				->	'`{:node | node isLiteralNode and: [ node isLiteralArray not ] }';
		add: #decimals				->	'`{:node | node isLiteralNode and: [ node value isKindOf: ScaledDecimal ] }';
		add: #floats				->	'`{:node | node isLiteralNode and: [ node value isFloat ] }';
		add: #strings			 	->	'`{:node | node isLiteralNode and: [ node value isString ] }';
		add: #integers			 	->	'`{:node | node isLiteralNode and: [ node value isInteger ] }';
		add: #integers_with_nsz	->	'`{:node | ((node isLiteralNode and: [ node value isInteger ]) and: [ (node value ~= 0) or: [ node token source size > 1 ] ]) and: [ node token source first = $0 ] }';
		add: #based_integers		->	'`{:node | (node isLiteralNode and: [ node value isInteger ]) and: [ node token source  includes: $r ] }';
		add: #symbols			 	->	'`{:node | node isLiteralNode and: [ node value isSymbol ] }';
		yourself
]

{ #category : 'literals' }
AstMemoryExperiments class >> literalsPercentagesAtMethodsFor: aLiteralKind [
	| total  |	
	total := self allMethodsCount.

	^ (self countLiteralsAtMethodsFor: aLiteralKind) collect: [:count | (100 * count / total) printShowingDecimalPlaces: 5 ]
]

{ #category : 'nodes' }
AstMemoryExperiments class >> medianNodesPerMethod [
	|nodeCounts|
	
	^  nodeCounts at: (nodeCounts size) / 2 "TODO"
]

{ #category : 'messages' }
AstMemoryExperiments class >> messagesByArity [
	| messages |
	messages := Dictionary new.
	
	"self allMethods do: [ :method |  
		AstNodeProcessor forEachNodeThat: #isMessage at: method ast do: [ :each |
			(messages at: each numArgs ifAbsentPut: [ OrderedCollection new ])
				addLast: each ] ]."
		
	self allMethodsAstsDo: [ :ast |  
		AstNodeProcessor forEachNodeThat: #isMessage at: ast do: [ :each |
			(messages at: each numArgs ifAbsentPut: [ OrderedCollection new ])
				addLast: each ] ].

	^ messages
]

{ #category : 'messages' }
AstMemoryExperiments class >> messagesByArityCount [
	^ (self messagesByArity collect: #size) associations sorted: [ :a1 :a2 | a1 key <= a2 key ]

]

{ #category : 'sequences' }
AstMemoryExperiments class >> methodBodiesByReturn [
	^ self allDefinedMethods groupedBy: [ :m| m ast lastIsReturn ]
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> methodsAsts [
	^methodsAsts
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> methodsBonsaiAsts [
	^methodsBonsaiAsts
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> methodsSource [
	^methodsSource
]

{ #category : 'comments' }
AstMemoryExperiments class >> methodsWithComments [

	^ self allDefinedMethods
		groupedBy: [ :aMethod | AstNodeProcessor countNodesThat: [:aNode| aNode comments isNotEmpty ] at: aMethod ast ]
]

{ #category : 'nodes' }
AstMemoryExperiments class >> nodesAtMethodsMatching: aSourcePattern [
	^ self allDefinedMethods
		collect: [ :method | 
			|nodes|
			nodes := OrderedCollection new.
			
			RBParseTreeSearcher new
				matches: aSourcePattern do: [ :node :owner | nodes add: nodes ];
				executeTree: method ast.
			nodes ]
		thenReject: [ :nodes| nodes isEmpty ]
]

{ #category : 'nodes' }
AstMemoryExperiments class >> nodesMatching: aSourcePattern [
	^ self allDefinedMethods 
		flatCollect: [ :method | 
			|result|
			result := OrderedCollection new.
			RBParseTreeSearcher new
				matches: aSourcePattern do: [ :node :owner | result add: node ];
				executeTree: method ast.
			result ] as: IdentitySet
]

{ #category : 'comments' }
AstMemoryExperiments class >> nodesWithComments [

	^ self allDefinedMethods
		collect: [ :aMethod | AstNodeProcessor collectNodesThat: [:aNode| aNode comments isNotEmpty ] at: aMethod ast ]
		thenReject: [: nodes| nodes isEmpty ]
]

{ #category : 'literals' }
AstMemoryExperiments class >> percentagesForLiteralsAtMethodsFor: aLiteralKind [
	| total  |	
	total := self allMethodsCount.

	^ (self countLiteralsAtMethodsFor: aLiteralKind) collect: [:count | (100 * count / total) printShowingDecimalPlaces: 5 ]
]

{ #category : 'comments' }
AstMemoryExperiments class >> percentagesForMethodsWithComments [
	| total |	
	total := self allMethodsCount.

	^self countMethodsWithComments collect: [:count | (100 * count / total) printShowingDecimalPlaces: 5 ]

]

{ #category : 'pragmas' }
AstMemoryExperiments class >> pragmasUsageByArity [
	| pragmas |
	pragmas := OrderedCollection new.

	self allClassesTraitsAndMetaClasesDo: [:klass|
		klass methodDict values do: [ :method|
			pragmas addAll: method pragmas ] ].
	
	^ pragmas groupedBy: #numArgs
]

{ #category : 'pragmas' }
AstMemoryExperiments class >> pragmasUsageByArityCount [

	^ self pragmasUsageByArity collect: #size
]

{ #category : 'pragmas' }
AstMemoryExperiments class >> pragmasUsageByArityCountAndPercentanges [

	^ self countAndPercentangesFor: self pragmasUsageByArityCount.
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> removeMethodsAstsAtTheImage [
	methodsAsts  := OrderedCollection new.
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> removeMethodsSourceAtTheImage [
	methodsSource := OrderedCollection new.
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> saveMethodsAstsAtTheImage [
	methodsAsts := OrderedCollection new: self allDefinedMethodsCount.
	
	self allMethodsAstsDo: [ :ast | methodsAsts add: ast  ]
	
	
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> saveMethodsAstsAtTheImageWithNoComments [
	methodsAsts := OrderedCollection new: self allDefinedMethodsCount.
	
	self allMethodsAstsDo: [ :ast |		
		AstNodeProcessor  clearComments: ast.
		methodsAsts add: ast 
	]
	
	
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> saveMethodsBonsaiAstsAtTheImage [
	methodsBonsaiAsts := OrderedCollection new: self allDefinedMethodsCount.

	methodsBonsaiAsts addAll: (self allDefinedMethods collect: [ :aMethod |	
		FWEncoder new visitNode: aMethod ast
	])
]

{ #category : 'souce code space' }
AstMemoryExperiments class >> saveMethodsSourceAtTheImage [
	methodsSource := OrderedCollection new: self allDefinedMethodsCount .
	
	self allDefinedMethodsDo: [ :aMethod | methodsSource add: aMethod sourceCode ]
]

{ #category : 'selectors' }
AstMemoryExperiments class >> selectorsByArity [
	| selectors |
	selectors := Set new.

	self allClassesTraitsAndMetaClasesDo: [:klass| 
		selectors addAll: klass methodDict  keys ].

	^ selectors groupedBy: #numArgs
]

{ #category : 'selectors' }
AstMemoryExperiments class >> selectorsByArityCount [
	^ self selectorsByArity collect: #size
]

{ #category : 'selectors' }
AstMemoryExperiments class >> selectorsByArityCountAndPercetanges [
	| selsCounts|
	selsCounts := self selectorsByArityCount.

	^ self countAndPercentangesFor: selsCounts.
]

{ #category : 'selectors' }
AstMemoryExperiments class >> selectorsByUsage [
	| selectors |
	selectors := Dictionary new.
	
	self allDefinedMethods do: [ :method |  
		AstNodeProcessor forEachNodeThat: #isMessage at: method ast do: [ :aMessageNode |
			selectors 	at: aMessageNode selector
						put: (selectors at: aMessageNode selector ifPresent: [ :value | value + 1 ] ifAbsent: [ 1 ] ) ] ].

	^ selectors
]

{ #category : 'selectors' }
AstMemoryExperiments class >> selectorsByUsageSorted [		
	^ self selectorsByUsage associations sort: [ :a1 :a2 | a1 value > a2 value]
]

{ #category : 'sequences' }
AstMemoryExperiments class >> sequencesByLength [
	| sequences |
	sequences := Dictionary new.
	
	self allDefinedMethods do: [ :method |  
		AstNodeProcessor forEachNodeThat: #isSequence at: method ast do: [ :each |
			(sequences at: each statements size ifAbsentPut: [ OrderedCollection new ])
				addLast: each ] ].

	^ sequences
]

{ #category : 'sequences' }
AstMemoryExperiments class >> sequencesByLengthCount [

	^ self sequencesByLength collect: #size
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> tempVariablesNames [

	^self tempVariablesRepetition inject: Set new into: [ :res :vars |  res addAll: vars. res ]
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> tempVariablesRepetition [
	| uniqVars |
	uniqVars := self uniqTempVariables.
	^uniqVars keys groupedBy: [ :key| uniqVars at: key ]
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> uniqInstanceVariables [

	^ self instanceVariablesClasses collect: #size
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> uniqTempVariables [
	|tempVars|
	tempVars := OrderedCollection new.
	
	AstMemoryExperiments allDefinedMethods do: [:aCompiledMethod|
		|aMethod|
		aMethod := aCompiledMethod ast.
		tempVars addAll: aMethod argumentNames;
				    addAll: aMethod temporaryNames.

		AstNodeProcessor forEachNodeAt: aMethod do: [:aNode|
			aNode isBlock ifTrue: [
				tempVars 	addAll: aNode argumentNames;
							addAll: aNode temporaryNames ] ] ].

	^(tempVars groupedBy: #yourself) collect: #size.
]

{ #category : 'identifiers' }
AstMemoryExperiments class >> variableNamesRepetition [
	| uniqVars |
	uniqVars := self uniqTempVariables.
	self uniqInstanceVariables keysAndValuesDo: [ :key :value |
		uniqVars at: key put: (uniqVars at: key ifAbsent: [ 0 ]) + value ].
		
	^uniqVars keys groupedBy: [ :key| uniqVars at: key ]
]
