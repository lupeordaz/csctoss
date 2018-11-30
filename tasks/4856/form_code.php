$line = [line_id];

{line_id} = [line_id];

//
// Get line detail information
//
$sql_get_line = "SELECT
	line_id ,
	line_start_date ,
	line_end_date ,
	radius_username ,
	equipment_model_number ,
	equipment_carrier ,
	equipment_maker ,
	equipment_vendor ,
	product_code ,
	sales_order_number ,
	esn_hex ,
	serial_number ,
	location_owner ,
	location_id ,
	location_address ,
	location_name ,
	location_processor ,
	cellsignal ,
	static_ip_address ,
	name ,
	connection_status ,
	last_connected_timestamp,
	firmware_version ,
	warranty_start_date ,
	warranty_end_date ,
	warranty_status ,
	soup_config_name ,
	is_connected ,
	config_status ,
	firmware_status 
FROM csctoss.portal_active_lines_vw
WHERE (billing_entity_id = " . [usr_billing_entity] . " OR parent_billing_entity_id = " . [usr_billing_entity] . ") AND line_id = " . [line_id];

sc_lookup(line_info, $sql_get_line, "conn_oss");

//var_dump({line_info});
//exit();

$username          = urldecode({line_info[0][3]});
$equipment         = {line_info[0][4]};
$equipment_maker   = {line_info[0][6]};
$equipment_vendor  = {line_info[0][7]};
$esn               = {line_info[0][10]};
$serial            = {line_info[0][11]};
$location_owner    = {line_info[0][12]};
$location_id       = {line_info[0][13]};
$location_address  = {line_info[0][14]};
$location_name     = {line_info[0][15]};
$processor         = {line_info[0][16]};
$company_name      = {line_info[0][19]};
$connection_status = {line_info[0][20]};
$firmware          = {line_info[0][22]};
$warranty          = {line_info[0][25]};
$config            = {line_info[0][26]};
$is_connected      = {line_info[0][27]};

//
// Connection status
//
$get_priority_query = "SELECT * FROM usergroup WHERE username = '" . $username . "'";
sc_lookup(status, $get_priority_query, "conn_oss");

//if ({line_info[0][17]} != "Administratively disconnected") {
if ($connection_status != "Administratively disconnected") {
	if (strcmp({status[0][2]}, "userdisconnected") == 0 || strcmp({status[0][2]}, "SERVICE-vzwretail_wallgarden_cnione") == 0) {
		$btn_status = <<<EOD
			<form id="resume{line_id}" method="get" action="../resume_blank">
			<input id="resume_esn_value{line_id}" type="hidden" name="resume_esn_value" value="$esn">
			<input id="resume_username{line_id}" type="hidden" name="resume_username" value="$username">
			<input id="resume" class="scButton_default" style="background-color:red; vertical-align: middle; display:inline-block;"  type="submit" value="Resume" >
			</form>
EOD;
	}
	else {
		$btn_status = <<<EOD
			<form id="suspend{line_id}" method="get" action="../suspend_blank">
			<input id="suspend_esn_value{line_id}" type="hidden" name="suspend_esn_value" value="$esn">
			<input id="suspend_username{line_id}" type="hidden" name="suspend_username" value="$username">
			<input id="supend"  class="scButton_default" style="vertical-align: middle; display:inline-block;"  type="submit" value="Suspend">
			</form>
EOD;
	}
}


//
// Data Usage
//
$beginning_month = date('Y-m-01'); // hard-coded '01' for first day
$end_month  = date('Y-m-t');

$get_usage_query = "SELECT
		  	username,
		  	SUM(acctinputoctets + acctoutputoctets) AS total_in_out_bytes
		FROM master_radacct
		WHERE 1 = 1
		AND username = '"  .$username . "'
		AND acctstarttime >= '".$beginning_month." 00:00:00'::timestamp with time zone
		AND acctstarttime <  '".$end_month." 00:00:00'::timestamp with time zone
		GROUP BY username";

sc_lookup(usage_var, $get_usage_query, "conn_log");

if (!empty({usage_var})) {
	$value = ({usage_var[0][1]} / 1024) / 1024;
	$value = number_format((float)$value, 2, '.', '');
	$usage = $value." MB";
}
else {
	$value = 0;
	$usage = "0 MB";
}


//
// Control buttons
//
//if (is_null({line_info[0][4]}) && is_null({line_info[0][5]}) && is_null({line_info[0][6]}) && is_null({line_info[0][7]}) && is_null({line_info[0][16]})) {
if (is_null($location_owner) && is_null($location_id) && is_null($location_address) && is_null($location_name) && is_null($processor)) {
	$conLocation = 'insert';
	$btn_submit  = '<button type="submit" class="scButton_default">Save Location</button>';
}
else {
	$conLocation = 'update';
	$btn_submit = '<button type="submit" class="scButton_default">Update Location</button>';
}

if ({line_info[0][17]} == "TRUE") {
	$msg = "Yes";
}
else {
	$msg = "No";
}

//
// Warranty
//
//if ({line_info[0][11]} == "In warranty") {
if ($warranty == "In warranty") {
	$rma = '<form action="../license_blank" method="get">'
		.'<input id="rma_line_id" type="hidden" name="rma_line_id" value="'.{line_id}.'">'
		.'<input id="rma_esn_value" type="hidden" name="rma_esn_value" value="'.$esn.'">'
		.'<input id="rma_serial_number" type="hidden" name="rma_serial_number" value="'.$serial.'">'
		.'<input id="rma_username_var" type="hidden" name="rma_username_var" value="'.$username.'">'
		.'<input id="rma_usr_login" type="hidden" name="rma_usr_login" value="'.[usr_login].'">'
		.'<input id="rma_company_name" type="hidden" name="rma_company_name" value="'.$company_name.'">'
		.'<input id="sc_rmaTicket_bot" class="scButton_default" style="vertical-align: middle; display:inline-block;" type="submit" value="RMA">'
		.'</form>';
}


//
// Firmware update
//
//if (strcmp({line_info[0][15]}, "Systech Corp.") == 0) {
if (strcmp($equipment_maker, "Systech Corp.") == 0) {
	$software = '<th><form action="../blank_config" method="get" target="_self">'
				.'<input id="config'.{line_id}.'" type="hidden" name="config" value="'.$config.'">'
				.'<input type="hidden" name="serial" value="'.$serial.'">'
				.'<input type="hidden" name="model" value="'.$equipment.'">'
				.'<input id="sc_configUpdate_bot" class="scButton_default" style="vertical-align: middle; display:inline-block;"  type="submit" value="Config Update">'
				.'</form></th>'
				.'<th><form action="../blank_firmware" method="get" target="_self">'
				.'<input id="firmware'.{line_id}.'" type="hidden" name="firmware" value="'.$firmware.'">'
				.'<input type="hidden" name="serial" value="'.$serial.'">'
				.'<input type="hidden" name="model" value="'.$equipment.'">'
				.'<input id="sc_firmwareUpdate_bot" class="scButton_default" style="vertical-align: middle; display:inline-block;" type="submit" value="Firmware Update">'
				.'</form><th>';
}

$form = <<<"EOD"
	<table align="center">
	<tr>
		<th>
				<div class="form-group">
					<div class="col-sm-offset-2 col-sm-10">
						<table align="center">
							<th>
								$rma
							</th>
							<th>
								$software
							</th>
							<th>
								$btn_status
							<th>
							<th>
								<form action="../blank_tranfer_cancel" method="get">
									<input id="esn_value" type="hidden" name="esn_value" value="$esn">
									<input id="sc_cancelLine_bot" class="scButton_default" style="vertical-align: middle; display:inline-block;" type="submit" value="Cancel Line">
								</form>
							</th>
							<form action="../location_ajax" id="locationForm{line_id}" method="get" target="_self">
							<th>
								$btn_submit
								<input id="condition" type="hidden" name="condition" value="$conLocation" />
								<input id="line_id" type="hidden" name="line_id" value="{line_id}">
							</th>
						</table>
						<table class="scFormTable" width="100%" align="center" style="height: 100%;">
		<tbody>	
			<tr>
				<input id="line_id{line_id}" type="hidden" name="country" value="{line_id}">
				<input id="condition'{line_id}" type="hidden" name="country" value="$conLocation">
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="serial_number"><strong>Serial Number:</strong></label>
				</td>
				<td class="scFormDataOdd " style="text-align:left;">
					<p id="serial_number{line_id}" name="serial_number" align="center" style="display:inline;">$serial</p>
				</td>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="esn_hex"><strong>ESN:</strong></label>
				</td>
				<td class="scFormDataOdd " style="text-align:left;">	
					<p id="esn_hex{line_id}" name="esn_hex" align="center" style="display:inline;">$esn</p>
				</td>
			</tr>
			<tr>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="owner"><strong>Owner:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<input type="text" id="owner{line_id}" name="owner" placeholder="Type Here" value="$location_owner">
				</td>	
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="processor"><strong>Processor:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<input type="text" id="processor{line_id}" name="processor" placeholder="Type Here" value="$processor">
				</td>
			</tr>
			<tr>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="location_id"><strong>Location ID:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<input type="text" id="location_id{line_id}" name="location_id" placeholder="Type Here" value="$location_id">
				</td>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="location_name"><strong>Location Name:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<input type="text" id="location_name{line_id}" name="location_name" placeholder="Type Here" value="$location_name">
				</td>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="location_address"><strong>Location Address:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<input type="text" id="location_address{line_id}" name="location_address" placeholder="Type Here" value="$location_address">
				</td>
			</tr>
			<tr>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="fwver"><strong>Config:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<p id="config{line_id}" name="isConnected" style="display:inline">$config</p>
				</td>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="fwver"><strong>Firmware:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<p id="fwver{line_id}" name="isConnected" style="display:inline">$firmware</p>
				</td>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="fwver"><strong>In Warranty:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<p id="warranty{line_id}" name="warranty" style="display:inline">$warranty</p>
				</td>
			</tr>
			<tr>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="uptime"><strong>Is Connected:</strong></label>
				</td>
				<td class="scFormDataOdd ">
					<p id="isConnected{line_id}" name="isConnected" style="display:inline">$is_connected</p>
				</td>
				<td class="scFormLabelOdd scUiLabelWidthFix">
					<label for="usage"><strong>Current Month Usage:</strong></label>
				</td>
				<td class="scFormDataOdd " style="text-align:left;">
					<p id="usage{line_id}" name="usage" style="display:inline">$usage</p>
				</td>
			</tr>
		</tbody>
	</table>
					</div>
				</div>
			</form>
		</th>
		<form>
		</form>
		<th>
			
		</th>	
	</tr>
	</table>
EOD;

{form_field} = $form;