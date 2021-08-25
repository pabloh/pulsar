"
A BTCascadeMessageEncoder is an encoder for cascade messages parts.
"
Class {
	#name : #BTCascadePartEncoder,
	#superclass : #BTNodeEncoder,
	#category : #'Blast-Encoders'
}

{ #category : #'encoding - decoding' }
BTCascadePartEncoder >> decode: aBitList [
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
BTCascadePartEncoder >> encode: aCascadePartNode [
	| selectorBits |
	selectorBits := self encodedMessageSelector: aCascadePartNode selector.
	
	^aCascadePartNode arguments inject: selectorBits 
		into: [ :result :argument | 
			result	append: (self encodedTypePrefixFor: argument); 
					append: (self encodedArgumentExpression: argument) ]
]

{ #category : #'private - encoding' }
BTCascadePartEncoder >> encodedArgumentExpression: anExpressionNode [
	^ BTBitList fromInteger: 
		((self storageFor: anExpressionNode) store: anExpressionNode)
]

{ #category : #'private - encoding' }
BTCascadePartEncoder >> encodedMessageSelector: aSelector [

	^ BTBitList fromInteger:
		(self selectorStorage store:  aSelector)
]

{ #category : #'private - decoding' }
BTCascadePartEncoder >> extractArgumentPositionFrom: aBitList [
	^ aBitList removeFirstBits: self argumentSize
]

{ #category : #'private - decoding' }
BTCascadePartEncoder >> extractSelectorPositionFrom: aBitList [
	^ aBitList removeFirstBits: self selectorSize
]
