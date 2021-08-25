"
A BTBlockEncoder encodes BTBlockNode objects to binary encoder.


"
Class {
	#name : #BTBlockEncoder,
	#superclass : #BTNodeEncoder,
	#category : #'Blast-Encoders'
}

{ #category : #'private - decoding' }
BTBlockEncoder >> argListSizeFieldSize [
	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTBlockEncoder >> decode: aBitList [
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
BTBlockEncoder >> encode: aBlockNode [
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
BTBlockEncoder >> encodedArgumentListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode arguments size
]

{ #category : #'private - encoding' }
BTBlockEncoder >> encodedReturnFor: aBlockNode [
	^ BTBitList value: aBlockNode hasReturn width: 1
]

{ #category : #'private - encoding' }
BTBlockEncoder >> encodedStatementFor: anExpressionNode [
	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTBlockEncoder >> encodedStatementListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode statements size
]

{ #category : #'private - encoding' }
BTBlockEncoder >> encodedTempVarFor: aVariableNode [
	^ BTBitList fromInteger: 
		(self tempVariableNodeStorage store: aVariableNode) 
]

{ #category : #'private - encoding' }
BTBlockEncoder >> encodedTempVarListLengthFor: aBlockNode [
	^ BTBitList fromInteger: 
		aBlockNode temporaries size
]

{ #category : #'private - decoding' }
BTBlockEncoder >> extractArgListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self argListSizeFieldSize
]

{ #category : #'private - decoding' }
BTBlockEncoder >> extractHasReturnFrom: aBitList [
	^aBitList isSetBitAt: 1
]

{ #category : #'private - decoding' }
BTBlockEncoder >> extractStatementFrom: aBitList [
	^ aBitList removeFirstBits: self statementFieldSize
]

{ #category : #'private - decoding' }
BTBlockEncoder >> extractStatementListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self statementsListSizeFieldSize
]

{ #category : #'private - decoding' }
BTBlockEncoder >> extractTempListSizeFrom: aBitList [
	^ aBitList removeFirstBits: self temporariesListSizeFieldSize
]

{ #category : #'private - decoding' }
BTBlockEncoder >> extractTempVarPositionFrom: aBitList [
	^ aBitList removeFirstBits: self tempVariableFieldSize
]

{ #category : #'private - decoding' }
BTBlockEncoder >> statementFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTBlockEncoder >> statementsListSizeFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTBlockEncoder >> tempVariableFieldSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTBlockEncoder >> temporariesListSizeFieldSize [
	^self wordBitsSize
]
