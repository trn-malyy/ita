:: Command to execute the test
:: ruby ./lib/static_element_validation.rb -d www.epinions.com --exitstatus
:: ruby ./lib -f html -o ./reports/epinions_post_qa_test.html
ruby ./lib/epinions_post_qa.rb -f html -o ./reports/epinions_post_qa_test.html
pause
