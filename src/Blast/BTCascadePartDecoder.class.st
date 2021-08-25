"
A BTCascadeMessageEncoder is an encoder for cascade messages parts.
"
Class {
	#name : #BTCascadePartDecoder,
	#superclass : #BTNodeDecoder,
	#category : #'Blast-Decoders'
}

{ #category : #'encoding - decoding' }
BTCascadePartDecoder >> decode: aBitList [
	|  selectorPos   selector arguments |

	selectorPos := self extractSelectorPositionFrom: aBitList.
	selector := self selectorStorage objectAt: selectorPos.
	
	arguments := OrderedCollection new.
	selector numArgs
		timesRepeat: [ 
			| argTypePrefix argumentPos |
			argTypePrefix := self extractTypePrefixFrom: aBitList.
			argumentPos := self extractArgumentPositionFrom: aBitList.
			arguments addLast: ((self storageForTypePrefix: argTypePrefix) objectAt: argumentPos) ].
		
	^ BTCascadePartNode selector: selector arguments: arguments
]

{ #category : #'encoding - decoding' }
BTCascadePartDecoder >> encode: aCascadePartNode [
	| selectorBits |
	selectorBits := self encodedMessageSelector: aCascadePartNode selector.
	
	^aCascadePartNode arguments inject: selectorBits 
		into: [ :result :argument | 
			result	append: (self encodedTypePrefixFor: argument); 
					append: (self encodedArgumentExpression: argument) ]
]

{ #category : #'private - encoding' }
BTCascadePartDecoder >> encodedArgumentExpression: anExpressionNode [
	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTCascadePartDecoder >> encodedMessageSelector: aSelector [

	^ BTBitList fromInteger:
		(self selectorStorage store:  aSelector)
]

{ #category : #'private - decoding' }
BTCascadePartDecoder >> extractArgumentPositionFrom: aBitList [
	^ aBitList removeFirstBits: self argumentSize
]

{ #category : #'private - decoding' }
BTCascadePartDecoder >> extractSelectorPositionFrom: aBitList [
	^ aBitList removeFirstBits: self selectorSize
]
