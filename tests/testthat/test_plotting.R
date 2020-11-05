# test plotting function

context('Test plot functions')

# load data

ann_dat <- get("Zooplankton_Annual_Stations")
occ_dat <- get("Zooplankton_Occupations_Stations")

# test annual plotting

test_that('Annual means plotting', {
  expect_silent(plot_annual_means(ann_dat, variable = 'Calanus_finmarchicus_log10'))
  expect_error(plot_annual_means(ann_dat, variable = 'not_a_variable'))
  expect_error(plot_annual_means(occ_dat, variable = 'Calanus_finmarchicus')) # fix line when variables are properly renamed

  p <- plot_annual_means(ann_dat, variable = 'Calanus_finmarchicus_log10')
  expect_is(p,"ggplot")
})

# test timeseries plotting

test_that('Occupation plotting', {
  expect_silent(plot_timeseries(occ_dat, variable  = 'Calanus_finmarchicus')) # fix line when variables are properly renamed
  expect_error(plot_timeseries(occ_dat, variable = 'not_a_variable'))
  expect_error(plot_timeseries(ann_dat, variable = 'Calanus_finmarchicus_log10'))

  p <- plot_timeseries(occ_dat, variable = 'Calanus_finmarchicus')
  expect_is(p, 'ggplot')
})

# test generic plotting

test_that('Generic plotting', {

  expect_silent(p1 <- plot_azmpdata(dataset = "Zooplankton_Annual_Stations", variable = 'Calanus_finmarchicus_log10'))
  expect_silent(p2 <- plot_annual_means(ann_dat, variable = 'Calanus_finmarchicus_log10'))
  expect_equal(p1, p2)

  expect_silent(p3 <- plot_azmpdata(dataset = "Zooplankton_Occupations_Stations", variable = 'Calanus_finmarchicus'))
  expect_silent(p4 <- plot_timeseries(occ_dat, variable  = 'Calanus_finmarchicus')) # fix line when variables are properly renamed
  expect_equal(p3, p4)

  expect_error(plot_azmpdata(dataset = "Zooplankton_Annual_Stations", variable = 'not_a_variable'))
  expect_error(plot_azmpdata(dataset = "Zooplankton_Occupations_Stations", variable = 'not_a_variable'))

  expect_error(plot_azmpdata(dataset = 'not_a_dataset', variable = 'not_a_variable'))


})

