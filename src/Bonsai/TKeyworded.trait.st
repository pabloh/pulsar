"
A trait used to gather the common behavior of classes that have a selector and a list of arguments.
"
Trait {
	#name : #TKeyworded,
	#category : #'Bonsai-Expressions'
}

{ #category : #'private-checking' }
TKeyworded classSide >> privateCheckSelector: selector arguments: arguments [ 
	(arguments size = selector numArgs) ifFalse: [ 
		self error: 
			('The selector { 1 } expects {2} arguments but {3} arguments are provided.' 
				format: {selector. selector numArgs. arguments size }) ].
]

{ #category : #accessing }
TKeyworded >> arguments [
	self explicitRequirement
]

{ #category : #accessing }
TKeyworded >> keywords [
	^ self selector keywords
]

{ #category : #enumerating }
TKeyworded >> keywordsAndArgumentsDo: aBlock [
	self keywordsAndArgumentsDo: aBlock separatedBy: nil
]

{ #category : #enumerating }
TKeyworded >> keywordsAndArgumentsDo: aBlock separatedBy: aSeparatorBlock [
	| firstIteration |
	firstIteration := true.
	self keywords with: self arguments do: [ :keyword :argument | 
		firstIteration 
			ifTrue: [ firstIteration := false ]
			ifFalse: [ aSeparatorBlock value ].
		aBlock value: keyword value: argument ]
]

{ #category : #printing }
TKeyworded >> printKeywordsAndArgumentsOn: aStream [
	self arguments isEmpty ifTrue: [ ^ aStream << self selector ].
	self 
		keywordsAndArgumentsDo:  [ :keyword :argument |
			aStream 
				<< keyword;
				space;
				print: argument ]
		separatedBy: [ aStream space ]

]

{ #category : #accessing }
TKeyworded >> selector [
	self explicitRequirement
]
