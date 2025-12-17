Class {
	#name : 'FWTests',
	#superclass : 'TestCase',
	#instVars : [
		'caches'
	],
	#category : 'Pulsar-Flyweight-Tests',
	#package : 'Pulsar-Flyweight',
	#tag : 'Tests'
}

{ #category : 'parsing' }
FWTests >> parse: aString [
	^ (RBParser parseExpression: aString) acceptVisitor: FWEncoder new
]

{ #category : 'parsing' }
FWTests >> parseExpression: aString [
	^ FWEncoder parseExpression: aString
]

{ #category : 'parsing' }
FWTests >> parseMethod: aString [
	^ FWEncoder parseMethod: aString
]

{ #category : 'running' }
FWTests >> setUp [
	caches := FWFlyweightNode allSubclasses collect: #cache.
	FWFlyweightNode resetAllCaches
]

{ #category : 'running' }
FWTests >> tearDown [ 
	FWFlyweightNode allSubclasses withIndexDo: [ :nodeClass :index | nodeClass cache: (caches at: index) ].
	caches := nil 
]
