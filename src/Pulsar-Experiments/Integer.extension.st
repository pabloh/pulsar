Extension { #name : #Integer }

{ #category : #'*Pulsar-Experiments' }
Integer >> quadWords [
	"Multiply per 8 bytes"
	^self * 8
]
