test_that("C++ code works", {
  expect_equal(two(), 2L)
})

test_that("compiler version", {
  expect_message(compiler())
})
