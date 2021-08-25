"
A BTMessageEncoder is a BTMessageNode to binary encoder.

"
Class {
	#name : #BTMessageEncoder,
	#superclass : #BTNodeEncoder,
	#category : #'Blast-Encoders'
}

{ #category : #'private - decoding' }
BTMessageEncoder >> argumentSize [

	^self wordBitsSize
]

{ #category : #'encoding - decoding' }
BTMessageEncoder >> decode: aBitList [
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
BTMessageEncoder >> encode: aMessageNode [
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
BTMessageEncoder >> encodedArgumentExpression: anExpressionNode [

	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTMessageEncoder >> encodedMessageSelector: aSelector [

	^ BTBitList fromInteger:
		(self selectorStorage store:  aSelector)
]

{ #category : #'private - encoding' }
BTMessageEncoder >> encodedReceiverExpression: anExpressionNode [

	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - decoding' }
BTMessageEncoder >> extractArgumentPositionFrom: aBitList [
	^ aBitList removeFirstBits: self argumentSize
]

{ #category : #'private - decoding' }
BTMessageEncoder >> extractReceiverPositionFrom: aBitList [
	^ aBitList removeFirstBits: self receiverSize
]

{ #category : #'private - decoding' }
BTMessageEncoder >> extractSelectorPositionFrom: aBitList [
	^ aBitList removeFirstBits: self selectorSize
]

{ #category : #'private - decoding' }
BTMessageEncoder >> receiverSize [

	^self wordBitsSize
]

{ #category : #'private - decoding' }
BTMessageEncoder >> selectorSize [

	^self wordBitsSize
]
