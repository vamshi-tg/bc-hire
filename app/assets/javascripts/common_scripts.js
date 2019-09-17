var DATE_FORMAT = 'YYYY-MM-DD';
var TIME_FORMAT = 'LT';
var DATE_TIME_FORMAT = DATE_FORMAT + ' ' + TIME_FORMAT;

function setupDynamicInterviewersDropDown($roundNameEle, $interviewerDropDown, round_wise_interviewers) {
    // On round name change set interviewer dropdown options
    $roundNameEle.change(function() {
        var roundName = $(this).val();
        var interviewerIdMap = round_wise_interviewers[roundName];
        setSelectInterviewerDropDown($interviewerDropDown, interviewerIdMap);
    });

    function setSelectInterviewerDropDown(dropdown, options_obj) {
        dropdown.empty();
        dropdown.append($("<option>").html("Select Interviewer"));
        $.each(options_obj, function(name, id) {
            $interviewerDropDown.append($("<option>").val(id).html(name));
        });
    }
}

function handleInterviewFormSubmit($formEle, interviewScheduleElements) {
    $formEle.submit(function() {
        var interviewDate = interviewScheduleElements.date.datetimepicker('date').format(DATE_FORMAT);

        prefixInterviewDateToTime(interviewScheduleElements.startTime, interviewDate);
        prefixInterviewDateToTime(interviewScheduleElements.endTime, interviewDate);

        return true;
    });

    function prefixInterviewDateToTime(timeEle, interviewDate) {
        var time = timeEle.datetimepicker('date').format(TIME_FORMAT);
        var dateTime = getFormattedDate(interviewDate + ' ' + time);

        timeEle.datetimepicker('date', dateTime);
        timeEle.datetimepicker('format', DATE_TIME_FORMAT);
    }
}

function getFormattedDate(date) {
    return moment(date, DATE_TIME_FORMAT);
}