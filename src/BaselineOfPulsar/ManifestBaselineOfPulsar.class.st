"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestBaselineOfPulsar,
	#superclass : #PackageManifest,
	#category : #'BaselineOfPulsar-Manifest'
}

{ #category : #'code-critics' }
ManifestBaselineOfPulsar class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#BaselineOfPulsar #baseline: #false)) #'2022-02-21T03:21:13.718121-03:00') )
]
