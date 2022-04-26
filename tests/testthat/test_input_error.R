testthat::expect_error(newInput(list()),
                       "Input not defined in config!")


testthat::expect_error(schemaRange("https://raw.githubusercontent.com/nf-osi/nf-metadata-dictionary/main/NF.jsonld", "ex:DoesNotExist"),
                       "Id not found in reference schema!")
