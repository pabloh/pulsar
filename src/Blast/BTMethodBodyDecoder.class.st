"
A BTBlockEncoder encodes BTBlockNode objects to binary encoder.


"
Class {
	#name : #BTMethodBodyDecoder,
	#superclass : #BTNodeDecoder,
	#category : #'Blast-Decoders'
}

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> argListSizeFieldSize [
	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTMethodBodyDecoder >> decode: aBitList [
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
BTMethodBodyDecoder >> encode: aBlockNode [
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
BTMethodBodyDecoder >> encodedArgumentListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode arguments size
]

{ #category : #'private - encoding' }
BTMethodBodyDecoder >> encodedReturnFor: aBlockNode [
	^ BTBitList value: aBlockNode hasReturn width: 1
]

{ #category : #'private - encoding' }
BTMethodBodyDecoder >> encodedStatementFor: anExpressionNode [
	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTMethodBodyDecoder >> encodedStatementListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode statements size
]

{ #category : #'private - encoding' }
BTMethodBodyDecoder >> encodedTempVarFor: aVariableNode [
	^ BTBitList fromInteger: 
		(self tempVariableNodeStorage store: aVariableNode) 
]

{ #category : #'private - encoding' }
BTMethodBodyDecoder >> encodedTempVarListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode temporaries size
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> extractArgListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self argListSizeFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> extractHasReturnFrom: aBitList [
	^aBitList isSetBitAt: 1
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> extractStatementFrom: aBitList [
	^ aBitList removeFirstBits: self statementFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> extractStatementListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self statementsListSizeFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> extractTempListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self temporariesListSizeFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> extractTempVarPositionFrom: aBitList [
	^ aBitList removeFirstBits: self tempVariableFieldSize
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> statementFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> statementsListSizeFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> tempVariableFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTMethodBodyDecoder >> temporariesListSizeFieldSize [
	^self wordBitsSize
]
