"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestPulsarTests,
	#superclass : #PackageManifest,
	#category : #'Pulsar-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestPulsarTests class >> rulePrecedenceRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#MemorySizeVisitorTest #testSequenceNodeWithTemporaries #false)) #'2022-04-28T03:49:34.429156-03:00') )
]
