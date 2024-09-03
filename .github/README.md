<!-- # TODO: document that a "concrete" workflow will never have any condition. Conditions are set at the calling workflow levels only.
# first level is about trigerring event and path filtering. 
# second level workflow is about more arbitrary condition level. 
# second level workflow is not only triggered on workflow-call since it should be able to be optionally triggered by feature branch activity (so we may also filter on event / path) -->

<!-- TODO: document the fact that we extensively use the notion of github environment coupled with the notion of 'main' workflow to impement the third factor of 12 factors app -->

# Github Action

## Overall understanding

Please read the main [README](./../README.md) to understand the best practices we try to illustrate

## Github action targets

This repository is a monorepo mixing sources from frontend and backend application along with Infrastructure As Code.   
Mixing frontend and backend is ok as they usually share a common lifecycle. It is not the case of the IaC.   
Although Git is powerfull enough to separate lifecycle event in a common repo (branching and Github actions allowing to segregates Git flows), we would still mix concerns during the Pull Requests.   
We choose to still mix sources for the sake of demonstration purpose on GHA usage in applicative and infrastructure context.

### IaC sources

### Application sources

### Needed environment variables

## Github Actions strategies

Defined GHA workflows illustrates *clean code* concepts:   
* Naming
* Separation of concerns
* Hierarchic separation, which is a specialized kind of separation of concerns
* Strategic conditionning taking advantage of the hierachic separation so that "concrete" workflow (the ones which does not focus on orchestration but launch actual jobs) will hardly require `if` keyword 
* Usage of Github environment, not only for deployment concerns

# Git flow

## Infrastructure

## Application

## How to read workflows

Because of the hierachical separation, we multiply the number of files which clearly does not help readability.  
File naming convention may help. Here is the proposed convention:   

* Pipeline entry point are files prefixed by **0_** prefix
* Concrete workflow (doing the actual job and only callable) are prefixed by **_** 
* Unprefixed workflow are the one which are callable but also triggered by Github events. (e.g: for feature branches controls)

# Applicative packages tagging strategy
 This action considers that given an image name, it either has:
 1. a tag with the current triggering event's sha1 --> we need to allign the tag latest with this tag sha1 (creating it if not existing)
 2. a tag 'latest' exists but no tag named after trigerring event sha1 --> We need to allign the sha1 tag with the existing 'latest' tag
 
 We should fail if none of these situtations is true.


 This strategy allows us to consider multi-services deployment with a single sha1 commit.
 Note: 
 - Tag latest is not to be referenced. Only to track the 
 - This strategy works if applied on a single branch. Generally the history source of truth for source code: default branch.
   beware to call this action from a workflow considering a single branch only. Otherwise, latest will be relative and concurently accessed. 
 - To reset the logic, just remove tags latest from your sevice repositories



 Workflow dedicated to the image build and push action.

 In order to preserve Github action compute time, we build an image from a Dockerfile if and only if associated files have changed.  
 Associated is to be understand as: files in the same Dockerfile dirname or subdirestories.  

 Dockerfiles are automatically detected if following the pattern 'Dockerfile*'
 The tag 'latest' is added if not exist, otherwise translated to the new sha1 tag.
 Whether built or not, we set the tag corresponding to the sha1 originating this workflow at the same location of the 'latest' tag.

 If any of the dockerfile build fails, we do not have to remove images which builds succeeded.
 Thx to the previous strategy, the fix commit would either only trigger new tags appliance with the fix sha1 either rebuild the image 
 and apply the same fix sha1. Tag 'latest' will be translated to thix fix. 
 We will have 'orphaned' images (never considered by the CD pipeline as we want all images to be on the same tag) that would be cleaned at some point.