
function print_help()
{
	printf "Command Line:\ngawk -v [option1] -f {sample}.awk {logfile_location}\n"
	printf "Provide options option1=1, option2=1, option3=1\n"
	printf "\t\toptions: option1={} do something 1\n"
	printf "\t\toptions: option2={} do something 2\n"
	printf "\t\toptions: option3={} do something 3\n"
}

function build_pattern()
{
	NORMAL_PATTERN="{%s-L:%d-%s} "
	OPTION1_FOUND = "(OPTION1:)"
	OPTION2_FOUND = "(OPTION2:)"
	OPTION3_PATTERN = "(word1)|(word 2)|(word3)|(word4)|(word5)|(word6)"
	OPTION1_PATTERN = "(P*OPTION1:"OPTION1",)"
	OPTION2_PATTERN = "(OPTION2:"OPTION2",)"

	printf "-----------------------------------------------------------------------------------------\n"
	printf " OPTION3 Pattern:%s\n", OPTION3_PATTERN
	printf " OPTION1 Pattern:%s\n", OPTION1_PATTERN
	printf "-----------------------------------------------------------------------------------------\n"

	if ( length(OPTION3_PATTERN) == 0 || length(OPTION1_PATTERN)==0 || length(OPTION2_PATTERN)==0 ){
		print_help()
		exit -1
	}
}

function OPTION2_matched()
{		
	if (match($0,OPTION2_FOUND))
	{
		if (match($0,OPTION2_PATTERN)) 
		{
			return 1;
		}
		return 0; 
	}
	return 1;
}
function OPTION1_matched()
{		
	if (match($0,OPTION1_FOUND))
	{
		if (match($0,OPTION1_PATTERN)) 
		{
			return 1;
		}
		return 0;
	}
	return 1;
}

function check_valid()
{
	if ( OPTION1 != 0 ) {
		return OPTION1_matched()
	}
	if ( OPTION2 !=0 ) {
		return OPTION2_matched()
	}
	return 1;
}
function print_OPTION3_information()
{
	if (match($0,OPTION3_PATTERN))
	{
		if(!check_valid())
		{
			return ;
		}
		printf (NORMAL_PATTERN,"PO",NR,$4)
		for(i=6;i<=NF;i++){
			printf ("%s ",$i) 
		}
		printf("\n")
   	}
	
}
function print_OPTION1_information()
{
	if (match($0,OPTION1_PATTERN)) {
		printf (NORMAL_PATTERN,"CON",NR,$4)
		for(i=6;i<=NF;i++){
			printf ("%s ",$i) 
		}
		printf("\n")
   	}
}
function print_OPTION2_information()
{
	if (match($0,OPTION2_PATTERN)) {
		printf (NORMAL_PATTERN,"PR",NR,$4)
		for(i=6;i<=NF;i++){
			printf ("%s ",$i) 
		}
		printf("\n")
	}
	
}

BEGIN {
	build_pattern()
}
{
	if(OPTION3 !=0 ){
	 	print_OPTION3_information(); 
	}

	if (OPTION1 != 0) {
		print_OPTION1_information(); 
	}else if (OPTION2 != 0) {
		print_OPTION2_information()
	}
}
END{}
