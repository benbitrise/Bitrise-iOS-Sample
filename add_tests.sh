#!/bin/zsh

ui_test_file=$(find . | grep BitriseTestUITests.swift)
file_contents=$(cat $ui_test_file)
$editing_file=$(echo ${file_contents%\}*})
for i in {1..100}
do
$editing_file+="""
    func testExample$i() throws {
        let app = XCUIApplication()
        app.launch()
    }
"""
done

$editing_file+="""
}
"""

echo $editing_file > $ui_test_file
