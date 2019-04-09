# Sample CWL Pipelines that work with BLAST.
This directory contains a collection of sample Common Workflow Language (CWL) pipelines that make use of a dockerized version of BLAST.  The samples are also supposed to be simple, so you can easily understand them and start modifying them.

If you are new to CWL or docker, you may want to start by looking at some of the resources listed at the end of this page.

### Why a workflow language?
Many pipeline are written in an ad hoc manner using the scripting language at hand. There's nothing inherently wrong with scripting languages, but a workflow language (e.g., CWL) provides a framework that helps you break your task up into distinct steps that are easier to maintain and performs more checking on input. You can still use a script as one of the steps. Additionally, the CWL framework results in pipeline that are more compliant with [FAIR principles][fair_principles].

### What's here that's interesting?
Enough talk.  What's in this directory that I should look at?  

First, you should take a quick read through the [CWL User Guide][cwl_man] (admittedly, that's not in this directory).  Then, you could start by looking at a simple BLASTP search.  Every CWL task requires two files.  The first one specifies the tools and the structure of the work.  The second specifies the arguments to your tools.  For the BLASTP search, you'd execute (TODO: install database):

   ```bash
   cwl-runner blastp_docker.cwl blastp_docker_input.yml
   ```

This command just runs a BLASTP search and produces BLAST output.  In the parlance of CWL this module has the class "CommandLineTool".  That's good, but it would be more interesting to run a pipeline where the BLASTP search is just one part of it.  The command below runs BLASTP, then parses the tabular output with a python script (TODO: set path with: export PATH="$PATH:$PWD"):

   ```bash
   cwl-runner simple_two_step.cwl simple_two_step_input.yml
   ``` 

You can modify the python script (it's called `parse_blast_report.py`) to make it do something else. You can also add steps to this workflow. This module has the CWL class "Workflow" and runs a couple of modules with class CommandLineTool. 

Also, you are not limited to the CWL modules in this directory or the ones you write.  There's a bunch of CWL modules [here][cwl_mods].  One of the workflows in this directory (`magicblast2bami.cwl`) uses the samtools workflows from that directory to produce a sorted/indexed BAM file from the original SAM file that Magic-BLAST produces.  These modules use a dockerized version of samtools, so you don't even need to compile and install samtools! 

### Can I visualize my pipeline?
Sure.  You can use the CWL viewer [here][cwlviewer].  To see what this looks like, take a look at the plot for the [simple_three_step][three_step_view] workflow.

### Why docker?
We've dockerized BLAST for our pipelines for a couple of different reasons.  One is that it makes the setup of BLAST on a cloud instance very simple.  Another is that docker plays nicely with CWL.  

### Where can I run these?
So far, these workflows have been run on a Ubuntu 18.0.4 instance with the following packages installed:
* git
* cwltool
* vim
* docker

You'll also need an instance with sufficient disk space for the BLAST databases (300+ GB) and sufficient memory to hold the sequence and index parts of the databases (120 GB seems to work as of April 2019).  Both of these numbers will change as the databases increase in size.

### Can you describe these workflows?
Sure.  Look at the table below.


|Description   |Input   |Class    | Purpose    |Requirements    |
|--------------|--------|---------|------------|----------------|
|blastp_docker.cwl | blastp_docker_input.yml | CommandLineTool | BLASTP search | database, query file|
|blastdbcmd_docker.cwl | blastdbcmd_docker_input.yml | CommandLineTool | Fetch info from BLAST database | database |
|magicblast_docker.cwl | magicblast_docker_input.yml | CommandLineTool | Align sequences | database | 
|parse_blast_report.cwl | parse_blast_report_input.yml | CommandLineTool | parse tabular output | Tabular input |
|samtools-bed.cwl | samtools-bed_input.yml | CommandLineTool | produce BED file from BAM | Workflows from [here][cwl_mods]|
|simple_two_step.cwl | simple_two_step_input.yml | Workflow | BLASTP search and parse tabular | database, query file, parse_blast_report.py, add location of parse_blast_report.py to $PATH|
|simple_three_step.cwl | simple_three_step_input.yml | Workflow | simple_two_step, dump out subject sequences | query, db, add location of parse_blast_report.py to $PATH|
|magicblast2bami.cwl | magicblast2bami_input.yml | Workflow| Magic-BLAST run; SAM to indexed BAM| database, Workflows from [here][cwl_mods]|




### Resources
* [CWL User Guide][cwl_man] 
* [Video on CWL][cwl_video] 
* [BLAST docker documentation][docker_man]
* [Troubleshooting docker](https://github.com/ncbi/docker/blob/master/blast/README.md#troubleshooting)
* [NCBI workbench documentation][workbench_man]
* [Using BLAST in the Cloud][blast_in_cloud]
* [Using BLAST Well][blast_well]

[cwl_man]: https://www.commonwl.org/user_guide/
[cwl_video]: https://www.youtube.com/watch?v=jfQb1HJWRac&feature=youtu.be
[docker_man]: https://github.com/ncbi/docker/blob/master/blast/README.md
[workbench_man]: https://github.com/ncbi/docker/tree/master/ncbi-workbench
[fair_principles]: https://www.force11.org/group/fairgroup/fairprinciples
[cwl_mods]: https://github.com/common-workflow-language/workflows/tree/master/tools
[blast_in_cloud]: https://docs.google.com/presentation/d/1kgIiF2jGZwqLZ1eqyM8ihMtZEwd8w3Bq3IwTIa2AQ-0/edit#slide=id.p
[blast_in_cloud]: https://docs.google.com/presentation/d/1kgIiF2jGZwqLZ1eqyM8ihMtZEwd8w3Bq3IwTIa2AQ-0/edit?usp=sharing
[blast_well]: https://ftp.ncbi.nlm.nih.gov/pub/education/public_webinars/2018/10Oct03_Using_BLAST/Using_BLAST_Well2.pdf
[cwlviewer]:https://view.commonwl.org
[three_step_view]: https://w3id.org/cwl/view/git/881c04b0ffd908244f838ff24a530e381ddfa34a/blast-pipelines/simple_three_step.cwl


