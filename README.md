# Test suite for `outsider`

[![Build Status](https://travis-ci.org/ropensci/outsider-testsuites.svg?branch=master)](https://travis-ci.org/ropensci/outsider-testsuites) [![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/ropensci/outsider-testsuites?branch=master&svg=true)](https://ci.appveyor.com/project/DomBennett/outsider-testsuites)

Runs a series of pipelines implementing multiple `outsider` modules in order to
better assess the functionality of the package `outsider` as well as the piping
of `outsider` modules and their various components.

For more information on `outsider` visit its
[webpage](https://ropensci.github.io/outsider/).

## Contributing

Please feel free to fork and add your own test suite! Expected file structure:

```
-- [0-9]_suite/
  -- script.R       # the simple pipeline
  -- README.md      # description of the pipeline
```

Please ensure pipelines run quickly, provide helpful messaging and run < 5 mins.
