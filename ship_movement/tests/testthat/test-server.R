testServer(expr = {

  session$setInputs(ship_type = 'Cargo')
  expect_equal(output$distance_info, "Traveled 1104.79 meters at 33.71 Km/h")

})
