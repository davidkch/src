<#
.SYNOPSIS
Generic script to create the windows scheduler task
.DESCRIPTION
Generic script to create the windows scheduler task on a current server.
.EXAMPLE
.\Create-SchedulerTask.ps1 -FileNamewithPath $FileNamewithPath -TaskName $TaskName -UserName $UserName -Password $Password -ScheduleFrequency $ScheduleFrequency -StartTime $StartTime
/TR $FileNamewithPath is the executable to schedule for run
/TN $TaskName is the task name
/RU $UserName is the user account under which the task runs
/RP $Password is the user account password
/SC $ScheduleFrequency as MINUTE, HOURLY, DAILY, WEEKLY, MONTHLY, ONCE, ONSTART, ONLOGON, ONIDLE, ONEVENT
/ST $StartTime is the start time to run the task. Format is HH:mm i.e 14:30 for 2.30 pm
/F tp forcefully creates the task and suppresses warnings.
Version History
v1.0 - balas - Initial Release
#>

param(

		[string]$FileNamewithPath = $(throw, "Input the file name with fully qualified path"),
		[string]$TaskName = $(throw, "Input the task name"),
		[string]$ScheduleFrequency = $(throw, "Input the frequency you want to schedule the task"),
		[string]$StartTime = $(throw, "Input the starting time of the task")
)

Function Create-SchedulerTask
{
	try
	{
		#$CreateTask = "schtasks.exe /Create /TR `"c:\windows\system32\notepad.exe`" /TN `"Test Notepad Task`" /RU `"NT AUTHORITY\NETWORKSERVICE`" /SC ONSTART /F " 
		$CreateTask = "schtasks.exe /Create /TR `"$FileNamewithPath`" /TN $TaskName /RU `"NT AUTHORITY\NETWORKSERVICE`" /SC $ScheduleFrequency /ST $StartTime /F"
		
		##  Create the scheduled task by invoking the command string  ##
		Invoke-Expression $CreateTask
		
	}
	Catch [System.Exception]
	{
		Write-Host $_.exception.message
	}
	Finally
	{
		"Windows schedule task has been created successfully!"
	}
}

# Call the function to get it execute when user call the .ps1 file
Create-SchedulerTask -FileNamewithPath $FileNamewithPath -TaskName $TaskName -ScheduleFrequency $ScheduleFrequency -StartTime $StartTime