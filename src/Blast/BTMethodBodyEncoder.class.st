"
A BTBlockEncoder encodes BTBlockNode objects to binary encoder.


"
Class {
	#name : #BTMethodBodyEncoder,
	#superclass : #BTNodeEncoder,
	#category : #'Blast-Encoders'
}

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> argListSizeFieldSize [
	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTMethodBodyEncoder >> decode: aBitList [
	| argumentList temporaryList statementList hasReturn tempListSize argListSize statementListSize |
	
	hasReturn := self extractHasReturnFrom: aBitList.
	argListSize := self extractArgListSizeFrom: aBitList.
	tempListSize := self extractTempListSizeFrom: aBitList.
	statementListSize := self extractStatementListSizeFrom: aBitList.
	
	argumentList := OrderedCollection new.
	argListSize timesRepeat: [ |tempVarPos|
		tempVarPos := self extractTempVarPositionFrom: aBitList.
		argumentList addLast: (self tempVariableStogare objectAt: tempVarPos ) ].
	
	temporaryList := OrderedCollection new.
	tempListSize timesRepeat: [ | tempVarPos |
		tempVarPos := self extractTempVarPositionFrom: aBitList.
		tempListSize addLast: (self tempVariableStogare objectAt: tempVarPos ) ].
		
	statementList := OrderedCollection new.
	statementListSize timesRepeat: [ | statementType statementPos |
		statementType := self extractTypePrefixFrom: aBitList.
		statementPos := self extractStatementFrom: aBitList.
		statementList addLast: ((self storageForTypePrefix: statementType) objectAt: statementPos ) ].
	
	^ BTBlockNode arguments: argumentList 
		temporaries: temporaryList 
		statements: statementList
		hasReturn: hasReturn
]

{ #category : #'encoding - decoding' }
BTMethodBodyEncoder >> encode: aBlockNode [
	| result |

	result := BTBitList new	
		append: (self encodedReturnFor: aBlockNode);
		append: (self encodedArgumentListLengthFor: aBlockNode);
		append: (self encodedTempVarListLengthFor: aBlockNode);
		append: (self encodedStatementListLengthFor: aBlockNode).
	
	aBlockNode arguments do: [ :variable | result append: (self encodedTempVarFor: variable) ].
	aBlockNode temporaries do: [ :variable | result append: (self encodedTempVarFor: variable) ].
	aBlockNode statements do: [ :statement | 
		result append: (self encodedTypePrefixFor: statement);
			append: (self encodedStatementFor: statement) ].
	
	^ result
]

{ #category : #'private - encoding' }
BTMethodBodyEncoder >> encodedArgumentListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode arguments size
]

{ #category : #'private - encoding' }
BTMethodBodyEncoder >> encodedReturnFor: aBlockNode [
	^ BTBitList value: aBlockNode hasReturn width: 1
]

{ #category : #'private - encoding' }
BTMethodBodyEncoder >> encodedStatementFor: anExpressionNode [
	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTMethodBodyEncoder >> encodedStatementListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode statements size
]

{ #category : #'private - encoding' }
BTMethodBodyEncoder >> encodedTempVarFor: aVariableNode [
	^ BTBitList fromInteger: 
		(self tempVariableNodeStorage store: aVariableNode) 
]

{ #category : #'private - encoding' }
BTMethodBodyEncoder >> encodedTempVarListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode temporaries size
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> extractArgListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self argListSizeFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> extractHasReturnFrom: aBitList [
	^aBitList isSetBitAt: 1
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> extractStatementFrom: aBitList [
	^ aBitList removeFirstBits: self statementFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> extractStatementListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self statementsListSizeFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> extractTempListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self temporariesListSizeFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> extractTempVarPositionFrom: aBitList [
	^ aBitList removeFirstBits: self tempVariableFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> statementFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> statementsListSizeFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> tempVariableFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTMethodBodyEncoder >> temporariesListSizeFieldSize [
	^self wordBitsSize
]
