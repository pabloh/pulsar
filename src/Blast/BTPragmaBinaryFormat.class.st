Class {
	#name : #BTPragmaBinaryFormat,
	#superclass : #BTNodeBinaryFormat,
	#category : #'Blast-BinaryFormats'
}

{ #category : #'format selection' }
BTPragmaBinaryFormat class >> defaultFormat [
	^ BTDefaultPragmaBinaryFormat
]

{ #category : #decoding }
BTPragmaBinaryFormat >> decodeArgumentsIndexesFor: numArgs [
	(1 to: numArgs) collect: [ :idx |
		self literalsPacker extractThenUnpackFrom: bitList ]
]

{ #category : #encoding }
BTPragmaBinaryFormat >> encodeArguments: argumentsIndexes [
	argumentsIndexes do: [ :each | self literalsPacker pack: each into: bitList ]
]

{ #category : #decoding }
BTPragmaBinaryFormat >> removeHeader [	
	bitList removeFirstBits: 1
]
