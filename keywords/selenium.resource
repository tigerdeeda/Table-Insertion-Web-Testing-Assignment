*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${CHROME_DRIVER_PATH_WINS}    ${EXECDIR}${/}driver${/}win32${/}chromedriver.exe
${CHROME_DRIVER_PATH_MAC}     ${EXECDIR}${/}driver${/}mac64${/}chromedriver
${CHROME_DRIVER_PATH_LINUX}   ${/}usr${/}local${/}bin${/}chromedriver
${FIREFOX_DRIVER_PATH_WINS}   ${CURDIR}${/}..${/}..${/}driver${/}win32${/}geckodriver.exe
${FIREFOX_DRIVER_PATH_MAC}    ${CURDIR}${/}..${/}..${/}driver${/}mac64${/}geckodriver
${FIREFOX_DRIVER_PATH_LINUX}  ${/}usr${/}bin${/}geckodriver

*** Keywords ***
Create Chrome Webdriver
    [Documentation]  create new chrome driver with options
    [Arguments]    ${url}   ${speed}=0.1
    ${system}=    Evaluate    platform.system()    platform
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method  ${chrome_options}  add_experimental_option    useAutomationExtension    ${False}
#    Call Method  ${chrome_options}  add_argument  --headless
    Call Method  ${chrome_options}  add_argument  --test-type
    Call Method  ${chrome_options}  add_argument  --ignore-certificate-errors
    Call Method  ${chrome_options}  add_argument  --disable-gpu
    Call Method  ${chrome_options}  add_argument  --no-sandbox
    Run Keyword If    '${system}'=='Linux'    
    ...    Run Keywords     Call Method     ${chrome_options}    add_argument    --test-type
    ...    AND              Call Method     ${chrome_options}    add_argument    --disable-extensions
    ...    AND              Call Method     ${chrome_options}    add_argument    --headless
    ...    AND              Call Method     ${chrome_options}    add_argument    --window-size\=1600,1200
    ${driver_path}=    Run Keyword If    '${system}'=='Linux'    Set Variable    ${CHROME_DRIVER_PATH_LINUX}
    ...    ELSE IF    '${system}'=='Windows'  Set Variable    ${CHROME_DRIVER_PATH_WINS}
    ...    ELSE IF    '${system}'=='Darwin'   Set Variable    ${CHROME_DRIVER_PATH_MAC}
    ...    ELSE     fail    Not support system : ${system}
    ${kwargs}=    BuiltIn.Create Dictionary    executable_path=${driver_path}
    Create Webdriver    Chrome    chrome_options=${chrome_options}    kwargs=${kwargs}
    Run Keyword If    '${system}'=='Windows'  Maximize Browser Window
    Run Keyword If    '${system}'=='Darwin'   Maximize Browser Window
    Set Selenium Speed	${speed}
    Go To    ${url}

Connect Chrome Webdriver
    [Documentation]  Connect to Chrome browser on exist chromedriver.
    ...  \nRequired to run command "chrome.exe --remote-debugging-port=9222" first.
    [Arguments]  ${url}  ${speed}=0.5  ${debug_address}=127.0.0.1  ${debug_port}=9222
    log to console  ------
    ${chrome_options} =  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys
    call method  ${chrome_options}  add_experimental_option  debuggerAddress  ${debug_address}:${debug_port}
    ${kwargs} =  BuiltIn.Create Dictionary  executable_path=${DRIVER_PATH}
    Create Webdriver  Chrome  chrome_options=${chrome_options}  kwargs=${kwargs}
    Go To  ${url}
    Set Selenium Speed  ${speed}

Create Firefox Webdriver
    [Documentation]  create new chrome driver with options
    [Arguments]  ${url}      ${speed}=0.2
    ${system}=    Evaluate    platform.system()    platform
    ${firefox_options} =  Evaluate  sys.modules['selenium.webdriver'].firefox.webdriver.Options()  sys, selenium.webdriver
    Call Method  ${firefox_options}  add_argument  --test-type
    Call Method  ${firefox_options}  add_argument  --ignore-certificate-errors
    Call Method  ${firefox_options}  add_argument  --disable-extensions
    Call Method  ${firefox_options}  add_argument  --headless
    Call Method  ${firefox_options}  add_argument  --disable-gpu
    Call Method  ${firefox_options}  add_argument  --no-sandbox
    Call Method   ${firefox_options}  add_argument  --width\=1600
    Call Method   ${firefox_options}  add_argument  --height\=1200
    Run Keyword If    '${system}'=='Linux'    Run Keywords
    ...    Call Method    ${firefox_options}    add_argument    --test-type
    ...    AND    Call Method   ${firefox_options}    add_argument    --ignore-certificate-errors
    ...    AND    Call Method   ${firefox_options}    add_argument    --disable-extensions
    ...    AND    Call Method   ${firefox_options}    add_argument    --headless
    ...    AND    Call Method   ${firefox_options}    add_argument    --disable-gpu
    ...    AND    Call Method   ${firefox_options}    add_argument    --no-sandbox
    ...    AND    Call Method   ${firefox_options}  add_argument  --width\=1600
    ...    AND    Call Method   ${firefox_options}  add_argument  --height\=1200
    ${driver_path}=    Run Keyword If    '${system}'=='Linux'    Set Variable    ${FIREFOX_DRIVER_PATH_LINUX}
    ...    ELSE IF    '${system}'=='Windows'  Set Variable    ${FIREFOX_DRIVER_PATH_WINS}
    ...    ELSE IF    '${system}'=='Darwin'   Set Variable    ${FIREFOX_DRIVER_PATH_MAC}
    ...    ELSE     fail    Not support system : ${system}
    ${kwargs} =  BuiltIn.Create Dictionary  executable_path=${driver_path}
    Create Webdriver  Firefox  firefox_options=${firefox_options}  kwargs=${kwargs}
    Go To  ${url}
    Set Selenium Speed  ${speed}

Input Text and Verify
    [Documentation]  Veirfy element visible before inputting test.
    [Arguments]  ${element}  ${text}  ${timeout}=1  ${element_name}=element  ${error_message}=input error! \${element_name}=${element}
    SeleniumLibrary.wait until element is visible  ${element}  ${timeout}  ${error_message}
    SeleniumLibrary.input text  ${element}  ${text}

Click Element and Verify
    [Documentation]  Verify element visible before clicking element.
    [Arguments]  ${element}  ${timeout}=1  ${error_message}=click error! \${element}=${element}
    SeleniumLibrary.wait until element is visible  ${element}  ${timeout}  ${error_message}
    SeleniumLibrary.click element  ${element}