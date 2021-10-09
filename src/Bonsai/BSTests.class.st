Class {
	#name : #BSTests,
	#superclass : #TestCase,
	#instVars : [
		'caches'
	],
	#category : #'Bonsai-Tests'
}

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
	BSFlyweightNode resetAllCaches
]

{ #category : #running }
BSTests >> tearDown [ 
	BSFlyweightNode allSubclasses withIndexDo: [ :nodeClass :index | nodeClass cache: (caches at: index) ].
	caches := nil 
]
