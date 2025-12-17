Class {
	#name : 'FWFlyweightsTests',
	#superclass : 'FWTests',
	#category : 'Pulsar-Flyweight-Tests',
	#package : 'Pulsar-Flyweight',
	#tag : 'Tests'
}

{ #category : 'fixtures' }
FWFlyweightsTests >> array [
	^ FWArrayNode expressions: { self variable . self message. self cascade }
]

{ #category : 'fixtures' }
FWFlyweightsTests >> assignment [
	^ FWAssignmentNode
		variable: self variable
		expression: self cascade
]

{ #category : 'fixtures' }
FWFlyweightsTests >> block [
	^ FWBlockNode
		arguments: { FWVariableNode name: #blip. FWVariableNode name: #blop }
		temporaries: { FWVariableNode name: #temp1. FWVariableNode name: #temp2 }
		expressions: { self assignment. self array. self cascade }
		hasReturn: true 
]

{ #category : 'fixtures' }
FWFlyweightsTests >> cascade [
	^ FWCascadeNode
		messages: {
			self message.
			self message2 }
]

{ #category : 'fixtures' }
FWFlyweightsTests >> literal [
	^ FWLiteralNode value: #baz
]

{ #category : 'fixtures' }
FWFlyweightsTests >> message [
	^ FWMessageNode
		receiver: self variable
		selector: #foo:
		arguments: { self literal }
]

{ #category : 'fixtures' }
FWFlyweightsTests >> message2 [
	^ FWMessageNode
		receiver: self variable
		selector: #baz
		arguments: { }
]

{ #category : 'tests-arrayEquality' }
FWFlyweightsTests >> testArrayEqualsEquivalentArray [
	self assert: self array hash = (FWArrayNode privateHash: { self variable. self message. self cascade }).
	self assert: self array = { self variable. self message. self cascade }
]

{ #category : 'tests-arrayEquality' }
FWFlyweightsTests >> testAssignmentEqualsEquivalentArray [
	self assert: self assignment hash = (FWAssignmentNode privateHash: { self variable. self cascade }).
	self assert: self assignment =  { self variable. self cascade }
]

{ #category : 'tests-arrayEquality' }
FWFlyweightsTests >> testBlockEqualsEquivalentArray [
	| equivalentArray |
	equivalentArray := { 
		{ FWVariableNode name: #blip. FWVariableNode name: #blop }. 
		{ FWVariableNode name: #temp1. FWVariableNode name: #temp2 }. 
		true. 
		self assignment. self array . self cascade }.
	self assert: self block hash = (FWBlockNode privateHash: equivalentArray).
	self assert: self block = equivalentArray
]

{ #category : 'tests-flyweightClasses' }
FWFlyweightsTests >> testCacheInitialization [
	FWFlyweightNode allSubclassesDo: [ :cls | 
		self assert: cls cache class = Set.
		self deny: cls cache == FWFlyweightNode cache ]  
]

{ #category : 'tests-arrayEquality' }
FWFlyweightsTests >> testCascadeEqualsEquivalentArray [
	self assert: self cascade hash = (FWCascadeNode privateHash: { self message. self message2 }).
	self assert: self cascade = { self message. self message2 } 
]

{ #category : 'tests-creation' }
FWFlyweightsTests >> testCreatingArray [
	self assert: self array == self array.
	self assert: self array expressions size equals: 3.
	self assert: self array expressions first == self variable.
	self assert: self array expressions second == self message.
	self assert: self array expressions third == self cascade
	
]

{ #category : 'tests-creation' }
FWFlyweightsTests >> testCreatingAssignment [
	self assert: self assignment == self assignment.
	self assert: self assignment variable == self variable.
	self assert: self assignment expression == self cascade.
]

{ #category : 'tests-creation' }
FWFlyweightsTests >> testCreatingBlock [
	self assert: self block == self block.
	self assert: self block arguments first name equals: #blip.
	self assert: self block arguments second name equals: #blop.
	self assert: self block temporaries first name equals: #temp1.
	self assert: self block temporaries second name equals: #temp2.
	self assert: self block expressions size equals: 3.
	self assert: self block expressions first == self assignment.
	self assert: self block expressions second == self array.
	self assert: self block expressions third == self cascade.
	self assert: self block hasReturn.
	self assert: self block return == self cascade
]

{ #category : 'tests-creation' }
FWFlyweightsTests >> testCreatingCascade [
	self assert: self cascade == self cascade.
	self assert: self cascade messages first == self message.
	self assert: self cascade messages second receiver == self variable
]

{ #category : 'tests-creation' }
FWFlyweightsTests >> testCreatingLiteral [
	self assert: self literal == self literal.
	self assert: self literal value equals: #baz
	
]

{ #category : 'tests-creation' }
FWFlyweightsTests >> testCreatingMessage [
	self assert: self message == self message.
	self assert: self message receiver == self variable.
	self assert: self message selector equals: #foo:.
	self assert: self message arguments first == self literal
]

{ #category : 'tests-creation' }
FWFlyweightsTests >> testCreatingVariable [
	self assert: self variable == self variable.
	self assert: self variable name equals: #id
]

{ #category : 'tests-flyweightClasses' }
FWFlyweightsTests >> testInstanceCreationIsForbidden [
	self should: [ FWFlyweightNode new ] raise: Error 
]

{ #category : 'tests-arrayEquality' }
FWFlyweightsTests >> testLiteralEqualsEquivalentArray [
	self assert: self literal hash = (FWLiteralNode privateHash: #(baz)). 
	self assert: self literal = #(baz)
]

{ #category : 'tests-arrayEquality' }
FWFlyweightsTests >> testMessageEqualsEquivalentArray [
	self assert: self message hash = (FWMessageNode privateHash: { self variable. #foo:. self literal }). 
	self assert: self message = { self variable. #foo:. self literal }
	

]

{ #category : 'tests-printing' }
FWFlyweightsTests >> testPrintArray [
	self assert: (self parse: self array printString) == self array
]

{ #category : 'tests-printing' }
FWFlyweightsTests >> testPrintAssignment [
	self assert: (self parse: self assignment printString) == self assignment
]

{ #category : 'tests-printing' }
FWFlyweightsTests >> testPrintBlock [
	self assert: (self parse: self block printString) == self block
]

{ #category : 'tests-printing' }
FWFlyweightsTests >> testPrintCascade [
	self assert: (self parse: self cascade printString) == self cascade
]

{ #category : 'tests-printing' }
FWFlyweightsTests >> testPrintLiteral [
	self assert: (self parse: self literal printString) == self literal
]

{ #category : 'tests-printing' }
FWFlyweightsTests >> testPrintMessage [
	self assert: (self parse: self message printString) == self message
]

{ #category : 'tests-printing' }
FWFlyweightsTests >> testPrintVariable [
	self assert: (self parse: self variable printString) == self variable
]

{ #category : 'tests-arrayEquality' }
FWFlyweightsTests >> testVariableEqualsEquivalentArray [
	self assert: self variable hash = (FWVariableNode privateHash: #(#id)).
	self assert: self variable = #(id) 
]

{ #category : 'tests-hash' }
FWFlyweightsTests >> testVariablesAndSymbolsHaveDifferentHashes [
	| symbol variable |
	symbol := FWLiteralNode value: #name. 
	variable := FWVariableNode name: #name.
	self deny: symbol hash = variable hash.
	self deny: (FWMessageNode privateHash: {symbol. #foo})= (FWMessageNode privateHash: {variable. #foo})
]

{ #category : 'fixtures' }
FWFlyweightsTests >> variable [
	^ FWVariableNode name: #id
]

{ #category : 'fixtures' }
FWFlyweightsTests >> variable2 [
	^ FWVariableNode name: #baz
]
