"
A BTNode is the base class for AST nodes that have an encoded representation.

"
Class {
	#name : #BTEncodedNode,
	#superclass : #BTNode,
	#category : #'Blast-Nodes'
}

{ #category : #storages }
BTEncodedNode class >> defaultStorage [
	^ self storageAt: BTNodeStorageDirectory default
]

{ #category : #storages }
BTEncodedNode class >> storageAt: aStorageDirectory [
	self subclassResponsibility
]

{ #category : #storages }
BTEncodedNode >> storageAt: aStorageDirectory [

	self class storageAt: aStorageDirectory
]
