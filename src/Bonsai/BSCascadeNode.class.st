"
Represents the code of a cascade.

Variable Part			<BSMessageFlyweight*>

"
Class {
	#name : #BSCascadeNode,
	#superclass : #BSFlyweightNode,
	#type : #variable,
	#category : #'Bonsai-Expressions'
}

{ #category : #'instance creation' }
BSCascadeNode class >> messages: aMessageNodeArray [
	self assert:
		(aMessageNodeArray allSatisfy: [ :each | each isMessageNode and: [ each receiver == aMessageNodeArray first receiver ] ]).
	^ self privateLookup: aMessageNodeArray
]

{ #category : #visitor }
BSCascadeNode >> acceptVisitor: aBSNodeVisitor [

	^ aBSNodeVisitor visitCascadeNode: self
]

{ #category : #testing }
BSCascadeNode >> isCascadeNode [
	^ true
]

{ #category : #accessing }
BSCascadeNode >> messages [
	^ self variablePart
]

{ #category : #transformations }
BSCascadeNode >> messages: aMessageArray [
	^ self class messages: aMessageArray
]

{ #category : #printing }
BSCascadeNode >> printOn: aStream [
	(self at: 1) receiver printOn: aStream.
	aStream << ' '.
	self messages 
		do: [ :message | message printKeywordsAndArgumentsOn: aStream ]
		separatedBy: [ aStream << '; ' ]
]
