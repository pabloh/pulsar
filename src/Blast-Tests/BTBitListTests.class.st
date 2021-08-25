"
A BTBitListTests is xxxxxxxxx.

Instance Variables
	bitList:		<Object>
	bitList023:		<Object>
	bitList23:		<Object>
	bitList5:		<Object>
	bitList7:		<Object>
	bitListb01:		<Object>
	bitListb11:		<Object>
	emptyBitList:		<Object>

bitList
	- xxxxx

bitList023
	- xxxxx

bitList23
	- xxxxx

bitList5
	- xxxxx

bitList7
	- xxxxx

bitListb01
	- xxxxx

bitListb11
	- xxxxx

emptyBitList
	- xxxxx

"
Class {
	#name : #BTBitListTests,
	#superclass : #TestCase,
	#instVars : [
		'bitList5',
		'bitList',
		'bitList23',
		'bitList7',
		'bitList023',
		'emptyBitList',
		'bitListb01',
		'bitListb11',
		'bitListb0',
		'bitListb1'
	],
	#classInstVars : [
		'bitList'
	],
	#category : #'Blast-Tests'
}

{ #category : #running }
BTBitListTests >> setUp [

	bitList := BTBitList new.
	emptyBitList := bitList.
	bitList5 := BTBitList value: 5 width: 4.
	bitList7 := BTBitList value: 7 width: 4.
	bitList23 := BTBitList value: 16r17 width: 6.
	bitList023 := BTBitList value: 16r17 width: 8.
	bitListb01 :=  BTBitList  value: 2r01 width: 2.
	bitListb11 :=  BTBitList  value: 2r11 width: 2.
	bitListb0 :=  BTBitList  value: 2r0 width: 1.
	bitListb1 :=  BTBitList  value: 2r1 width: 1.
]

{ #category : #'tests - adding' }
BTBitListTests >> testAppend [

	bitList7 append: bitListb01.
	self assert: bitList7 equals: (BTBitList value: 16r17 width: 6).
	
	bitList7 append: bitListb11.
	self assert: bitList7 equals: (BTBitList value: 16rD7 width: 8).
]

{ #category : #'tests - adding' }
BTBitListTests >> testAppendBitsFromInteger [
	
	bitList7 appendBits: 3 from: 16r15.

	self assert: bitList7 asInteger equals: 16r57.
	self assert: bitList7 width equals: 7.
	
	bitListb11 appendBits: 30 from: 3.

	self assert: bitListb11 asInteger equals: 15.
	self assert: bitListb11 width equals: 32.
]

{ #category : #'tests - adding' }
BTBitListTests >> testAppendBitsFromIntegerToEmptyList [
	
	emptyBitList appendBits: 6 from: 20.

	self assert: emptyBitList asInteger equals: 20.
	self assert: emptyBitList width equals: 6.
]

{ #category : #'tests - adding' }
BTBitListTests >> testAppendToEmptyList [

	emptyBitList append: bitList5.
	self assert: emptyBitList equals: bitList5.
]

{ #category : #'tests - testing' }
BTBitListTests >> testBeginsWith [

	self assert: (bitList23 beginsWith: bitListb11).
	self deny: (bitList23 beginsWith: bitListb01).
	
	self deny: (bitList23 beginsWith: bitList5).
	self assert: (bitList23 beginsWith: bitList7).
	self assert: (bitList23 beginsWith: bitList23).
	self deny: (bitList23 beginsWith: bitList023).
]

{ #category : #'tests - accessing' }
BTBitListTests >> testBitAt [

	self assert: (bitList5 bitAt: 1) equals: 1.
	self assert: (bitList5 bitAt: 2) equals: 0.
	self assert: (bitList5 bitAt: 3) equals: 1.
]

{ #category : #'tests - accessing' }
BTBitListTests >> testBitAtPut [

	self assert: (bitList5 bitAt: 2) equals: 0.
	bitList5 bitAt: 2 put: 1.
	self assert: (bitList5 bitAt: 2) equals: 1.
	
	self assert: (bitList5 bitAt: 3) equals: 1.
	bitList5 bitAt: 3 put: 0.
	self assert: (bitList5 bitAt: 3) equals: 0
]

{ #category : #'tests - accessing' }
BTBitListTests >> testBitListFrom [

	self assert: (bitList23 bitListFrom: 1 to: 4) equals: bitList7.
	self assert: (bitList23 bitListFrom: 5 to: 6) equals: bitListb01
]

{ #category : #tests }
BTBitListTests >> testBitMaskFor [

	self assert: (bitList bitMaskFor: 1) equals: 2r1.
	self assert: (bitList bitMaskFor: 5) equals: 2r11111.
	self assert: (bitList bitMaskFor: 32) equals: 16rFFFFFFFF.
	self assert: (bitList bitMaskFor: 64) equals: 16rFFFFFFFFFFFFFFFF.
]

{ #category : #'tests - accessing' }
BTBitListTests >> testBitsFromTo [

	self assert: (bitList23 bitsFrom: 1 to: 1) equals: 1.
	self assert: (bitList23 bitsFrom: 2 to: 3) equals: 3.
	self assert: (bitList23 bitsFrom: 2 to: 4) equals: 3.
	self assert: (bitList23 bitsFrom: 4 to: 6) equals: 2.
]

{ #category : #'tests - testing' }
BTBitListTests >> testBitsFromToEquals [
	
	self assert: (bitList23 bitsFrom: 2 to: 4 equals: 3).
	self deny: (bitList23 bitsFrom: 3 to: 4 equals: 3).

	self assert: (bitList23 bitsFrom: 1 to: 6 equals: 23).
	self deny: (bitList23 bitsFrom: 1 to: 7 equals: 23).

]

{ #category : #'tests - accessing' }
BTBitListTests >> testBitsFromToWithWrongRange [

	self should: [ bitList23 bitsFrom: 4 to: 7 ] raise: SubscriptOutOfBounds.
	self should: [ bitList23 bitsFrom: 4 to: 35 ] raise: SubscriptOutOfBounds.
]

{ #category : #'tests - initialization' }
BTBitListTests >> testDefaultInitialization [
	| newBitList |
	newBitList := BTBitList new.
	
	self assert: bitList asInteger equals: 0.
	self assert: bitList width equals: 0
]

{ #category : #tests }
BTBitListTests >> testEquals [

	self assert: (bitList23 = bitList23).
	self deny: (bitList23 = bitList023).
	
	self assert: (bitList23 = (BTBitList value: 23 width: 6)).
	self deny: (bitList23 = (BTBitList value: 23 width: 7)).
	self deny: (bitList23 = (BTBitList value: 21 width: 6)).
]

{ #category : #'tests - accessing' }
BTBitListTests >> testFirstBits [

	self assert: (bitList23 firstBits: 1) equals: 1.
	self assert: (bitList23 firstBits: 2) equals: 3.
	self assert: (bitList23 firstBits: 3) equals: 7.
	self assert: (bitList23 firstBits: 4) equals: 7.	
	self assert: (bitList23 firstBits: 5) equals: 23.

]

{ #category : #'tests - accessing' }
BTBitListTests >> testFirstBitsWithMoreBitsThanAvailable [

	self should: [ bitList23 firstBits: 8 ] raise: SubscriptOutOfBounds.
]

{ #category : #'tests - initialization' }
BTBitListTests >> testInitializationWithParams [
	bitList value: 5 width: 4.
	
	self assert: bitList asInteger equals: 5.
	self assert: bitList width equals: 4
]

{ #category : #'tests - accessing' }
BTBitListTests >> testIsSetBitAt [

	self assert: (bitList5 isSetBitAt: 1).
	self deny: (bitList5 isSetBitAt: 2).
	self assert: (bitList5 isSetBitAt: 3).
]

{ #category : #'tests - testing' }
BTBitListTests >> testPrefixCodeCompatibilityisFalseWhenOneIsAPrefixOfTheOther [

	self deny: (bitListb01 isPrefixCodeCompatible: bitListb01).
	self deny: (bitListb1 isPrefixCodeCompatible: bitListb01).
	self deny: (bitListb01 isPrefixCodeCompatible: bitListb1).
]

{ #category : #'tests - testing' }
BTBitListTests >> testPrefixCodeCompatibilityisTrueWhenNoneIsAPrefixOfTheOther [

	self assert: (bitListb0 isPrefixCodeCompatible: bitListb01).
	self assert: (bitListb01 isPrefixCodeCompatible: bitListb0).
]

{ #category : #'tests - removing' }
BTBitListTests >> testRemoveFirstBitsList [
	| result |
	result := bitList023 removeFirstBitList: 3.
	
	self assert: bitList023 asInteger equals: 2.
	self assert: bitList023 width equals: 5.
	self assert: result equals: (BTBitList value: 7 width:3).
]

{ #category : #'tests - removing' }
BTBitListTests >> testRemoveFirstBitsToEmptyBitList [
	bitList23 removeFirstBits: 6.
	
	self should: [ bitList23 removeFirstBits: 4 ] raise: SubscriptOutOfBounds .
	self should: [ bitListb11 removeFirstBits: 3 ] raise: SubscriptOutOfBounds.

]

{ #category : #'tests - removing' }
BTBitListTests >> testRemoveFirstBitsUntilEmpty [
	| result |
	result := bitList023 removeFirstBits: 4.
	
	self assert: bitList023 asInteger equals: 1.
	self assert: bitList023 width equals: 4.
	self assert: result equals: 7.
	
	result := bitList023 removeFirstBits: 4.
	
	self assert: result equals: 1.
	self assert: bitList023 width equals: 0.

]

{ #category : #'tests - testing' }
BTBitListTests >> testfirstBitsEquals [

	self assert: (bitList23 firstBits: 3 equals: 7).
	self deny: (bitList23 firstBits: 3 equals: 5).
	self assert: (bitList23 firstBits: 2 equals: 2r11).
	self deny: (bitList23 firstBits: 2 equals: 2r111).
	
	self assert: (bitList23 firstBits: 6 equals: 23).
	self deny: (bitList23 firstBits: 7 equals: 23).
]
