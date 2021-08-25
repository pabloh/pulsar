"
A BTVariableWordStorage binary storage that stores varible length binary objects.

"
Class {
	#name : #BTVariableWordStorage,
	#superclass : #BTBinaryStorage,
	#instVars : [
		'indexesArray'
	],
	#category : #'Blast-Storage'
}

{ #category : #initialization }
BTVariableWordStorage >> initialize [
	super initialize.
	indexesArray := ShortIntegerArray new: self indexesArrayDefaultSize.
]
