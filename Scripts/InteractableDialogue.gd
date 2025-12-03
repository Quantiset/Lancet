extends Node

var dialogue := {
	"DoorToSelf": [
		"OBJECT DETECTED: Powered Door",
		"|-STATUS: Forcibly closed; continuous power usage",
	],
	"MainLever": [
		"OBJECT DETECTED: Switch",
		"|-STATUS: Electrical hazard; leaking arcs",
		"|-VERDICT: Potentially shockable"
	],
	"LongHallway": [
		"ROOM DETECTED: Staircase",
		"|-OBSERVATION: Hastily drawn paintings adorn walls",
		"|-OBSERVATION: Elevation rapidly descending"
	],
	"FileCabinet": [
		"OBJECT DETECTED: File Cabinet",
		"|-OBSERVATION: Filled with papers",
		"|-OBSERVATION: Papers in foreign language",
		"|-OBSERVATION: Pictures contain possible war plans",
		"|-INTEL STORED REMOTELY"
	],
	"Computers": [
		"ROOM DETECTED: Computer Room",
		"|-OBSERVATION: Powered off",
		"|-VERDICT: Bootable"
	],
	"ComputersOn": [
		"ROOM DETECTED: Computer Room",
		"|-OBSERVATION: Text chats opened",
		"|-VERDICT: Illegal scam operation conducted"
	],
	"Pantry": [
		"ROOM DETECTED: Kitchen",
		"|-OBSERVATION: Food strewn about; inadequate supplies",
		"|-VERDICT: Failing regulations"
	],
	"SleepingBeds": [
		"ROOM DETECTED: Living Quarters",
		"|-WARNING: Living lifeforms observed.",
		"|-THREAT: Docile",
		"|-OBSERVATION: Multiple wet beds",
	],
	"Generator": [
		"ROOM DETECTED: Generator",
		"|-OBSERVATION: Powers facility",
	],
	"DeadGenerator": [
		"ROOM DETECTED: [///ERRNO2]",
		"|-OBSERVATION: Ash and soot thinly coats the room",
	],
	"Us": [
		"OBJECT DETECTED: EXPENDABLE",
		"ELIMINATE",
		"DO NOT HESITATE",
	]
}
