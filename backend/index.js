import express from 'express'
import bodyParser from 'body-parser'
import dotenv from 'dotenv'
import { topics, prompts } from './data/data.js'

dotenv.config()
import OpenAI from 'openai'
const openai = new OpenAI({
     apiKey: process.env.OPENAI_API_KEY 
});

const app = express()

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())



app.post('/subjects', async (req,res)=>{
	try{
		// Return the list of subjects to the user
		res.json(subjects)
	}catch(err){
		res.json({
			error: err
		})
	}
});

/* Retrieve all topics for a given subject */
app.post('/subjects/:subject/topics', async (req,res)=>{
	const subject = req.params.subject
	res.json({
		topic : topics[subject]
	})
})


app.post('/problems/:subject/:topic/generate', async (req,res)=>{
	// Collect the subject and topic they want problems for
	const subject = req.params.subject
	const topic = req.params.topic

	// Grab the AI prompt to generate the problems
	let prompt = prompts[subject][topic]


	// Try generating the problems and returning them to the front-end
	try{
		if(prompt != null){
			await generateProblems(res,prompt, subject, topic)
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
		console.log(error.message)
		await generateProblems(res, prompt, course, topic)
	}
}

app.listen(process.env.PORT,()=>{
	console.log("Server listening on port 3000")
})
