import express from 'express'
import bodyParser from 'body-parser'
import dotenv from 'dotenv'
dotenv.config();
import OpenAI from 'openai';
const openai = new OpenAI({
     apiKey: process.env.OPENAI_API_KEY 
});
const app = express();

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))

// parse application/json
app.use(bodyParser.json())


const prompts = {
	"precalc_identifying_and_evaluating_functions" : "In this lesson, you will revisit relationships between two variables, more specifically, functions. Specifically, this lesson will cover: 1. Determining Whether a Relation Represents a Function a. Functions Defined by Sets of Ordered Pairs b. Functions Defined by Equations 2. Finding Input and Output Values of a Function 3. Why Use Function Notation? ChatGPT generate 10 math problems and answers with steps for each of the things mentioned above. Make an anonymous json array of objects, one for each problem and add a key named answer and set it to the answer for that problem. Also add a key named problem with the text for the problem. Don't console log the answers and problems in the end of the script. Only the array no extra text included..",
	"precalc_domain_and_range_of_functions" : "In this lesson, you will explore the domain and range of a function. This is very important since the domain and range collectively tell us the possible inputs and outputs of a function. Specifically, this lesson will cover: 1. Finding the Domain of a Function Defined by an Equation 2. Finding Domain and Range From Graphs ChatGPT generate 10 math problems and answers with steps for each of the things mentioned above. Make an anonymous json array of objects, one for each problem and add a key named answer and set it to the answer for that problem. Also add a key named problem with the text for the problem. Don't console log the answers and problems in the end of the script. Only the array no extra text included."
};


app.post('/problems/:course/:topic/generate', async (req,res)=>{
	
	const course = req.params.course;
	const topic = req.params.topic;

	let prompt = null;

	switch(course){
		case "PreCalculus":
			switch(topic){
				case "precalc_identifying_and_evaluating_functions":
					prompt = prompts["precalc_identifying_and_evaluating_functions"];
					break;
				case "precalc_domain_and_range_of_functions":
					prompt = prompts["precalc_domain_and_range_of_functions"];
					break;
				default:
					break;
			}
		default:
			break;
	}

	try{
		if(prompt != null){
			await generateProblems(res,prompt, course, topic);
		}else{
			res.json({
				error : "We have no problems for that topic."
			})
		}
	}catch(error){
		console.log("Error generating problems.")
		res.json(error)
	}
})

const generateProblems = async (res, prompt, course, topic) => {
	try {
		console.log(`Generating problems for ${course} - ${topic}`)
		const completion = await openai.chat.completions.create({
			messages: [
				{ 
					role: "system", 
					content: prompt 
				}
			],
				model: "gpt-3.5-turbo",
		});

		return res.json(JSON.parse(completion.choices[0].message.content))
	}catch(error){
		console.log("There was an error while generating the problems. Attempting again.")
		console.log(error.message);
		await generateProblems(res, prompt, course, topic);
	}
}

app.listen(process.env.PORT,()=>{
	console.log("Server listening on port 3000");
})
