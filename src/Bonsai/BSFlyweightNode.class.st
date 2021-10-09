"
This class is the root of Bonsai's flyweight hierarchy.
It has a class-side instance variable cache that its subclassses use for caching their instances.
"
Class {
	#name : #BSFlyweightNode,
	#superclass : #BSNode,
	#classVars : [
		'HashBlock'
	],
	#classInstVars : [
		'cache'
	],
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSFlyweightNode class >> basicNew [
	self error: 'You must instantiate flyweights with appropriate methods. See class side ''instance creation'' protocol'
]

{ #category : #caching }
BSFlyweightNode class >> cache [
	^ cache ifNil: [ cache := Set new: self initialCacheSize ]
]

{ #category : #caching }
BSFlyweightNode class >> cache: aSet [
	cache :=  aSet
]

{ #category : #caching }
BSFlyweightNode class >> initialCacheSize [
	"Approximation of the size of the caches to avoid to many rehash"
	^ 20000
]

{ #category : #'private-caching' }
BSFlyweightNode class >> initialize [
	HashBlock := [ :hash :otherHash | (hash bitShift: -7) bitXor: otherHash ]
]

{ #category : #'private-caching' }
BSFlyweightNode class >> privateHash: arrayOrFlyweight [
	
	| hash |
	hash := 0.
	1 to: arrayOrFlyweight size do: [ :index | hash := HashBlock value: hash value: (arrayOrFlyweight instVarAt: index) hash ].
	^ hash
]

{ #category : #'private-caching' }
BSFlyweightNode class >> privateLookup: initCollection [
	| array index start element |
	array := self cache array.
	index := start := (self privateHash: initCollection) \\ array size + 1.
	[ ((element := array at: index) 
		ifNil: [ ^ self cache add: (self privateNewInstanceWith: initCollection) ] 
		ifNotNil: [ 
			element enclosedElement  = initCollection ]) 
				ifTrue: [ ^ element enclosedElement ].
		(index := index \\ array size + 1) = start ] whileFalse.
]

{ #category : #'private-caching' }
BSFlyweightNode class >> privateNewInstanceWith: initCollection [
	| newInstance |
	self assert: [ initCollection size = self instSize or: [ initCollection size > self instSize and: [ self isVariable ] ] ].
	newInstance := self isVariable
		ifTrue: [ super basicNew: initCollection size - self instSize ]
		ifFalse: [ super basicNew ].
	initCollection withIndexDo: [ :each :index | newInstance instVarAt: index put: each ].
	^ newInstance
]

{ #category : #caching }
BSFlyweightNode class >> resetAllCaches [
	self allSubclassesDo: #resetCache 
]

{ #category : #cache }
BSFlyweightNode class >> resetCache [
	cache := nil
]

{ #category : #comparing }
BSFlyweightNode >> = anObject [
	"A flyweight is equal to itself or to an array whose items are equals to my instances variables"
	^ anObject == self or: 
	 	[ anObject isArray 
			and: [ 
				anObject size = self size ifFalse: [ ^ false ].
				1 to: self size do: [ :index | (self instVarAt: index) = (anObject at: index) ifFalse: [ ^ false ] ].
				true ] ]
]

{ #category : #comparing }
BSFlyweightNode >> hash [
	^ self class privateHash: self
]

{ #category : #comparing }
BSFlyweightNode >> size [
	^ self basicSize + self class instSize
]

{ #category : #private }
BSFlyweightNode >> variablePart [
	"Returns an array tht corresponds to the variable part of the receiver"
	^ (1 to: self basicSize) collect: [ :index | self at: index ] as: Array
]
