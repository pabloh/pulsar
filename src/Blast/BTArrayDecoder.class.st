"
A BTMessageEncoder is BTArrayNode to binary encoder.
"
Class {
	#name : #BTArrayDecoder,
	#superclass : #BTNodeDecoder,
	#category : #'Blast-Decoders'
}

{ #category : #'private - decoding' }
BTArrayDecoder >> arrayLengthSize [
	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTArrayDecoder >> decode: aBitList [
	| expressions arraySize |
	arraySize := self extractArrayLengthFrom: aBitList.
	
	expressions := OrderedCollection new.
	arraySize timesRepeat: [ | itemPos itemType |
		itemType := self extractTypePrefixFrom: aBitList.
		itemPos := self extractArrayItemPositionFrom: aBitList.
		expressions addLast: ((self storageForTypePrefix: itemType) objectAt: itemPos)].
		
	^ BTArrayNode expressions: expressions
]

{ #category : #'encoding - decoding' }
BTArrayDecoder >> encode: anArrayNode [
	| arrayLengthBits |
	arrayLengthBits := self encodedArrayLengthFor:  anArrayNode.
	
	^ anArrayNode expression
		inject: arrayLengthBits
		into: [ :result :expression | 
			result	append: (self encodedTypePrefixFor: expression); 
					append: (self encodedArrayItemExpression: expression) ]
]

{ #category : #'private - encoding' }
BTArrayDecoder >> encodedArrayItemExpression: anExpressionNode [
	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTArrayDecoder >> encodedArrayLengthFor: anArrayNode [
	^ BTBitList fromInteger:
		anArrayNode statements size
]

{ #category : #'private - decoding' }
BTArrayDecoder >> extractArrayLengthFrom: aBitList [
	^ aBitList removeFirstBits: self arrayLengthSize
]
