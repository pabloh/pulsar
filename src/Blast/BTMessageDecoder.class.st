"
A BTMessageEncoder is a BTMessageNode to binary encoder.

"
Class {
	#name : #BTMessageDecoder,
	#superclass : #BTNodeDecoder,
	#category : #'Blast-Decoders'
}

{ #category : #'private - decoding' }
BTMessageDecoder >> argumentSize [

	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTMessageDecoder >> decode: aBitList [
	| receiverPos selectorPos typePrefix receiver selector arguments |
	
	typePrefix := self extractTypePrefixFrom: aBitList.
	receiverPos := self extractReceiverPositionFrom: aBitList.
	receiver := (self storageFor: typePrefix) objectAt: receiverPos.
	
	selectorPos := self extractSelectorPositionFrom: aBitList.
	selector := self selectorStorage objectAt: selectorPos.
	
	arguments := OrderedCollection new.
	selector numArgs
		timesRepeat: [ 
			| argTypePrefix argumentPos |
			argTypePrefix := self extractTypePrefixFrom: aBitList.
			argumentPos := self extractArgumentPositionFrom: aBitList.
			arguments addLast: ((self storageForTypePrefix: argTypePrefix) objectAt: argumentPos) ].
		
	^ BTMessageNode receiver: receiver selector: selector arguments: arguments
]

{ #category : #'encoding - decoding' }
BTMessageDecoder >> encode: aMessageNode [
	| receiverBits receiverTypePrefixBits selectorBits  result |
	
	receiverTypePrefixBits := self encodedTypePrefixFor: aMessageNode receiver.
	receiverBits := self encodedReceiverExpression: aMessageNode receiver.
	
	selectorBits := self encodedMessageSelector: aMessageNode selector.
		
	result := receiverTypePrefixBits
		append: receiverBits;
		append: selectorBits.

	aMessageNode arguments do: [ :each |
		result	append: (self encodedTypePrefixFor: each);
				append: (self encodedArgumentExpression: each) ].
		
	^result.
]

{ #category : #'private - encoding' }
BTMessageDecoder >> encodedArgumentExpression: anExpressionNode [

	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTMessageDecoder >> encodedMessageSelector: aSelector [

	^ BTBitList fromInteger:
		(self selectorStorage store:  aSelector)
]

{ #category : #'private - encoding' }
BTMessageDecoder >> encodedReceiverExpression: anExpressionNode [

	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - decoding' }
BTMessageDecoder >> extractArgumentPositionFrom: aBitList [
	^ aBitList removeFirstBits: self argumentSize
]

{ #category : #'private - decoding' }
BTMessageDecoder >> extractReceiverPositionFrom: aBitList [
	^ aBitList removeFirstBits: self receiverSize
]

{ #category : #'private - decoding' }
BTMessageDecoder >> extractSelectorPositionFrom: aBitList [
	^ aBitList removeFirstBits: self selectorSize
]

{ #category : #'private - decoding' }
BTMessageDecoder >> receiverSize [

	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTMessageDecoder >> selectorSize [

	^self wordBitsSize
]
