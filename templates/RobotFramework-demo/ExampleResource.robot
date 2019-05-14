*** Keywords ***
Successful Calculation (bdd)
    [Arguments]    ${expression}    ${expected_result}    # ${expression} should be string that can be evaluated as Python expression
    [Documentation]    Keywords as templates for some of testsGiven expression "${expression}" is evaluated
    Given expression "${expression}" is valid
    When expression "${expression}" is evaluated
    Then result is equal to "${expected_result}"

Successful Calculation (non-bdd)
    [Arguments]    ${expression}    ${expected_result}    # ${expression} should be string that can be evaluated as Python expression
    [Documentation]    Keywords as templates for some of tests
    Comment    Well I know why eval is not so popular, so I'll make a check just in case
    Should Be True    all([not x.isalpha() for x in list(str(${expression}))])
    ${expression_evaluated}    ExamplePythonLibrary.Better Evaluate    ${expression}
    Should Be Equal    float(${expression_evaluated})    float(${expected_result})

expression "${expression}" is evaluated
    ${expression_evaluated}    ExamplePythonLibrary.Better Evaluate    ${expression}
    Set Test Variable    ${EXPRESSION_EVALUATED}

expression "${expression}" is valid
    Comment    Well I know why eval is not so popular, so I'll make a check just in case
    Should Be True    all([not x.isalpha() for x in list(str(${expression}))])

result is equal to "${expected_result}"
    Should Be Equal    float(${EXPRESSION_EVALUATED})    float(${expected_result})
