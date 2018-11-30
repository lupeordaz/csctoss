
'A serial number for replacement equipment must be present in UI table';
'Carrier for new equipment does not exist.';
'Delete rows from radreply for old username';
'Determine config for radcheck table';
'Failure within or when calling the rt_jbilling_rma() function';
'INSERT FAILED for new row into line_equipment with new equipment id for line';
'Insert into radreply with config variables';
'Insert radius config data into radcheck for new_username';
'Insert radius config data into radcheck for old_username';
'Insert/update failed for equipment_warranty, equipment_id';
'Model ID for the new equipment id does not exist.';
'New ESN: '||in_new_esn||' not found in UI table';
'Obtain groupname for new equipment';
'Obtaining priority for new groupname from groupname table';
'Obtaining priority for RMA groupname from groupname table';
'Original ESN must be associated with an active line in line_equipment table';
'Original ESN must be present in line_equipment with a null end date';
'Replacement ESN cannot be currently active in line_equipment table';
'Replacement ESN cannot have todays date as end_date in line_equipment table';    
'Replacement ESN must be present in unique identifier table - and the equipment_id must have a match in the equipment table';
'Replacing username data in usergroup table for new username';
'Serial number for new equipment does not exist.';
'Serial number for old equipment does not exist.';
'Set billing entity for old usename to 2';
'The groupname for the username of the original equipment must be present in usergroup table';
'Unable to set change_log_staff_id';
'Unassign old static IP in static_ip_pool';
'Update line equipment to set end date on Original equipment';
'Update line with new username and line_label';
'Update usergroup and priority for old username';
'Update username for new equipment';
'username for new equipment does not exist.';



if(strcmp($result,'change log staff id could not be set') == 0)
{
echo '<script type="text/javascript">alert("change log staff id could not be set")</script>';
sc_redir("rma_queue", "", "_self");
}


if(strcmp($result,'A serial number for replacement equipment must be present in UI table') ==0)
{
echo '<script type="text/javascript">alert("A serial number for replacement equipment must be present in UI table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Carrier for new equipment does not exist.') ==0)
{
echo '<script type="text/javascript">alert("Carrier for new equipment does not exist.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Delete rows from radreply for old username') ==0)
{
echo '<script type="text/javascript">alert("Delete rows from radreply for old username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Determine config for radcheck table') ==0)
{
echo '<script type="text/javascript">alert("Determine config for radcheck table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Failure within or when calling the rt_jbilling_rma() function') ==0)
{
echo '<script type="text/javascript">alert("Failure within or when calling the rt_jbilling_rma() function")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'INSERT FAILED for new row into line_equipment with new equipment id for line') ==0)
{
echo '<script type="text/javascript">alert("INSERT FAILED for new row into line_equipment with new equipment id for line")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Insert into radreply with config variables') ==0)
{
echo '<script type="text/javascript">alert("Insert into radreply with config variables")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Insert radius config data into radcheck for new_username') ==0)
{
echo '<script type="text/javascript">alert("Insert radius config data into radcheck for new_username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Insert radius config data into radcheck for old_username') ==0)
{
echo '<script type="text/javascript">alert("Insert radius config data into radcheck for old_username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Insert/update failed for equipment_warranty, equipment_id') ==0)
{
echo '<script type="text/javascript">alert("Insert/update failed for equipment_warranty, equipment_id")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Model ID for the new equipment id does not exist.') ==0)
{
echo '<script type="text/javascript">alert("Model ID for the new equipment id does not exist.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'New ESN: '||in_new_esn||' not found in UI table') ==0)
{
echo '<script type="text/javascript">alert("New ESN: '||in_new_esn||' not found in UI table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Obtain groupname for new equipment') ==0)
{
echo '<script type="text/javascript">alert("Obtain groupname for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Obtaining priority for new groupname from groupname table') ==0)
{
echo '<script type="text/javascript">alert("Obtaining priority for new groupname from groupname table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Obtaining priority for RMA groupname from groupname table') ==0)
{
echo '<script type="text/javascript">alert("Obtaining priority for RMA groupname from groupname table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Original ESN must be associated with an active line in line_equipment table') ==0)
{
echo '<script type="text/javascript">alert("Original ESN must be associated with an active line in line_equipment table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Original ESN must be present in line_equipment with a null end date') ==0)
{
echo '<script type="text/javascript">alert("Original ESN must be present in line_equipment with a null end date")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Replacement ESN cannot be currently active in line_equipment table') ==0)
{
echo '<script type="text/javascript">alert("Replacement ESN cannot be currently active in line_equipment table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Replacement ESN cannot have todays date as end_date in line_equipment table' ) ==0)
{
echo '<script type="text/javascript">alert("Replacement ESN cannot have todays date as end_date in line_equipment table.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Replacement ESN must be present in unique identifier table - and the equipment_id must have a match in the equipment table') ==0)
{
echo '<script type="text/javascript">alert("Replacement ESN must be present in unique identifier table - and the equipment_id must have a match in the equipment table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Replacing username data in usergroup table for new username') ==0)
{
echo '<script type="text/javascript">alert("Replacing username data in usergroup table for new username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Serial number for new equipment does not exist.') ==0)
{
echo '<script type="text/javascript">alert("Serial number for new equipment does not exist.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Serial number for old equipment does not exist.') ==0)
{
echo '<script type="text/javascript">alert("Serial number for old equipment does not exist.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Set billing entity for old usename to 2') ==0)
{
echo '<script type="text/javascript">alert("Set billing entity for old usename to 2")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'The groupname for the username of the original equipment must be present in usergroup table') ==0)
{
echo '<script type="text/javascript">alert("The groupname for the username of the original equipment must be present in usergroup table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Unable to set change_log_staff_id') ==0)
{
echo '<script type="text/javascript">alert("Unable to set change_log_staff_id")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Unassign old static IP in static_ip_pool') ==0)
{
echo '<script type="text/javascript">alert("Unassign old static IP in static_ip_pool")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Update line equipment to set end date on Original equipment') ==0)
{
echo '<script type="text/javascript">alert("Update line equipment to set end date on Original equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Update line with new username and line_label') ==0)
{
echo '<script type="text/javascript">alert("Update line with new username and line_label")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Update usergroup and priority for old username') ==0)
{
echo '<script type="text/javascript">alert("Update usergroup and priority for old username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'Update username for new equipment') ==0)
{
echo '<script type="text/javascript">alert("Update username for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'username for new equipment does not exist.') ==0)
{
echo '<script type="text/javascript">alert("username for new equipment does not exist.")</script>';
sc_redir("rma_queue", "", "_self");
}







