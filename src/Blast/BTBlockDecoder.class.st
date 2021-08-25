"
A BTBlockEncoder encodes BTBlockNode objects to binary encoder.


"
Class {
	#name : #BTBlockDecoder,
	#superclass : #BTNodeDecoder,
	#category : #'Blast-Decoders'
}

{ #category : #'private - decoding' }
BTBlockDecoder >> argListSizeFieldSize [
	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTBlockDecoder >> decode: aBitList [
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
BTBlockDecoder >> encode: aBlockNode [
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
BTBlockDecoder >> encodedArgumentListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode arguments size
]

{ #category : #'private - encoding' }
BTBlockDecoder >> encodedReturnFor: aBlockNode [
	^ BTBitList value: aBlockNode hasReturn width: 1
]

{ #category : #'private - encoding' }
BTBlockDecoder >> encodedStatementFor: anExpressionNode [
	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTBlockDecoder >> encodedStatementListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode statements size
]

{ #category : #'private - encoding' }
BTBlockDecoder >> encodedTempVarFor: aVariableNode [
	^ BTBitList fromInteger: 
		(self tempVariableNodeStorage store: aVariableNode) 
]

{ #category : #'private - encoding' }
BTBlockDecoder >> encodedTempVarListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode temporaries size
]

{ #category : #'private - decoding' }
BTBlockDecoder >> extractArgListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self argListSizeFieldSize
]

{ #category : #'private - decoding' }
BTBlockDecoder >> extractHasReturnFrom: aBitList [
	^aBitList isSetBitAt: 1
]

{ #category : #'private - decoding' }
BTBlockDecoder >> extractStatementFrom: aBitList [
	^ aBitList removeFirstBits: self statementFieldSize
]

{ #category : #'private - decoding' }
BTBlockDecoder >> extractStatementListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self statementsListSizeFieldSize
]

{ #category : #'private - decoding' }
BTBlockDecoder >> extractTempListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self temporariesListSizeFieldSize
]

{ #category : #'private - decoding' }
BTBlockDecoder >> extractTempVarPositionFrom: aBitList [
	^ aBitList removeFirstBits: self tempVariableFieldSize
]

{ #category : #'private - decoding' }
BTBlockDecoder >> statementFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTBlockDecoder >> statementsListSizeFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTBlockDecoder >> tempVariableFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTBlockDecoder >> temporariesListSizeFieldSize [
	^self wordBitsSize
]
