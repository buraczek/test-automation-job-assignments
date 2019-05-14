@constant(SUPER_SECRET_SUITE_VARIABLE: 37)
@constant(VARIABLE_FROM_LIB: 42)
Feature: Example feature file testing my mathematics skills
    This is description of feature file
    This particular one will demonstrate
    Scenario, scenario outlines, background

    Background: Display message
        Given demo message is displayed

    @basic
    @math_tests
    Scenario Outline : Sunny day scenarios - basic actions
        Given expression "<expression>" is valid
        When expression "<expression>" is evaluated
        Then result is equal to "<expected_result>"

    Examples:
        | expression                                                                                           | expected_result |
        | ${SUPER_SECRET_SUITE_VARIABLE}+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1+1                                       | 53              |
        | ${VARIABLE_FROM_LIB}+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1)+(-1) | 26              |
        | ${SUPER_SECRET_SUITE_VARIABLE}-${VARIABLE_FROM_LIB}                                                  | -5              |
        | ${VARIABLE_FROM_LIB}-${SUPER_SECRET_SUITE_VARIABLE}                                                  | 5               |
        | ${SUPER_SECRET_SUITE_VARIABLE}*${SUPER_SECRET_SUITE_VARIABLE}                                        | 1369            |
        | ${VARIABLE_FROM_LIB}*${VARIABLE_FROM_LIB}                                                            | 1764            |
        | ${SUPER_SECRET_SUITE_VARIABLE}/${VARIABLE_FROM_LIB}                                                  | 0.880952380952  |
        | ${VARIABLE_FROM_LIB}/${SUPER_SECRET_SUITE_VARIABLE}                                                  | 1.13513513514   |

    @advanced
    @math_tests
    Scenario: Sunny day scenarios - multiple actions
        Given expression "(4 - 2 * 3 + 6 / 2) / 2" is valid
        When expression "(4 - 2 * 3 + 6 / 2) / 2" is evaluated
        Then result is equal to "0.5"
