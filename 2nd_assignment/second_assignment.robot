*** Settings ***
Test Setup        Downloads Home is Cleared
Test Teardown     Close All Browsers
Library           Selenium2Library
Library           String
Library           Collections
Library           DateTime
Library           OperatingSystem

*** Variables ***
${ASSIGNMENT_PAGE_URL}    https://xyz
${VALID_ASSIGNMENT_PAGE_PASSWORD}    ${SECRET0}${SECRET1}${SECRET2}${SECRET3}
${INVAILD_ASSIGNMENT_PAGE_PASSWORD}    ${SECRET3}${SECRET2}${SECRET1}${SECRET0}
${SECRET0}        xx
${SECRET1}        cc
${SECRET2}        aa
${SECRET3}        bb
${DOWNLOADS_HOME}    /tmp/autotests
${AUTHOR_NAME}    buraczek

*** Test Cases ***
TestCase01 - Invalid Password
    Given Assignment Page is Opened
    When Invalid Login is Performed
    Then Invalid Login Error Message is Displayed

TestCase02 - Valid Password
    Given Assignment Page is Opened
    When Valid Login is Performed
    Then Assignment Page Contents are Displayed

TestCase03 - Sort by Name Desc
    Given Assignment Page is Opened
    And Valid Login is Performed
    And Assignment Page Contents are Displayed
    And Example Folder is Opened    DataFolder1/testData
    When Sort Settings are Set    name    DESC
    Then Files are Sorted by Name    DESC

TestCase04 - Sort by Name Asc
    Given Assignment Page is Opened
    And Valid Login is Performed
    And Assignment Page Contents are Displayed
    And Example Folder is Opened    DataFolder1/testData
    When Sort Settings are Set    name    ASC
    Then Files are Sorted by Name    ASC

TestCase05 - Sort by Date Desc
    Given Assignment Page is Opened
    And Valid Login is Performed
    And Assignment Page Contents are Displayed
    And Example Folder is Opened    DataFolder1/testData
    When Sort Settings are Set    last_modified    DESC
    Then Files are Sorted by Date    DESC

TestCase06 - Sort by Date Asc
    Given Assignment Page is Opened
    And Valid Login is Performed
    And Assignment Page Contents are Displayed
    And Example Folder is Opened    DataFolder1/testData
    When Sort Settings are Set    last_modified    ASC
    Then Files are Sorted by Date    ASC

TestCase07 - Attempt to Enter Non-existent Folder by Url Modification
    Given Assignment Page is Opened
    And Valid Login is Performed
    And Assignment Page Contents are Displayed
    When Entering Malformed Url is Attempted
    Then Invalid Folder Message is Displayed

TestCase08 - Download Single File
    Given Assignment Page is Opened
    And Valid Login is Performed
    And Assignment Page Contents are Displayed
    And Example Folder is Opened    DataFolder1/testData
    When List of Items is Selected and Downloaded    black-red.png
    Then Single Element is Properly Downloaded as-is    black-red.png

TestCase09 - Download File and Folder
    Given Assignment Page is Opened
    And Valid Login is Performed
    And Assignment Page Contents are Displayed
    When List of Items is Selected and Downloaded    readme.txt    DataFolder1
    Then Multiple Elements are Properly Downloaded as an Archive    readme.txt    DataFolder1

TestCase10 - Download File and Check Folder Structure
    Given Assignment Page is Opened
    And Valid Login is Performed
    And Assignment Page Contents are Displayed
    When List of Items is Selected and Downloaded    folder1
    Then Multiple Elements are Properly Downloaded as an Archive    folder1
    And Directory Structure is Preserved

*** Keywords ***
Assignment Page Contents are Displayed
    Wait Until Element Is Visible    //*[@id="content"]/div/aside/div/header/img    10s

Assignment Page is Opened
    ${preferences}    Create Dictionary    browser.helperApps.neverAsk.saveToDisk    application/msword, application/csv, application/ris, text/csv, image/png, application/pdf, text/html, text/plain, application/zip, application/x-zip, application/x-zip-compressed, application/download, application/octet-stream
    Log Dictionary    ${preferences}
    Open Browser    ${ASSIGNMENT_PAGE_URL}    desired_capabilities=${preferences}    ff_profile_dir=/home/indra/.mozilla/firefox/en8gb3ke.default/

Assignment Page is Opened and Login are Performed
    Given Assignment Page is Opened
    When Valid Login is Performed
    Then Assignment Page Contents are Displayed

Directory Structure is Preserved
    ${output}    Run    unzip -v ${DOWNLOADS_HOME}/file_name_without_annoying_first_letter.zip | grep "${AUTHOR_NAME}" | \ cut -f 1 -d '/' --complement
    Log    ${output}
    ${file}    Fetch From Right    ${output}    /
    ${path}    Fetch From Left    ${output}    /${file}
    Example Folder is Opened    ${path}

Downloads Home is Cleared
    Log    Clearing ${DOWNLOADS_HOME}
    Run Keyword And Ignore Error    Create Directory    ${DOWNLOADS_HOME}
    Run Keyword And Ignore Error    Empty Directory    ${DOWNLOADS_HOME}

Entering Malformed Url is Attempted
    ${url}    Get Location
    Go to    ${url}abcd
    Sleep    500ms

Example Folder is Opened
    [Arguments]    ${path}
    ${folder_list}    Split String    ${path}    /
    : FOR    ${folder}    IN    @{folder_list}
    \    Log    ${folder}
    \    Wait Until Page Contains Element    //*[@title="${folder}"]    1s
    \    Click Element    //*[@title="${folder}"]

Files are Sorted by Date
    [Arguments]    ${order}
    ${num}    Get Matching Xpath Count    //*[@class="file-info"]
    ${items}    Create List
    : FOR    ${i}    IN RANGE    1    ${num} + 1
    \    ${item}    Get Text    xpath=(//*[@class="file-info"])[${i}]
    \    ${item}    Get Line    ${item}    1
    \    ${item}    Convert Date    ${item}    date_format=%b %d, %Y %I:%M%p
    \    Append To List    ${items}    ${item}
    Sorting is Tested    ${order}    ${items}

Files are Sorted by Name
    [Arguments]    ${order}
    ${num}    Get Matching Xpath Count    //*[@class="file-info"]
    ${items}    Create List
    : FOR    ${i}    IN RANGE    1    ${num} + 1
    \    ${item}    Get Text    xpath=(//*[@class="file-info"])[${i}]
    \    ${item}    Get Line    ${item}    0
    \    Append To List    ${items}    ${item.lower()}
    Sorting is Tested    ${order}    ${items}

Invalid Folder Message is Displayed
    Page Should Contain    This folder is no longer available
    Page Should Contain    This folder is no longer available. Contact the person who sent you this link to get a new link to the folder.

Invalid Login Error Message is Displayed
    Wait Until Element Is Visible    //*[@id="password_controls"]/div    10s

Invalid Login is Performed
    Input Password    //*[@id="password"]    ${INVAILD_ASSIGNMENT_PAGE_PASSWORD}
    Click Element    //*[@id="password_controls"]/form/a

List of Items is Selected and Downloaded
    [Arguments]    @{items}
    Sleep    1s
    ${num}    Get Element Count    xpath=//*[@class="file-info"]
    ${indexes}    Create List
    : FOR    ${i}    IN RANGE    1    ${num} + 1
    \    ${item}    Get Text    xpath=(//*[@class="file-info"])[${i}]
    \    ${item}    Get Line    ${item}    0
    \    Run Keyword If    "${item}" in ${items}    Append To List    ${indexes}    ${i}
    Log List    ${indexes}
    : FOR    ${i}    IN RANGE    1    ${num} + 1
    \    Sleep    100ms
    \    Run Keyword If    ${i} in ${indexes}    Click Element    xpath=(//*[@id="folder-items"])/li[${i}]/div/div/div[1]
    Click Button    //*[@class="btn btn-primary btn-block folderLink-buttons-download is-type-selected"]
    Sleep    500ms

Multiple Elements are Properly Downloaded as an Archive
    [Arguments]    @{names}
    Comment    Downloading whole archive may takesome time
    Sleep    10s
    File Should Exist    ${DOWNLOADS_HOME}/${AUTHOR_NAME}.zip
    File Should Not Be Empty    ${DOWNLOADS_HOME}/${AUTHOR_NAME}.zip
    Copy File    ${DOWNLOADS_HOME}/${AUTHOR_NAME}.zip    ${DOWNLOADS_HOME}/file_name_without_annoying_first_letter.zip
    ${output}    Run    unzip -v ${DOWNLOADS_HOME}/file_name_without_annoying_first_letter.zip
    Log    ${output}
    : FOR    ${name}    IN    @{names}
    \    Should Contain    ${output}    ${name}

Number of Items is Selected and Downloaded
    [Arguments]    ${num}
    Sleep    500ms
    ${count}    Get Element Count    xpath=//*[@class="file-info"]
    ${items}    Create List
    : FOR    ${i}    IN RANGE    1    ${num} + 1
    \    ${item}    Get Text    xpath=(//*[@class="file-info"])[${i}]
    \    ${item}    Get Line    ${item}    0
    \    Append To List    ${items}    ${item}
    : FOR    ${i}    IN RANGE    1    ${num} + 1
    \    Click Element    xpath=(//*[@id="folder-items"])/li[${i}]/div/div/div[1]
    Click Button    //*[@class="btn btn-primary btn-block folderLink-buttons-download is-type-selected"]
    Sleep    500ms

Single Element is Properly Downloaded as-is
    [Arguments]    ${name}
    File Should Exist    ${DOWNLOADS_HOME}/${name}
    File Should Not Be Empty    ${DOWNLOADS_HOME}/${name}

Sort Settings are Set
    [Arguments]    ${data}    ${order}
    Sleep    200ms
    Click Element    //*[@id="content"]/div/header/ul/li[1]/div/div/div/a
    Sleep    200ms
    Click Element    //*[@data-sort="${data}"]
    Sleep    200ms
    Click Element    //*[@id="content"]/div/header/ul/li[1]/div/div/div/a
    Sleep    200ms
    Click Element    //*[@data-order="${order}"]
    Sleep    200ms

Sorting is Tested
    [Arguments]    ${order}    ${items}
    ${items_sorted}    Copy List    ${items}
    Sort List    ${items_sorted}
    Run Keyword if    "${order}" == "DESC"    Reverse List    ${items_sorted}
    Log List    ${items}
    Log List    ${items_sorted}
    Lists Should Be Equal    ${items}    ${items_sorted}

Valid Login is Performed
    Input Password    //*[@id="password"]    ${VALID_ASSIGNMENT_PAGE_PASSWORD}
    Click Element    //*[@id="password_controls"]/form/a
