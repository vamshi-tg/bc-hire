require 'test_helper'

class CreateCandidateApplicationTest < ActionDispatch::IntegrationTest
  valid_payload = {candidate: {
                          name:  "vamshi",
                          email: "user@example.com",
                          applications_attributes: [{
                              role: "Web Developer",
                              experience: 5
                              }] 
                        }} 


  test "vaild candidate application information" do
    get new_candidate_application_path
    assert_template 'candidates/new_application_for_candidate'

    assert_difference [ 'Application.count', 'Candidate.count' ], 1 do
      post candidate_application_path, params: valid_payload
    end
  end

  test "invaild candidate application information" do
    get new_candidate_application_path
    assert_template 'candidates/new_application_for_candidate'

    assert_no_difference [ 'Application.count', 'Candidate.count' ] do
      post candidate_application_path, params: {candidate: {
                                                            name:  "vamshi",
                                                            email: "user@invalid",
                                                            applications_attributes: [{
                                                                role: "Web Developer",
                                                                experience: 5
                                                                }] 
                                                          }}
    end

    assert_select 'div#error_explanation' 
    ERROR_MSG_REGEX = /The form contains 1 error\..*Email is invalid.*/m
    assert_match ERROR_MSG_REGEX, response.body
  end
end
