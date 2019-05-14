*** Settings ***
Test Setup        Generic Test Setup
Test Teardown     Close All Browsers
Library           Selenium2Library
Library           Collections
Library           String
Library           libexample.py

*** Variables ***
${ASSIGNMENT_PAGE_URL}    https://xyz
${OFFERS_BY_PAGE}    6
${CURRENT_PAGE}    0
${PAGES_TOTAL}    0
${OFFERS_TOTAL}    0
@{OFFERS}

*** Test Cases ***
Case01 - Last Page, no City Selected
    Search Open Positions For Job    Customer Service Engineer    Kuala Lumpur

Case02 - Middle Page, no City Selected
    Search Open Positions For Job    Senior Full Stack Developer    Helsinki

Case03 - First Page, no City Selected
    Search Open Positions For Job    (Senior) Backend Software Engineer for Labs Advanced Protection Solutions    Helsinki

Case04 - Last Page, City Selected
    Select City    Helsinki
    Get Number of Pages and Offers
    Search Open Positions For Job    Software Engineer in Test    Helsinki

Case05 - Middle Page, City Selected
    Select City    Helsinki
    Search Open Positions For Job    Technical Information Security Manager    Helsinki

Case06 - First Page, City Selected
    Select City    Helsinki
    Search Open Positions For Job    (Senior) Data Scientist    Helsinki

*** Keywords ***
Apply For Job
    Element Should Contain    //*[@class="btn btn-huge btn-success btn-embossed btn-block mbl"]    I'm interested
    Click Element    //*[@class="btn btn-huge btn-success btn-embossed btn-block mbl"]

Assert Job Location
    [Arguments]    ${city}
    Element Should Contain    //*[@class="job-details hidden-phone"]/li[2]    ${city}

Assert Job Title
    [Arguments]    ${position}
    Element Should Contain    //*[@class="job-title"]    ${position}

Assignment Page is Opened
    Open Browser    ${ASSIGNMENT_PAGE_URL}
    Maximize Browser Window
    Comment    make cookie consent bar go away
    Wait Until Element Is Visible    //*[@id="cookie-consent"]/*/a[@href="#"]
    Click Element    //*[@id="cookie-consent"]/*/a[@href="#"]
    Wait Until Element Is Visible    //*[@id="wrapper"]/footer

Calculate Max Number of Pages and Offers
    ${offers_visible}    Get Matching Xpath Count    //*[@class="border-b p-b-2"]
    ${offers_hidden}    Get Matching Xpath Count    //*[@class="border-b p-b-2 hide"]
    ${offers_total}    Evaluate    ${offers_visible} + ${offers_hidden}
    ${output}    Evaluate    math.ceil(float(${offers_total}) / ${OFFERS_BY_PAGE})    math
    Set Test Variable    ${OFFERS_TOTAL}    ${offers_total}
    [Return]    ${output}

Check Offer Presence on Page
    [Arguments]    ${position}    ${city}
    ${num}    Get Matching Xpath Count    //*[@class="border-b p-b-2"]
    ${range_start}    Evaluate    (${CURRENT_PAGE} - 1) * ${OFFERS_BY_PAGE} + 1
    ${range_stop}    Evaluate    min([${CURRENT_PAGE} * ${OFFERS_BY_PAGE}, ${OFFERS_TOTAL}] ) + 1
    : FOR    ${i}    IN RANGE    ${range_start}    ${range_stop}
    \    ${offer}    Get Text    //*[@id="job-ads"]/article[${i}]/h2
    \    ${city}    Get Text    //*[@id="job-ads"]/article[${i}]/p
    \    ${item}    Evaluate    ("${offer}", "${city}")
    \    Append To List    ${OFFERS}    ${item}
    ${output}    Check Presence In List    ${OFFERS}    ${position}    ${city}
    Log    ${output}
    [Return]    ${output}

Generic Test Setup
    Assignment Page is Opened
    Go To Careers Page
    Go To Open Positions    //*[@href="/en/web/about_global/careers/job-openings"]
    ${pages}    Calculate Max Number of Pages and Offers
    Set Test Variable    ${PAGES_TOTAL}    ${pages}
    ${tmp}    Create List
    Set Test Variable    ${OFFERS}    ${tmp}

Get Number of Pages and Offers
    ${offers_total}    Set Variable    0
    :FOR    ${page}    IN RANGE    1    ${PAGES_TOTAL} + 1
    \    ${output}    Get Matching Xpath Count    //*[@class="border-b p-b-2"]
    \    ${offers_total}    Evaluate    ${offers_total} + ${output}
    \    ${status}    ${junk}    Run Keyword And Ignore Error    Go To Open Positions    //*[@class="page-link next"]
    \    Run Keyword If    '${status}' == 'FAIL'    Exit For Loop
    Set Test Variable    ${OFFERS_TOTAL}    ${offers_total}
    Set Test Variable    ${PAGES_TOTAL}    ${CURRENT_PAGE}
    Set Test Variable    ${CURRENT_PAGE}    0
    Go To Open Positions    //*[@href="#page-1"]

Go To Careers Page
    Focus    //*[@id="about"]/*/a[@href="/en/web/about_global/careers"]
    Click Element    //*[@id="about"]/*/a[@href="/en/web/about_global/careers"]
    Wait Until Element Is Visible    //*[@id="wrapper"]/footer
    Wait Until Page Contains    Cyber Security lives here
    Wait Until Page Contains    See our open positions

Go To Open Positions
    [Arguments]    ${xpath}
    Click Element    ${xpath}
    Wait Until Element Is Visible    //*[@id="wrapper"]/footer
    Wait Until Page Contains    Join us
    Wait Until Element Is Visible    //*[@id="job-city"]
    ${page_update}    Evaluate    ${CURRENT_PAGE} + 1
    Set Test Variable    ${CURRENT_PAGE}    ${page_update}

Search Open Positions For Job
    [Arguments]    ${position}    ${location}
    : FOR    ${page}    IN RANGE    1    ${PAGES_TOTAL} + 1
    \    Sleep    100ms
    \    ${index}    Check Offer Presence on Page    ${position}    ${location}
    \    Run Keyword If    ${index} == None    Go To Open Positions    //*[@class="page-link next"]
    \    ...    ELSE    Exit For Loop
    View Job Offer with Specified id    ${index}
    Assert Job Title    ${position}
    Assert Job Location    ${location}
    Apply For Job

Select City
    [Arguments]    ${city}
    Click Button    //*[@data-id="job-city"]
    Comment    Select From List By Value    //*[@id="job-city"]    ${city}
    Click Element    //*[@class="text" and text()='${city}']

View Job Offer with Specified id
    [Arguments]    ${index}
    Click Element    //*[@id="job-ads"]/article[${index+1}]/a
    Sleep    2s
    Select Window    NEW
    Maximize Browser Window
    Wait Until Element Is Visible    //*[@class="job-title"]
    Wait Until Element Is Visible    //*[@class="job-details hidden-phone"]
