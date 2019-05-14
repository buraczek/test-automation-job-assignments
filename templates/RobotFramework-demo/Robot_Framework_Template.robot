*** Settings ***
Documentation     This is just a simple demo for *RobotFramework* using example of *calculator*, *Keyword* and *Gherkin* -styled keyword syntax. Can be used as a template for other tests if You're still learning framwework.
Suite Setup       Generic Suite Setup
Suite Teardown    Generic Suite Teardown
Test Teardown     Generic Test Teardown
Force Tags        TAG_FOR_EVERYONE
Default Tags      TAG_FOR_TAGLESS
Test Timeout      100 milliseconds
Metadata          Directory    %{PWD}
Library           ExamplePythonLibrary.py    42    # Example library written in Python
Resource          ExampleResource.robot    # Example resource holding keywords that will be templates for some test cases

*** Variables ***
${SUPER_SECRET_SUITE_VARIABLE}    37
${VARIABLE_FROM_LIB}    ${EMPTY}

*** Test Cases ***    expression                                                                                              expected_result
Additions non-bdd     [Tags]                                                                                                  ADD
                      [Template]                                                                                              Successful Calculation (non-bdd)
                      ${SUPER_SECRET_SUITE_VARIABLE}+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1                                          53
                      ${VARIABLE_FROM_LIB}+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)    26

Subtractions non-bdd
                      [Tags]                                                                                                  SUB
                      [Template]                                                                                              Successful Calculation (non-bdd)
                      ${SUPER_SECRET_SUITE_VARIABLE}-${VARIABLE_FROM_LIB}                                                     -5
                      ${VARIABLE_FROM_LIB}-${SUPER_SECRET_SUITE_VARIABLE}                                                     5

Multiplication non-bdd
                      [Tags]                                                                                                  MUL
                      [Template]                                                                                              Successful Calculation (non-bdd)
                      ${SUPER_SECRET_SUITE_VARIABLE}*${SUPER_SECRET_SUITE_VARIABLE}                                           1369
                      ${VARIABLE_FROM_LIB}*${VARIABLE_FROM_LIB}                                                               1764

Division non-bdd      [Tags]                                                                                                  DIV
                      [Template]                                                                                              Successful Calculation (non-bdd)
                      ${SUPER_SECRET_SUITE_VARIABLE}/${VARIABLE_FROM_LIB}                                                     0.880952380952
                      ${VARIABLE_FROM_LIB}/${SUPER_SECRET_SUITE_VARIABLE}                                                     1.13513513514

Mixed non-bdd         Successful Calculation (non-bdd)                                                                        (4 - 2 * 3 + 6 / 2) / 2             0.5

Additions bdd         [Tags]                                                                                                  ADD
                      [Template]                                                                                              Successful Calculation (bdd)
                      ${SUPER_SECRET_SUITE_VARIABLE}+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1                                          53
                      ${VARIABLE_FROM_LIB}+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)    26

Subtractions bdd      [Tags]                                                                                                  SUB
                      [Template]                                                                                              Successful Calculation (bdd)
                      ${SUPER_SECRET_SUITE_VARIABLE}-${VARIABLE_FROM_LIB}                                                     -5
                      ${VARIABLE_FROM_LIB}-${SUPER_SECRET_SUITE_VARIABLE}                                                     5

Multiplication bdd    [Tags]                                                                                                  MUL
                      [Template]                                                                                              Successful Calculation (bdd)
                      ${SUPER_SECRET_SUITE_VARIABLE}*${SUPER_SECRET_SUITE_VARIABLE}                                           1369
                      ${VARIABLE_FROM_LIB}*${VARIABLE_FROM_LIB}                                                               1764

Division bdd          [Tags]                                                                                                  DIV
                      [Template]                                                                                              Successful Calculation (bdd)
                      ${SUPER_SECRET_SUITE_VARIABLE}/${VARIABLE_FROM_LIB}                                                     0.880952380952
                      ${VARIABLE_FROM_LIB}/${SUPER_SECRET_SUITE_VARIABLE}                                                     1.13513513514

Mixed bdd             Successful Calculation (bdd)                                                                            (4 - 2 * 3 + 6 / 2) / 2             0.5

*** Keywords ***
Generic Suite Setup
    Log    This text should appear as the first in the log: Hello!
    ${tmp}    ExamplePythonLibrary.Get Var
    Set Global Variable    ${VARIABLE_FROM_LIB}    ${tmp}
    Log Many    Metadata:    &{SUITE METADATA}

Generic Suite Teardown
    Log    This text should appear as the last in the log: Goodbye!

Generic Test Teardown
    Log    Test status: ${TEST STATUS}
