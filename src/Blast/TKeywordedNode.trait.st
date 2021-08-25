"
A trait used to gather the common behavior of classes that have a selector and a list of arguments.
"
Trait {
	#name : #TKeywordedNode,
	#category : #'Blast-Nodes'
}

{ #category : #accessing }
TKeywordedNode >> arguments [
	self explicitRequirement
]

{ #category : #accessing }
TKeywordedNode >> keywords [
	^ self selector keywords
]

{ #category : #enumerating }
TKeywordedNode >> keywordsAndArgumentsDo: aBlock separatedBy: aSeparatorBlock [
	| firstIteration |
	firstIteration := true.
	self keywords with: self arguments do: [ :keyword :argument | 
		firstIteration 
			ifTrue: [ firstIteration := false ]
			ifFalse: [ aSeparatorBlock value ].
		aBlock value: keyword value: argument ]
]

{ #category : #printing }
TKeywordedNode >> printKeywordsAndArgumentsOn: aStream [	
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
TKeywordedNode >> selector [
	self explicitRequirement
]
