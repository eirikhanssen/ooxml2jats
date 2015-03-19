# ooxml2jats

Developing an automatic tagging solution to produce **JATS** XML output from **.docx** files saved in the format **ooxml**.

Written in XSLT 2.0 and XProc 1.0.

## Warning - work in progress
This project is currently under active development and will change without notice.

## Project motivation

In a previous project, called jats2epub, me and my collegues developed an XML based workflow and a tool called jats2epub (https://github.com/eirikhanssen/jats2epub) to automatically generate HTML fulltext and ePub from scientific articles marked up using the JATS Publishing tagset.
As a bonus the ePub can also easily be converted to .mobi format, allowing the use of kindle devices as well.

### Tagging by hand

Marking up scientific papers in the JATS xml tagset can be rather time consuming. 
Typical time spent marking up a single paper in JATS Publishing tag set vary between 3 to 4 hours per article. But in the extreme cases it can take a skilled person even 10 hours to tag just one scientific article.
The number of in-text citations, references in the reference list as well as the length of the article all contribute to almost proportionally increasing the time it takes a human to mark up an article.

### Scalability

Without an automatic tagging solution, with our available manpower, we are only able to provide the service of publishing in html, ePub and mobi formats to one of our institution's ten journals.

Wouldn't it be wonderful if there was a tool that could allow a machine to do this work?

Then the person working with this task could spend considerably less time per article and focus on proofreading.

And then the project ooxml2jats was born.

## OOXML
OOXML, or Open Office XML is a XML based document format. A .docx file in this format can be unzipped, and the internal file and folder structure will be revealed.

### Why OOXML?

OOXML was chosen as a starting point because:
- It is an easy container format to work with.
- We get files delivered as word .docx files, that we easily save in the OOXML format.

## What about ODF?

**there will be an odf2jats too**

ODF is a similar container format. You can unzip an .odt file and reveal the internal folder and file-structure.

- ODF = Open Document Format
- native format of Libre Office and Open Office, and being a free format as in free speech, it is supported by many other programs

## JATS (Publishing)
Journal Archiving Tag Suite is an XML tagset for marking up/describing scientific articles.

- http://jats.nlm.nih.gov/
- http://jats.nlm.nih.gov/publishing/
- http://jats.nlm.nih.gov/publishing/tag-library/

## Technical overview - ooxml2jats

ooxml2jats exploits the grouping and RegularExpressions text pattern matching capabilities of the XSLT 2.0 and XPath 2.0 language.

The automatic tagging solution is broken down into small and managable tasks and run using an XProc pipeline. 
XProc is an XML pipeline language, enabling to run a series of tasks that need to be done to get from the starting poing to the final output.
XProc can run XSLT 2.0 stylesheets, as well as many useful steps of it's own.

ooxml2jats contains many xsl stylesheets that do the transformations needed.

### Pattern matching

In order to properly mark up the running text citations and the references in the reference list, the support for regular expressions in XSLT 2.0/XPath 2.0 is exploited to:
- identify where the references are in the running text
- automatically generate id's for the references
- identify what type of references are in the reference list
- identify different parts of the reference list and automatically mark up the references using the JATS tagset.

It is also worth to note that it is important to preserve **bold** and *italic* formatting during the extraction from the OOXML container format.
This is because in the APA style citation format, italic text in the references in the reference list has special meaning that helps to identify the different parts of a reference. Also we would like to preserve the author's formatting of text that should be in boldface or italics.

### Generating structure from a flat document structure

XSLT 2.0's grouping cababilities have been exploited to divide the body text of the article in proper section (sec) elements.
If you're interested in how that's done, you can read the excellent article on the topic by Pricilla Walmsley: http://www.ibm.com/developerworks/library/x-addstructurexslt/
This article also explains how to generate a structure from the OOXML format based on a style mapping.

## Citation styles

Initially this tool is developed to support APA style citation formatting because it is the most commonly used citation style in our institution.

But with time other commonly used citation styles could easily be added as well.
- Chicago style
- Harward style
- Possibly other styles as well - if you're missing a style and know (or are willing to learn) Regular Expressions and XSLT 2.0, you could make a new style module.

## Required software

- XProc processor: calabash - http://xmlcalabash.com/ (this will probably work with a different XProc processor as well).
    - calabash is built on top of the XSLT processor saxon and java.
- java - calabash, saxon and the libs are .jar archives, so you need a java environment to run the pipeline.
- python-pygments (optional) - if you want the xml colorized output in the less pager using the ooxml2jats shellscript.

## Operating system??

I am using Gnu/Linux but anything goes as long as you have the above installed.

## How to use (WIP)

**Warning: ooxml2jats is currently undergoing active deveopment and is subject to change without notice**

Try the command:

```
calabash ooxml2jats.xpl
```
or use the bash shellscript:

```
./ooxml2jats
```
The ooxml2jats shellscript saves the output in ooxml2jats.output.xml and then filters it through pygmentize to colorize the xml output in the less pager:
```
#!/bin/bash
calabash ooxml2jats.xpl | tee ooxml2jats.output.xml | pygmentize -l xml | less -RS
```

## Todo

Ideas, tasks and issues that haven't been implemented/fixed yet
- reference list
    - book type references
        - the reference parser can't handle an uri at the end
        - when title is translated:
            - need trans-source elements and xml:lang on source and trans-source
    - book chapter type references
        - the source (name of the book) is missing
        - trans-title and trans-source elements missing for references with translated titles
        - the reference parser probably can't handle an uri at the end
    - journal type references
        - not implemented yet
    - dissertation not marked up (sort of a book type reference) - Persson S. (2008) - missing id also, because of long publisher name with comma.
- running text citations
    - identify and isolate each reference present within a parenthesis
    - automatically tag and generate id for these running text citations
- generate a report of punctuation errors we can mail back to the authors
- schematron validation
    - if book chapter ref and either of trans-source or trans-title present
        - then chapter-title, source, trans-source and trans-title must all have xml:lang attributes
    - if journal type ref and trans-title element present, then article-title and trans-title botn need xml:lang attributes
    - if book ref and translated title (trans-source element)
        - then source and trans-source need to have xml:lang
- should use types/type checking with the as attribute in xslt stylesheets
- should create a method to check if all text in the original refernce has been marked up and issue a warning if there is some text that has not
- resolve duplicate id's gracefully

## How to contribute

If you're interested in this project, go ahead and message me or fork this project and issue a pull request!
