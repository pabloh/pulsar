"
A BTCascadeMessageEncoder is an encoder for cascade messages.

"
Class {
	#name : #BTCascadeMessageDecoder,
	#superclass : #BTNodeDecoder,
	#category : #'Blast-Decoders'
}

{ #category : #'private - decoding' }
BTCascadeMessageDecoder >> cascadeLengthSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTCascadeMessageDecoder >> cascadePartSize [
	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTCascadeMessageDecoder >> decode: aBitList [
	| receiverPos typePrefix receiver cascadeLength parts |
	typePrefix := self extractTypePrefixFrom: aBitList.
	receiverPos := self extractReceiverPositionFrom: aBitList.
	receiver := (self storageFor: typePrefix) objectAt: receiverPos.
	
	cascadeLength := self extractCascadeLength: aBitList.
	
	parts := OrderedCollection new.
	cascadeLength	timesRepeat: [ | cascadePartPos |
		"TODO: extract a selector when there is message send without parameters"
		cascadePartPos := self extractCascadePartPosFrom: aBitList.
		parts addLast: (self cascadePartsStorage objectAt: cascadePartPos) ].
		
	^ BTCascadeNode receiver: receiver parts: parts
]

{ #category : #'encoding - decoding' }
BTCascadeMessageDecoder >> encode: aCascadeMessageNode [
	| receiverBits cascadeLengthBits receiverTypePrefixBits |
	receiverTypePrefixBits := self encodedTypePrefixFor: aCascadeMessageNode receiver.
	receiverBits := self encodedReceiverExpression: aCascadeMessageNode receiver.
	cascadeLengthBits := self encodedCascadeLengthFor: aCascadeMessageNode.
	
	^ aCascadeMessageNode parts
		inject: (receiverTypePrefixBits append: receiverBits; append: cascadeLengthBits)
		into: [ :result :part | result append: (self encodedCascadePart: part) ]
]

{ #category : #'private - encoding' }
BTCascadeMessageDecoder >> encodedCascadeLengthFor: aCascadeMessageNode [
	^ BTBitList fromInteger:
		aCascadeMessageNode parts size
]

{ #category : #'private - encoding' }
BTCascadeMessageDecoder >> encodedCascadePart: aCascadePartNode [
	"TODO: just point to the selector when there is message send without parameters"
	^BTBitList fromInteger:
		(self cascadePartsStorage store: aCascadePartNode )
]

{ #category : #'private - encoding' }
BTCascadeMessageDecoder >> encodedReceiverExpression: anExpressionNode [

	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - decoding' }
BTCascadeMessageDecoder >> extractCascadeLengthFrom: aBitList [
	^ aBitList removeFirstBits: self cascadeLengthSize
]

{ #category : #'private - decoding' }
BTCascadeMessageDecoder >> extractCascadePartPosFrom: aBitList [
	^ aBitList removeFirstBits: self cascadePartSize
]

{ #category : #'private - decoding' }
BTCascadeMessageDecoder >> extractReceiverPositionFrom: aBitList [
	^ aBitList removeFirstBits: self receiverSize
]

{ #category : #'private - decoding' }
BTCascadeMessageDecoder >> receiverSize [
	^self wordBitsSize
]
