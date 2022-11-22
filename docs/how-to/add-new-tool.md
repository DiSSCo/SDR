# Adding a new tool to the SDR #

Adding a new tool to the SDR follows the standard Galaxy [procedure](https://training.galaxyproject.org/training-material/topics/dev/tutorials/tool-from-scratch/tutorial.html#galaxy-tool-wrappers "galaxy tool wrapper").

In this how-to we will discuss the general tool structure we have followed for the SDR and break down a template example.

## Tool development procedure ##

In general the procedure for developing a Galaxy tool wrapper is as follows:
  * Decide whether or not to containerise the tool
  * Define the shell command(s) required for running a tool
  * Create the framework of the tool
  * Formalise the inputs of the tool
  * Formalise the outputs of the tool
    * Implement collection output
  * Add tool to tool configuration
  * Reload Galaxy
  
### Containerisation ###

Most tools in the SDR are containerised, meaning then have been packaged in [Docker](https://www.docker.com/ "docker") containers. Performing this containerisation is recommended for tools of medium and high complexity but beyond the scope of this guide.

### Shell command derivation ###

All Galaxy tools wrappers essentially represent the formalisation of a single or series of shell commands. As such, an understanding of the basic use of the tool you want to package, and how you would like it to be run on the command line is essential to being able to formulate a Galaxy tool wrapper.

For this guide, we will follow the example of creating a wrapper for an already implemented SDR tool, the "split file" tool. This command uses the Linux [split](https://www.gnu.org/software/coreutils/manual/html_node/split-invocation.html "split") tool to divide individual lines of an input csv file into separate files, output as a Galaxy collection.

The shell command use to achieve this end, in a standard Bash prompt was:

```console
foo@bar $ split input.csv -l1 -d split_ --additional-suffic=.csv -a5
```
where:
  * `input.csv` was the input file
  * `-l1` splits the input every 1 lines
  * `-d split_` set the output file prefix
  * `--additional-suffix=.csv` set the output file suffix
  * `-a5` creates numerically ascending 5 digit reference
  
to produce output files named "split_XXXXX.csv" 

### Top matter and description ###

To create a Galaxy wrapper, a basic framework should be created. This consists of a tool tag containing:
  *  a unique id, a tool name and version
  *  a human readable description of the tool being implemented 
  *  help text.
  
This block for the split tool is given below.

``` xml
<tool id="split_file" name="Split file into collection" version="0.1.0">
  <description>Splits a file line by line into seperate entries in a collection</description>
  <help>
    Splits a file line by line into seperate entries in a collection
  </help>
</tool>

```

### Command ###

Next the terminal command to be run should be formalised. The command is enclosed in a tag named command and the `<![CDATA[ content ]]>` directive instructs the parser to not attempt to evaluate the contents as XML.

``` xml
  <command>
    <![CDATA[
    ]]>
  </command>
```

Populating this structure with the command derived above we achieve:

``` xml
  <command>
    <![CDATA[
      split input.csv -l1 -d split_ --additional-suffix=.csv -a5 
    ]]>
  </command>
```

However, to make the output of the command easier to retrieve, we will produce this output in a subfolder. This is achieved using standard Bash commands, chained with `&&` (continue to next command if successful).

``` xml
  <command>
    <![CDATA[
      mkdir outputs && cd outputs && split input.csv -l1 -d split_ --additional-suffix=.csv -a5 
    ]]>
  </command>
```

At this moment, the input file name is hard coded, which is very undesirable. To overcome this, a variable is used which is linked to the input specification.

``` xml
  <command>
    <![CDATA[
      mkdir outputs && cd outputs && split '$input' -l1 -d split_ --additional-suffix=.csv -a5 
    ]]>
  </command>
```

### Inputs ###

Having defined the input variable, we now need to expose it to the Galaxy GUI. This is achieved using the inputs tag, as below:

``` xml
  <inputs>
    <param format="text" name="input" type="data" label="Input"/>
  </inputs>
```

Here we have defined an input named "input", specifying an input text file using the type "data" and format "text" specifications. The input will appear in the Galaxy GUI labelled as "Input".

### Outputs ###

We now need to specify the outputs which Galaxy should pick up. For a simple command this might look like the following (n.b. the dummy shell command):

``` xml
  <command>
    <![CDATA[
      echo hello > $output
    ]]>
  </command>
  <outputs>
    <data format="text" type="data" name="output" />
  </outputs>
```

Here, the simple command produces text output, which is piped into an output file. The output tag, similar to the input tag used above can pick the tool output using the output variable.

However, in our case we are trying to collect many files, a common use case. This is achieved by using the discover datasets directive, which allows us to specify patterns by which to search for files to collect for output.

``` xml
  <command>
    <![CDATA[
      mkdir outputs && cd outputs && split '$input' -l1 -d split_ --additional-suffix=.csv -a5 
    ]]>
  </command>
  <outputs>
    <discover_datasets pattern="__name_and_ext__" directory="outputs" />
  </outputs>
```

This tool is workable, but produces a large amount of records to be written to the Galaxy history. To instead bundle the output into a single item, we use the Galaxy concept of collections.

``` xml
  <outputs>
    <collection name="split_files" type="list" label="Split files">
      <discover_datasets pattern="__name_and_ext__" directory="outputs" />
    </collection>
  </outputs>
```

### Final tool wrapper ###

Taken the modifications we have made above, we now have a full tool wrapper:

``` xml
<tool id="split_file" name="Split file into collection" version="0.1.0">
  <description>Splits a file line by line into seperate entries in a collection</description>
  <command>
    <![CDATA[
      mkdir outputs && cd outputs && split '$input' -l1 -d split_ --additional-suffix=.csv -a5 
    ]]>
  </command>
  <inputs>
    <param format="text" name="input" type="data" label="Input"/>
  </inputs>
  <outputs>
    <collection name="split_files" type="list" label="Split files">
      <discover_datasets pattern="__name_and_ext__" directory="outputs" />
    </collection>
  </outputs>
  <help>
    Splits a file line by line into seperate entries in a collection
  </help>
</tool>
```

### Add to Tool configuration ###

For Galaxy to pick up the tool we have developed, we must place it in a known location on the server. The SDR tools are collected at `/srv/galaxy/server/tools/sdr` and this path must be added to the tool config file, located in the SDR deployment repository at `/path/to/sdr/templates/galaxy/config/tool_conf.xml.j2`. 

The file has the format below and a new tag should be added to point to your new tool.

```
<?xml version='1.0' encoding='utf-8'?>
<toolbox monitor="true">
  ...
  <section name="SDR" id="sdr">
    <tool file="sdr/create-opends/create_opends.xml" />
    <tool file="sdr/validate-opends/validate_opends.xml" />
    <tool file="sdr/split_file/split_file.xml" />
    ...
  </section>
  ...
</toolbox>
```

### Reload Galaxy ###

```console
foo@bar $ systemctl restart galaxy
foo@bar $ systemctl status galaxy
```
