"
A BTNodeProcessor is an object that manipulates stored Blast AST nodes.

Instance Variables
	storageDirectory:		<Object>

storageDirectory
	- xxxxx

"
Class {
	#name : #BTNodeProcessor,
	#superclass : #Object,
	#instVars : [
		'storageDirectory',
		'binaryFormat'
	],
	#category : #'Blast-Core'
}

{ #category : #'instance creation' }
BTNodeProcessor class >> using: aStorageDirectory [
	^self basicNew
		storageDirectory: aStorageDirectory;
		yourself
]

{ #category : #'binary format' }
BTNodeProcessor >> binaryFormatClass [
	self subclassResponsibility 
]

{ #category : #storages }
BTNodeProcessor >> cascadePartsStorage [
	^ storageDirectory assignmentNodeStorage
]

{ #category : #'private - encoding' }
BTNodeProcessor >> encodedTypePrefixFor: anExpressionNode [
	^ BTBitList value: (self typePrefixFor: anExpressionNode) width: self typePrefixSize
]

{ #category : #'private - decoding' }
BTNodeProcessor >> extractTypePrefixFrom: aBitList [
	^ aBitList removeFirstBits: self typePrefixSize
]

{ #category : #initialization }
BTNodeProcessor >> initialize [
	storageDirectory := BTNodeStorageDirectory default.
]

{ #category : #storages }
BTNodeProcessor >> literalStorage [
	^ storageDirectory literalNodeStorage
]

{ #category : #storages }
BTNodeProcessor >> pragmaSelectorStorage [
	^ storageDirectory pragmaSelectorStorage
]

{ #category : #accessing }
BTNodeProcessor >> result [
	^ result
]

{ #category : #storages }
BTNodeProcessor >> selectorStorage [
	^ storageDirectory selectorStorage 
]

{ #category : #accessing }
BTNodeProcessor >> storageDirectory [
	^ storageDirectory
]

{ #category : #accessing }
BTNodeProcessor >> storageDirectory: anObject [
	storageDirectory := anObject
]

{ #category : #storages }
BTNodeProcessor >> storageFor: aNode [
	^ aNode storageAt: storageDirectory
]

{ #category : #'private - type prefixes' }
BTNodeProcessor >> storageForTypePrefix: aPrefixType [
	^ self shouldBeImplemented.
]

{ #category : #storages }
BTNodeProcessor >> tempVariableStogare [
	^ storageDirectory tempVariableNodeStorage
]

{ #category : #'private - type prefixes' }
BTNodeProcessor >> typePrefixFor: aNode [
	^ self shouldBeImplemented
]

{ #category : #'private - field sizes' }
BTNodeProcessor >> typePrefixSize [
	^ 3.
]

{ #category : #storages }
BTNodeProcessor >> unaryPragmaNodeStorage [
	^ storageDirectory unaryPragmaNodeStorage
]

{ #category : #storages }
BTNodeProcessor >> variableStogare [
	^ storageDirectory variableNodeStorage
]

{ #category : #'private - field sizes' }
BTNodeProcessor >> wordBitsSize [
	^ Smalltalk wordSize * 8 "bits per byte"
]
