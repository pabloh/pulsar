Class {
	#name : #BSTests,
	#superclass : #TestCase,
	#instVars : [
		'caches'
	],
	#category : #'Bonsai-Tests'
}

{ #category : #running }
BSTests >> cacheIndex [
	"Index of the class-side instance variable 'cache' of BZFlyweight subclasses"
	^ 15
]

{ #category : #parsing }
BSTests >> parse: aString [
	^ (RBParser parseExpression: aString) acceptVisitor: BSEncoder new
]

{ #category : #parsing }
BSTests >> parseExpression: aString [
	^ BSEncoder parseExpression: aString
]

{ #category : #parsing }
BSTests >> parseMethod: aString [
	^ BSEncoder parseMethod: aString
]

{ #category : #running }
BSTests >> setUp [
	caches := BSFlyweightNode allSubclasses collect: #cache.
	BSFlyweightNode allSubclassesDo: [ :class | class instVarAt: self cacheIndex put: nil ]
]

{ #category : #running }
BSTests >> tearDown [ 
	BSFlyweightNode allSubclasses withIndexDo: [ :class :index | class instVarAt: self cacheIndex put: (caches at: index) ].
	caches := nil 
]
