require "time"

module TestReportWriter

  def level_0_text_report(test_report)
    test_report[:test_suite_result_status]
  end

  def text_report(test_report, extra_report_header)
	separator_width = 120
    text_report = ""

    text_report_header = <<-EOS
Title: #{@test_report[:test_suite_title]}
Description: #{@test_report[:test_suite_description]}
Test specification: #{@test_report[:test_spec_path]}
Kadu server: #{@test_report[:kadu_server]}
    EOS
    text_report_header += extra_report_header unless extra_report_header.nil?

    @test_report[:test_cases].each do |tc_id, tc|
       if tc.has_key?(:server_info)
         text_report_header += <<-EOS
Kadu branch: #{tc[:server_info][:kadu_branch]}
Kadu version: #{tc[:server_info][:kadu_version]}
Kadu index: #{tc[:server_info][:kadu_index]}
         EOS
         break
       end
    end

    text_report_header += <<-EOS
Test suite status: #{@test_report[:test_suite_result_status]}
When test ran: #{@test_report[:test_run_completed_time]}

    EOS
    text_report_test_cases = <<-EOS
Test cases:
    EOS

    @test_report[:test_cases].each do |tc_id, tc|
      text_report_test_case = <<-EOS
#{"_" * 120}

#{tc_id}: #{tc[:title]}
Description: #{tc[:description]}
Test result status: #{tc[:test_case_result_status]}

Steps to reproduce
#{"-" * 120 }
      EOS
      text_steps = ""
      tc[:test_steps].each do |step_id, step|
        text_step = <<-EOS
#{step_id}
        EOS

        if step.has_key?(:action)
          text_query_params_section = <<-EOS
Kadu URL:
#{step[:action]}
          EOS

          text_step += text_query_params_section
        end

        if step.has_key?(:mt_url)
          text_query_params_section = <<-EOS
MT URL:
#{step[:mt_url]}

          EOS
          text_step += text_query_params_section
        end


        if step.has_key?(:dynamic_params)
          text_dynamic_params_section = <<-EOS
Dynamic Parameters
          EOS

          exclusion_term = "set @kadu_response"
          step[:dynamic_params].each do |parameter, expression|
            expression = exclusion_term if expression.to_s.include?(exclusion_term)
            text_dynamic_params = <<-EOS
#{parameter} = #{expression}
            EOS
            text_dynamic_params_section += text_dynamic_params
          end
          text_step += text_dynamic_params_section + "\n"
        end

        if step.has_key?(:validation_steps)

          text_vstep_results = <<-EOS
Validations

          EOS

          step[:validation_steps].each do |vstep, result|
            text_vstep_result = <<-EOS
 Validation: #{vstep} [#{result["test_result_status"]}]
 Message: #{result["test_result_message"]}

            EOS
            text_vstep_results += text_vstep_result.force_encoding('ASCII-8BIT')
          end

          text_vstep_results = text_vstep_results

          text_step += text_vstep_results
        end

        text_steps += text_step + "\n" + "#{'=' * separator_width}" + "\n"

      end
      text_report_test_cases = text_report_test_cases + text_report_test_case + text_steps

    end

    test_report_footer = <<-EOS

Summary: #{@test_report[:test_suite_title]} on #{@test_report[:kadu_server]} Result: #{@test_report[:test_suite_result_status]}

    EOS
    text_report = text_report_header + text_report_test_cases + "#{'_' * separator_width}\n" + test_report_footer + "#{'_' * separator_width}\n"
    text_report
  end

  # convert the file contents to json format
  def json_report(test_report)
    test_report.to_json
  end

  # adds the known issues note to the test runner report
  def get_fail_test_details(note)
    text = <<-EOS
    <p id=statusfail>#{note}</p>
    EOS
    text
  end

  # convert file contents to string
  def get_file_as_string(filename)
    data = ""
    File.open(filename, "r").each_line do |line|
      data += line
    end
    data
  end

  # remove spaces and add dashes instead
  def replace_space_by_dash(string)
    string.gsub(/\s/,'-')
  end

  # Gets the test run summary section of the report. Used in the test runner when executing multiple test suite together.
  # test_summary is a hash with values such as report title, start time, end time, country, known issue note
  def get_test_run_summary_report(test_report, test_summary)
    file_data = test_report
    file_lines = file_data.split("\n")

=begin
    #Remove the duplicate headings
    title = 0
    i = 0
    file_lines.each do |line|
      i += 1
      if line.match(/<h1 align='center'><u>(\w|\s)+<\/u><\/h1><br\/>/)
        title += 1
        if title > 1
          file_lines.delete_at(i-1)
        end
      end
    end
=end

    test_run_summary = <<-EOS
      <h1 align='center'><u>#{test_summary[:title]}<\/u><\/h1><br\/>
    EOS

    #Get the test run details from the report
    file_data.match(/<td>Kadu server:(.+)<\/td>/)
    kadu_server = $1
    test_suites = file_data.scan(/<th align="center">(.+)<\/th>/)
    test_suite_status = file_data.scan(/Test suite status: <font id=(statuspass|statusfail)>(.*)<\/font>/)

    i = 0
    test_status = {}
    test_suites.each do |test_suite|
      test_status[test_suite] = test_suite_status[i]
      i +=1
    end

    test_status = test_status.sort_by{|name,status| status}

    test_run_time_in_secs = Time.parse(test_summary[:test_run_end_time].to_s) - Time.parse(test_summary[:test_run_start_time].to_s)

    # Get the test case numbers
    passed_tcs = 0
    failed_tcs = 0
    blocked_tcs = 0

    file_lines.each do |line|
      passed_tcs +=1 if line.match("Test result status:  <font id=statuspass>PASS</font>")
      failed_tcs +=1 if line.match("Test result status:  <font id=statusfail>FAIL</font>")
      blocked_tcs +=1 if line.match("Test result status:  <font id=statusfail>BLOCK</font>")
    end
    total_tcs_count = passed_tcs + failed_tcs + blocked_tcs

    #Create the test run summary section
    test_run_summary += <<-EOS
    <a name=summary></a>
    <table id="specifications" width="500px">
      <tr><td><strong>Kadu Server:</strong></td><td>#{kadu_server}</td></tr>
      <tr><td><strong>Country:</strong></td><td>#{test_summary[:country]}</td></tr>
      <tr><td><strong>Test Run Started On:</strong></td><td>#{test_summary[:test_run_start_time]}</td></tr>
      <tr><td><strong>Duration:</strong></td><td>#{test_run_time_in_secs} secs</td></tr>
      <tr><td><strong>Number of test cases executed:</strong></td><td>#{total_tcs_count}</td></tr>
      <tr><td><strong>Number of test cases passed:</strong></td><td>#{passed_tcs}</td></tr>
      <tr><td><strong>Number of test cases failed:</strong></td><td>#{failed_tcs}</td></tr>
      <tr><td><strong>Number of test cases blocked:</strong></td><td>#{blocked_tcs}</td></tr>
    </table>
    <br>
    EOS
    if !test_summary[:known_issues].nil?
      test_run_summary += <<-EOS
      #{get_fail_test_details(test_summary[:known_issues])}
      <br>
      EOS
    end

    test_run_summary += <<-EOS
        <table id="specifications" width="900px">
        <tr>
        <th >Test Suite</th>
        <th >Test Suite Status</th>
        </tr>
    EOS
    i = 0
    test_status.each do |suite_name,suite_status|
      test_run_summary += <<-EOS
        <tr>
        <td><a href="##{replace_space_by_dash(suite_name.to_s.gsub(/"|\[|\]/,''))}">#{suite_name.to_s.gsub(/"|\[|\]/,'')}</a></td>
        <td><font id=#{suite_status[0]}>#{suite_status[1]}</font></td>
        </tr>
      EOS
      i +=1
    end
    test_run_summary += <<-EOS
        </table>
    <br>
    <hr size=2 color="#000080">
    <br/>
    EOS

    # Convert the section into array and add it to the file at the start.
    test_run_summary = test_run_summary.split("\n")
    i = 0
    file_lines.each do |line|
      i += 1
      if line.match(/<center>/)
          j = i
          test_run_summary.each do |row|
            file_lines.insert(j,row)
            j +=1
          end
        break
      end
    end

    report = ""
    file_lines.each do |line|
      report += <<-EOS
        #{line}
      EOS
    end
    report
  end

  #Gets the style needed according to the test status
  def status(result)
      result = result.upcase
      if result == "PASS"
        id_value = "statuspass"
      else
        id_value = "statusfail"
      end
      id_value
  end

  #Converts the test report hash into html report format, used in individual test suites.
  def html_report(test_report, extra_report_header)

    html_report = <<-EOS
    <html>
    EOS

    html_style = <<-EOS
      <style>
        body {background-color: #FFFFF0; font-family: "VAG Round" ; color : #000080;font-weight:normal;word-break: break-all;}
        #specs-table{font-family:Arial,Helvetica,Sans-serif;font-size:12px;text-align:left;border-collapse:collapse;border-top: 2px solid #6678B1;border-bottom: 2px solid #6678B1;margin:20px;}
        #specs-table th{font-size:13px;font-weight:normal;background:#b9c9fe;border-top:4px solid #aabcfe;border-bottom:1px solid #fff;color:#039;padding:8px;}
        #specs-table td{background:#e8edff;border-top:1px solid #fff;border-bottom:1px solid #fff;color:#039;padding:8px;}
        #specifications{font-family:Arial,Helvetica,Sans-serif;font-size:13px;width:480px;background:#fff;border-collapse:collapse;text-align:left;margin:20px;border:1px solid #ccc;}
        #specifications th{font-size:14px;font-weight:bold;color:#039;border-bottom:2px solid #6678b1;padding:10px 8px;}
        #specifications td{border-bottom:1px solid #ccc;color:#009;padding:6px 8px;}
        #statuspass{font-family:Arial,Helvetica,Sans-serif;font-size:12px;color:green;font-weight:bold;}
        #statusfail{font-family:Arial,Helvetica,Sans-serif;font-size:12px;color:red;font-weight:bold;}
        #tcs{font-family:Arial,Helvetica,Sans-serif;font-size:13px;background:#fff;width:900px;border-collapse:collapse;text-align:left;margin:20px;border:1px solid #ccc;}
        #tcs th{font-size:14px;font-weight:bold;color:#039;border-bottom:2px solid #6678b1;padding:10px 8px;}
        #tcs td{border-bottom:1px solid #ccc;color:#009;padding:6px 8px;}
        #checkpoint{font-family:Arial,Helvetica,Sans-serif;font-size:13px;background:#fff;width:900px;border-collapse:collapse;text-align:left;margin:20px;border:1px solid #ccc;}
        #checkpoint td{border-bottom:1px solid #ccc;color:#009;padding:6px 8px;}
        #container{margin: 0 30px;background: #fff;border:1px solid #ccc;}
        #header{background: #e8edff;padding: 2px;border-bottom: 2px solid #6678b1;}
        #steps{background: #e8edff;font-weight: bold;}
        #dp{font-weight: bold;}
        #validations{font-weight: bold;}
        #content{clear: left;padding: 10px;}
        #footer{background: #e8edff;text-align: right;padding: 10px;}
      </style>
    EOS

    title = <<-EOS
    <head><title>#{test_report[:test_suite_title]}</title></head>

    <body>
    EOS

    html_report += html_style + title

    report_header = <<-EOS
    <center>

    <a name=#{replace_space_by_dash(test_report[:test_suite_title])}></a>
    <table id="specifications">
      <th align="center">#{test_report[:test_suite_title]}</th>
      <tr><td>Test specification: #{test_report[:test_spec_path]}</td></tr>
      <tr><td>Kadu server: #{test_report[:kadu_server]}</td></tr>
    EOS
    @test_report[:test_cases].each do |tc_id, tc|
       if tc.has_key?(:server_info)
         report_header += <<-EOS
      <tr><td>Kadu branch: #{tc[:server_info][:kadu_branch]}</td></tr>
      <tr><td>Kadu version: #{tc[:server_info][:kadu_version]}</td></tr>
      <tr><td>Kadu index: #{tc[:server_info][:kadu_index]}</td></tr>
         EOS
         break
       end
    end
    if !extra_report_header.nil?
      details = extra_report_header.split("\n")
      details.each do |line|
        report_header += <<-EOS
        <tr><td>#{line}</td></tr>
        EOS
      end
    end
    test_suite_time_in_secs = Time.parse(test_report[:test_suite_completed_time].to_s) - Time.parse(test_report[:test_suite_start_time].to_s)

    report_header += <<-EOS
      <tr><td>Test suite started On: #{test_report[:test_suite_start_time]}</td></tr>
      <tr><td>Duration: #{test_suite_time_in_secs} secs</td></tr>
      <tr><td>Test suite status: <font id=#{status(test_report[:test_suite_result_status])}>#{test_report[:test_suite_result_status]}</font></td></tr>
    </table>
    <br>
    EOS
    report_tc_summary = <<-EOS
      <table id="tcs">
        <tr>
        <th >Test Case</th>
        <th >Test Case Status</th>
        </tr>
    EOS

    test_report[:test_cases].each do |tc_id, tc|
      report_tc_summary += <<-EOS
        <tr>
        <td><a href="##{tc_id}">#{tc_id}: #{tc[:title]}</a></td><td><font id=#{status(tc[:test_case_result_status])}>#{tc[:test_case_result_status]}</font></td>
        </tr>
      EOS
    end

    report_tc_summary += <<-EOS
    </table>
    <br>
    <h4>#{test_report[:test_suite_description]}</h4>
    <br>
    </center>
    EOS
    test_cases = ""
    test_report[:test_cases].each do |tc_id, tc|
      test_case = <<-EOS
      <div id="container" style="word-break: break-all;width:100%;">
      <div id="header">
        <h4>
          <p><a name="#{tc_id}">#{tc_id}: #{tc[:title]}</a></p>
          <p>#{tc[:description]}</p>
          <p>Test result status:  <font id=#{status(tc[:test_case_result_status])}>#{tc[:test_case_result_status]}</font></p>
        </h4>
      </div>
      <div id="content">
      <h4>
        Steps to reproduce
      </h4>
      EOS

      tc[:test_steps].each do |step_id, step|
        test_steps = <<-EOS
        <p id="steps">#{step_id}</p>
        EOS

        if step.has_key?(:action) || step.has_key?(:mt_url)
          test_steps += <<-EOS
          <p style="word-break: break-all;" width=900px >URL: #{step[:action]}</p>
          EOS
        end

        if step.has_key?(:dynamic_params)
          test_steps += <<-EOS
          <p id="dp">Dynamic Parameters</p>
          EOS

          exclusion_term = "set @kadu_response"
          step[:dynamic_params].each do |parameter, expression|
            expression = exclusion_term if expression.to_s.include?(exclusion_term)
            test_steps += <<-EOS
            <p>#{parameter} = #{expression}</p>
            EOS
          end
        end

        if step.has_key?(:validation_steps)

          test_steps += <<-EOS
            <p id="validations">
              Validations
            </p>
            <table id="checkpoint">
          EOS

          step[:validation_steps].each do |vstep, result|
            steps = <<-EOS
            <tr>
              <td colspan="2" width="90%">
              <p>#{vstep}</p>
              <p>#{result["test_result_message"]}</p>
              </td>
              <td width="10%" rowspan="1" align="center"><font id=#{status(result["test_result_status"])}>#{result["test_result_status"]}</font></td>
            </tr>
            EOS
            test_steps += steps
          end

          test_steps += <<-EOS
            </table>
          EOS

        end
        test_case += test_steps
      end
      test_cases += test_case
      test_cases += <<-EOS
      </div>
      <div id="footer">
        <a href="##{replace_space_by_dash(test_report[:test_suite_title])}">back to test suite</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#summary">back to summary</a>
	    </div>
      </div>
      <br>
      EOS
    end

    report_footer = <<-EOS
        <br>
        <hr>
        <br>
      </body>
      </html>
    EOS

    html_report += report_header + report_tc_summary + test_cases + report_footer

    html_report
  end

end