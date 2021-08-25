"
A Flufo is dummy class used for experiments.

Instance Variables
	baz:		<Object>
	ber:		<Object>
	biz:		<Object>
	foo:		<Object>

baz
	- xxxxx

ber
	- xxxxx

biz
	- xxxxx

foo
	- xxxxx

"
Class {
	#name : #Flufo,
	#superclass : #Object,
	#instVars : [
		'biz',
		'foo',
		'ber',
		'baz'
	],
	#category : #ASTProfile
}

{ #category : #'as yet unclassified' }
Flufo >> foo [
	"esto es un comentario en un metodo"
	|var bir|
	
	bir := 'asdas'.
	var := 3 + 24 + 1.0 + 322s4.

	^ foo +  var "comentario".
]

{ #category : #'as yet unclassified' }
Flufo >> foo: arg1 bar: arg2 [
	"esto es un comentario en un metodo"

	|temp|
	
	temp := 1.

	^ temp + 3 + 4 + 1.0 "comentario".
]

{ #category : #'as yet unclassified' }
Flufo >> initialize [
	foo := 1.
	
]

{ #category : #'as yet unclassified' }
Flufo >> python [
	^ monty
]
