Class {
	#name : #BTIntegerPackerTests,
	#superclass : #TestCase,
	#instVars : [
		'newPacker',
		'packer'
	],
	#category : #'Blast-Tests'
}

{ #category : #running }
BTIntegerPackerTests >> setUp [
	newPacker := BTIntegerPacker new.
	
	packer := BTIntegerPacker new 
		for: (1 to: 5) use: (BTBitList value: 0 width: 1);
		for: (6 to: 14) use: (BTBitList value: 2r01 width: 2);
		for: (15 to: 28) use: (BTBitList value: 2r11 width: 2).
]

{ #category : #'tests - setup' }
BTIntegerPackerTests >> testsASetOfHeadersThatAreNotAValidPrefixCodeRaisesAnErrorWhenSettingUp [
	newPacker 	for: (1 to: 5) use: (BTBitList value: 2r0 width: 1).
		
	self should: [ newPacker for: (6 to: 14) use: (BTBitList value: 2r10 width: 2). ] raise: Error.
	self should: [ newPacker for: (6 to: 14) use: (BTBitList value: 2r0 width: 1). ] raise: Error.
	self shouldnt: [ newPacker for: (6 to: 14) use: (BTBitList value: 2r01 width: 2). ] raise: Error.
]

{ #category : #'tests - setup' }
BTIntegerPackerTests >> testsASetOfRangesAndHeadersCanBeSettedUp [
	newPacker 
		for: (1 to: 5) use: (BTBitList value: 0 width: 1);
		for: (6 to: 14) use: (BTBitList value: 2r01 width: 2);
		for: (15 to: 28) use: (BTBitList value: 2r11 width: 2).
		
	self assert: (newPacker pack: 2r11000) equals: (BTBitList value: 2r110000 width: 6).
	self assert: (newPacker pack: 2r10101010) equals: (BTBitList value: 2r1010101001 width: 16).
	
]

{ #category : #'tests - setup' }
BTIntegerPackerTests >> testsAnOverlapingSetOfRangesRaisesAnErrorWhenSettingUp [
	newPacker 	for: (1 to: 5) use: (BTBitList value: 0 width: 1).
		
	self should: [ newPacker for: (5 to: 14) use: (BTBitList value: 2r01 width: 2). ] raise: Error.
	self should: [ newPacker for: (3 to: 8) use: (BTBitList value: 2r01 width: 2). ] raise: Error.
	self shouldnt: [ newPacker for: (6 to: 14) use: (BTBitList value: 2r01 width: 2). ] raise: Error.
	
]

{ #category : #'tests - extracting' }
BTIntegerPackerTests >> testsGivenAConfiguredFormatCanExtractValidBitList [
	| bitlist |
	
	bitlist := BTBitList value: 2r110011110001001101010001 width: 24.
	self assert: (packer extractThenUnpackFrom: bitlist) equals: 2r10011010100.
	self assert: bitlist width equals: 8.
]

{ #category : #'tests - packing' }
BTIntegerPackerTests >> testsGivenAConfiguredFormatCanPackAnValidInteger [
	| result |
	result := packer pack: 2r011100.
	
	self assert: (result isKindOf: BTBitList).
	self assert: result width equals: 6.
	self assert: result asInteger equals: 2r111000.
	
	result := packer pack: 2r11010100.
	
	self assert: (result isKindOf: BTBitList).
	self assert: result width equals: 16.
	self assert: result asInteger equals: 2r1101010001
]

{ #category : #'tests - packing' }
BTIntegerPackerTests >> testsGivenAConfiguredFormatCanPackAnValidIntegerIntoABitList [
	| bitList |
	bitList := BTBitList new.
	packer pack: 2r011100 into: bitList.
	
	self assert: bitList width equals: 6.
	self assert: bitList asInteger equals: 2r111000.
	
	bitList := BTBitList new.
	packer pack: 2r11010100 into: bitList.
	
	self assert: bitList width equals: 16.
	self assert: bitList asInteger equals: 2r1101010001
]

{ #category : #'tests - unpacking' }
BTIntegerPackerTests >> testsGivenAConfiguredFormatCanUnpackValidBitList [
	self assert: (packer unpack: (BTBitList value: 2r111000 width: 6)) equals: 2r011100.
	self assert: (packer unpack: (BTBitList value: 2r1101010001 width: 16)) equals: 2r11010100.
]

{ #category : #'tests - packing' }
BTIntegerPackerTests >> testsGivenAConfiguredFormatShoudPackRaiseAnErrorForAnIntegerOutsideValidRanges [
	self should: [packer pack: 16r10000000 ] raise: Error.
	self shouldnt: [packer pack: 16r1000000 ] raise: Error
]

{ #category : #'tests - unpacking' }
BTIntegerPackerTests >> testsGivenAConfiguredFormatUnpackShoudRaiseAnErrorForAnUndetectedHeader [
	newPacker for: (1 to: 28) use: (BTBitList value: 0 width: 1).
	
	self should: [ newPacker unpack: (BTBitList fromInteger: 1) ] raise: Error.
	self shouldnt: [ newPacker unpack: (BTBitList fromInteger: 0) ] raise: Error
]

{ #category : #'tests - packing' }
BTIntegerPackerTests >> testsWhenPackingAValidIntegerHeadersAreLeftIntact [
	| custPacker bitList |	
	bitList := BTBitList value: 0 width: 1.
	custPacker := BTIntegerPacker new.

	custPacker for: (1 to: 5) use: bitList.
	custPacker pack: 2r011100.
	
	self assert: bitList equals: (BTBitList value: 0 width: 1)
]
