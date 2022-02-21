Class {
	#name : #BaselineOfPulsar,
	#superclass : #BaselineOf,
	#category : #BaselineOfPulsar
}

{ #category : #baselines }
BaselineOfPulsar >> baseline: spec [
	<baseline>
	spec
		for: #pharo
		do: [	
			spec
				package: 'Pulsar';
				package: 'Pulsar-Tests';
				package: 'Pulsar-Experiments';
				package: 'Blast';	
				package: 'Blast-Tests';
				package: 'Blast-AST-Experiments';
				package: 'Bonsai' ]
]
