"
An BytecodeMemoryExperiments is a class for helping profiling bytecode memory footpring.
"
Class {
	#name : 'ByteCodeMemoryExperiments',
	#superclass : 'Object',
	#category : 'Blast-AST-Experiments',
	#package : 'Blast-AST-Experiments'
}

{ #category : 'memory space' }
ByteCodeMemoryExperiments class >> allCompiledMethodsSizeInMemory [
	|res|
	res :=0.
	
	AstMemoryExperiments allMethods do: [ :aMethod |  res := res + 	aMethod sizeInMemory ].
			
	^res
]
