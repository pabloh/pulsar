"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestPulsarExperiments,
	#superclass : #PackageManifest,
	#category : #'Pulsar-Experiments-Manifest'
}

{ #category : #'code-critics' }
ManifestPulsarExperiments class >> ruleBadMessageRule2V1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#PLMemorySizeVisitor #measureCollection: #false)) #'2022-04-28T13:08:13.712331-03:00') )
]

{ #category : #'code-critics' }
ManifestPulsarExperiments class >> ruleNobodyShouldSendMethodDictV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'PLMemoryExperiments class' #allMethodsDo: #true)) #'2022-05-12T05:43:28.436323-03:00') )
]
