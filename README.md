## FoRmd: Rmarkdown form templates

This package intends to provide:

- A reusable collection of form components/wording, currently focused on collecting project intake and governance info.
- Utils for creating web forms so that functional forms can be customized from templates or from scratch.
- A place for Sage projects to share other reusable form documents. 

**New governance forms are in development.**

### Templates

#### General Usage

(`rmarkdown` >= 2.14)

View templates:  
`rmarkdown::available_templates(package = "formd")`

Create a draft from one of the listed templates, for example:
`rmarkdown::draft("data_sharing_bespoke_DCC", template = "Section_Data_Sharing", package = "formd")`

With the form/doc from the template, customize it to fit the needs of your project, e.g.:

- Change a parameter such as `fundingAgency` to reference the actual project funding agency.
- Tweak the wording.
- Remove or add form inputs; a `*_config.yml` file defines inputs if there are inputs for that template.

Forms are modularized so that they be hosted on separate web pages or concatenated into a single web page.
This allows you to build your form _a la carte_.

##### RStudio

If using RStudio, templates can be accessed via _New File > Rmarkdown..._

![](man/figures/templates_view.png)

For more about templates (if you've never used them), see [RStudio - Rmarkdown Templates](https://rstudio.github.io/rstudio-extensions/rmarkdown_templates.html).

### Form Utils

Instead of customizing a template, you can use the form utils to generate your HTML form front-end through an entirely new Rmarkdown document.
The "DSP Core" template is the best example of what inputs are available and how to compose them. 

### Examples

### Questions

- **Which form backend should I use/does this work with?** We recommend formspark.io. There are a multitude of good form backends, though you may need to preprocess your JSON data to make PDF generation work correctly. 
- **Can this be used with PHI?** That actually depends on your form backend and where you are putting your form. But this was originally intended for better administrative data collection. 

### Development Notes

**This is being incubated in the NF-OSI project. 
At some point, when stable and useful enough, we plan to have this be under [Sage-Bionetworks](https://github.com/Sage-Bionetworks/).**


