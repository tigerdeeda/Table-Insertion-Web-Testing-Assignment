*** Settings ***
Library     BuiltIn
Library     Collections
Resource    ${EXECDIR}/keywords/selenium.resource
Test Teardown   Close Browser

*** Variables ***
@{DIRECTOR}          Steven Spielberg     Apichatpong Weerasethakul                            Prince
@{MOVIE}             Jurrasic Park        Uncle Boonmee Who Can Recall His Past Lives          Purple Rain  
${URL}               https://www.encodedna.com/angularjs/tutorial/add-remove-table-rows-dynamically-from-angularjs-controller-demo.htm

*** Test Cases ***
ASSIGNMENT : PLEASE CORRECT THE DIRECTOR's FILM
#   How to Run This AUTOMATION SCRIPT 
#      - robot -L TRACE -d results  table_insertion.robot
#   
    Create Chrome Webdriver   ${URL}
    Insert Director     ${DIRECTOR}     ${MOVIE}
    Check The Table     ${DIRECTOR}     ${MOVIE}

*** Keywords ***
Insert Director
    [Documentation]  Please complete the keyword that is able to insert the director's name and movie name from list into a table.
    [Arguments]     ${director}         ${movie}
 

Check The Table
    [Documentation]  After you complete the "Insert Director" keyword. Please verify the director's name and movie name that appear on the web is correct.
    [Arguments]     ${director}         ${movie}

            