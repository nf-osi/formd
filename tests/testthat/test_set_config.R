# What a config list object should look like when read in
test_config_1 <- list(Input1 = list(name = "Input1", type = "hidden", form = "x"))
attr(test_config_1, "sourcefile") <- "test_config_1.yml"

testthat::expect_identical({
  setConfig("test_config_1.yml")
  }, test_config_1)

# Appending to an existing config when .F already exists
# test_config_2 <- c(test_config_1,
#                    list(Input2 = list(name = "Input2", type = "text", form = "x")))
# attr(test_config_2, "sourcefile") <- c("test_config_1.yml", "test_config_2.yml")
# 
# testthat::expect_identical({
#   .F <- setConfig("test_config_1.yml")
#   .F <- setConfig("test_config_2.yml")
#   .F
#   },
#   test_config_2)
