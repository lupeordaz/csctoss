if(strcmp($result,'change log staff id could not be set') == 0)
{
echo '<script type="text/javascript">alert("change log staff id could not be set")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'OLD ESN HEX NOT PRESENT UI TABLE') == 0)
{
echo '<script type="text/javascript">alert("OLD ESN HEX NOT PRESENT UI TABLE")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'EQUIPMENT ID ASSOCIATED WITH OLD ESN NOT FOUND IN LINE_EQUIPMENT TABLE') == 0)
{
echo '<script type="text/javascript">alert("EQUIPMENT ID ASSOCIATED WITH OLD ESN NOT FOUND IN LINE_EQUIPMENT TABLE")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'EQUIPMENT ID ASSOCIATED WITH NEW ESN FOUND IN LINE_EQUIPMENT TABLE') == 0)
{
echo '<script type="text/javascript">alert("EQUIPMENT ID ASSOCIATED WITH NEW ESN FOUND IN LINE_EQUIPMENT TABLE")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'BILLING_ENTIY_ID NOT PRESENT IN BILLING_ENTITY_TABLE') == 0)
{
echo '<script type="text/javascript">alert("BILLING_ENTIY_ID NOT PRESENT IN BILLING_ENTITY_TABLE")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result, 'Invalid new Usergroup')==0)
{
echo '<script type="text/javascript">alert("Invalid new Usergroup")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'No match for parameters') == 0)
{
echo '<script type="text/javascript">alert("No match for parameters")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'NEW ESN HEX NOT PRESENT') == 0)
{
echo '<script type="text/javascript">alert("NEW ESN HEX NOT PRESENT")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'SERIAL NUMBER NOT PRESENT FOR NEW ESN HEX') == 0)
{
echo '<script type="text/javascript">alert("SERIAL NUMBER NOT PRESENT FOR NEW ESN HEX")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result, "CARRIER FOR EQUIPMENT MODEL NOT FOUND")==0)
{
echo '<script type="text/javascript">alert("CARRIER FOR EQUIPMENT MODEL NOT FOUND")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'USERNAME FOR NEW EQUIPMENT NOT FOUND') == 0)
{
echo '<script type="text/javascript">alert("USERNAME FOR NEW EQUIPMENT NOT FOUND")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,'LINE_EQUIPMENT END_DATE NOT UPDATED')==0)
{
echo '<script type="text/javascript">alert("LINE_EQUIPMENT END_DATE NOT UPDATED")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,"ACTIVE LINE FOR OLD EQUIPMENT NOT FOUND IN LINE_EQUIPMENT") == 0)
{
echo '<script type="text/javascript">alert("ACTIVE LINE FOR OLD EQUIPMENT NOT FOUND IN LINE_EQUIPMENT")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result, "NEW USERNAME NOT PRESENT IN USERGROUP TABLE") == 0)
{
echo '<script type="text/javascript">alert("NEW USERNAME NOT PRESENT IN USERGROUP TABLE")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result, "Static IP not unassigned: % rows updated: %',v_ip,v_numrows") == 0)
{
echo '<script type="text/javascript">alert("Static IP not unassigned: % rows updated: %\',v_ip,v_numrows")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result, "ROW(S) NOT DELETED FROM RADREPLY TABLE") == 0)
{
echo '<script type="text/javascript">alert("ROW(S) NOT DELETED FROM RADREPLY TABLE")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result,"ROW(S) NOT DELETED FROM RADCHECK FOR OLD USERNAME: %',v_old_username") == 0)
{
echo '<script type="text/javascript">alert("ROW(S) NOT DELETED FROM RADCHECK FOR OLD USERNAME: %\',v_old_username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result, "Unable to obtain priority for groupname : %', v_rma_groupname") == 0)
{
echo '<script type="text/javascript">alert("Unable to obtain priority for groupname : %\', v_rma_groupname")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result, "UPDATE OF OLD USERGROUP WAS UNSUCESSFULL!") == 0)
{
echo '<script type="text/javascript">alert("UPDATE OF OLD USERGROUP WAS UNSUCESSFULL!")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result, "UNABLE TO OBTAIN PRIORITY FOR GROUPNAME : % !', in_new_usergroup") == 0)
{
echo '<script type="text/javascript">alert("UNABLE TO OBTAIN PRIORITY FOR GROUPNAME : % !\', in_new_usergroup;")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "INSERT INTO USERGROUP TABLE WAS UNSUCESSFULL!") == 0)
{
echo '<script type="text/javascript">alert("INSERT INTO USERGROUP TABLE WAS UNSUCESSFULL!")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "MORE THAN 1 ROW IN LINE_EQUIPMENT WAS UPDATED.") == 0)
{
echo '<script type="text/javascript">alert("MORE THAN 1 ROW IN LINE_EQUIPMENT WAS UPDATED.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "INSERT INTO RADREPLY TABLE WAS UNSUCESSFUL!!") == 0)
{
echo '<script type="text/javascript">alert("INSERT INTO RADREPLY TABLE WAS UNSUCESSFUL!!")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Invalid Carrier for new equipment") == 0)
{
echo '<script type="text/javascript">alert("Invalid Carrier for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "INSERT INTO RADCHECK TABLE WAS UNSUCESSFUL!!") == 0)
{
echo '<script type="text/javascript">alert("INSERT INTO RADCHECK TABLE WAS UNSUCESSFUL!!")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "UPDATE OF OLD USERNAME FAILED.") == 0)
{
echo '<script type="text/javascript">alert("UPDATE OF OLD USERNAME FAILED.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "UPDATE  OF NEW USERNAME FAILED.") == 0)
{
echo '<script type="text/javascript">alert("UPDATE  OF NEW USERNAME FAILED.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "CALL TO oss.jbilling_rma RESULTED IN FAILURE") == 0)
{
echo '<script type="text/javascript">alert("CALL TO oss.jbilling_rma RESULTED IN FAILURE")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Original ESN must be present in line_equipment with a null end date") == 0)
{
echo '<script type="text/javascript">alert("Original ESN must be present in line_equipment with a null end date")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "New ESN: {new_esn_hex} not found in UI table") == 0)
{
echo '<script type="text/javascript">alert("New ESN: {new_esn_hex} not found in UI table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "New ESN: not found in UI table") == 0)
{
echo '<script type="text/javascript">alert("New ESN: not found in UI table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Unable to set change_log_staff_id") == 0)
{
echo '<script type="text/javascript">alert("Unable to set change_log_staff_id")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Replacement ESN cannot be currently active in line_equipment table") == 0)
{
echo '<script type="text/javascript">alert("Replacement ESN cannot be currently active in line_equipment table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Original ESN must be associated with an active line in line_equipment table") == 0)
{
echo '<script type="text/javascript">alert("Original ESN must be associated with an active line in line_equipment table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "A serial number for replacement equipment must be present in UI table") == 0)
{
echo '<script type="text/javascript">alert("A serial number for replacement equipment must be present in UI table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "The groupname for the username of the original equipment must be present in usergroup table") == 0)
{
echo '<script type="text/javascript">alert("The groupname for the username of the original equipment must be present in usergroup table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Replacement ESN must be present in unique identifier table - and the equipment_id must have a match in the equipment table") == 0)
{
echo '<script type="text/javascript">alert("Replacement ESN must be present in unique identifier table - and the equipment_id must have a match in the equipment table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Obtain the model ID of the replacement equipment") == 0)
{
echo '<script type="text/javascript">alert("Obtain the model ID of the replacement equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Obtain the model ID of the replacement equipment") == 0)
{
echo '<script type="text/javascript">alert("Obtain the model ID of the replacement equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Obtaining serial number for new ESN") == 0)
{
echo '<script type="text/javascript">alert("Obtaining serial number for new ESN")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Obtain carrier for new equipment") == 0)
{
echo '<script type="text/javascript">alert("Obtain carrier for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Obtain username for new equipment") == 0)
{
echo '<script type="text/javascript">alert("Obtain username for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Obtain username for new equipment") == 0)
{
echo '<script type="text/javascript">alert("Obtain username for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Obtain groupname for new equipment") == 0)
{
echo '<script type="text/javascript">alert("Obtain groupname for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Update line equipment to set end date on Original equipment") == 0)
{
echo '<script type="text/javascript">alert("Update line equipment to set end date on Original equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Unassign old static IP in static_ip_pool") == 0)
{
echo '<script type="text/javascript">alert("Unassign old static IP in static_ip_pool")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Delete rows from radreply for old username") == 0)
{
echo '<script type="text/javascript">alert("Delete rows from radreply for old username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Update usergroup and priority for old username") == 0)
{
echo '<script type="text/javascript">alert("Update usergroup and priority for old username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Obtaining priority for new groupname from groupname table") == 0)
{
echo '<script type="text/javascript">alert("Obtaining priority for new groupname from groupname table")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Replacing username data in usergroup table for new username") == 0)
{
echo '<script type="text/javascript">alert("Replacing username data in usergroup table for new username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Insert new row into ine_equipment with new equipment id for line") == 0)
{
echo '<script type="text/javascript">alert("Insert new row into ine_equipment with new equipment id for line")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Call static_ip_assign to assign new static IP for new equipment") == 0)
{
echo '<script type="text/javascript">alert("Call static_ip_assign to assign new static IP for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Insert into radreply with config variables") == 0)
{
echo '<script type="text/javascript">alert("Insert into radreply with config variables")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Insert radius config data into radcheck for new_username") == 0)
{
echo '<script type="text/javascript">alert("Insert radius config data into radcheck for new_username")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Set billing entity for old usename to 2") == 0)
{
echo '<script type="text/javascript">alert("Set billing entity for old usename to 2")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Update username for new equipment") == 0)
{
echo '<script type="text/javascript">alert("Update username for new equipment")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Failure within or when calling the rt_jbilling_rma() function.") == 0)
{
echo '<script type="text/javascript">alert("Failure within or when calling the rt_jbilling_rma() function.")</script>';
sc_redir("rma_queue", "", "_self");
}
if(strcmp($result , "Original ESN must be present in line_equipment with a null end date") == 0)
{
echo '<script type="text/javascript">alert("Original ESN must be present in line_equipment with a null end date")</script>';
sc_redir("rma_queue", "", "_self");
}