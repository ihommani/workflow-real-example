# Github action in practice
*Github action* (GHA) is the *de facto* standard when it comes to implement *continuous {integration, delivery, deployment}* logics on Github repositories.  
The pipeline logic is orchestrated through workflows which launch jobs, each of which containing steps where we run actions or scripts.  
One can say GHA pipelines are nothing more than special kind of applications which react to repository events rather than API calls.  
To develop those pipelines, Github imposes a declarative paradigm which expressivity is defined through a Github context specialized syntax.

In particular this syntax adresses the following concerns:   


1. **Git flow logic**  
What branch mirrors which maturity level, how it evolves, what action must be taken to release a new code version and so on.   
We all know the infamous Gitflow, or trunk base development. It is examples of such logics that we can express throught the GHA syntax.  

2. **{integration, delivery, deployment} logic**  
Software Delivery Lifecycle is a set of ordered steps of actions to guarantee code caracteristics such as quality, security, conformity, ...    

3. **Definition of an actions graph**   
A GHA pipeline is a [Directed Acyclic Graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) which nodes are Github actions and vertices dependencies between those actions.    

4. **Graph traversal logic**   
Action's triggering condition decides if somes graph nodes are run or not.   


This mix of concerns is powerfull but quickly comes at the expense of readability and maintainability as your code grows.  
Official documentation along with community blog posts usually focus on the features but hardly about the need to master the induced complexity of your code.  
Without any *discipline* you will sooner than later transform your pipeline into a [big ball of mud](http://www.laputan.org/mud/mud.html#BigBallOfMud).  
The question which prevails then is how to define this *discipline* ?   

We previously described the GHA pipeline as a special kind of application. Developpers know from a long time that the code complexity can be mitigated by following *clean code* practices.   
We may know acronyms such as DRY, KISS, SOLID, law of Demeter, ...

This repository is an attempt to answer by the practice a simple question: 
**How releavant is the inspiration from Clean Code practices in the context of GHA pipelines and its highly specialized expresivity tissue?**

Below points describes some best practices that were insightful when thinking the pipeline growth.  
There are by no mean exhaustive.  

## Use IDE GHA extension
Use the existing IDE extension to help you write syntaxically valid GHA workflow code.  
In the case of VSCode extension it also embeds the syntax documentation when hovering keywords. 

## Naming

While reading the definition code or the execution log of your pipeline, it is important to get the functional purpose of what is happening.   
To this intent, naming is important.   
Several entities must be named in GHA:   
* Workflows
* jobs
* steps

Each of which must express the functional intent it represents so reading the names only, saves you from checking the level below such as run instructions to understand what is happening.   
Specific care should be taken to not fall into another extreme which would be extra verbosity.   
Naming should be explicit and concise.   

## Split workflow definitions per concerns

In development, we tend to avoid {package, class, ...} definition with too many line of code. An healthy approach is to split files per concerns and create interaction between defined entities through interfaces (input and output).    
Although GHA does not provide a language *per se* we still have the capacity to split workflows per functionnal concern.  
The split capacity relies a lot on the triggering configuration which can target event types and path of your folders.   
That way you can trigger tasks dedicated to IaC integration on pull request event on branch foo when files from folder bar are modidified.     

## Keep triggering intents low per workflow

The previous tips, can be misinterpreted as your `on` triggering section can grow while still treating for instance integration concerns.  
When setting several `on.<event type>` you introduce a kind of ambiguity for jobs which care about the event type.  You must solve this ambiguity with `job.if` section which hurts readability.  
To avoid that, prefer to separate triggering intents per workflow files rather than gathering all or many intents in a single workflow file.    
This approach comes at the price of multiplying the workflow file definitions.    

## Condition in workflows rather than in actions

`if` keyword hurts readability. Instead, prefers to condition job execution to the one at the workflow level (coarse conditioning) through the `on` keyword.  

## Hierarchical worklows

Worklows can be called by other workflow using trigerring event `on.workflow_call`.  This enables to subdivide a workflow into a chain of hierarchical workflow i.e a DAG of jobs.   
This brings several benefits:     
* We ease the separation of concerns  
* We mimic the programing concept of (java protected) function as some workflow can only be called by other workflows but no Github event. This is usefull to control the global pipeline job execution as the called workflow kind of inherit the triggering condition of the root workflow  
* We mutualize code and allow calling worflows in several pipelines avoiding code duplication   
* We document workflow through input and output which serves as a "contracts" for consumer workflows    
* We control the global workflow execution by conditioning the "sub-workflows" calls   
* We can add concerns to "level" of workflow. e.g: Level 0 being the orchestration level of level 1 workflow. Level 1 are CI/CD step related tasks (linting, formating, dependency scan, ...), while level 3 workflows are concreted actions calls.   

## Use Github environment by default

GHA environment are documented in the context of deployment purpose.   
In fact they can be selected for any purpose to configure behavior of your workflow jobs.  
This approach is behind the idea of the factor 3 from the *Twelve-Factor App*: "Store config in the environment".    

Only level 0 workflow should access environment variable while sub-workflow will access their values through inputs.    
This enables a strict control of environment consumption and ease readability of subworkflow which are agnostic to environment existence.     
As a rule of thumb we can keep: *Higher level workflow access environment, lower level workflow consumes input*   

## Consume actions market place extensively

In theory, job's steps can be all defined using bash or python. We all love to code but it is important to not reinvent the wheel.   
Compared to other CI/CD pipeline technology, actions market place is a killer feature. It allows to release worldwide common logics so that "I" don't have to code it. Only to consume it.  
Ideally the pipeline is a DAG of actions we only consumes. Coding should be the exception.  

# Missing pieces

GHA, while proposing interesting feature, falls short for some simple features.   

## No ctrl+click in the extension

`uses` keyword enables you to point other local workflows.  
It is however not yet possible to *^+click* on it to navigate to its definition file which breaks the dev flow.   

## Matrix strategy and outputs

The kind of *for loop* of GHA is represented on GHA by the `matrix` strategy.   
Given an input list, it splits your work by threads, each one being bounded to one element of the list.   
This powerful feature is mitigated by the impossibility to collect the output objects of each threads in a collection.  
In a sens, each matrix thread is a kind of *dead end*, you cannot plug the a next job to a collection of output.   
Instead you have to output it in a GHA artifact which is very unconvenient for your workflow readability.   

## Organize workflow per folders

One drawback of our *hierarchical workflows* tip is that it multitplies the number of workflow files.  
Only a minority are effectively called on github event, while the vast majority are triggered on `on.workflow_call`.    
From the GHA console it really hurts visibility.  
A simple ordering by folders may easily fix this issue but it does not exist and the only approch to order workflow files is through naming. 

# Partial conclusion

GHA syntax is not a programation langage. It lacks basic constructs to create needed abstraction for clean code. 
Moreover Github lacks of *easy* feature to simply organize workflows code and set visibility to your consumers.  
That being said, clean code principles also rely on simpler constructs such as naming, code declaration consistency, usage of methods to describe intent, code mutualization...
Those elements are reachable whith GHA but should not be thought as mandatory as it complexifies your code, and should be prefered for complex or enterprise wide shared flow.  
As it is hard to automatically measure the *fitness* of your code, there is a high risk of architecture decay if your organization strategy is not strictly observed.   
This can be a sign that this clean code approach may be not what you need and that a straight forward pipeline may be enough.   
As always, a lean startup approach will prevent you from falling into the trap of overcomplexity by starting with a straightforward pipeline and slowly evolving to more complex strategy if you need to.