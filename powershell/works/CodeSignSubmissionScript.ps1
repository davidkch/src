<#   
.SYNOPSIS   
	Function to codesign the files like .dll, .exe, .msi, .xap
    
.DESCRIPTION 
	This function provides the functionality to codesign the files like .dll, .exe, .msi, .xap

.EXAMPLE   
	.\CodeSignSubmissionScript.ps1 -jobPath "D:\CodeSignInstaller" -include "*.msi" -exclude "*.docx","*.dll" -StrongName "" -AuthentiCode "2" -server "codesign.gtm.microsoft.com" -port "9556" -displayURL "https://codesign.gtm.microsoft.com"

#>

param(
		#Write-OutPut "Override Params here"		 
		[String]$jobPath=$(throw "Please pass job path e.g. SourcesDirectory\CodeSignInstaller")
        ,$include=$(throw 'Please pass job path e.g. "*.dll","*.msi"')
        ,$exclude
        ,[String]$StrongName
        ,[String]$AuthentiCode=$(throw "Please pass AuthentiCode e.g. 2 or 10006")	
        ,[string]$server = $(throw "Provide RelayServer")
        ,[string]$port = $(throw "Provide RelayPort")
        ,[string]$displayURL = $(throw "Provide Display URL")         	    
	 )


# Define parameters used in script

$isSSL = $true;
$approver1 = "aaronmc";
$approver2 = "balas";
$displayName = "CodeSign";
$description = "CodeSignActivity";
$publisherKey = "CertSubject";
#$publisherValue = "CN=Skype Software Sarl, O=Microsoft Corporation, L=Luxembourg, S=Luxembourg, C=LU";
$isAllowReturnPartial = $false;


function CodeSign
{
try
{
# Function
# Load an assembly from the application directory or from the global assembly cache using a partial name
function AddAssembly ($name) 
{
      return [System.Reflection.Assembly]::LoadWithPartialName($name) | Out-Null;
}

function GetElapsedTime 
{
      param([DateTime]$t1, [DateTime]$t2);
      
      $runtime = $t2 - $t1;
      $elpasedTime = $runtime.Seconds;
      return $elpasedTime;
}

function GetCertificateOperationSet
{
      $cops = "";
      foreach ($key in $job.SelectedCertificateList.Keys)
      {
            $cops += $key + ", ";
      }
      
      return $cops.Substring(0, $cops.Length - 2);
}

function GetPublisherValue
{
      $n = $job.CustomList.Count;
      for ($i = 0; $i -lt $n; $i++) 
      {
            $key = $job.CustomList.Keys[$i];
            if ($key -eq "CertSubject") 
            {
                  return $job.CustomList.Values[$i];
            }
      }
      return $null;
}

function GetPersonList
{
      $flag = $false;
      $n = $job.PersonList.Count;
      $personList = "";
      for ($i = 0; $i -lt $n; $i++)
      {
            if ($job.PersonList.Values[$i].IsSubmitter)
            {
                  $personList += "Submitter: " + $job.PersonList.Values[$i].Alias + ", ";
            }
            elseif ($job.PersonList.Values[$i].IsApprover)
            {
                  if (!$flag) 
                  {
                       $personList += "Approver: " + $job.PersonList.Values[$i].Alias + ", ";
                        $flag = $true;
                  }
                  else
                  {
                        if ($i -eq $n - 1) 
                        {
                              $personList += $job.PersonList.Values[$i].Alias;
                        }
                        else 
                        {
                              $personList += $job.PersonList.Values[$i].Alias + ", ";
                        }
                  }
            }
      }
      
      return $personList;
}

#function GetErrorList
#{
#    $errorMsg = "";
#    foreach ($err in $job.ErrorList)
#   {
#       $errorMsg += $err + ", ";
#}
    
#     return $errorMsg.Substring(0, $errorMsg.Length - 2);
#}

$before = Get-Date;


AddAssembly "CODESIGN.Submitter";

$job = [CODESIGN.Submitter.Job]::Initialize($server, $port, $isSSL);
$job.AddApprover($approver1);
$job.AddApprover($approver2);


if($StrongName -eq "")
{
$copsCodeList=$AuthentiCode;
}
elseif($AuthentiCode -eq "")
{
$copsCodeList=$StrongName;
}
else
{
$copsCodeList=$StrongName,$AuthentiCode;
}

foreach($cop in $copsCodeList)
{
$job.SelectCertificate($cop);
}


$jobFileList+=Get-ChildItem -Path $jobPath -Include $include -Exclude $exclude -Recurse
Write-output "Files submitted for CodeSign:"
Write-output $jobFileList
Write-output "		 "

foreach($jobfile in $jobFileList)
{
$job.AddFile($jobfile, $displayName, $displayURL, [CODESIGN.JavaPermissionsTypeEnum]::None);
}

$job.Description = $description;
$job.Keywords = $description;
$job.AddCustomFeature($publisherKey, $publisherValue);

$job.IsAllowReturnPartial = $isAllowReturnPartial;

$job.Send();
#Write-output "Files Submitted for CodeSign : " $job.FileList.Keys

#Write-output $job.FileList.Values

 function WaitForCompletion
        {
            $errorCount ="";
            $jobWatcher = New-Object CODESIGN.Submitter.JobWatcher;
            

            $jobWatcher.Watch($job.JobNumber, $server, $port, $isSSL, $false);
           
            if($jobWatcher.IsSuccess)
            {
           # $RetrievedFiles=RetrieveSignedFiles;
            $errorCount+=RetrieveSignedFiles;
            $errorCount+="            ";
            $errorCount+="Job completed: Success="
            $errorCount+=$jobWatcher.IsSuccess
            $errorCount+="            ";
            $errorCount+="Signed="
            $errorCount+=$jobWatcher.TotalSigned
            $errorCount+="            ";
            $errorCount+="BytesSigned="
            $errorCount+=$jobWatcher.TotalByteSize;
            }
            if ($jobWatcher.IsPartial)
            {                
               $errorCount+=$jobWatcher.IsPartial;
            }
            foreach ($JobError in $jobWatcher.ErrorList.Values)
            {                
                $errorCount+="Job Failed :[Please check if all the included files are Strong Named or delaysigned properly]  "
                $errorCount+=$JobError.Number
                $errorCount+="          ";
                $errorCount+=$JobError.Description;
            }
            foreach ($JobFile in $jobWatcher.FailedFileList.Values)
            {                
              
               $errorCount+="Sign Failure: Individual file could not be signed:"
               $errorCount+="        ";
                $errorCount+=$JobFile.FileFullPath;
            }
            
            return $errorCount;
        }


    function RetrieveSignedFiles
    {
       $status="";
        foreach ($jobFile in $job.FileList.Values)
        {

        $jobFileKey=$jobFile.RelativePath+$jobFile.FileName;        
        $signedFile = Join-Path $job.JobCompletionPath $jobFileKey

            if(Test-Path $signedFile)           
            {
                if(Test-Path $jobFile.FileFullPath)
                {
                    $presignFile = $jobFile.FileFullPath + ".presign";
                    Copy-Item $jobFile.FileFullPath $presignFile;
                   
                    $status+=$jobFile.FileFullPath;
                    $status+=".presign file is created";

                }
                else
                {
              
                    $status+=$jobFile.FileFullPath;
                    $status+="   does not exist in the Local path";
                }
                Copy-Item $signedFile $jobFile.FileFullPath;               
                $status+="         ";
                $status+=$signedFile;
                $status+=" Signed file is copied from Shared path to Original Location";
                $status+="         ";
            }
            else
            {               
               $status+="         ";
               $status+=$signedFile;               
               $status+="    does not exist";
               
            }
        }
        
        return $status;
    }

$after = Get-Date;
$elapsedTime = GetElapsedTime $before $after;
$cops = GetCertificateOperationSet;
$publisher = GetPublisherValue;
#$submitter = $job.PersonList.Values | Where-Object { $_.IsSubmitter -eq $true } | Format-Table -Property Alias;
$personList = GetPersonList;
foreach($var in $personList)
{
write-output "Approvers added :  $var "
}
#$errorList = GetErrorList;
$WaitForCompletion=WaitForCompletion;
write-output $WaitForCompletion 

Write-Output "";

Write-Output "";

# Job submission info
Write-output "Job has been submitted with the following info:"
Write-output "-----------------------------------------------"
Write-output "Elapsed time             :" $elapsedTime seconds
Write-output "StrongName               :" $StrongName 
Write-output "AuthentiCode             :" $AuthentiCode 
Write-output "JobNumber                :" $job.JobNumber
Write-output "Number of Files          :" $job.FileCount
Write-output "Total job size           :" $job.TotalByteSize "bytes"
Write-output "HashType                 :" $job.HashType
Write-output "PriorityType             :" $job.PriorityType
Write-output "SubmissionPath           :" $job.JobSubmissionPath 
Write-output "CompletionPath           :" $job.JobCompletionPath 
Write-output "PersonList               :" $personList
Write-output "Description              :" $job.Description
Write-output "Publisher                :" $publisher
Write-output "Submitter ClientVersion  :" $job.ClientVersion
Write-output "Submitter CurrentVersion :" $job.CurrentVersion 
#Write-output "Number of Errors         :" $job.ErrorList.Count 
#Write-Host "ErrorList                :" errorList
Write-output "MetricsXML               :" $job.MetricsXML
Write-output "RelayServer              :" $job.RelayServer
Write-output "RelayPort                :" $job.RelayPort 
Write-output "RelayMode                :" $job.RelayMode
Write-output "MaxRetries               :" $job.MaxRetries 
Write-output "RetryDelay               :" $job.RetryDelay 
#Write-output "JobRelayInstance         :" $job.JobRelayInstance

$job = $null;


}
	Catch [system.exception]
	{
		write-output $_.exception.message 
		
	}
}
CodeSign -jobPath $jobPath -StrongName $StrongName -AuthentiCode $AuthentiCode -include $include -exclude $exclude -server $server -port $port -displayURL $displayURL



