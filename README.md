[![Infrastructure main workflow](https://github.com/ihommani/workflow-real-example/actions/workflows/main_flow_infrastructure.yaml/badge.svg?branch=integration)](https://github.com/ihommani/workflow-real-example/actions/workflows/main_flow_infrastructure.yaml)

# Github action in practice
*Github action* is the *de facto* standard when it comes to implement *continuous {integration, delivery, deployment}* logics on Github repositories.  
The pipeline logic is orchestrated through workflows which launch jobs, each of which containing steps where we run actions or scripts.  
One can say GHA pipelines are nothing more than special kind of applications which react to repository events rather than API call scripts.  
To develop those pipelines Github imposes a declarative paradigm which expressivity is defined through a Github repositories context specialized syntax.   

In particular this syntax allows to adress the following concerns:
1. Git flow logic
2. {integration, delivery, deployment} logic
3. Definition of a graph of actions
4. Graph traversal logic

This mix of concerns is powerfull but quickly comes at the expence of readability and maintainability as your code grows.  
Official documentation along with community blog posts usually focus on the features but hardly about the need to master the induced complexity of your pipeline definitions as your code grows.  
The inconvenient truth is that, without any *discipline*, you will sooner than later deliver a big ball of mud.  
The question which prevails then is how to define this *discipline* ?

We previously described the GHA pipeline as a special kind of application. Developpers know from a long time that the code complexity should be mastered by following *clean code* practices.   
We may know acronyms such as DRY, KISS, SOLID, law of Demeter, ...

This repository is an attempt to answer by the practice a simple question: 
**How releavant is the inspiration from Clean Code practices in the context of GHA pipelines and its highly specialized expresivity tissue?**

Below points describes some best practice that were insightful when thinking the pipeline growth.  

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
It is however possible to rely on github artifact notion to bypass this limitation but it comes at the cost of an extra complexity.   


## Use Github action wherever you can
*Github action* is not only about action. We have workflows which contain jobs which defines steps from where we do the actual job, i.e actions.   
Still, actions is indeed the pillar of the *Github action* ecosystem which should be seen as a market place of capabilities that someone has already coded for you ? 
Need to create a CHANGELOG, need to authenticate to a cloud platform before deploying an OCI image ? 
Most likely a community has already packaged your need in a dedicated action that you should take advantage of.   
**The best code, is the code you don't write**   


# Partial conclusion

GHA syntax is not a programation langage. It lacks basic constructs to create needed abstraction for clean code. 
Moreover Github lacks of *easy* feature to simply organize workflows code and set visibility to your consumers.  
That being said, clean code principles also rely on more simple construct such as naming, code declaration consistency, usage of methods to describe intent, code mutualization...
Those elements are reachable whith GHA but should not however be thought as mandatory as it complexifies your code, and should be prefered for complex flow.  
As it is hard to automatically measure the *fitness* of your code, there is a high risk of architecture decay if the strategy is not strictly observed.   
This can be a sign that this clean code approach may be not what you need and that a straight forward pipeline may be enough.   
As always, a lean startup appraoch will prevent you from falling into the trap of overcomplexity by starting with a straightforward approche and slowly evolving to more complex strategy if you need to.