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
				package: 'Pulsar-Tests' with: [ spec requires: #('Pulsar') ];
				package: 'Pulsar-Experiments' with: [ spec requires: #('Pulsar' 'Bonsai') ];
				package: 'Blast';	
				package: 'Blast-Tests' with: [ spec requires: #('Blast') ];
				package: 'Blast-AST-Experiments' with: [ spec requires: #('Blast' 'Bonsai') ];
				package: 'Bonsai' ]
]
