# TODOs

## Horizontals
1. Add some more tests to list int, which may break the list int function

2. Find way of selecting from a list of parsers and highlighting the parsers

## Verticals
1. Fix parsing logic, the implementation leaks on Main.elm. Move implementation inside CustomParser.elm

2. Do something with the Model, does not look good. Because it makes parseListOfInt ugly. 
We can return a (err, res) or can create another function for handling the result values. 
Anyways parseListOfInt should not return Model but a Result Err (List Int) would be good.

3. DeadEnd to String sucks. Find a better way to deal with that. Probably return a custom error message
Write the custom error messages in a separate file ErrorMessages.elm and show on errors.

4. Make List Int more generic to support List (Type) instead by taking a parser of the type
and parsing a list 
we can add more features like adding a delimeter or something else but it will start to look similar to *Test.sequence*

