Comments from the review addressed:

* Please add \value to .Rd files regarding exported methods and explain
  the functions results in the documentation: Missing \value added.

* You have examples for unexported functions: examples removed.

* All your examples are wrapped in \donttest{} and therefore do not get
  tested: As explained in the previous submission, many examples run above 5s depending on the machine. 
  On CRAN I had to disable those examples, but there are some examples that are run on CRAN. 
  Besides the packages has tests for some functions.

* You are using installed.packages() in your code. As mentioned in the
  notes of installed.packages() help page, this can be very slow:
  I'm aware and I did on purpose, as the purpose of the call was to show a representative example for the user. 
  Not to test if a suggested package was available. Nevertheless, I commented it from the example.

* This is a new package being submitted to CRAN

* This packages access data on src/contrib/Meta/ via the tools package: 
  Sometimes it fails to read it if the data is being written.

* This packages works without errors or warnings on the Rhub platforms: 
 - noSuggests
 
* This packages works without errors or warnings on the CRAN platforms: 
 - win-devel
 - win-release
 - macos
 
 * There are no references for this package as it is not described in any academic article or even blog post (yet?) 
