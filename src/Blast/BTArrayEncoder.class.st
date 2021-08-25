"
A BTMessageEncoder is BTArrayNode to binary encoder.
"
Class {
	#name : #BTArrayEncoder,
	#superclass : #BTNodeEncoder,
	#category : #'Blast-Encoders'
}

{ #category : #'private - decoding' }
BTArrayEncoder >> arrayLengthSize [
	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTArrayEncoder >> decode: aBitList [
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
BTArrayEncoder >> encode: anArrayNode [
	| arrayLengthBits |
	arrayLengthBits := self encodedArrayLengthFor:  anArrayNode.
	
	^ anArrayNode expression
		inject: arrayLengthBits
		into: [ :result :expression | 
			result	append: (self encodedTypePrefixFor: expression); 
					append: (self encodedArrayItemExpression: expression) ]
]

{ #category : #'private - encoding' }
BTArrayEncoder >> encodedArrayItemExpression: anExpressionNode [
	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTArrayEncoder >> encodedArrayLengthFor: anArrayNode [
	^ BTBitList fromInteger:
		anArrayNode statements size
]

{ #category : #'private - decoding' }
BTArrayEncoder >> extractArrayLengthFrom: aBitList [
	^ aBitList removeFirstBits: self arrayLengthSize
]
