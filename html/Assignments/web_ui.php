<!DOCTYPE html>
<html>
<head>
        <title>OSS</title>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="bootstrap3/css/bootstrap.css">
<!-- Optional theme -->
<link rel="stylesheet" type="text/css" href="bootstrap3/css/bootstrap-theme.css">
<link rel="stylesheet" type="text/css" href="phpcss/jquery.fileupload.css">
<link rel="stylesheet" type="text/css" href="phpcss/jquery.fileupload-ui.css">
<link rel="stylesheet" type="text/css" href="colorbox/colorbox.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="phpcss/OSS.css">
<script type="text/javascript" src="jquery/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="jquery/jquery.ui.widget.js"></script>
<script type="text/javascript" src="jquery/jquery.storageapi.min.js"></script>
<script type="text/javascript" src="jquery/pStrength.jquery.js"></script>
<script type="text/javascript" src="jquery/pGenerator.jquery.js"></script>
<script type="text/javascript" src="bootstrap3/js/bootstrap.min.js"></script>
<script type="text/javascript" src="phpjs/typeahead.bundle.min.js"></script>
<script type="text/javascript" src="jqueryfileupload/load-image.all.min.js"></script>
<script type="text/javascript" src="jqueryfileupload/jqueryfileupload.min.js"></script>
<script type="text/javascript" src="colorbox/jquery.colorbox-min.js"></script>
<script type="text/javascript" src="phpjs/mobile-detect.min.js"></script>
<script type="text/javascript" src="phpjs/moment.min.js"></script>
<script type="text/javascript">
var EW_LANGUAGE_ID = "en";
var EW_DATE_SEPARATOR = "/"; // Date separator
var EW_TIME_SEPARATOR = ":"; // Time separator
var EW_DATE_FORMAT = "mm/dd/yyyy"; // Default date format
var EW_DATE_FORMAT_ID = "6"; // Default date format ID
var EW_DECIMAL_POINT = ".";
var EW_THOUSANDS_SEP = ",";
var EW_MIN_PASSWORD_STRENGTH = 8;
var EW_GENERATE_PASSWORD_LENGTH = 8;
var EW_GENERATE_PASSWORD_UPPERCASE = true;
var EW_GENERATE_PASSWORD_LOWERCASE = true;
var EW_GENERATE_PASSWORD_NUMBER = true;
var EW_GENERATE_PASSWORD_SPECIALCHARS = false;
var EW_SESSION_TIMEOUT = 0; // Session timeout time (seconds)
var EW_SESSION_TIMEOUT_COUNTDOWN = 60; // Count down time to session timeout (seconds)
var EW_SESSION_KEEP_ALIVE_INTERVAL = 0; // Keep alive interval (seconds)
var EW_RELATIVE_PATH = ""; // Relative path
var EW_SESSION_URL = EW_RELATIVE_PATH + "ewsession13.php"; // Session URL
var EW_IS_LOGGEDIN = true; // Is logged in
var EW_IS_SYS_ADMIN = false; // Is sys admin
var EW_CURRENT_USER_NAME = "tstovicek"; // Current user name
var EW_IS_AUTOLOGIN = false; // Is logged in with option "Auto login until I logout explicitly"
var EW_TIMEOUT_URL = EW_RELATIVE_PATH + "logout.php"; // Timeout URL
var EW_LOOKUP_FILE_NAME = "ewlookup13.php"; // Lookup file name
var EW_LOOKUP_FILTER_VALUE_SEPARATOR = ","; // Lookup filter value separator
var EW_MODAL_LOOKUP_FILE_NAME = "ewmodallookup13.php"; // Modal lookup file name
var EW_AUTO_SUGGEST_MAX_ENTRIES = 10; // Auto-Suggest max entries
var EW_DISABLE_BUTTON_ON_SUBMIT = true;
var EW_IMAGE_FOLDER = "phpimages/"; // Image folder
var EW_UPLOAD_URL = "ewupload13.php"; // Upload URL
var EW_UPLOAD_THUMBNAIL_WIDTH = 200; // Upload thumbnail width
var EW_UPLOAD_THUMBNAIL_HEIGHT = 0; // Upload thumbnail height
var EW_MULTIPLE_UPLOAD_SEPARATOR = ","; // Upload multiple separator
var EW_USE_COLORBOX = true;
var EW_USE_JAVASCRIPT_MESSAGE = false;
var EW_MOBILE_DETECT = new MobileDetect(window.navigator.userAgent);
var EW_IS_MOBILE = EW_MOBILE_DETECT.mobile() ? true : false;
var EW_PROJECT_STYLESHEET_FILENAME = "phpcss/OSS.css"; // Project style sheet
var EW_PDF_STYLESHEET_FILENAME = "phpcss/ewpdf.css"; // Pdf style sheet
var EW_TOKEN = "Zt0b8OgcIF_B83IOjfz41g..";
var EW_CSS_FLIP = false;
var EW_CONFIRM_CANCEL = true;
var EW_SEARCH_FILTER_OPTION = "Client";
</script>
<script type="text/javascript" src="phpjs/jsrender.min.js"></script>
<script type="text/javascript" src="phpjs/ewp13.js"></script>
<script type="text/javascript">
var ewVar = [];
var ewLanguage = new ew_Language({"cancelbtn":"Cancel","clickrecaptcha":"Please click reCAPTCHA","closebtn":"Close","confirmbtn":"Confirm","confirmcancel":"Do you want to cancel?","lightboxtitle":" ","lightboxcurrent":"image {current} of {total}","lightboxprevious":"previous","lightboxnext":"next","lightboxclose":"close","lightboxxhrerror":"This content failed to load.","lightboximgerror":"This image failed to load.","countselected":"%s selected","currentpassword":"Current password: ","deleteconfirmmsg":"Are you sure you want to delete?","deletefilterconfirm":"Delete filter %s?","enterfiltername":"Enter filter name","enternewpassword":"Please enter new password","enteroldpassword":"Please enter old password","enterpassword":"Please enter password","enterpwd":"Please enter password","enterusername":"Please enter username","entervalidatecode":"Enter the validation code shown","entersenderemail":"Please enter sender email","enterpropersenderemail":"Exceed maximum sender email count or email address incorrect","enterrecipientemail":"Please enter recipient email","enterproperrecipientemail":"Exceed maximum recipient email count or email address incorrect","enterproperccemail":"Exceed maximum cc email count or email address incorrect","enterproperbccemail":"Exceed maximum bcc email count or email address incorrect","entersubject":"Please enter subject","enteruid":"Please enter user ID","entervalidemail":"Please enter valid Email Address","exporttoemailtext":"Email","filtername":"Filter name","overwritebtn":"Overwrite","incorrectemail":"Incorrect email","incorrectfield":"Incorrect field","incorrectfloat":"Incorrect floating point number","incorrectguid":"Incorrect GUID","incorrectinteger":"Incorrect integer","incorrectphone":"Incorrect phone number","incorrectregexp":"Regular expression not matched","incorrectrange":"Number must be between %1 and %2","incorrectssn":"Incorrect social security number","incorrectzip":"Incorrect ZIP code","insertfailed":"Insert failed","invalidrecord":"Invalid Record! Key is null","loading":"Loading...","maxfilesize":"Max. file size (%s bytes) exceeded.","messageok":"OK","mismatchpassword":"Mismatch Password","next":"Next","noaddrecord":"No records to be added","nofieldselected":"No field selected for update","norecord":"No records found","norecordselected":"No records selected","of":"of","page":"Page","passwordstrength":"Strength: %p","passwordtoosimple":"Your password is too simple","pleaseselect":"Please select","pleasewait":"Please wait...","prev":"Prev","quicksearchauto":"Auto","quicksearchautoshort":"","quicksearchall":"All keywords","quicksearchallshort":"All","quicksearchany":"Any keywords","quicksearchanyshort":"Any","quicksearchexact":"Exact match","quicksearchexactshort":"Exact","record":"Records","recordsperpage":"Page size","reloadbtn":"Reload","search":"Search","selectbtn":"Select","sendemailsuccess":"Email sent successfully","sessionwillexpire":"Your session will expire in %s seconds. Click OK to continue your session.","sessionexpired":"Your session has expired.","updatebtn":"Update","uploading":"Uploading...","uploadstart":"Start","uploadcancel":"Cancel","uploaddelete":"Delete","uploadoverwrite":"Overwrite old file?","uploaderrmsgmaxfilesize":"File is too big","uploaderrmsgminfilesize":"File is too small","uploaderrmsgacceptfiletypes":"File type not allowed","uploaderrmsgmaxnumberoffiles":"Maximum number of files exceeded","uploaderrmsgmaxfilelength":"Total length of file names exceeds field length","useradministrator":"Administrator","useranonymous":"Anonymous","userdefault":"Default","userleveladministratorname":"User level name for user level -1 must be 'Administrator'","userlevelanonymousname":"User level name for user level -2 must be 'Anonymous'","userlevelidinteger":"User Level ID must be integer","userleveldefaultname":"User level name for user level 0 must be 'Default'","userlevelidincorrect":"User defined User Level ID must be larger than 0","userlevelnameincorrect":"User defined User Level name cannot be 'Administrator' or 'Default'","valuenotexist":"Value does not exist","wrongfiletype":"File type is not allowed."});</script>
<script type="text/javascript" src="http://maps.googleapis.com/maps/api/js?key=AIzaSyD3OIpUon9I3J0m5SFGh7ACe5MPkpYwHuk"></script>
<script type="text/javascript" src="phpjs/ewgooglemaps.js"></script>
<script type="text/javascript" src="phpjs/userfn13.js"></script>
<script type="text/javascript">

// Write your client script here, no need to add script tags.
</script>
<link rel="shortcut icon" type="image/vnd.microsoft.icon" href="http://webui.contournetworks.net/OSS/cct_logo.ico"><link rel="icon" type="image/vnd.microsoft.icon" href="http://webui.contournetworks.net/OSS/cct_logo.ico">
<meta name="generator" content="PHPMaker v2017.0.7">
</head>
<body>
<div class="ewLayout">
        <!-- header (begin) --><!-- ** Note: Only licensed users are allowed to change the logo ** -->
        <div id="ewHeaderRow" class="hidden-xs ewHeaderRow"><img src="phpimages/cct_logo.jpg" alt=""></div>
<nav id="ewMobileMenu" role="navigation" class="navbar navbar-default visible-xs hidden-print">
        <div class="container-fluid"><!-- Brand and toggle get grouped for better mobile display -->
                <div class="navbar-header">
                        <button data-target="#ewMenu" data-toggle="collapse" class="navbar-toggle" type="button">
                                <span class="sr-only">Toggle navigation</span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="#">OSS</a>
                </div>
                <div id="ewMenu" class="collapse navbar-collapse" style="height: auto;"><!-- Begin Main Menu -->
<!-- Begin Main Menu -->
<ul id="MobileMenu" class="nav navbar-nav">
<li id="mmi_quick_search_php"><a href="quick_search.php">Quick Search</a></li>
<li id="mmi_search_sessions_php"><a href="search_sessions.php">Search Sessions</a></li>
<li id="mmci_Device_Operation" class="dropdown"><a class="ewDropdown" href="#">Device Operation<span class="icon-arrow-down"></span></a><ul class="dropdown-menu" role="menu">
<li id="mmi_cancel_device_php" class="active"><a href="javascript:void(0);">Cancel Device</a></li>
<li id="mmi_cancel_device_only_in_oss_php"><a href="cancel_device_only_in_oss.php">Cancel Device only in OSS</a></li>
<li id="mmi_suspend_device_php"><a href="suspend_device.php">Suspend Device</a></li>
<li id="mmi_restore_device_php"><a href="restore_device.php">Restore Device</a></li>
</ul>
</li>
<li id="mmci_OSS" class="dropdown"><a class="ewDropdown" href="#">OSS<span class="icon-arrow-down"></span></a><ul class="dropdown-menu" role="menu">
<li id="mmi_active_lines_vw"><a href="active_lines_vwlist.php">active lines vw</a></li>
<li id="mmi_oss_line_summary_vw"><a href="oss_line_summary_vwlist.php">oss line summary vw</a></li>
<li id="mmi_billing_entity"><a href="billing_entitylist.php?cmd=resetall">billing entity</a></li>
<li id="mmi_unique_identifier"><a href="unique_identifierlist.php">unique identifier</a></li>
<li id="mmi_equipment_model"><a href="equipment_modellist.php">equipment model</a></li>
<li id="mmi_static_ips_vw"><a href="static_ips_vwlist.php">static ips vw</a></li>
<li id="mmi_product"><a href="productlist.php">product</a></li>
<li id="mmi_number_of_active_per_carrier_vw"><a href="number_of_active_per_carrier_vwlist.php">number of active per carrier vw</a></li>
<li id="mmi_denoss02_master_radacct_vw"><a href="denoss02_master_radacct_vwlist.php">denoss 02 master radacct vw</a></li>
<li id="mmi_usccsprint_radcheck"><a href="usccsprint_radchecklist.php">usccsprint radcheck</a></li>
<li id="mmi_equipment_model_status"><a href="equipment_model_statuslist.php">equipment model status</a></li>
<li id="mmi_equipment"><a href="equipmentlist.php">equipment</a></li>
<li id="mmi_username_change_php"><a href="username_change.php">username_change</a></li>
<li id="mmi_cancel_info_php"><a href="cancel_info.php">Cancel_Info</a></li>
<li id="mmi_oss_jbill_plan_comparison_vw"><a href="oss_jbill_plan_comparison_vwlist.php">oss jbill plan comparison vw</a></li>
<li id="mmi_change_static_ip_php"><a href="change_static_ip.php">Change Static IP Address</a></li>
<li id="mmi_cancellation_report_vw"><a href="cancellation_report_vwlist.php">cancellation report vw</a></li>
<li id="mmi_location_labels_vw"><a href="location_labels_vwlist.php">location labels vw</a></li>
<li id="mmi_radius_username_change_log_vw"><a href="radius_username_change_log_vwlist.php">radius username change log vw</a></li>
<li id="mmi_equipment_credential"><a href="equipment_credentiallist.php">equipment credential</a></li>
<li id="mmi_groupname_default"><a href="groupname_defaultlist.php">groupname default</a></li>
<li id="mmi_plan"><a href="planlist.php">plan</a></li>
<li id="mmi_static_ip_pool"><a href="static_ip_poollist.php">static ip pool</a></li>
<li id="mmi_device_monitor"><a href="device_monitorlist.php">device monitor</a></li>
<li id="mmi_device_monitor_vw"><a href="device_monitor_vwlist.php">device monitor vw</a></li>
<li id="mmi_equipment_warranty_rule"><a href="equipment_warranty_rulelist.php">equipment warranty rule</a></li>
<li id="mmi_oss_jbill_billing_entity_mapping"><a href="oss_jbill_billing_entity_mappinglist.php">oss jbill billing entity mapping</a></li>
<li id="mmi_firmware"><a href="firmwarelist.php">firmware</a></li>
<li id="mmi_lookup_lines_by_dynamic_ip_php"><a href="lookup_lines_by_dynamic_ip.php">Lookup_lines_by_dynamic_IP</a></li>
<li id="mmi_oss_active_line_config_revisions_vw"><a href="oss_active_line_config_revisions_vwlist.php">oss active line config revisions vw</a></li>
</ul>
</li>
<li id="mmci_JBilling" class="dropdown"><a class="ewDropdown" href="#">JBilling<span class="icon-arrow-down"></span></a><ul class="dropdown-menu" role="menu">
<li id="mmi_jbill_shipping_cost_report_vw"><a href="jbill_shipping_cost_report_vwlist.php">jbill shipping cost report vw</a></li>
<li id="mmi_jbill_tax_rates_per_customer"><a href="jbill_tax_rates_per_customerlist.php">jbill tax rates per customer</a></li>
<li id="mmi_jbill_order_details_vw"><a href="jbill_order_details_vwlist.php">jbill order details vw</a></li>
<li id="mmi_item"><a href="itemlist.php">item</a></li>
<li id="mmi_jbill_customer_specific_pricing"><a href="jbill_customer_specific_pricinglist.php">jbill customer specific pricing</a></li>
<li id="mmi_jbill_invoice_data"><a href="jbill_invoice_datalist.php">jbill invoice data</a></li>
<li id="mmi_jbill_customer_user_list"><a href="jbill_customer_user_listlist.php">jbill customer user list</a></li>
<li id="mmi_all_cancelled_lines_by_customer_vw"><a href="all_cancelled_lines_by_customer_vwlist.php">all cancelled lines by customer vw</a></li>
<li id="mmi_jbill_pricing"><a href="jbill_pricinglist.php">jbill pricing</a></li>
<li id="mmi_customer_external_ids_vw"><a href="customer_external_ids_vwlist.php">customer external ids vw</a></li>
<li id="mmi_jbill_reactivation_list"><a href="jbill_reactivation_listlist.php">jbill reactivation list</a></li>
<li id="mmi_subaccounts_and_parents_vw"><a href="subaccounts_and_parents_vwlist.php">subaccounts and parents vw</a></li>
<li id="mmi_jbill_so_item_list"><a href="jbill_so_item_listlist.php">jbill so item list</a></li>
<li id="mmi_order_line"><a href="order_linelist.php">order line</a></li>
<li id="mmi_prov_line"><a href="prov_linelist.php">prov line</a></li>
<li id="mmi_purchase_order"><a href="purchase_orderlist.php">purchase order</a></li>
<li id="mmi_sales_tax"><a href="sales_taxlist.php">sales tax</a></li>
<li id="mmi_telcom_tax"><a href="telcom_taxlist.php">telcom tax</a></li>
<li id="mmi_jbill_location_vw"><a href="jbill_location_vwlist.php">jbill location vw</a></li>
<li id="mmi_customer"><a href="customerlist.php">customer (Set external_id)</a></li>
</ul>
</li>
<li id="mmci_RADIUS" class="dropdown"><a class="ewDropdown" href="#">RADIUS<span class="icon-arrow-down"></span></a><ul class="dropdown-menu" role="menu">
<li id="mmi_radreply"><a href="radreplylist.php">radreply</a></li>
<li id="mmi_lns_lookup"><a href="lns_lookuplist.php">lns lookup</a></li>
<li id="mmi_nas"><a href="naslist.php">nas</a></li>
<li id="mmi_radcheck"><a href="radchecklist.php">radcheck</a></li>
<li id="mmi_groupname"><a href="groupnamelist.php">groupname</a></li>
<li id="mmi_radgroupcheck"><a href="radgroupchecklist.php?cmd=resetall">radgroupcheck</a></li>
<li id="mmi_radgroupreply"><a href="radgroupreplylist.php?cmd=resetall">radgroupreply</a></li>
<li id="mmi_radius_operator"><a href="radius_operatorlist.php">radius operator</a></li>
<li id="mmi_username"><a href="usernamelist.php">username</a></li>
<li id="mmi_usergroup"><a href="usergrouplist.php">usergroup</a></li>
</ul>
</li>
<li id="mmci_OpenTaps" class="dropdown"><a class="ewDropdown" href="#">OpenTaps<span class="icon-arrow-down"></span></a><ul class="dropdown-menu" role="menu">
<li id="mmi_otaps_product_code_translation"><a href="otaps_product_code_translationlist.php">otaps product code translation</a></li>
<li id="mmi_cct_shipping_cost_vw"><a href="cct_shipping_cost_vwlist.php">cct shipping cost vw</a></li>
<li id="mmi_service_line_number"><a href="service_line_numberlist.php">service line number</a></li>
<li id="mmi_service_line_detail"><a href="service_line_detaillist.php">service line detail</a></li>
</ul>
</li>
<li id="mmci_SessionInfo" class="dropdown"><a class="ewDropdown" href="#">SessionInfo<span class="icon-arrow-down"></span></a><ul class="dropdown-menu" role="menu">
<li id="mmi_last_session_starttime_for_last6mo"><a href="last_session_starttime_for_last6molist.php">last session starttime for last 6mo</a></li>
<li id="mmi_master_radacct_vw"><a href="master_radacct_vwlist.php">master radacct vw</a></li>
<li id="mmi_session_history_last30days_vw"><a href="session_history_last30days_vwlist.php">session history last 30days vw</a></li>
<li id="mmi_verizon_usage_last_one_month_vw"><a href="verizon_usage_last_one_month_vwlist.php">verizon usage last one month vw</a></li>
</ul>
</li>
<li id="mmci_SOUP" class="dropdown"><a class="ewDropdown" href="#">SOUP<span class="icon-arrow-down"></span></a><ul class="dropdown-menu" role="menu">
<li id="mmi_soup_cellsignal"><a href="soup_cellsignallist.php">soup cellsignal (Updated hourly)</a></li>
<li id="mmi_soup_device_table"><a href="soup_device_tablelist.php">soup device table (Updated hourly)</a></li>
<li id="mmi_soup_device_stats_table"><a href="soup_device_stats_tablelist.php">soup device stats table (Updated hourly)</a></li>
<li id="mmi_soup_alerts_table"><a href="soup_alerts_tablelist.php">soup alerts table (Updated hourly)</a></li>
<li id="mmi_soup_config_info"><a href="soup_config_infolist.php">soup config info</a></li>
<li id="mmi_config"><a href="configlist.php">config</a></li>
</ul>
</li>
<li id="mmci_PortalDB" class="dropdown"><a class="ewDropdown" href="#">PortalDB<span class="icon-arrow-down"></span></a><ul class="dropdown-menu" role="menu">
<li id="mmi_rma_reason"><a href="rma_reasonlist.php">rma reason</a></li>
<li id="mmi_agreement_message"><a href="agreement_messagelist.php">agreement message</a></li>
<li id="mmi_reason"><a href="reasonlist.php">reason (Cancellation reason)</a></li>
<li id="mmi_date_invoice_detail"><a href="date_invoice_detaillist.php">date invoice detail</a></li>
<li id="mmi_date_invoice"><a href="date_invoicelist.php">date invoice</a></li>
<li id="mmi_cancel_reason"><a href="cancel_reasonlist.php">cancel reason</a></li>
<li id="mmi_rma_form"><a href="rma_formlist.php">rma form</a></li>
<li id="mmi_sc_log_vw"><a href="sc_log_vwlist.php">sc log vw</a></li>
</ul>
</li>
<li id="mmi_changepwd"><a href="changepwd.php">Change Password</a></li>
<li id="mmi_logout"><a href="logout.php">Logout</a></li>
</ul>
<ul class="nav navbar-nav navbar-right"></ul><!-- End Main Menu -->
                </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
</nav>
        <!-- header (end) -->
        <div id="ewMenuRow" class="hidden-xs">
                <div class="ewMenu">
<!-- Begin Main Menu -->
<div class="navbar navbar-default"><ul id="ewHorizMenu" class="nav navbar-nav">
<li id="mi_quick_search_php"><a href="quick_search.php">Quick Search</a></li>
<li id="mi_search_sessions_php"><a href="search_sessions.php">Search Sessions</a></li>
<li id="mci_Device_Operation" class="dropdown"><a href="#">Device Operation <b class="caret"></b></a><ul class="dropdown-menu" role="menu">
<li id="mi_cancel_device_php" class="active"><a href="javascript:void(0);">Cancel Device</a></li>
<li id="mi_cancel_device_only_in_oss_php"><a href="cancel_device_only_in_oss.php">Cancel Device only in OSS</a></li>
<li id="mi_suspend_device_php"><a href="suspend_device.php">Suspend Device</a></li>
<li id="mi_restore_device_php"><a href="restore_device.php">Restore Device</a></li>
</ul>
</li>
<li id="mci_OSS" class="dropdown"><a href="#">OSS <b class="caret"></b></a><ul class="dropdown-menu" role="menu">
<li id="mi_active_lines_vw"><a href="active_lines_vwlist.php">active lines vw</a></li>
<li id="mi_oss_line_summary_vw"><a href="oss_line_summary_vwlist.php">oss line summary vw</a></li>
<li id="mi_billing_entity"><a href="billing_entitylist.php?cmd=resetall">billing entity</a></li>
<li id="mi_unique_identifier"><a href="unique_identifierlist.php">unique identifier</a></li>
<li id="mi_equipment_model"><a href="equipment_modellist.php">equipment model</a></li>
<li id="mi_static_ips_vw"><a href="static_ips_vwlist.php">static ips vw</a></li>
<li id="mi_product"><a href="productlist.php">product</a></li>
<li id="mi_number_of_active_per_carrier_vw"><a href="number_of_active_per_carrier_vwlist.php">number of active per carrier vw</a></li>
<li id="mi_denoss02_master_radacct_vw"><a href="denoss02_master_radacct_vwlist.php">denoss 02 master radacct vw</a></li>
<li id="mi_usccsprint_radcheck"><a href="usccsprint_radchecklist.php">usccsprint radcheck</a></li>
<li id="mi_equipment_model_status"><a href="equipment_model_statuslist.php">equipment model status</a></li>
<li id="mi_equipment"><a href="equipmentlist.php">equipment</a></li>
<li id="mi_username_change_php"><a href="username_change.php">username_change</a></li>
<li id="mi_cancel_info_php"><a href="cancel_info.php">Cancel_Info</a></li>
<li id="mi_oss_jbill_plan_comparison_vw"><a href="oss_jbill_plan_comparison_vwlist.php">oss jbill plan comparison vw</a></li>
<li id="mi_change_static_ip_php"><a href="change_static_ip.php">Change Static IP Address</a></li>
<li id="mi_cancellation_report_vw"><a href="cancellation_report_vwlist.php">cancellation report vw</a></li>
<li id="mi_location_labels_vw"><a href="location_labels_vwlist.php">location labels vw</a></li>
<li id="mi_radius_username_change_log_vw"><a href="radius_username_change_log_vwlist.php">radius username change log vw</a></li>
<li id="mi_equipment_credential"><a href="equipment_credentiallist.php">equipment credential</a></li>
<li id="mi_groupname_default"><a href="groupname_defaultlist.php">groupname default</a></li>
<li id="mi_plan"><a href="planlist.php">plan</a></li>
<li id="mi_static_ip_pool"><a href="static_ip_poollist.php">static ip pool</a></li>
<li id="mi_device_monitor"><a href="device_monitorlist.php">device monitor</a></li>
<li id="mi_device_monitor_vw"><a href="device_monitor_vwlist.php">device monitor vw</a></li>
<li id="mi_equipment_warranty_rule"><a href="equipment_warranty_rulelist.php">equipment warranty rule</a></li>
<li id="mi_oss_jbill_billing_entity_mapping"><a href="oss_jbill_billing_entity_mappinglist.php">oss jbill billing entity mapping</a></li>
<li id="mi_firmware"><a href="firmwarelist.php">firmware</a></li>
<li id="mi_lookup_lines_by_dynamic_ip_php"><a href="lookup_lines_by_dynamic_ip.php">Lookup_lines_by_dynamic_IP</a></li>
<li id="mi_oss_active_line_config_revisions_vw"><a href="oss_active_line_config_revisions_vwlist.php">oss active line config revisions vw</a></li>
</ul>
</li>
<li id="mci_JBilling" class="dropdown"><a href="#">JBilling <b class="caret"></b></a><ul class="dropdown-menu" role="menu">
<li id="mi_jbill_shipping_cost_report_vw"><a href="jbill_shipping_cost_report_vwlist.php">jbill shipping cost report vw</a></li>
<li id="mi_jbill_tax_rates_per_customer"><a href="jbill_tax_rates_per_customerlist.php">jbill tax rates per customer</a></li>
<li id="mi_jbill_order_details_vw"><a href="jbill_order_details_vwlist.php">jbill order details vw</a></li>
<li id="mi_item"><a href="itemlist.php">item</a></li>
<li id="mi_jbill_customer_specific_pricing"><a href="jbill_customer_specific_pricinglist.php">jbill customer specific pricing</a></li>
<li id="mi_jbill_invoice_data"><a href="jbill_invoice_datalist.php">jbill invoice data</a></li>
<li id="mi_jbill_customer_user_list"><a href="jbill_customer_user_listlist.php">jbill customer user list</a></li>
<li id="mi_all_cancelled_lines_by_customer_vw"><a href="all_cancelled_lines_by_customer_vwlist.php">all cancelled lines by customer vw</a></li>
<li id="mi_jbill_pricing"><a href="jbill_pricinglist.php">jbill pricing</a></li>
<li id="mi_customer_external_ids_vw"><a href="customer_external_ids_vwlist.php">customer external ids vw</a></li>
<li id="mi_jbill_reactivation_list"><a href="jbill_reactivation_listlist.php">jbill reactivation list</a></li>
<li id="mi_subaccounts_and_parents_vw"><a href="subaccounts_and_parents_vwlist.php">subaccounts and parents vw</a></li>
<li id="mi_jbill_so_item_list"><a href="jbill_so_item_listlist.php">jbill so item list</a></li>
<li id="mi_order_line"><a href="order_linelist.php">order line</a></li>
<li id="mi_prov_line"><a href="prov_linelist.php">prov line</a></li>
<li id="mi_purchase_order"><a href="purchase_orderlist.php">purchase order</a></li>
<li id="mi_sales_tax"><a href="sales_taxlist.php">sales tax</a></li>
<li id="mi_telcom_tax"><a href="telcom_taxlist.php">telcom tax</a></li>
<li id="mi_jbill_location_vw"><a href="jbill_location_vwlist.php">jbill location vw</a></li>
<li id="mi_customer"><a href="customerlist.php">customer (Set external_id)</a></li>
</ul>
</li>
<li id="mci_RADIUS" class="dropdown"><a href="#">RADIUS <b class="caret"></b></a><ul class="dropdown-menu" role="menu">
<li id="mi_radreply"><a href="radreplylist.php">radreply</a></li>
<li id="mi_lns_lookup"><a href="lns_lookuplist.php">lns lookup</a></li>
<li id="mi_nas"><a href="naslist.php">nas</a></li>
<li id="mi_radcheck"><a href="radchecklist.php">radcheck</a></li>
<li id="mi_groupname"><a href="groupnamelist.php">groupname</a></li>
<li id="mi_radgroupcheck"><a href="radgroupchecklist.php?cmd=resetall">radgroupcheck</a></li>
<li id="mi_radgroupreply"><a href="radgroupreplylist.php?cmd=resetall">radgroupreply</a></li>
<li id="mi_radius_operator"><a href="radius_operatorlist.php">radius operator</a></li>
<li id="mi_username"><a href="usernamelist.php">username</a></li>
<li id="mi_usergroup"><a href="usergrouplist.php">usergroup</a></li>
</ul>
</li>
<li id="mci_OpenTaps" class="dropdown"><a href="#">OpenTaps <b class="caret"></b></a><ul class="dropdown-menu" role="menu">
<li id="mi_otaps_product_code_translation"><a href="otaps_product_code_translationlist.php">otaps product code translation</a></li>
<li id="mi_cct_shipping_cost_vw"><a href="cct_shipping_cost_vwlist.php">cct shipping cost vw</a></li>
<li id="mi_service_line_number"><a href="service_line_numberlist.php">service line number</a></li>
<li id="mi_service_line_detail"><a href="service_line_detaillist.php">service line detail</a></li>
</ul>
</li>
<li id="mci_SessionInfo" class="dropdown"><a href="#">SessionInfo <b class="caret"></b></a><ul class="dropdown-menu" role="menu">
<li id="mi_last_session_starttime_for_last6mo"><a href="last_session_starttime_for_last6molist.php">last session starttime for last 6mo</a></li>
<li id="mi_master_radacct_vw"><a href="master_radacct_vwlist.php">master radacct vw</a></li>
<li id="mi_session_history_last30days_vw"><a href="session_history_last30days_vwlist.php">session history last 30days vw</a></li>
<li id="mi_verizon_usage_last_one_month_vw"><a href="verizon_usage_last_one_month_vwlist.php">verizon usage last one month vw</a></li>
</ul>
</li>
<li id="mci_SOUP" class="dropdown"><a href="#">SOUP <b class="caret"></b></a><ul class="dropdown-menu" role="menu">
<li id="mi_soup_cellsignal"><a href="soup_cellsignallist.php">soup cellsignal (Updated hourly)</a></li>
<li id="mi_soup_device_table"><a href="soup_device_tablelist.php">soup device table (Updated hourly)</a></li>
<li id="mi_soup_device_stats_table"><a href="soup_device_stats_tablelist.php">soup device stats table (Updated hourly)</a></li>
<li id="mi_soup_alerts_table"><a href="soup_alerts_tablelist.php">soup alerts table (Updated hourly)</a></li>
<li id="mi_soup_config_info"><a href="soup_config_infolist.php">soup config info</a></li>
<li id="mi_config"><a href="configlist.php">config</a></li>
</ul>
</li>
<li id="mci_PortalDB" class="dropdown"><a href="#">PortalDB <b class="caret"></b></a><ul class="dropdown-menu" role="menu">
<li id="mi_rma_reason"><a href="rma_reasonlist.php">rma reason</a></li>
<li id="mi_agreement_message"><a href="agreement_messagelist.php">agreement message</a></li>
<li id="mi_reason"><a href="reasonlist.php">reason (Cancellation reason)</a></li>
<li id="mi_date_invoice_detail"><a href="date_invoice_detaillist.php">date invoice detail</a></li>
<li id="mi_date_invoice"><a href="date_invoicelist.php">date invoice</a></li>
<li id="mi_cancel_reason"><a href="cancel_reasonlist.php">cancel reason</a></li>
<li id="mi_rma_form"><a href="rma_formlist.php">rma form</a></li>
<li id="mi_sc_log_vw"><a href="sc_log_vwlist.php">sc log vw</a></li>
</ul>
</li>
<li id="mi_changepwd"><a href="changepwd.php">Change Password</a></li>
<li id="mi_logout"><a href="logout.php">Logout</a></li>
</ul>
<ul class="nav navbar-nav navbar-right"></ul></div><!-- End Main Menu -->
                </div>
        </div>
        <!-- content (begin) -->
        <div id="ewContentTable" class="ewContentTable">
                <div id="ewContentRow">
                        <div id="ewContentColumn" class="ewContentColumn">
                                <!-- right column (begin) -->
                                <h4 class="hidden-xs ewSiteTitle">OSS</h4>
<div class="ewToolbar">
<ul class="breadcrumb ewBreadcrumbs"><li id="ewBreadcrumb1"><a href="index.php" title="Home" class="ewHome"><span data-phrase="HomePage" class="glyphicon glyphicon-home ewIcon" data-caption="Home"></span></a></li><li id="ewBreadcrumb2" class="active"><span id="ewPageCaption">Cancel Device</span></li></ul><div class="clearfix"></div>
</div>
<form action="/OSS/cancel_device.php" method="post">
<div>
ESN HEX : <input type="text" name="esn_hex" value="" placeholder="ESN HEX here." pattern="^[0-9A-Z]+$" autofocus required>
<input type="hidden" name="token" value="Zt0b8OgcIF_B83IOjfz41g.."><br/>
<input type="submit" name="cancel" value="Review">
<br/>
<br/>
<p>Note) This feature cancels a device in OSS and JBilling.</p>
</div>
</form>

<hr/>


                                <!-- right column (end) -->
                                                        </div>
                </div>
        </div>
        <!-- content (end) -->
        <!-- footer (begin) --><!-- ** Note: Only licensed users are allowed to remove or change the following copyright statement. ** -->
        <div id="ewFooterRow" class="ewFooterRow">        
                <div class="ewFooterText">&copy;2016 CCT Inc, All rights reserved.</div>
                <!-- Place other links, for example, disclaimer, here -->                
        </div>
        <!-- footer (end) -->        
</div>
<!-- modal dialog -->
<div id="ewModalDialog" class="modal" role="dialog" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title"></h4></div><div class="modal-body"></div><div class="modal-footer"></div></div></div></div>
<!-- message box -->
<div id="ewMsgBox" class="modal" role="dialog" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-body"></div><div class="modal-footer"><button type="button" class="btn btn-primary ewButton" data-dismiss="modal">OK</button></div></div></div></div>
<!-- prompt -->
<div id="ewPrompt" class="modal" role="dialog" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-body"></div><div class="modal-footer"><button type="button" class="btn btn-primary ewButton">OK</button><button type="button" class="btn btn-default ewButton" data-dismiss="modal">Cancel</button></div></div></div></div>
<!-- session timer -->
<div id="ewTimer" class="modal" role="dialog" aria-hidden="true"><div class="modal-dialog"><div class="modal-content"><div class="modal-body"></div><div class="modal-footer"><button type="button" class="btn btn-primary ewButton" data-dismiss="modal">OK</button></div></div></div></div>
<!-- tooltip -->
<div id="ewTooltip"></div>
<script type="text/javascript">
jQuery.get("phpjs/userevt13.js");
</script>
<script type="text/javascript">

// Write your global startup script here
// document.write("page loaded");

</script>
</body>
</html>