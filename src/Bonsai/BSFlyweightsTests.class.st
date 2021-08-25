Class {
	#name : #BSFlyweightsTests,
	#superclass : #BSTests,
	#category : #'Bonsai-Tests'
}

{ #category : #fixtures }
BSFlyweightsTests >> array [
	^ BSArrayNode expressions: { self variable . self message. self cascade }
]

{ #category : #fixtures }
BSFlyweightsTests >> assignment [
	^ BSAssignmentNode
		variable: self variable
		expression: self cascade
]

{ #category : #fixtures }
BSFlyweightsTests >> block [
	^ BSBlockNode
		arguments: { BSVariableNode name: #blip. BSVariableNode name: #blop }
		temporaries: { BSVariableNode name: #temp1. BSVariableNode name: #temp2 }
		expressions: { self assignment. self array. self cascade }
		hasReturn: true 
]

{ #category : #fixtures }
BSFlyweightsTests >> cascade [
	^ BSCascadeNode
		messages: {
			self message.
			self message2 }
]

{ #category : #fixtures }
BSFlyweightsTests >> literal [
	^ BSLiteralNode value: #baz
]

{ #category : #fixtures }
BSFlyweightsTests >> message [
	^ BSMessageNode
		receiver: self variable
		selector: #foo:
		arguments: { self literal }
]

{ #category : #fixtures }
BSFlyweightsTests >> message2 [
	^ BSMessageNode
		receiver: self variable
		selector: #baz
		arguments: { }
]

{ #category : #'tests-arrayEquality' }
BSFlyweightsTests >> testArrayEqualsEquivalentArray [
	self assert: self array hash = (BSArrayNode privateHash: { self variable. self message. self cascade }).
	self assert: self array = { self variable. self message. self cascade }
]

{ #category : #'tests-arrayEquality' }
BSFlyweightsTests >> testAssignmentEqualsEquivalentArray [
	self assert: self assignment hash = (BSAssignmentNode privateHash: { self variable. self cascade }).
	self assert: self assignment =  { self variable. self cascade }
]

{ #category : #'tests-arrayEquality' }
BSFlyweightsTests >> testBlockEqualsEquivalentArray [
	| equivalentArray |
	equivalentArray := { 
		{ BSVariableNode name: #blip. BSVariableNode name: #blop }. 
		{ BSVariableNode name: #temp1. BSVariableNode name: #temp2 }. 
		true. 
		self assignment. self array . self cascade }.
	self assert: self block hash = (BSBlockNode privateHash: equivalentArray).
	self assert: self block = equivalentArray
]

{ #category : #'tests-flyweightClasses' }
BSFlyweightsTests >> testCacheInitialization [
	BSFlyweightNode allSubclassesDo: [ :cls | 
		self assert: cls cache class = Set.
		self deny: cls cache == BSFlyweightNode cache ]  
]

{ #category : #'tests-arrayEquality' }
BSFlyweightsTests >> testCascadeEqualsEquivalentArray [
	self assert: self cascade hash = (BSCascadeNode privateHash: { self message. self message2 }).
	self assert: self cascade = { self message. self message2 } 
]

{ #category : #'tests-creation' }
BSFlyweightsTests >> testCreatingArray [
	self assert: self array == self array.
	self assert: self array expressions size equals: 3.
	self assert: self array expressions first == self variable.
	self assert: self array expressions second == self message.
	self assert: self array expressions third == self cascade
	
]

{ #category : #'tests-creation' }
BSFlyweightsTests >> testCreatingAssignment [
	self assert: self assignment == self assignment.
	self assert: self assignment variable == self variable.
	self assert: self assignment expression == self cascade.
]

{ #category : #'tests-creation' }
BSFlyweightsTests >> testCreatingBlock [
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

{ #category : #'tests-creation' }
BSFlyweightsTests >> testCreatingCascade [
	self assert: self cascade == self cascade.
	self assert: self cascade messages first == self message.
	self assert: self cascade messages second receiver == self variable
]

{ #category : #'tests-creation' }
BSFlyweightsTests >> testCreatingLiteral [
	self assert: self literal == self literal.
	self assert: self literal value equals: #baz
	
]

{ #category : #'tests-creation' }
BSFlyweightsTests >> testCreatingMessage [
	self assert: self message == self message.
	self assert: self message receiver == self variable.
	self assert: self message selector equals: #foo:.
	self assert: self message arguments first == self literal
]

{ #category : #'tests-creation' }
BSFlyweightsTests >> testCreatingVariable [
	self assert: self variable == self variable.
	self assert: self variable name equals: #id
]

{ #category : #'tests-flyweightClasses' }
BSFlyweightsTests >> testInstanceCreationIsForbidden [
	self should: [ BSFlyweightNode new ] raise: Error 
]

{ #category : #'tests-arrayEquality' }
BSFlyweightsTests >> testLiteralEqualsEquivalentArray [
	self assert: self literal hash = (BSLiteralNode privateHash: #(baz)). 
	self assert: self literal = #(baz)
]

{ #category : #'tests-arrayEquality' }
BSFlyweightsTests >> testMessageEqualsEquivalentArray [
	self assert: self message hash = (BSMessageNode privateHash: { self variable. #foo:. self literal }). 
	self assert: self message = { self variable. #foo:. self literal }
	

]

{ #category : #'tests-printing' }
BSFlyweightsTests >> testPrintArray [
	self assert: (self parse: self array printString) == self array
]

{ #category : #'tests-printing' }
BSFlyweightsTests >> testPrintAssignment [
	self assert: (self parse: self assignment printString) == self assignment
]

{ #category : #'tests-printing' }
BSFlyweightsTests >> testPrintBlock [
	self assert: (self parse: self block printString) == self block
]

{ #category : #'tests-printing' }
BSFlyweightsTests >> testPrintCascade [
	self assert: (self parse: self cascade printString) == self cascade
]

{ #category : #'tests-printing' }
BSFlyweightsTests >> testPrintLiteral [
	self assert: (self parse: self literal printString) == self literal
]

{ #category : #'tests-printing' }
BSFlyweightsTests >> testPrintMessage [
	self assert: (self parse: self message printString) == self message
]

{ #category : #'tests-printing' }
BSFlyweightsTests >> testPrintVariable [
	self assert: (self parse: self variable printString) == self variable
]

{ #category : #'tests-arrayEquality' }
BSFlyweightsTests >> testVariableEqualsEquivalentArray [
	self assert: self variable hash = (BSVariableNode privateHash: #(#id)).
	self assert: self variable = #(id) 
]

{ #category : #'tests-hash' }
BSFlyweightsTests >> testVariablesAndSymbolsHaveDifferentHashes [
	| symbol variable |
	symbol := BSLiteralNode value: #name. 
	variable := BSVariableNode name: #name.
	self deny: symbol hash = variable hash.
	self deny: (BSMessageNode privateHash: {symbol. #foo})= (BSMessageNode privateHash: {variable. #foo})
]

{ #category : #fixtures }
BSFlyweightsTests >> variable [
	^ BSVariableNode name: #id
]

{ #category : #fixtures }
BSFlyweightsTests >> variable2 [
	^ BSVariableNode name: #baz
]
