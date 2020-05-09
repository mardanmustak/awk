function get_regex()
{
	regular_expression=""
	if (mdata == 1){
		regular_expression = "(on_start_process_info)|(on_user_info)"
	}
	
	if (ctype == 1)
	{
		if (length(regular_expression) != 0){
			regular_expression = regular_expression "\|"
		}
		regular_expression = regular_expression "(proxy:false)\|(proxy:true)"
	}
	
	if (error == 1)
	{
		if (length(regular_expression) != 0){
			regular_expression = regular_expression "\|"
		}
		regular_expression = regular_expression "(\\[error\\])"
	}
	return regular_expression
}
function print_help()
{
	printf "Command Line:\ngawk -v [option1] -v [option2] -f {file.awk} {*.log}\n"
	printf "Provide atleast one option below:\n"
	printf "\t\toptions: mdata=1 print metadata error lines\n"
	printf "\t\toptions: error=1 print all error lines\n"
	printf "\t\toptions: ctype=1 print connection type logs\n"
	printf "\t\toptions:(optional) pregex=1 print regular expression for log no processing\n"
}

function match_log_pattern()
{
	if(pregex==1)
		return
	if (match($0,PATTERN)) {
		printf "\n %s \n", $0
   	}
}
BEGIN {
	
	if (mdata ==0 && error==0 && type ==0){
		print "Error : options missing"	
		print_help()
		exit -1
	}
	PATTERN = get_regex()
	if (length(PATTERN) == 0){
		print "Error : invalid log expression identified :%s\n", PATTERN
		print_help()
		exit -1
	}
	printf "\t Log_pattern: %s \n", PATTERN
}
{
	match_log_pattern()
}
END{}
