export const precalculus_prompts = {
	"precalc_identifying_and_evaluating_functions" : "In this lesson, you will revisit relationships between two variables, more specifically, functions. Specifically, this lesson will cover: 1. Determining Whether a Relation Represents a Function a. Functions Defined by Sets of Ordered Pairs b. Functions Defined by Equations 2. Finding Input and Output Values of a Function 3. Why Use Function Notation? ChatGPT generate 10 math problems and answers with steps for each of the things mentioned above. Make an anonymous json array of objects, one for each problem and add a key named answer and set it to the answer for that problem. Also add a key named problem with the text for the problem. Don't console log the answers and problems in the end of the script. Only the array no extra text included..",
	"precalc_domain_and_range_of_functions" : "In this lesson, you will explore the domain and range of a function. This is very important since the domain and range collectively tell us the possible inputs and outputs of a function. Specifically, this lesson will cover: 1. Finding the Domain of a Function Defined by an Equation 2. Finding Domain and Range From Graphs ChatGPT generate 10 math problems and answers with steps for each of the things mentioned above. Make an anonymous json array of objects, one for each problem and add a key named answer and set it to the answer for that problem. Also add a key named problem with the text for the problem. Don't console log the answers and problems in the end of the script. Only the array no extra text included.",
	"graphs_of_piecewise_functions" : "In this lesson, you will graph piecewise functions. Specifically, this lesson will cover: 1. Graphing a Function on a Restricted Domain 2. Graphing a Piecewise Function ChatGPT generate 10 math problems and answers with steps for each of the things mentioned above. Make an anonymous json array of objects, one for each problem and add a key named answer and set it to the answer for that problem. Also add a key named problem with the text for the problem. Don't console log the answers and problems in the end of the script. Only the array no extra text included."
}

export const prompts = {
	"PreCalculus" : precalculus_prompts
}

export const subjects = [
	"PreCalculus",
	"Calculus",
	"Javascript",
	"Chemistry"
]

export const topics = {
	"PreCalculus" : Object.keys(prompts["PreCalculus"]) ?? [],
	"Calculus" : Object.keys(prompts["Calculus"] ?? {}) ?? [],
	"Javascript" : Object.keys(prompts["Javascript"] ?? {}) ?? [],
	"Chemistry" : Object.keys(prompts["Chemistry"] ?? {}) ?? []
}