"
Represents the code of a cascade.

Variable Part			<BSMessageFlyweight*>

"
Class {
	#name : 'FWCascadeNode',
	#superclass : 'FWFlyweightNode',
	#type : 'variable',
	#category : 'Pulsar-Flyweight-Expressions',
	#package : 'Pulsar-Flyweight',
	#tag : 'Expressions'
}

{ #category : 'instance creation' }
FWCascadeNode class >> messages: aMessageNodeArray [
	self assert:
		(aMessageNodeArray allSatisfy: [ :each | each isMessageNode and: [ each receiver == aMessageNodeArray first receiver ] ]).
	^ self privateLookup: aMessageNodeArray
]

{ #category : 'visitor' }
FWCascadeNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitCascadeNode: self
]

{ #category : 'testing' }
FWCascadeNode >> isCascadeNode [
	^ true
]

{ #category : 'accessing' }
FWCascadeNode >> messages [
	^ self variablePart
]

{ #category : 'transformations' }
FWCascadeNode >> messages: aMessageArray [
	^ self class messages: aMessageArray
]

{ #category : 'printing' }
FWCascadeNode >> printOn: aStream [
	(self at: 1) receiver printOn: aStream.
	aStream << ' '.
	self messages 
		do: [ :message | message printKeywordsAndArgumentsOn: aStream ]
		separatedBy: [ aStream << '; ' ]
]
