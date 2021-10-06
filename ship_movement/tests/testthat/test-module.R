# See ?testServer for more information
testServer(DropDownMod, {
  # Set initial value of a button
  session$setInputs(ship_type = 'Cargo')

  # Check the value of the reactiveVal `count()`
  expect_equal(ship_namest()[1:3], c("AALDERDIJK" , "ADAMAS" ,"ADASTRA"))
  
})
