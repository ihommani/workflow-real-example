[![Infrastructure main workflow](https://github.com/ihommani/workflow-real-example/actions/workflows/main_flow_infrastructure.yaml/badge.svg?branch=integration)](https://github.com/ihommani/workflow-real-example/actions/workflows/main_flow_infrastructure.yaml)

# workflow-real-example
Test github action workflow strategy using the following guidance elements:  
* Workflow reuse to mutualize logic
* Trigger job and associated steps if needed
* Use actions from the marketplace

Test

## Racourci: les environnemnts sont hébergés sur le même projet GCP. Normalement nous privilegions un projet GCP par environnement 




# Explanation


## Git Flow logic MIXED WITH {integration; delivery; deployment} logic MIXED WITH graph construction logic MIXED WITH graph traversal logic
The complexity of Github actions mainly comes from its nature to not separate by design logics of different natures. 
We can distinguish 4 of them: 
* Git flow logic
* graph construction or orchestration logic
Very basic. It follows the order of jobs or steps declaration and parallelize what can be parallelized. 
Mainly by checking the existence of the 'needs' keyword in a job declaration (a job can require the output).
The 'needs' could have beed infered from the content of the job. For instance, tool like *Terraform* proceed like this where 'depends_on' keyword is the exception not the rule. 
'Matrix' strategy is the Github action *for_each* but does not 'joint' to a single node on the graph. It creates branches on which we only the capacity to call actions and not workflow (composite action are handy there). Actions from 
* graph traversal
We can condition the exection of workflow and jobs based on Github contextual event or any arbitrary logic. 
The complexity is to slice workflow to the right size in order take advantage of the triggering filtering keyword 'on' at most and lower the 'if' in the job or step declarations. Avoid especially filtering duplication between 'on' and 'if'. 
'on' keyword should monopolize the Github triggering event strategy along with modified path. An 'if' with such event should be rare and focus on more arbitrary logic that the 'on' keyword cannot track (e.g: if the modified file is of type  )
* {integration; delivery; deployment} logic 
The actions itself

## Workflow VS composite actions VS action from a graph theory point of view

We can interprete a github action worflow as a Directed Acyclic Graph (DAG), where vertices are defined by the worklow jobs declaration and the nodes , the actions defined in the job step. 

Both allow to gather topic related logics. 
A composite action is an association of several actions which can be called as a single action from a job. 
From a graph perspective it's a  

## The matrix strategy 'dead end' effect

Once you are in an execution branch from a 'matrix' job, you cannot produce an output to use outside from this matrix job. 
In other word you must finish the logic you have started there.  
It exists a community action to enable 'matrix' ouput but it comes at an higher comlexity cost when understanding your code.   
Use it as a last resort.  


## Use Github action agressively
Should be a translation of the factor 3 of the 12 factors application manifesto