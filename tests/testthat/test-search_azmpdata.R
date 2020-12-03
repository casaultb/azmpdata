context('Test searching functionality')

library(azmpdata)

test_that('single simple keyword search ',{
  expect_silent(ans <- variable_lookup('nitrate'))
  expect_true(is.data.frame(ans))
  # expect_equal(dim(ans), c(10,3))
})


test_that('single keyowrd search with help',{
  expect_message(ans <- variable_lookup(keywords = 'nitrate', search_help = TRUE))
  # expect_equal(dim(ans), c(18,3))

})

# local testing only
# if there is an error try adding a lib.loc argument to specify where the package help is located
# eg
# variable_lookup(keywords = 'nitrate', search_help = TRUE, lib.loc = 'C:/Users/ChisholmE/Documents/R/R-4.0.2/library')

test_that('multiple keywords with help',{
  expect_message(ans <- variable_lookup(keywords = c('nitrate', 'integrated'), search_help = TRUE))
  # tibble 41x3
  # expect_equal(dim(ans), c(41,3))
  expect_message(ans <- variable_lookup(keywords = c('nitrate', '100'), search_help = TRUE))
  # tibble 30x3
  # expect_equal(dim(ans), c(30,3))
})


test_that('keywords which only exist in help files show up',{

  expect_message(ans <- variable_lookup(keywords = 'unique identifier', search_help = TRUE))
  # tibble 2x3
  #expect_equal(dim(ans), c(2,3))
  expect_message(ans <- variable_lookup(keywords = 'stratification', search_help = TRUE))
  # tibble 1x3
  #expect_equal(dim(ans), c(1,3))
})
