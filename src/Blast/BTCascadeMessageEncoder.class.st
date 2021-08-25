"
A BTCascadeMessageEncoder is an encoder for cascade messages.

"
Class {
	#name : #BTCascadeMessageEncoder,
	#superclass : #BTNodeEncoder,
	#category : #'Blast-Encoders'
}

{ #category : #'private - decoding' }
BTCascadeMessageEncoder >> cascadeLengthSize [
	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTCascadeMessageEncoder >> cascadePartSize [
	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTCascadeMessageEncoder >> decode: aBitList [
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
BTCascadeMessageEncoder >> encode: aCascadeMessageNode [
	| receiverBits cascadeLengthBits receiverTypePrefixBits |
	receiverTypePrefixBits := self encodedTypePrefixFor: aCascadeMessageNode receiver.
	receiverBits := self encodedReceiverExpression: aCascadeMessageNode receiver.
	cascadeLengthBits := self encodedCascadeLengthFor: aCascadeMessageNode.
	
	^ aCascadeMessageNode parts
		inject: (receiverTypePrefixBits append: receiverBits; append: cascadeLengthBits)
		into: [ :result :part | result append: (self encodedCascadePart: part) ]
]

{ #category : #'private - encoding' }
BTCascadeMessageEncoder >> encodedCascadeLengthFor: aCascadeMessageNode [
	^ BTBitList fromInteger:
		aCascadeMessageNode parts size
]

{ #category : #'private - encoding' }
BTCascadeMessageEncoder >> encodedCascadePart: aCascadePartNode [
	"TODO: just point to the selector when there is message send without parameters"
	^BTBitList fromInteger:
		(self cascadePartsStorage store: aCascadePartNode )
]

{ #category : #'private - encoding' }
BTCascadeMessageEncoder >> encodedReceiverExpression: anExpressionNode [

	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - decoding' }
BTCascadeMessageEncoder >> extractCascadeLengthFrom: aBitList [
	^ aBitList removeFirstBits: self cascadeLengthSize
]

{ #category : #'private - decoding' }
BTCascadeMessageEncoder >> extractCascadePartPosFrom: aBitList [
	^ aBitList removeFirstBits: self cascadePartSize
]

{ #category : #'private - decoding' }
BTCascadeMessageEncoder >> extractReceiverPositionFrom: aBitList [
	^ aBitList removeFirstBits: self receiverSize
]

{ #category : #'private - decoding' }
BTCascadeMessageEncoder >> receiverSize [
	^self wordBitsSize
]
