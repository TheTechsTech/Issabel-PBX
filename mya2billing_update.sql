USE mya2billing;

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


ALTER TABLE cc_callback_spool CHANGE variable variable VARCHAR( 300 ) DEFAULT NULL;

-- fix various uses of ISO-3166-1 alpha-2 rather than alpha-3
UPDATE cc_country SET countrycode='BVT' WHERE countrycode='BV';
UPDATE cc_country SET countrycode='IOT' WHERE countrycode='IO';
UPDATE cc_country SET countrycode='HMD' WHERE countrycode='HM';
UPDATE cc_country SET countrycode='PCN' WHERE countrycode='PN';
UPDATE cc_country SET countrycode='SGS' WHERE countrycode='GS';
UPDATE cc_country SET countrycode='SJM' WHERE countrycode='SJ';
UPDATE cc_country SET countrycode='TLS' WHERE countrycode='TL';
UPDATE cc_country SET countrycode='UMI' WHERE countrycode='UM';
UPDATE cc_country SET countrycode='ESH' WHERE countrycode='EH';

-- integrate changes from ISO-3166-1 newsletters V-1 to V-12
UPDATE cc_country SET countryname='Lao People''s Democratic Republic' WHERE countrycode='LAO';
UPDATE cc_country SET countryname='Timor-Leste', countryprefix='670' WHERE countrycode='TLS';
UPDATE cc_country SET countryprefix='0' WHERE countrycode='TMP';

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


-- Never too late to add some indexes :D

ALTER TABLE cc_call ADD INDEX ( username );
ALTER TABLE cc_call ADD INDEX ( starttime );
ALTER TABLE cc_call ADD INDEX ( terminatecause );
ALTER TABLE cc_call ADD INDEX ( calledstation );


ALTER TABLE cc_card ADD INDEX ( creationdate );
ALTER TABLE cc_card ADD INDEX ( username );



OPTIMIZE TABLE cc_card;
OPTIMIZE TABLE cc_call;

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/

--
-- A2Billing database script - Update database for MYSQL 5.X
-- 
-- 
-- Usage:
-- mysql -u root -p"root password" < UPDATE-a2billing-v1.3.0-to-v1.4.0.sql
--




CREATE TABLE cc_invoice_items (
	id bigint(20) NOT NULL auto_increment,
	invoiceid int(11) NOT NULL,
	invoicesection text,
	designation text,
	sub_designation text,
	start_date date default NULL,
	end_date date default NULL,
	bill_date date default NULL,
	calltime int(11) default NULL,
	nbcalls int(11) default NULL,
	quantity int(11) default NULL,
	price decimal(15,5) default NULL,
	buy_price decimal(15,5) default NULL,
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE cc_invoice (
	id int(11) NOT NULL auto_increment,
	cardid bigint(20) NOT NULL,
	invoicecreated_date timestamp NOT NULL default CURRENT_TIMESTAMP,
	amount decimal(15,5) default '0.00000',
	tax decimal(15,5) default '0.00000',
	total decimal(15,5) default '0.00000',
	filename varchar(250) collate utf8_bin default NULL,
	payment_status int(11) default '0',
	cover_call_startdate timestamp NOT NULL default '0000-00-00 00:00:00',
	cover_call_enddate timestamp NOT NULL default '0000-00-00 00:00:00',
	cover_charge_startdate timestamp NOT NULL default '0000-00-00 00:00:00',
	cover_charge_enddate timestamp NOT NULL default '0000-00-00 00:00:00',
	currency varchar(3) collate utf8_bin default NULL,
	previous_balance decimal(15,5) default NULL,
	current_balance decimal(15,5) default NULL,
	templatefile varchar(250) collate utf8_bin default NULL,
	username char(50) collate utf8_bin default NULL,
	lastname char(50) collate utf8_bin default NULL,
	firstname char(50) collate utf8_bin default NULL,
	address char(100) collate utf8_bin default NULL,
	city char(40) collate utf8_bin default NULL,
	state char(40) collate utf8_bin default NULL,
	country char(40) collate utf8_bin default NULL,
	zipcode char(20) collate utf8_bin default NULL,
	phone char(20) collate utf8_bin default NULL,
	email char(70) collate utf8_bin default NULL,
	fax char(20) collate utf8_bin default NULL,
	vat float default NULL,
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_charge DROP COLUMN id_cc_subscription_fee;

ALTER TABLE cc_charge ADD COLUMN id_cc_card_subscription BIGINT;
ALTER TABLE cc_charge ADD COLUMN cover_from DATE;
ALTER TABLE cc_charge ADD COLUMN cover_to 	DATE;

ALTER TABLE cc_trunk ADD COLUMN inuse INT DEFAULT 0;
ALTER TABLE cc_trunk ADD COLUMN maxuse INT DEFAULT -1;
ALTER TABLE cc_trunk ADD COLUMN status INT DEFAULT 1;
ALTER TABLE cc_trunk ADD COLUMN if_max_use INT DEFAULT 0;


CREATE TABLE cc_card_subscription (
	id BIGINT NOT NULL AUTO_INCREMENT,
	id_cc_card BIGINT ,
	id_subscription_fee INT,
	startdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	stopdate TIMESTAMP,
	product_id VARCHAR( 100 ),
	product_name VARCHAR( 100 ),
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE cc_card DROP id_subscription_fee;
ALTER TABLE cc_card ADD COLUMN id_timezone INT DEFAULT 0;


CREATE TABLE cc_config_group (
	id 								INT NOT NULL auto_increment,
	group_title 					VARCHAR(64) NOT NULL,
	group_description 				VARCHAR(255) NOT NULL,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_config_group (group_title, group_description) VALUES ('global', 'This configuration group handles the global settings for application.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('callback', 'This configuration group handles calllback settings.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('webcustomerui', 'This configuration group handles Web Customer User Interface.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('sip-iax-info', 'SIP & IAX client configuration information.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('epayment_method', 'Epayment Methods Configuration.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('signup', 'This configuration group handles the signup related settings.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('backup', 'This configuration group handles the backup/restore related settings.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('webui', 'This configuration group handles the WEBUI and API Configuration.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('peer_friend', 'This configuration group define parameters for the friends creation.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('log-files', 'This configuration group handles the Log Files Directory Paths.');
INSERT INTO cc_config_group (group_title, group_description) VALUES ('agi-conf1', 'This configuration group handles the AGI Configuration.');



CREATE TABLE cc_config (
	id 								INT NOT NULL auto_increment,
	config_title		 			VARCHAR( 100 )  NOT NULL,
	config_key 						VARCHAR( 100 )  NOT NULL,
	config_value 					VARCHAR( 100 )  NOT NULL,
	config_description 				TEXT NOT NULL,
	config_valuetype				INT NOT NULL DEFAULT 0,
	config_group_id 				INT NOT NULL,
	config_listvalues				VARCHAR( 100 ) ,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Card Number length', 'interval_len_cardnumber', '10-15', 'Card Number length, You can define a Range e.g: 10-15.', 0, 1, '10-15,5-20,10-30');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Card Alias length', 'len_aliasnumber', '15', 'Card Number Alias Length e.g: 15.', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Voucher length', 'len_voucher', '15', 'Voucher Number Length.', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Base Currency', 'base_currency', 'usd', 'Base Currency to use for application.', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Invoice Image', 'invoice_image', 'asterisk01.jpg', 'Image to Display on the Top of Invoice', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Admin Email', 'admin_email', 'root@localhost', 'Web Administrator Email Address.', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('DID Bill Payment Day', 'didbilling_daytopay', '5', 'DID Bill Payment Day of Month', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Manager Host', 'manager_host', 'localhost', 'Manager Host Address', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Manager User ID', 'manager_username', 'myasterisk', 'Manger Host User Name', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Manager Password', 'manager_secret', 'mycode', 'Manager Host Password', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Use SMTP Server', 'smtp_server', '0', 'Define if you want to use an STMP server or Send Mail (value yes for server SMTP)', 1, 1, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SMTP Host', 'smtp_host', 'localhost', 'SMTP Hostname', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SMTP UserName', 'smtp_username', '', 'User Name to connect on the SMTP server', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SMTP Password', 'smtp_password', '', 'Password to connect on the SMTP server', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Use Realtime', 'use_realtime', '1', 'if Disabled, it will generate the config files and offer an option to reload asterisk after an update on the Voip settings', 1, 1, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Go To Customer', 'customer_ui_url', '../../customer/index.php', 'Link to the customer account', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Context Callback', 'context_callback', 'a2billing-callback', 'Contaxt to use in Callback', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Extension', 'extension', '1000', 'Extension to call while callback.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Wait before callback', 'sec_wait_before_callback', '10', 'Seconds to wait before callback.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Avoid Repeat Duration', 'sec_avoid_repeate', '10', 'Number of seconds before the call-back can be re-initiated from the web page to prevent repeated and unwanted calls.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Time out', 'timeout', '20', 'if the callback doesnt succeed within the value below, then the call is deemed to have failed.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Answer on Call', 'answer_call', '1', 'if we want to manage the answer on the call. Disabling this for callback trigger numbers makes it ring not hang up.', 1, 2, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('No of Predictive Calls', 'nb_predictive_call', '10', 'number of calls an agent will do when the call button is clicked.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Delay for Availability', 'nb_day_wait_before_retry', '1', 'Number of days to wait before the number becomes available to call again.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('PD Contect', 'context_preditctivedialer', 'a2billing-predictivedialer', 'The context to redirect the call for the predictive dialer.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Max Time to call', 'predictivedialer_maxtime_tocall', '5400', 'When a call is made we need to limit the call duration : amount in seconds.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('PD Caller ID', 'callerid', '123456', 'Set the callerID for the predictive dialer and call-back.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Callback CallPlan ID', 'all_callback_tariff', '1', 'ID Call Plan to use when you use the all-callback mode, check the ID in the "list Call Plan" - WebUI.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Server Group ID', 'id_server_group', '1', 'Define the group of servers that are going to be used by the callback.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Audio Intro', 'callback_audio_intro', 'prepaid-callback_intro', 'Audio intro message when the callback is initiate.', 0, 2, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Signup URL', 'signup_page_url', '', 'url of the signup page to show up on the sign in page (if empty no link will show up).', 0, 3, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Payment Method', 'paymentmethod', 1, 'Enable or disable the payment methods; yes for multi-payment or no for single payment method option.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Personal Info', 'personalinfo', 1, 'Enable or disable the page which allow customer to modify its personal information.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Payment Info', 'customerinfo', 1, 'Enable display of the payment interface - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SIP/IAX Info', 'sipiaxinfo', 1, 'Enable display of the sip/iax info - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('CDR', 'cdr', 1, 'Enable the Call history - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Invoices', 'invoice', 1, 'Enable invoices - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Voucher Screen', 'voucher', 1, 'Enable the voucher screen - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Paypal', 'paypal', 1, 'Enable the paypal payment buttons - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Speed Dial', 'speeddial', 1, 'Allow Speed Dial capabilities - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('DID', 'did', 1, 'Enable the DID (Direct Inwards Dialling) interface - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('RateCard', 'ratecard', 1, 'Show the ratecards - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Simulator', 'simulator', 1, 'Offer simulator option on the customer interface - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('CallBack', 'callback', 1, 'Enable the callback option on the customer interface - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Predictive Dialer', 'predictivedialer', 1, 'Enable the predictivedialer option on the customer interface - yes or no.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('WebPhone', 'webphone', 1, 'Let users use SIP/IAX Webphone (Options : yes/no).', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('WebPhone Server', 'webphoneserver', 'localhost', 'IP address or domain name of asterisk server that would be used by the web-phone.', 0, 3, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Caller ID', 'callerid', 1, 'Let the users add new callerid.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Password', 'password', 1, 'Let the user change the webui password.', 1, 3, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('CallerID Limit', 'limit_callerid', '5', 'The total number of callerIDs for CLI Recognition that can be add by the customer.', 0, 3, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Trunk Name', 'sip_iax_info_trunkname', 'mytrunkname', 'Trunk Name to show in sip/iax info.', 0, 4, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Codecs Allowed', 'sip_iax_info_allowcodec', 'g729', 'Allowed Codec, ulaw, gsm, g729.', 0, 4, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Host', 'sip_iax_info_host', 'mydomainname.com', 'Host information.', 0, 4, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('IAX Parms', 'iax_additional_parameters', 'canreinvite = no', 'IAX Additional Parameters.', 0, 4, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SIP Parms', 'sip_additional_parameters', 'trustrpid = yes | sendrpid = yes | canreinvite = no', 'SIP Additional Parameters.', 0, 4, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Enable', 'enable', 1, 'Enable/Disable.', 1, 5, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('HTTP Server Customer', 'http_server', 'http://www.mydomainname.com', 'Set the Server Address of Customer Website, It should be empty for productive Servers.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('HTTPS Server Customer', 'https_server', 'https://www.mydomainname.com', 'https://localhost - Enter here your Secure Customers Server Address, should not be empty for productive servers.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Server Customer IP/Domain', 'http_cookie_domain', '26.63.165.200', 'Enter your Domain Name or IP Address for the Customers application, eg, 26.63.165.200.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Secure Server Customer IP/Domain', 'https_cookie_domain', '26.63.165.200', 'Enter your Secure server Domain Name or IP Address for the Customers application, eg, 26.63.165.200.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Application Customer Path', 'http_cookie_path', '/customer/', 'Enter the Physical path of your Customers Application on your server.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Secure Application Customer Path', 'https_cookie_path', '/customer/', 'Enter the Physical path of your Customers Application on your Secure Server.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Application Customer Physical Path', 'dir_ws_http_catalog', '/customer/', 'Enter the Physical path of your Customers Application on your server.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Secure Application Customer Physical Path', 'dir_ws_https_catalog', '/customer/', 'Enter the Physical path of your Customers Application on your Secure server.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Enable SSL', 'enable_ssl', 1, 'secure webserver for checkout procedure?', 1, 5, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('HTTP Domain', 'http_domain', '26.63.165.200', 'Http Address.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Directory Path', 'dir_ws_http', '/customer/', 'Directory Path.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Payment Amount', 'purchase_amount', '1:2:5:10:20', 'define the different amount of purchase that would be available - 5 amount maximum (5:10:15).', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Item Name', 'item_name', 'Credit Purchase', 'Item name that would be display to the user when he will buy credit.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Currency Code', 'currency_code', 'USD', 'Currency for the Credit purchase, only one can be define here.', 0, 5, NULL);
-- https://www.sandbox.paypal.com/cgi-bin/webscr
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Paypal Payment URL', 'paypal_payment_url', 'https://secure.paypal.com/cgi-bin/webscr', 'Define here the URL of paypal gateway the payment (to test with paypal sandbox).', 0, 5, NULL);
-- www.sandbox.paypal.com
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Paypal Verify URL', 'paypal_verify_url', 'ssl://www.paypal.com', 'paypal transaction verification url.', 0, 5, NULL);
-- https://test.authorize.net/gateway/transact.dll
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Authorize.NET Payment URL', 'authorize_payment_url', 'https://secure.authorize.net/gateway/transact.dll', 'Define here the URL of Authorize gateway.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('PayPal Store Name', 'store_name', 'Asterisk2Billing', 'paypal store name to show in the paypal site when customer will go to pay.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Transaction Key', 'transaction_key', 'asdf1212fasd121554sd4f5s45sdf', 'Transaction Key for security of Epayment Max length of 60 Characters.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Secret Word', 'moneybookers_secretword', '', 'Moneybookers secret word.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Enable', 'enable_signup', 1, 'Enable Signup Module.', 1, 6, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Captcha Security', 'enable_captcha', 1, 'enable Captcha on the signup module (value : YES or NO).', 1, 6, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Credit', 'credit', '0', 'amount of credit applied to a new user.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('CallPlan ID List', 'callplan_id_list', '1,2', 'the list of id of call plans which will be shown in signup.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Card Activation', 'activated', '0', 'Specify whether the card is created as Active or New.', 1, 6, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Access Type', 'simultaccess', '0', 'Simultaneous or non concurrent access with the card - 0 = INDIVIDUAL ACCESS or 1 = SIMULTANEOUS ACCESS.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Paid Type', 'typepaid', '0', 'PREPAID CARD  =  0 - POSTPAY CARD  =  1.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Credit Limit', 'creditlimit', '0', 'Define credit limit, which is only used for a POSTPAY card.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Run Service', 'runservice', '0', 'Authorise the recurring service to apply on this card  -  Yes 1 - No 0.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Enable Expire', 'enableexpire', '0', 'Enable the expiry of the card  -  Yes 1 - No 0.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Date Format', 'expirationdate', '', 'Expiry Date format YYYY-MM-DD HH:MM:SS. For instance 2004-12-31 00:00:00', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Expire Limit', 'expiredays', '0', 'The number of days after which the card will expire.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Create SIP', 'sip_account', 1, 'Create a sip account from signup ( default : yes ).', 1, 6, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Create IAX', 'iax_account', 1, 'Create an iax account from signup ( default : yes ).', 1, 6, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Activate Card', 'activatedbyuser', 0, 'active card after the new signup. if No, the Signup confirmation is needed and an email will be sent to the user with a link for activation (need to put the link into the Signup mail template).', 1, 6, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Customer Interface URL', 'urlcustomerinterface', 'http://localhost/customer/', 'url of the customer interface to display after activation.', 0, 6, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Asterisk Reload', 'reload_asterisk_if_sipiax_created', '0', 'Define if you want to reload Asterisk when a SIP / IAX Friend is created at signup time.', 1, 6, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Backup Path', 'backup_path', '/tmp', 'Path to store backup of database.', 0, 7, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('GZIP Path', 'gzip_exe', '/bin/gzip', 'Path for gzip.', 0, 7, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('GunZip Path', 'gunzip_exe', '/bin/gunzip', 'Path for gunzip .', 0, 7, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('MySql Dump Path', 'mysqldump', '/usr/bin/mysqldump', 'path for mysqldump.', 0, 7, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('PGSql Dump Path', 'pg_dump', '/usr/bin/pg_dump', 'path for pg_dump.', 0, 7, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('MySql Path', 'mysql', '/usr/bin/mysql', 'Path for MySql.', 0, 7, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('PSql Path', 'psql', '/usr/bin/psql', 'Path for PSql.', 0, 7, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SIP File Path', 'buddy_sip_file', '/etc/asterisk/additional_a2billing_sip.conf', 'Path to store the asterisk configuration files SIP.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('IAX File Path', 'buddy_iax_file', '/etc/asterisk/additional_a2billing_iax.conf', 'Path to store the asterisk configuration files IAX.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('API Security Key', 'api_security_key', 'Ae87v56zzl34v', 'API have a security key to validate the http request, the key has to be sent after applying md5, Valid characters are [a-z,A-Z,0-9].', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Authorized IP', 'api_ip_auth', '127.0.0.1', 'API to restrict the IPs authorised to make a request, Define The the list of ips separated by '';''.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Admin Email', 'email_admin', 'root@localhost', 'Administative Email.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('MOH Directory', 'dir_store_mohmp3', '/var/lib/asterisk/mohmp3', 'MOH (Music on Hold) base directory.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('MOH Classes', 'num_musiconhold_class', '10', 'Number of MOH classes you have created in musiconhold.conf : acc_1, acc_2... acc_10 class	etc....', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Display Help', 'show_help', 1, 'Display the help section inside the admin interface  (YES - NO).', 1, 8, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Max File Upload Size', 'my_max_file_size_import', '1024000', 'File Upload parameters, PLEASE CHECK ALSO THE VALUE IN YOUR PHP.INI THE LIMIT IS 2MG BY DEFAULT .', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Audio Directory Path', 'dir_store_audio', '/var/lib/asterisk/sounds/a2billing', 'Not used yet, The goal is to upload files and use them in the IVR.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Max Audio File Size', 'my_max_file_size_audio', '3072000', 'upload maximum file size.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Extensions Allowed', 'file_ext_allow', 'gsm, mp3, wav', 'File type extensions permitted to be uploaded such as "gsm, mp3, wav" (separated by ,).', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Muzic Files Allowed', 'file_ext_allow_musiconhold', 'mp3', 'File type extensions permitted to be uploaded for the musiconhold such as "gsm, mp3, wav" (separate by ,).', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Link Audio', 'link_audio_file', '0', 'Enable link on the CDR viewer to the recordings. (YES - NO).', 1, 8, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Monitor Path', 'monitor_path', '/var/spool/asterisk/monitor', 'Path to link the recorded monitor files.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Monitor Format', 'monitor_formatfile', 'gsm', 'FORMAT OF THE RECORDED MONITOR FILE.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Invoice Icon', 'show_icon_invoice', 1, 'Display the icon in the invoice.', 1, 8, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Show Top Frame', 'show_top_frame', '0', 'Display the top frame (useful if you want to save space on your little tiny screen ) .', 1, 8, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Currency', 'currency_choose', 'usd, eur, cad, hkd', 'Allow the customer to chose the most appropriate currency ("all" can be used).', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Card Export Fields', 'card_export_field_list', 'cc_card.id, username, useralias, lastname, credit, tariff, activated, language, inuse, currency, sip_buddy, iax_buddy, nbused, mac_addr', 'Fields to export in csv format from cc_card table.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Vouvher Export Fields', 'voucher_export_field_list', 'voucher, credit, tag, activated, usedcardnumber, usedate, currency', 'Field to export in csv format from cc_voucher table.', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Advance Mode', 'advanced_mode', '0', 'Advanced mode - Display additional configuration options on the ratecard (progressive rates, musiconhold, ...).', 1, 8, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SIP/IAX Delete', 'delete_fk_card', 1, 'Delete the SIP/IAX Friend & callerid when a card is deleted.', 1, 8, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Type', 'type', 'friend', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.', 0, 9, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Allow', 'allow', 'ulaw,alaw,gsm,g729', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.', 0, 9, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Context', 'context', 'a2billing', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.', 0, 9, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Nat', 'nat', 'yes', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.', 0, 9, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('AMA Flag', 'amaflag', 'billing', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.', 0, 9, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Qualify', 'qualify', 'yes', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.', 0, 9, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Host', 'host', 'dynamic', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.', 0, 9, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('DTMF Mode', 'dtmfmode', 'RFC2833', 'Refer to sip.conf & iax.conf documentation for the meaning of those parameters.', 0, 9, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Alarm Log File', 'cront_alarm', '/var/log/a2billing/cront_a2b_alarm.log', 'To disable application logging, remove/comment the log file name aside service.', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto refill Log File', 'cront_autorefill', '/var/log/a2billing/cront_a2b_autorefill.log', 'To disable application logging, remove/comment the log file name aside service.', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Bactch Process Log File', 'cront_batch_process', '/var/log/a2billing/cront_a2b_batch_process.log', 'To disable application logging, remove/comment the log file name aside service .', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Archive Log File', 'cront_archive_data', '/var/log/a2billing/cront_a2b_archive_data.log', 'To disable application logging, remove/comment the log file name aside service .', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('DID Billing Log File', 'cront_bill_diduse', '/var/log/a2billing/cront_a2b_bill_diduse.log', 'To disable application logging, remove/comment the log file name aside service .', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Subscription Fee Log File', 'cront_subscriptionfee', '/var/log/a2billing/cront_a2b_subscription_fee.log', 'To disable application logging, remove/comment the log file name aside service.', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Currency Cront Log File', 'cront_currency_update', '/var/log/a2billing/cront_a2b_currency_update.log', 'To disable application logging, remove/comment the log file name aside service.', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Invoice Cront Log File', 'cront_invoice', '/var/log/a2billing/cront_a2b_invoice.log', 'To disable application logging, remove/comment the log file name aside service.', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Cornt Log File', 'cront_check_account', '/var/log/a2billing/cront_a2b_check_account.log', 'To disable application logging, remove/comment the log file name aside service .', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Paypal Log File', 'paypal', '/var/log/a2billing/a2billing_paypal.log', 'paypal log file, to log all the transaction & error.', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('EPayment Log File', 'epayment', '/var/log/a2billing/a2billing_epayment.log', 'epayment log file, to log all the transaction & error .', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('ECommerce Log File', 'api_ecommerce', '/var/log/a2billing/a2billing_api_ecommerce_request.log', 'Log file to store the ecommerce API requests .', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Callback Log File', 'api_callback', '/var/log/a2billing/a2billing_api_callback_request.log', 'Log file to store the CallBack API requests.', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Webservice Card Log File', 'api_card', '/var/log/a2billing/a2billing_api_card.log', 'Log file to store the Card Webservice Logs', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('AGI Log File', 'agi', '/var/log/a2billing/a2billing_agi.log', 'File to log.', 0, 10, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Description', 'description', 'agi-config', 'Description/notes field', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Asterisk Version', 'asterisk_version', '1_4', 'Asterisk Version Information, 1_1,1_2,1_4 By Default it will take 1_2 or higher .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Answer Call', 'answer_call', 1, 'Manage the answer on the call. Disabling this for callback trigger numbers makes it ring not hang up.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Play Audio', 'play_audio', 1, 'Play audio - this will disable all stream file but not the Get Data , for wholesale ensure that the authentication works and than number_try = 1.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Say GoodBye', 'say_goodbye', '0', 'play the goodbye message when the user has finished.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Play Language Menu', 'play_menulanguage', '0', 'enable the menu to choose the language, press 1 for English, pulsa 2 para el español, Pressez 3 pour Français', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Force Language', 'force_language', '', 'force the use of a language, if you dont want to use it leave the option empty, Values : ES, EN, FR, etc... (according to the audio you have installed).', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Intro Prompt', 'intro_prompt', '', 'Introduction prompt : to specify an additional prompt to play at the beginning of the application .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Min Call Credit', 'min_credit_2call', '0', 'Minimum amount of credit to use the application .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Min Bill Duration', 'min_duration_2bill', '0', 'this is the minimum duration in seconds of a call in order to be billed any call with a length less than min_duration_2bill will have a 0 cost useful not to charge callers for system errors when a call was answered but it actually didn''t connect.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Not Enough Credit', 'notenoughcredit_cardnumber', 0, 'if user doesn''t have enough credit to call a destination, prompt him to enter another cardnumber .', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('New Caller ID', 'notenoughcredit_assign_newcardnumber_cid', 0, 'if notenoughcredit_cardnumber = YES  then	assign the CallerID to the new cardnumber.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Use DNID', 'use_dnid', '0', 'if YES it will use the DNID and try to dial out, without asking for the phonenumber to call.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Not Use DNID', 'no_auth_dnid', '2400,2300', 'list the dnid on which you want to avoid the use of the previous option "use_dnid" .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Try Count', 'number_try', '3', 'number of times the user can dial different number.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Force CallPlan', 'force_callplan_id', '', 'this will force to select a specific call plan by the Rate Engine.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Say Balance After Auth', 'say_balance_after_auth', 1, 'Play the balance to the user after the authentication (values : yes - no).', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Say Balance After Call', 'say_balance_after_call', '0', 'Play the balance to the user after the call (values : yes - no).', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Say Rate', 'say_rateinitial', '0', 'Play the initial cost of the route (values : yes - no)', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Say Duration', 'say_timetocall', 1, 'Play the amount of time that the user can call (values : yes - no).', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto Set CLID', 'auto_setcallerid', 1, 'enable the setup of the callerID number before the outbound is made, by default the user callerID value will be use.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Force CLID', 'force_callerid', '', 'If auto_setcallerid is enabled, the value of force_callerid will be set as CallerID.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('CLID Sanitize', 'cid_sanitize', '0', 'If force_callerid is not set, then the following option ensures that CID is set to one of the card''s configured caller IDs or blank if none available.(NO - disable this feature, caller ID can be anything, CID - Caller ID must be one of the customers caller IDs, DID - Caller ID must be one of the customers DID nos, BOTH - Caller ID must be one of the above two items)', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('CLID Enable', 'cid_enable', '0', 'enable the callerid authentication if this option is active the CC system will check the CID of caller  .', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Ask PIN', 'cid_askpincode_ifnot_callerid', 1, 'if the CID does not exist, then the caller will be prompt to enter his cardnumber .', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('FailOver LCR/LCD Prefix', 'failover_lc_prefix', 0, 'if we will failover for LCR/LCD prefix. For instance if you have 346 and 34 for if 346 fail it will try to outbound with 34 route.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto CLID', 'cid_auto_assign_card_to_cid', 1, 'if the callerID authentication is enable and the authentication fails then the user will be prompt to enter his cardnumber;this option will bound the cardnumber entered to the current callerID so that next call will be directly authenticate.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto Create Card', 'cid_auto_create_card', '0', 'if the callerID is captured on a2billing, this option will create automatically a new card and add the callerID to it.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto Create Card Length', 'cid_auto_create_card_len', '10', 'set the length of the card that will be auto create (ie, 10).', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto Create Card Type', 'cid_auto_create_card_typepaid', 'POSTPAY', 'billing type of the new card( value : POSTPAY or PREPAY) .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto Create Card Credit', 'cid_auto_create_card_credit', '0', 'amount of credit of the new card.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto Create Card Limit', 'cid_auto_create_card_credit_limit', '1000', 'if postpay, define the credit limit for the card.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto Create Card TariffGroup', 'cid_auto_create_card_tariffgroup', '6', 'the tariffgroup to use for the new card (this is the ID that you can find on the admin web interface) .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Auto CLID Security', 'callerid_authentication_over_cardnumber', '0', 'to check callerID over the cardnumber authentication (to guard against spoofing).', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SIP Call', 'sip_iax_friends', '0', 'enable the option to call sip/iax friend for free (values : YES - NO).', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SIP Call Prefix', 'sip_iax_pstn_direct_call_prefix', '555', 'if SIP_IAX_FRIENDS is active, you can define a prefix for the dialed digits to call a pstn number .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Direct Call', 'sip_iax_pstn_direct_call', '0', 'this will enable a prompt to enter your destination number. if number start by sip_iax_pstn_direct_call_prefix we do directly a sip iax call, if not we do a normal call.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('IVR Voucher Refill', 'ivr_voucher', '0', 'enable the option to refill card with voucher in IVR (values : YES - NO) .', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('IVR Voucher Prefix', 'ivr_voucher_prefix', '8', 'if ivr_voucher is active, you can define a prefix for the voucher number to refill your card, values : number - don''t forget to change prepaid-refill_card_with_voucher audio accordingly .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('IVR Low Credit', 'jump_voucher_if_min_credit', 0, 'When the user credit are below the minimum credit to call min_credit jump directly to the voucher IVR menu  (values: YES - NO) .', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Dail Command Parms', 'dialcommand_param', '|60|HRrL(%timeout%:61000:30000)', 'More information about the Dial : http://voip-info.org/wiki-Asterisk+cmd+dial<br>30 :  The timeout parameter is optional. If not specifed, the Dial command will wait indefinitely, exiting only when the originating channel hangs up, or all the dialed channels return a busy or error condition. Otherwise it specifies a maximum time, in seconds, that the Dial command is to wait for a channel to answer.<br>H: Allow the caller to hang up by dialing * <br>r: Generate a ringing tone for the calling party<br>R: Indicate ringing to the calling party when the called party indicates ringing, pass no audio until answered.<br>m: Provide Music on Hold to the calling party until the called channel answers.<br>L(x[:y][:z]): Limit the call to ''x'' ms, warning when ''y'' ms are left, repeated every ''z'' ms)<br>%timeout% tag is replaced by the calculated timeout according the credit & destination rate!.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('SIP/IAX Dial Command Parms', 'dialcommand_param_sipiax_friend', '|60|HL(3600000:61000:30000)', 'by default (3600000  =  1HOUR MAX CALL).', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Outbound Call', 'switchdialcommand', '0', 'Define the order to make the outbound call<br>YES -> SIP/dialedphonenumber@gateway_ip - NO  SIP/gateway_ip/dialedphonenumber<br>Both should work exactly the same but i experimented one case when gateway was supporting dialedphonenumber@gateway_ip, So in case of trouble, try it out.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Failover Retry Limit', 'failover_recursive_limit', '2', 'failover recursive search - define how many time we want to authorize the research of the failover trunk when a call fails (value : 0 - 20) .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Max Time', 'maxtime_tocall_negatif_free_route', '5400', 'This setting specifies an upper limit for the duration of a call to a destination for which the selling rate is less than or equal to 0.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Send Reminder', 'send_reminder', '0', 'Send a reminder email to the user when they are under min_credit_2call.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Record Call', 'record_call', '0', 'enable to monitor the call (to record all the conversations) value : YES - NO .', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Monitor File Format', 'monitor_formatfile', 'gsm', 'format of the recorded monitor file.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('AGI Force Currency', 'agi_force_currency', '', 'Force to play the balance to the caller in a predefined currency, to use the currency set for by the customer leave this field empty.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Currency Associated', 'currency_association', 'usd:dollars,mxn:pesos,eur:euros,all:credit', 'Define all the audio (without file extensions) that you want to play according to currency (use , to separate, ie "usd:prepaid-dollar,mxn:pesos,eur:Euro,all:credit").', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Minor Currency Associated', 'currency_association_minor', 'usd:prepaid-cents,eur:prepaid-cents,gbp:prepaid-pence,all:credit', 'Define all the audio (without file extensions) that you want to play according to minor currency (use , to separate, ie "usd:prepaid-cents,eur:prepaid-cents,gbp:prepaid-pence,all:credit").', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('File Enter Destination', 'file_conf_enter_destination', 'prepaid-enter-dest', 'Please enter the file name you want to play when we prompt the calling party to enter the destination number, file_conf_enter_destination = prepaid-enter-number-u-calling-1-or-011.', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('File Language Menu', 'file_conf_enter_menulang', 'prepaid-menulang2', 'Please enter the file name you want to play when we prompt the calling party to choose the prefered language .', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Bill Callback', 'callback_bill_1stleg_ifcall_notconnected', 1, 'Define if you want to bill the 1st leg on callback even if the call is not connected to the destination.', 1, 11, 'yes,no');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('International prefixes', 'international_prefixes', '011,00,09,1', 'List the prefixes you want stripped off if the call plan requires it', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Server GMT', 'server_GMT', 'GMT+1:00', 'Define the sever gmt time', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Invoice Template Path', 'invoice_template_path', '../invoice/', 'gives invoice template path from default one', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Outstanding Template Path', 'outstanding_template_path', '../outstanding/', 'gives outstanding template path from default one', 0, 1, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Sales Template Path', 'sales_template_path', '../sales/', 'gives sales template path from default one', 0, 1, NULL);




CREATE TABLE cc_timezone (
    id 								INT NOT NULL AUTO_INCREMENT,
    gmtzone							VARCHAR(255),
    gmttime		 					VARCHAR(255),
	gmtoffset						BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-12:00) International Date Line West', 'GMT-12:00', '-43200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-11:00) Midway Island, Samoa', 'GMT-11:00', '-39600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-10:00) Hawaii', 'GMT-10:00', '-36000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-09:00) Alaska', 'GMT-09:00', '-32400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-08:00) Pacific Time (US & Canada) Tijuana', 'GMT-08:00', '-28800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-07:00) Arizona', 'GMT-07:00', '-25200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-07:00) Chihuahua, La Paz, Mazatlan', 'GMT-07:00', '-25200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-07:00) Mountain Time(US & Canada)', 'GMT-07:00', '-25200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-06:00) Central America', 'GMT-06:00', '-21600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-06:00) Central Time (US & Canada)', 'GMT-06:00', '-21600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-06:00) Guadalajara, Mexico City, Monterrey', 'GMT-06:00', '-21600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-06:00) Saskatchewan', 'GMT-06:00', '-21600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-05:00) Bogota, Lima, Quito', 'GMT-05:00', '-18000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-05:00) Eastern Time (US & Canada)', 'GMT-05:00', '-18000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-05:00) Indiana (East)', 'GMT-05:00', '-18000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-04:00) Atlantic Time (Canada)', 'GMT-04:00', '-14400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-04:00) Caracas, La Paz', 'GMT-04:00', '-14400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-04:00) Santiago', 'GMT-04:00', '-14400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-03:30) NewFoundland', 'GMT-03:30', '-12600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-03:00) Brasillia', 'GMT-03:00', '-10800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-03:00) Buenos Aires, Georgetown', 'GMT-03:00', '-10800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-03:00) Greenland', 'GMT-03:00', '-10800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-03:00) Mid-Atlantic', 'GMT-03:00', '-10800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-01:00) Azores', 'GMT-01:00', '-3600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT-01:00) Cape Verd Is.', 'GMT-01:00', '-3600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT) Casablanca, Monrovia', 'GMT+00:00', '0');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon,  London', 'GMT', '0');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna', 'GMT+01:00', '3600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague', 'GMT+01:00', '3600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+01:00) Brussels, Copenhagen, Madrid, Paris', 'GMT+01:00', '3600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb', 'GMT+01:00', '3600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+01:00) West Central Africa', 'GMT+01:00', '3600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+02:00) Athens, Istanbul, Minsk', 'GMT+02:00', '7200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+02:00) Bucharest', 'GMT+02:00', '7200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+02:00) Cairo', 'GMT+02:00', '7200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+02:00) Harere, Pretoria', 'GMT+02:00', '7200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius', 'GMT+02:00', '7200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+02:00) Jeruasalem', 'GMT+02:00', '7200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+03:00) Baghdad', 'GMT+03:00', '10800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+03:00) Kuwait, Riyadh', 'GMT+03:00', '10800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+03:00) Moscow, St.Petersburg, Volgograd', 'GMT+03:00', '10800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+03:00) Nairobi', 'GMT+03:00', '10800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+03:30) Tehran', 'GMT+03:30', '12600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+04:00) Abu Dhabi, Muscat', 'GMT+04:00', '14400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+04:00) Baku, Tbillisi, Yerevan', 'GMT+04:00', '14400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+04:30) Kabul', 'GMT+04:30', '16200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+05:00) Ekaterinburg', 'GMT+05:00', '18000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+05:00) Islamabad, Karachi, Tashkent', 'GMT+05:00', '18000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi', 'GMT+05:30', '19800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+05:45) Kathmandu', 'GMT+05:45', '20700');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+06:00) Almaty, Novosibirsk', 'GMT+06:00', '21600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+06:00) Astana, Dhaka', 'GMT+06:00', '21600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+06:00) Sri Jayawardenepura', 'GMT+06:00', '21600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+06:30) Rangoon', 'GMT+06:30', '23400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+07:00) Bangkok, Hanoi, Jakarta', 'GMT+07:00', '25200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+07:00) Krasnoyarsk', 'GMT+07:00', '25200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+08:00) Beijiing, Chongging, Hong Kong, Urumqi', 'GMT+08:00', '28800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+08:00) Irkutsk, Ulaan Bataar', 'GMT+08:00', '28800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+08:00) Kuala Lumpur, Singapore', 'GMT+08:00', '28800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+08:00) Perth', 'GMT+08:00', '28800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+08:00) Taipei', 'GMT+08:00', '28800');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+09:00) Osaka, Sapporo, Tokyo', 'GMT+09:00', '32400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+09:00) Seoul', 'GMT+09:00', '32400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+09:00) Yakutsk', 'GMT+09:00', '32400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+09:00) Adelaide', 'GMT+09:00', '32400');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+09:30) Darwin', 'GMT+09:30', '34200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+10:00) Brisbane', 'GMT+10:00', '36000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+10:00) Canberra, Melbourne, Sydney', 'GMT+10:00', '36000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+10:00) Guam, Port Moresby', 'GMT+10:00', '36000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+10:00) Hobart', 'GMT+10:00', '36000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+10:00) Vladivostok', 'GMT+10:00', '36000');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+11:00) Magadan, Solomon Is., New Caledonia', 'GMT+11:00', '39600');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+12:00) Auckland, Wellington', 'GMT+1200', '43200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+12:00) Fiji, Kamchatka, Marshall Is.', 'GMT+12:00', '43200');
INSERT INTO cc_timezone (gmtzone, gmttime, gmtoffset) VALUES ('(GMT+13:00) Nuku alofa', 'GMT+13:00', '46800');


CREATE TABLE cc_iso639 (
    code character(2) NOT NULL,
    name character(16) NOT NULL,
    lname character(16),
    `charset` character(16) NOT NULL DEFAULT 'ISO-8859-1',
    CONSTRAINT iso639_name_key UNIQUE (name),
    CONSTRAINT iso639_pkey PRIMARY KEY (code)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ab', 'Abkhazian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('om', 'Afan (Oromo)    ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('aa', 'Afar            ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('af', 'Afrikaans       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sq', 'Albanian        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('am', 'Amharic         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ar', 'Arabic          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('hy', 'Armenian        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('as', 'Assamese        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ay', 'Aymara          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('az', 'Azerbaijani     ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ba', 'Bashkir         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('eu', 'Basque          ', 'Euskera         ', 'ISO-8859-15     ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('bn', 'Bengali Bangla  ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('dz', 'Bhutani         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('bh', 'Bihari          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('bi', 'Bislama         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('br', 'Breton          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('bg', 'Bulgarian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('my', 'Burmese         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('be', 'Byelorussian    ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('km', 'Cambodian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ca', 'Catalan         ', '          \t\t    ', 'ISO-8859-15     ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('zh', 'Chinese         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('co', 'Corsican        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('hr', 'Croatian        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('cs', 'Czech           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('da', 'Danish          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('nl', 'Dutch           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('en', 'English         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('eo', 'Esperanto       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('et', 'Estonian        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('fo', 'Faroese         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('fj', 'Fiji            ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('fi', 'Finnish         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('fr', 'French          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('fy', 'Frisian         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('gl', 'Galician        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ka', 'Georgian        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('de', 'German          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('el', 'Greek           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('kl', 'Greenlandic     ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('gn', 'Guarani         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('gu', 'Gujarati        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ha', 'Hausa           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('he', 'Hebrew          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('hi', 'Hindi           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('hu', 'Hungarian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('is', 'Icelandic       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('id', 'Indonesian      ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ia', 'Interlingua     ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ie', 'Interlingue     ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('iu', 'Inuktitut       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ik', 'Inupiak         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ga', 'Irish           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('it', 'Italian         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ja', 'Japanese        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('jv', 'Javanese        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('kn', 'Kannada         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ks', 'Kashmiri        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('kk', 'Kazakh          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('rw', 'Kinyarwanda     ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ky', 'Kirghiz         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('rn', 'Kurundi         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ko', 'Korean          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ku', 'Kurdish         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('lo', 'Laothian        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('la', 'Latin           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('lv', 'Latvian Lettish ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ln', 'Lingala         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('lt', 'Lithuanian      ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('mk', 'Macedonian      ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('mg', 'Malagasy        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ms', 'Malay           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ml', 'Malayalam       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('mt', 'Maltese         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('mi', 'Maori           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('mr', 'Marathi         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('mo', 'Moldavian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('mn', 'Mongolian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('na', 'Nauru           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ne', 'Nepali          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('no', 'Norwegian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('oc', 'Occitan         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('or', 'Oriya           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ps', 'Pashto Pushto   ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('fa', 'Persian (Farsi) ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('pl', 'Polish          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('pt', 'Portuguese      ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('pa', 'Punjabi         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('qu', 'Quechua         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('rm', 'Rhaeto-Romance  ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ro', 'Romanian        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ru', 'Russian         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sm', 'Samoan          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sg', 'Sangho          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sa', 'Sanskrit        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('gd', 'Scots Gaelic    ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sr', 'Serbian         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sh', 'Serbo-Croatian  ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('st', 'Sesotho         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('tn', 'Setswana        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sn', 'Shona           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sd', 'Sindhi          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('si', 'Singhalese      ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ss', 'Siswati         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sk', 'Slovak          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sl', 'Slovenian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('so', 'Somali          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('es', 'Spanish         ', '         \t\t     ', 'ISO-8859-15     ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('su', 'Sundanese       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sw', 'Swahili         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('sv', 'Swedish         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('tl', 'Tagalog         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('tg', 'Tajik           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ta', 'Tamil           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('tt', 'Tatar           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('te', 'Telugu          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('th', 'Thai            ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('bo', 'Tibetan         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ti', 'Tigrinya        ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('to', 'Tonga           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ts', 'Tsonga          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('tr', 'Turkish         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('tk', 'Turkmen         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('tw', 'Twi             ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ug', 'Uigur           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('uk', 'Ukrainian       ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('ur', 'Urdu            ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('uz', 'Uzbek           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('vi', 'Vietnamese      ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('vo', 'Volapuk         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('cy', 'Welsh           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('wo', 'Wolof           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('xh', 'Xhosa           ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('yi', 'Yiddish         ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('yo', 'Yoruba          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('za', 'Zhuang          ', '                ', 'ISO-8859-1      ');
INSERT INTO cc_iso639 (code, name, lname, charset) VALUES ('zu', 'Zulu            ', '                ', 'ISO-8859-1      ');

ALTER TABLE cc_templatemail DROP INDEX cons_cc_templatemail_mailtype;
ALTER TABLE cc_templatemail ADD id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST, ADD id_language CHAR( 20 ) NOT NULL DEFAULT 'en' AFTER id ;
ALTER TABLE cc_templatemail CHANGE id id INT( 11 ) NOT NULL ;
ALTER TABLE cc_templatemail DROP PRIMARY KEY;
ALTER TABLE cc_templatemail ADD UNIQUE cons_cc_templatemail_id_language ( mailtype, id_language );


ALTER TABLE cc_card ADD status INT NOT NULL DEFAULT '1' AFTER activated ;
update cc_card set status = 1 where activated = 't';
update cc_card set status = 0 where activated = 'f';

CREATE TABLE cc_status_log (
	id 				BIGINT(20) NOT NULL AUTO_INCREMENT,
	status 			INT(11) NOT NULL,
	id_cc_card 		BIGINT(20) NOT NULL,
	updated_date 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE cc_card ADD COLUMN tag CHAR(50);
ALTER TABLE cc_ratecard ADD COLUMN rounding_calltime INT NOT NULL DEFAULT 0;
ALTER TABLE cc_ratecard ADD COLUMN rounding_threshold INT NOT NULL DEFAULT 0;
ALTER TABLE cc_ratecard ADD COLUMN additional_block_charge DECIMAL(15,5) NOT NULL DEFAULT 0;
ALTER TABLE cc_ratecard ADD COLUMN additional_block_charge_time INT NOT NULL DEFAULT 0;
ALTER TABLE cc_ratecard ADD COLUMN tag CHAR(50);
ALTER TABLE cc_ratecard ADD COLUMN disconnectcharge_after INT NOT NULL DEFAULT 0;

ALTER TABLE cc_card ADD COLUMN template_invoice VARCHAR( 100 ) ;
ALTER TABLE cc_card ADD COLUMN template_outstanding VARCHAR( 100 ) ;

CREATE TABLE cc_card_history (
	id 					BIGINT NOT NULL AUTO_INCREMENT,
	id_cc_card 			BIGINT,
	datecreated 		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	description			TEXT,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



ALTER TABLE cc_callback_spool CHANGE variable variable VARCHAR( 300 ) DEFAULT NULL;


ALTER TABLE cc_call ADD COLUMN real_sessiontime INT (11) DEFAULT NULL;


-- ?? update this when release 1.4
CREATE TABLE cc_call_archive (
	id 									bigINT (20) NOT NULL AUTO_INCREMENT,
	sessionid 							char(40) NOT NULL,
	uniqueid 							char(30) NOT NULL,
	username 							char(40) NOT NULL,
	nasipaddress 						char(30) DEFAULT NULL,
	starttime 							timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
	stoptime 							timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
	sessiontime 						INT (11) DEFAULT NULL,
	calledstation 						char(30) DEFAULT NULL,
	startdelay 							INT (11) DEFAULT NULL,
	stopdelay 							INT (11) DEFAULT NULL,
	terminatecause 						char(20) DEFAULT NULL,
	usertariff 							char(20) DEFAULT NULL,
	calledprovider 						char(20) DEFAULT NULL,
	calledcountry 						char(30) DEFAULT NULL,
	calledsub 							char(20) DEFAULT NULL,
	calledrate 							FLOAT DEFAULT NULL,
	sessionbill 						FLOAT DEFAULT NULL,
	destination 						char(40) DEFAULT NULL,
	id_tariffgroup 						INT (11) DEFAULT NULL,
	id_tariffplan 						INT (11) DEFAULT NULL,
	id_ratecard 						INT (11) DEFAULT NULL,
	id_trunk 							INT (11) DEFAULT NULL,
	sipiax 								INT (11) DEFAULT '0',
	src 								char(40) DEFAULT NULL,
	id_did 								INT (11) DEFAULT NULL,
	buyrate 							DECIMAL(15,5) DEFAULT 0,
	buycost 							DECIMAL(15,5) DEFAULT 0,
	id_card_package_offer 				INT (11) DEFAULT 0,
	real_sessiontime					INT (11) DEFAULT NULL,
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_call_archive ADD INDEX ( username );
ALTER TABLE cc_call_archive ADD INDEX ( starttime );
ALTER TABLE cc_call_archive ADD INDEX ( terminatecause );
ALTER TABLE cc_call_archive ADD INDEX ( calledstation );



ALTER TABLE cc_card DROP COLUMN userpass;

CREATE TABLE cc_card_archive (
	id 								BIGINT NOT NULL,
	creationdate 					TIMESTAMP DEFAULT  CURRENT_TIMESTAMP NOT NULL,
	firstusedate 					TIMESTAMP,
	expirationdate 					TIMESTAMP,
	enableexpire 					INT DEFAULT 0,
	expiredays 						INT DEFAULT 0,
	username 						CHAR(50) NOT NULL,
	useralias 						CHAR(50) NOT NULL,
	uipass 							CHAR(50),
	credit 							DECIMAL(15,5) DEFAULT 0 NOT NULL,
	tariff 							INT DEFAULT 0,
	id_didgroup 					INT DEFAULT 0,
	activated 						CHAR(1) DEFAULT 'f' NOT NULL,
	status							INT DEFAULT 1,
	lastname 						CHAR(50),
	firstname 						CHAR(50),
	address 						CHAR(100),
	city 							CHAR(40),
	state 							CHAR(40),
	country 						CHAR(40),
	zipcode 						CHAR(20),
	phone 							CHAR(20),
	email 							CHAR(70),
	fax 							CHAR(20),
	inuse 							INT DEFAULT 0,
	simultaccess 					INT DEFAULT 0,
	currency 						CHAR(3) DEFAULT 'USD',
	lastuse  						TIMESTAMP,
	nbused 							INT DEFAULT 0,
	typepaid 						INT DEFAULT 0,
	creditlimit 					INT DEFAULT 0,
	voipcall 						INT DEFAULT 0,
	sip_buddy 						INT DEFAULT 0,
	iax_buddy 						INT DEFAULT 0,
	language 						CHAR(5) DEFAULT 'en',
	redial 							CHAR(50),
	runservice 						INT DEFAULT 0,
	nbservice 						INT DEFAULT 0,
	id_campaign						INT DEFAULT 0,
	num_trials_done 				BIGINT DEFAULT 0,
	callback 						CHAR(50),
	vat 							FLOAT DEFAULT 0 NOT NULL,
	servicelastrun 					TIMESTAMP,
	initialbalance 					DECIMAL(15,5) DEFAULT 0 NOT NULL,
	invoiceday 						INT DEFAULT 1,
	autorefill 						INT DEFAULT 0,
	loginkey 						CHAR(40),
	activatedbyuser 				CHAR(1) DEFAULT 't' NOT NULL,
	id_timezone 					INT DEFAULT 0,
	tag char(50) 					collate utf8_bin default NULL,
	template_invoice 				text collate utf8_bin,
	template_outstanding			text collate utf8_bin,
	mac_addr						CHAR(17) DEFAULT '00-00-00-00-00-00' NOT NULL,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



ALTER TABLE cc_card_archive ADD INDEX ( creationdate );
ALTER TABLE cc_card_archive ADD INDEX ( username );
ALTER TABLE cc_ratecard ADD COLUMN is_merged INT DEFAULT 0;

UPDATE cc_config SET config_title='Dial Command Params', config_description='More information about the Dial : http://voip-info.org/wiki-Asterisk+cmd+dial<br>30 :  The timeout parameter is optional. If not specifed, the Dial command will wait indefinitely, exiting only when the originating channel hangs up, or all the dialed channels return a busy or error condition. Otherwise it specifies a maximum time, in seconds, that the Dial command is to wait for a channel to answer.<br>H: Allow the caller to hang up by dialing * <br>r: Generate a ringing tone for the calling party<br>R: Indicate ringing to the calling party when the called party indicates ringing, pass no audio until answered.<br>g: When the called party hangs up, exit to execute more commands in the current context. (new in 1.4)<br>i: Asterisk will ignore any forwarding (302 Redirect) requests received. Essential for DID usage to prevent fraud. (new in 1.4)<br>m: Provide Music on Hold to the calling party until the called channel answers.<br>L(x[:y][:z]): Limit the call to ''x'' ms, warning when ''y'' ms are left, repeated every ''z'' ms)<br>%timeout% tag is replaced by the calculated timeout according the credit & destination rate!.' WHERE  config_key='dialcommand_param';
UPDATE cc_config SET config_title='SIP/IAX Dial Command Params', config_value='|60|HiL(3600000:61000:30000)' WHERE config_key='dialcommand_param_sipiax_friend';





-- VOICEMAIL CHANGES
ALTER TABLE cc_card ADD voicemail_permitted INTEGER DEFAULT 0 NOT NULL;
ALTER TABLE cc_card ADD voicemail_activated SMALLINT DEFAULT 0 NOT NULL;



-- ADD MISSING extracharge_did settings
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Extra charge DIDs', 'extracharge_did', '1800,1900', 'Add extra per-minute charges to this comma-separated list of DNIDs; needs "extracharge_fee" and "extracharge_buyfee"', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Extra charge DID fees', 'extracharge_fee', '0,0', 'Comma-separated list of extra sell-rate charges corresponding to the DIDs in "extracharge_did" - ie : 0.08,0.18', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Extra charge DID buy fees', 'extracharge_buyfee', '0,0', 'Comma-separated list of extra buy-rate charges corresponding to the DIDs in "extracharge_did" - ie : 0.04,0.13', 0, 11, NULL);


-- These triggers are to prevent bogus regexes making it into the database
DELIMITER //
CREATE TRIGGER cc_ratecard_validate_regex_ins BEFORE INSERT ON cc_ratecard
FOR EACH ROW
BEGIN
  DECLARE valid INTEGER;
  SELECT '0' REGEXP REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONCAT('^', NEW.dialprefix, '$'), 'X', '[0-9]'), 'Z', '[1-9]'), 'N', '[2-9]'), '.', '.+'), '_', '') INTO valid;
END
//
CREATE TRIGGER cc_ratecard_validate_regex_upd BEFORE UPDATE ON cc_ratecard
FOR EACH ROW
BEGIN
  DECLARE valid INTEGER;
  SELECT '0' REGEXP REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONCAT('^', NEW.dialprefix, '$'), 'X', '[0-9]'), 'Z', '[1-9]'), 'N', '[2-9]'), '.', '.+'), '_', '') INTO valid;
END
//
DELIMITER ;

ALTER TABLE cc_currencies CHANGE value value NUMERIC (12,5) unsigned NOT NULL DEFAULT '0.00000';



-- More info into log payment
ALTER TABLE cc_logpayment ADD COLUMN id_logrefill BIGINT DEFAULT NULL;


-- Support / Ticket section

CREATE TABLE cc_support (
	id smallint(5) NOT NULL auto_increment,
	`name` varchar(50) collate utf8_bin NOT NULL,
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE cc_support_component (
	id smallint(5) NOT NULL auto_increment,
	id_support smallint(5) NOT NULL,
	name varchar(50) collate utf8_bin NOT NULL,
	activated smallint(6) NOT NULL default '1',
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE cc_ticket (
	id bigint(10) NOT NULL auto_increment,
	id_component smallint(5) NOT NULL,
	title varchar(100) collate utf8_bin NOT NULL,
	description text collate utf8_bin,
	priority smallint(6) NOT NULL default '0',
	creationdate timestamp NOT NULL default CURRENT_TIMESTAMP,
	creator bigint(20) NOT NULL,
	status smallint(6) NOT NULL default '0',
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE cc_ticket_comment (
	id bigint(20) NOT NULL auto_increment,
	date timestamp NOT NULL default CURRENT_TIMESTAMP,
	id_ticket bigint(10) NOT NULL,
	description text collate utf8_bin,
	creator bigint(20) NOT NULL,
	is_admin char(1) collate utf8_bin NOT NULL default 'f',
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ( 'Support Modules', 'support', '1', 'Enable or Disable the module of support', 1, 3, 'yes,no');



-- change charset to use LIKE without "casse"
ALTER TABLE cc_ratecard CHANGE destination destination CHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL;


-- section for notification

INSERT INTO cc_config_group (group_title ,group_description) VALUES
 ( 'notifications', 'This configuration group handles the notifcations configuration');

INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'List of possible values to notify', 'values_notifications', '10:20:50:100:500:1000', 'Possible values to choose when the user receive a notification. You can define a List e.g: 10:20:100.', '0', '12', NULL);

INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues)
 VALUES ( 'Notifications Modules', 'notification', '1', 'Enable or Disable the module of notification for the customers', 1, 3, 'yes,no');


INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Notications Cron Module', 'cron_notifications', '1', 'Enable or Disable the cron module of notification for the customers. If it correctly configured in the crontab', '0', '12', 'yes,no');


INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Notications Delay', 'delay_notifications', '1', 'Delay in number of days to send an other notification for the customers. If the value is 0, it will notify the user everytime the cront is running.', '0', '12', NULL);

ALTER TABLE cc_card ADD last_notification TIMESTAMP NULL DEFAULT NULL ;


ALTER TABLE cc_card ADD email_notification CHAR( 70 ) CHARACTER SET utf8 COLLATE utf8_bin NULL ;

ALTER TABLE cc_card
ADD notify_email SMALLINT NOT NULL DEFAULT '0';

ALTER TABLE cc_card ADD credit_notification INT NOT NULL DEFAULT -1;

UPDATE cc_templatemail SET subject='Your Call-Labs account $cardnumber$ is low on credit ($currency$ $creditcurrency$)', messagetext = '

Your Call-Labs Account number $cardnumber$ is running low on credit.

There is currently only $creditcurrency$ $currency$ left on your account which is lower than the warning level defined ($credit_notification$)


Please top up your account ASAP to ensure continued service

If you no longer wish to receive these notifications or would like to change the balance amount at which these warnings are generated,
please connect on your myaccount panel and change the appropriate parameters


your account information :
Your account number for VOIP authentication : $cardnumber$

https://myaccount.mydomainname.com/
Your account login : $login$
Your account password : $password$


Thanks,
/My Company Name
-------------------------------------
http://www.mydomainname.com
 '
WHERE cc_templatemail.mailtype ='reminder' AND CONVERT( cc_templatemail.id_language USING utf8 ) = 'en' LIMIT 1 ;





-- Section for Agent

CREATE TABLE cc_agent (
	id 								BIGINT NOT NULL AUTO_INCREMENT,
    datecreation 					TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    active 							CHAR(1) DEFAULT 'f' NOT NULL,
    login 							CHAR(20) NOT NULL,
    passwd 							CHAR(40),
    location 						text,
    language 						CHAR(5) DEFAULT 'en',
    id_tariffgroup					INT,
    options 						integer NOT NULL DEFAULT 0,
    credit 							DECIMAL(15,5) DEFAULT 0 NOT NULL,
    climit 							DECIMAL(15,5) DEFAULT 0 NOT NULL,
    currency 						CHAR(3) DEFAULT 'USD',
    locale 							CHAR(10) DEFAULT 'C',
    commission 						DECIMAL(10,4) DEFAULT 0 NOT NULL,
    vat 							DECIMAL(10,4) DEFAULT 0 NOT NULL,
    banner 							TEXT,
	perms 							INT,
    lastname 						CHAR(50),
    firstname 						CHAR(50),
    address 						CHAR(100),
    city 							CHAR(40),
    state 							CHAR(40),
    country 						CHAR(40),
    zipcode 						CHAR(20),
    phone 							CHAR(20),
    email 							CHAR(70),
    fax 							CHAR(20),
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



ALTER TABLE cc_card ADD id_agent INT NOT NULL DEFAULT '0';

-- Add card id field in CDR to authorize filtering by agent

ALTER TABLE cc_call ADD card_id BIGINT( 20 ) NOT NULL AFTER username;

UPDATE cc_call,cc_card SET cc_call.card_id=cc_card.id WHERE cc_card.username=cc_call.username;


CREATE TABLE cc_agent_tariffgroup (
	id_agent BIGINT( 20 ) NOT NULL ,
	id_tariffgroup INT( 11 ) NOT NULL,
	PRIMARY KEY ( id_agent,id_tariffgroup )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;




-- Add new configuration payment agent

INSERT INTO cc_config ( id, config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES (NULL , 'Payment Amount', 'purchase_amount_agent', '100:200:500:1000', 'define the different amount of purchase that would be available.', '0', '5', NULL);


-- create group for the card

CREATE TABLE cc_card_group (
	id 					INT NOT NULL AUTO_INCREMENT ,
	name 				CHAR( 30 ) NOT NULL collate utf8_bin ,
	id_agi_conf 		INT NOT NULL ,
	description 		MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL ,
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- insert default group

INSERT INTO cc_card_group (id ,name ,id_agi_conf) VALUES ('1' , 'DEFAULT', '-1');

ALTER TABLE cc_card ADD id_group INT NOT NULL DEFAULT '1';


-- new table for the free minutes/calls package


CREATE TABLE cc_package_group (
	id INT NOT NULL AUTO_INCREMENT ,
	name CHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL,
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE cc_packgroup_package (
	packagegroup_id INT NOT NULL ,
	package_id INT NOT NULL ,
	PRIMARY KEY ( packagegroup_id , package_id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE cc_package_rate (
	package_id INT NOT NULL ,
	rate_id INT NOT NULL ,
	PRIMARY KEY ( package_id , rate_id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_config ( id , config_title , config_key , config_value , config_description , config_valuetype , config_group_id , config_listvalues ) VALUES ( NULL , 'Max Time For Unlimited Calls', 'maxtime_tounlimited_calls', '5400', 'For unlimited calls, limit the duration: amount in seconds .', '0', '11', NULL), (NULL , 'Max Time For Free Calls', 'maxtime_tofree_calls', '5400', 'For free calls, limit the duration: amount in seconds .', '0', '11', NULL);

ALTER TABLE cc_ratecard DROP freetimetocall_package_offer;
-- add additionnal grace to the ratecard

ALTER TABLE cc_ratecard ADD additional_grace INT NOT NULL DEFAULT '0';

-- add minimum cost option for a rate card

ALTER TABLE cc_ratecard ADD minimal_cost FLOAT NOT NULL DEFAULT '0';

-- add description for the REFILL AND PAYMENT
ALTER TABLE cc_logpayment ADD description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL ;
ALTER TABLE cc_logrefill ADD description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL ;


ALTER TABLE cc_config CHANGE config_description config_description TEXT CHARACTER SET utf8 COLLATE utf8_bin NOT NULL;


-- Deck threshold switch for callplan
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) 
VALUES ('CallPlan threshold Deck switch', 'callplan_deck_minute_threshold', '', 'CallPlan threshold Deck switch. <br/>This option will switch the user callplan from one call plan ID to and other Callplan ID
The parameters are as follow : <br/>
-- ID of the first callplan : called seconds needed to switch to the next CallplanID <br/>
-- ID of the second callplan : called seconds needed to switch to the next CallplanID <br/>
-- if not needed seconds are defined it will automatically switch to the next one <br/>
-- if defined we will sum the previous needed seconds and check if the caller had done at least the amount of calls necessary to go to the next step and have the amount of seconds needed<br/>
value example for callplan_deck_minute_threshold = 1:300, 2:60, 3', 
'0', '11', NULL);


ALTER TABLE cc_call ADD dnid CHAR( 40 );

-- update password field
ALTER TABLE cc_ui_authen CHANGE password pwd_encoded VARCHAR( 250 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL;

-- CHANGE SECURITY ABOUT PASSWORD : All password will be changed to "changepassword"



ALTER TABLE cc_card ADD company_name VARCHAR( 50 ) NULL ,
ADD company_website VARCHAR( 60 ) NULL ,
ADD VAT_RN VARCHAR( 40 ) NULL ,
ADD traffic BIGINT NULL ,
ADD traffic_target MEDIUMTEXT NULL ;

ALTER TABLE cc_logpayment ADD added_refill SMALLINT NOT NULL DEFAULT '0';

-- Add payment history in customer WebUI
INSERT INTO cc_config( config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues )
VALUES ('Payment Historique Modules', 'payment', '1', 'Enable or Disable the module of payment historique for the customers', 1, 3, 'yes,no');

-- modify the field type to authoriz to search by sell rate
ALTER TABLE cc_call CHANGE calledrate calledrate DECIMAL( 15, 5 ) NULL DEFAULT NULL;

-- Delete old menufile.
 DELETE FROM cc_config WHERE config_key = 'file_conf_enter_menulang' ;

INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ('Menu Language Order', 'conf_order_menulang', 'en:fr:es', 'Enter the list of languages authorized for the menu.Use the code language separate by a colon charactere e.g: en:es:fr', '0', '11', NULL);
INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Disable annoucement the second of the times that the card can call', 'disable_announcement_seconds', '0', 'Desactived the annoucement of the seconds when there are more of one minutes (values : yes - no)', '1', '11', 'yes,no');
INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Charge for the paypal extra fees', 'charge_paypal_fee', '0', 'Actived, if you want assum the fee of paypal and don''t apply it on the customer (values : yes - no)', '1', '5', 'yes,no');



-- Optimization on terminatecause
ALTER TABLE cc_call ADD COLUMN terminatecauseid INT (1) DEFAULT 1;
UPDATE cc_call SET terminatecauseid=1 WHERE terminatecause='ANSWER';
UPDATE cc_call SET terminatecauseid=1 WHERE terminatecause='ANSWERED';
UPDATE cc_call SET terminatecauseid=2 WHERE terminatecause='BUSY';
UPDATE cc_call SET terminatecauseid=3 WHERE terminatecause='NOANSWER';
UPDATE cc_call SET terminatecauseid=4 WHERE terminatecause='CANCEL';
UPDATE cc_call SET terminatecauseid=5 WHERE terminatecause='CONGESTION';
UPDATE cc_call SET terminatecauseid=6 WHERE terminatecause='CHANUNAVAIL';

ALTER TABLE cc_call DROP terminatecause;
ALTER TABLE cc_call ADD INDEX ( terminatecauseid );

-- Add index on prefix
ALTER TABLE cc_prefix ADD INDEX ( prefixe );

-- optimization on CDR
ALTER TABLE cc_call ADD COLUMN id_cc_prefix INT (11) DEFAULT 0;
ALTER TABLE cc_ratecard ADD COLUMN id_cc_prefix INT (11) DEFAULT 0;

ALTER TABLE cc_call DROP username;
ALTER TABLE cc_call DROP destination;
ALTER TABLE cc_call DROP startdelay;
ALTER TABLE cc_call DROP stopdelay;
ALTER TABLE cc_call DROP usertariff;
ALTER TABLE cc_call DROP calledprovider;
ALTER TABLE cc_call DROP calledcountry;
ALTER TABLE cc_call DROP calledsub;


-- Update all rates values to use Decimal
ALTER TABLE cc_ratecard CHANGE buyrate buyrate decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE rateinitial rateinitial decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE connectcharge connectcharge decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE disconnectcharge disconnectcharge decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE stepchargea stepchargea decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE chargea chargea decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE stepchargeb stepchargeb decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE chargeb chargeb decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE stepchargeb stepchargeb decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE chargeb chargeb decimal(15,5) NOT NULL DEFAULT '0';
ALTER TABLE cc_ratecard CHANGE minimal_cost minimal_cost decimal(15,5) NOT NULL DEFAULT '0';



-- change perms for new menu
UPDATE cc_ui_authen SET perms = '5242879' WHERE userid=1 LIMIT 1;

-- correct card group
ALTER TABLE cc_card_group DROP id_agi_conf;


CREATE TABLE cc_cardgroup_service (
	id_card_group INT NOT NULL ,
	id_service INT NOT NULL,
	PRIMARY KEY ( id_card_group , id_service )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ('Cents Currency Associated', 'currency_cents_association', '', 'Define all the audio (without file extensions) that you want to play according to cents currency (use , to separate, ie "amd:lumas").By default the file used is "prepaid-cents" .Use plural to define the cents currency sound, but import two sounds but cents currency defined : ending by ''s'' and not ending by ''s'' (i.e. for lumas , add 2 files : ''lumas'' and ''luma'') ', '0', '11', NULL);

ALTER TABLE cc_call DROP calledrate, DROP buyrate;


-- ------------------------------------------------------
-- for AutoDialer
-- ------------------------------------------------------

-- Create phonebook for
CREATE TABLE cc_phonebook (
	id 				INT NOT NULL AUTO_INCREMENT ,
	name 			CHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	description 	MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL ,
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE cc_phonenumber (
	id 				BIGINT NOT NULL AUTO_INCREMENT ,
	id_phonebook 	INT NOT NULL ,
	number 			CHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	name 			CHAR( 40 ) CHARACTER SET utf8 COLLATE utf8_bin NULL ,
	creationdate 	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	status 			SMALLINT NOT NULL DEFAULT '1',
	info 			MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL,
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_phonebook ADD id_card BIGINT NOT NULL ;

CREATE TABLE cc_campaign_phonebook (
	id_campaign 	INT NOT NULL ,
	id_phonebook 	INT NOT NULL,
	PRIMARY KEY ( id_campaign , id_phonebook )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_campaign CHANGE campaign_name name CHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
CHANGE enable status INT( 11 ) NOT NULL DEFAULT '1';

ALTER TABLE cc_campaign ADD frequency INT NOT NULL DEFAULT '20';

CREATE TABLE cc_campaign_phonestatus (
	id_phonenumber BIGINT NOT NULL ,
	id_campaign INT NOT NULL ,
	id_callback VARCHAR( 40 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	status INT NOT NULL DEFAULT '0',
	lastuse TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY ( id_phonenumber , id_campaign )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_campaign CHANGE id_trunk id_card BIGINT NOT NULL DEFAULT '0';
ALTER TABLE cc_campaign ADD forward_number CHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_bin NULL;

DROP TABLE cc_phonelist;

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES 
( 'Context Campaign''s Callback', 'context_campaign_callback', 'a2billing-campaign-callback', 'Context to use in Campaign of Callback', '0', '2', NULL);

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES 
( 'Default Context forward Campaign''s Callback ', 'default_context_campaign', 'campaign', 'Context to use by default to forward the call in Campaign of Callback', '0', '2', NULL);

ALTER TABLE cc_campaign ADD daily_start_time TIME NOT NULL DEFAULT '10:00:00',
ADD daily_stop_time TIME NOT NULL DEFAULT '18:00:00',
ADD monday TINYINT NOT NULL DEFAULT '1',
ADD tuesday TINYINT NOT NULL DEFAULT '1',
ADD wednesday TINYINT NOT NULL DEFAULT '1',
ADD thursday TINYINT NOT NULL DEFAULT '1',
ADD friday TINYINT NOT NULL DEFAULT '1',
ADD saturday TINYINT NOT NULL DEFAULT '0',
ADD sunday TINYINT NOT NULL DEFAULT '0';

ALTER TABLE cc_campaign ADD id_cid_group INT NOT NULL ;

CREATE TABLE cc_campaign_config (
	id INT NOT NULL AUTO_INCREMENT ,
	name VARCHAR( 40 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	flatrate DECIMAL(15,5) DEFAULT 0 NOT NULL,
	context VARCHAR( 40 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL ,
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE cc_campaignconf_cardgroup (
	id_campaign_config INT NOT NULL ,
	id_card_group INT NOT NULL ,
	PRIMARY KEY ( id_campaign_config , id_card_group )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE cc_campaign ADD id_campaign_config INT NOT NULL ;


-- ------------------------------------------------------
-- for Agent
-- ------------------------------------------------------

ALTER TABLE cc_card ADD COLUMN discount decimal(5,2) NOT NULL DEFAULT '0';


-- New config parameter to display card list : card_show_field_list
ALTER TABLE cc_config MODIFY config_value VARCHAR( 300 );
INSERT INTO  cc_config (config_title,config_key,config_value,config_description,config_valuetype,config_group_id) values ('Card Show Fields','card_show_field_list','id:,username:, useralias:, lastname:,id_group:, id_agent:,  credit:, tariff:, status:, language:, inuse:, currency:, sip_buddy:, iax_buddy:, nbused:,','Fields to show in Customer. Order is important. You can setup size of field using "fieldname:10%" notation or "fieldname:" for harcoded size,"fieldname" for autosize. <br/>You can use:<br/> id,username, useralias, lastname, id_group, id_agent,  credit, tariff, status, language, inuse, currency, sip_buddy, iax_buddy, nbused, firstname, email, discount, callerid',0,8);


-- ------------------------------------------------------
-- Cache system with SQLite Agent
-- ------------------------------------------------------
INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Enable CDR local cache', 'cache_enabled', '0', 'If you want enabled the local cache to save the CDR in a SQLite Database.', '1', '1', 'yes,no'),
( 'Path for the CDR cache file', 'cache_path', '/etc/asterisk/cache_a2billing', 'Defined the file that you want use for the CDR cache to save the CDR in a local SQLite database.', '0', '1', NULL);


ALTER TABLE cc_logrefill ADD COLUMN refill_type TINYINT NOT NULL DEFAULT 0;
ALTER TABLE cc_logpayment ADD COLUMN payment_type TINYINT NOT NULL DEFAULT 0;


-- ------------------------------------------------------
-- Add management of the web customer in groups
-- ------------------------------------------------------
ALTER TABLE cc_card_group ADD users_perms INT NOT NULL DEFAULT '0';



-- ------------------------------------------------------
-- PNL report
-- ------------------------------------------------------
INSERT INTO  cc_config(config_title,config_key,config_value,config_description,config_valuetype,config_group_id) values 
('PNL Pay Phones','report_pnl_pay_phones','(8887798764,0.02,0.06)','Info for PNL report. Must be in form "(number1,buycost,sellcost),(number2,buycost,sellcost)", number can be prefix, i.e 1800',0,8);
INSERT INTO  cc_config(config_title,config_key,config_value,config_description,config_valuetype,config_group_id) values
('PNL Toll Free Numbers','report_pnl_toll_free','(6136864646,0.1,0),(6477249717,0.1,0)','Info for PNL report. must be in form "(number1,buycost,sellcost),(number2,buycost,sellcost)", number can be prefix, i.e 1800',0,8);



-- ------------------------------------------------------
-- Update to use VarChar instead of Char
-- ------------------------------------------------------
ALTER TABLE cc_call CHANGE sessionid sessionid VARCHAR( 40 ) NOT NULL;
ALTER TABLE cc_call CHANGE uniqueid uniqueid VARCHAR( 30 ) NOT NULL;
ALTER TABLE cc_call CHANGE nasipaddress nasipaddress VARCHAR( 30 ) NOT NULL;
ALTER TABLE cc_call CHANGE calledstation calledstation VARCHAR( 30 ) NOT NULL;
ALTER TABLE cc_call CHANGE src src VARCHAR( 40 ) NOT NULL;
ALTER TABLE cc_call CHANGE dnid dnid VARCHAR( 40 ) NOT NULL;

ALTER TABLE cc_card CHANGE username username VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE useralias useralias VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE uipass uipass VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE lastname lastname VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE firstname firstname VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE address address VARCHAR( 100 ) NOT NULL;
ALTER TABLE cc_card CHANGE city city VARCHAR( 40 ) NOT NULL;
ALTER TABLE cc_card CHANGE state state VARCHAR( 40 ) NOT NULL;
ALTER TABLE cc_card CHANGE country country VARCHAR( 40 ) NOT NULL;
ALTER TABLE cc_card CHANGE zipcode zipcode VARCHAR( 20 ) NOT NULL;
ALTER TABLE cc_card CHANGE phone phone VARCHAR( 20 ) NOT NULL;
ALTER TABLE cc_card CHANGE email email VARCHAR( 70 ) NOT NULL;
ALTER TABLE cc_card CHANGE fax fax VARCHAR( 20 ) NOT NULL;
ALTER TABLE cc_card CHANGE redial redial VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE callback callback VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE loginkey loginkey VARCHAR( 40 ) NOT NULL;
ALTER TABLE cc_card CHANGE tag tag VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE email_notification email_notification VARCHAR( 70 ) NOT NULL;
ALTER TABLE cc_card CHANGE company_name company_name VARCHAR( 50 ) NOT NULL;
ALTER TABLE cc_card CHANGE company_website company_website VARCHAR( 60 ) NOT NULL;
ALTER TABLE cc_card CHANGE vat_rn vat_rn VARCHAR( 40 ) NOT NULL;
ALTER TABLE cc_card CHANGE traffic_target traffic_target VARCHAR( 300 ) NOT NULL;

ALTER TABLE cc_callerid CHANGE cid cid VARCHAR( 100 ) NOT NULL;


ALTER TABLE cc_iax_buddies CHANGE name name VARCHAR(80) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE accountcode accountcode VARCHAR(20) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE regexten regexten VARCHAR(20) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE callerid callerid VARCHAR(80) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE context context VARCHAR(80) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE fromuser fromuser VARCHAR(80) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE fromdomain fromdomain VARCHAR(80) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE host host VARCHAR(31) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE insecure insecure VARCHAR(20) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE mailbox mailbox VARCHAR(50) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE md5secret md5secret VARCHAR(80) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE permit permit VARCHAR(95) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE deny deny VARCHAR(95) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE mask mask VARCHAR(95) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE secret secret VARCHAR(80) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE username username VARCHAR(80) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE disallow disallow VARCHAR(100) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE allow allow VARCHAR(100) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE musiconhold musiconhold VARCHAR(100) NOT NULL;
ALTER TABLE cc_iax_buddies CHANGE canreinvite canreinvite VARCHAR(20) NOT NULL;

ALTER TABLE cc_sip_buddies CHANGE name name VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE accountcode accountcode VARCHAR(20) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE regexten regexten VARCHAR(20) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE callerid callerid VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE context context VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE fromuser fromuser VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE fromdomain fromdomain VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE host host VARCHAR(31) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE insecure insecure VARCHAR(20) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE mailbox mailbox VARCHAR(50) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE md5secret md5secret VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE permit permit VARCHAR(95) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE deny deny VARCHAR(95) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE mask mask VARCHAR(95) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE secret secret VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE username username VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE disallow disallow VARCHAR(100) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE allow allow VARCHAR(100) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE musiconhold musiconhold VARCHAR(100) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE fullcontact fullcontact VARCHAR(80) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE setvar setvar VARCHAR(100) NOT NULL;
ALTER TABLE cc_sip_buddies CHANGE canreinvite canreinvite VARCHAR(20) NOT NULL;


-- ------------------------------------------------------
-- Add restricted rules on the call system for customers 
-- ------------------------------------------------------

CREATE TABLE cc_restricted_phonenumber (
	id BIGINT NOT NULL AUTO_INCREMENT ,
	number VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	id_card BIGINT NOT NULL,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE cc_card ADD restriction TINYINT NOT NULL DEFAULT '0';

-- remove callback from card
ALTER TABLE cc_card DROP COLUMN callback;

-- ADD IAX TRUNKING
ALTER TABLE cc_iax_buddies ADD trunk CHAR(3) DEFAULT 'no';

-- Refactor Agent Section
ALTER TABLE cc_card DROP id_agent;
ALTER TABLE cc_card_group ADD id_agent INT NOT NULL DEFAULT '0';

-- remove old template invoice
ALTER TABLE cc_card DROP template_invoice;
ALTER TABLE cc_card DROP template_outstanding;

-- rename vat field
ALTER TABLE cc_card CHANGE VAT_RN vat_rn VARCHAR( 40 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;

-- add amount
ALTER TABLE cc_phonenumber ADD amount INT NOT NULL DEFAULT '0';


-- add company to Agent
ALTER TABLE cc_agent ADD COLUMN company varchar(50);


-- Change AGI Verbosity & logging
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) 
VALUES ('Verbosity', 'verbosity_level', '0', '0 = FATAL; 1 = ERROR; WARN = 2 ; INFO = 3 ; DEBUG = 4', 0, 11, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) 
VALUES ('Logging', 'logging_level', '3', '0 = FATAL; 1 = ERROR; WARN = 2 ; INFO = 3 ; DEBUG = 4', 0, 11, NULL);


ALTER TABLE cc_ticket ADD creator_type TINYINT NOT NULL DEFAULT '0';
ALTER TABLE cc_ticket_comment CHANGE is_admin creator_type TINYINT NOT NULL DEFAULT '0';

ALTER TABLE cc_ratecard ADD COLUMN announce_time_correction decimal(5,3) NOT NULL DEFAULT 1.0;


ALTER TABLE cc_agent DROP climit;

CREATE TABLE cc_agent_cardgroup (
	id_agent INT NOT NULL ,
	id_card_group INT NOT NULL ,
	PRIMARY KEY ( id_agent , id_card_group )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_card_group DROP id_agent;

ALTER TABLE cc_agent ADD secret VARCHAR( 20 ) NOT NULL;

-- optimization on CDR
ALTER TABLE cc_ratecard DROP destination;
ALTER TABLE cc_call DROP id_cc_prefix;
ALTER TABLE cc_ratecard DROP id_cc_prefix;
ALTER TABLE cc_call ADD COLUMN destination INT (11) DEFAULT 0;
ALTER TABLE cc_ratecard ADD COLUMN destination INT (11) DEFAULT 0;


UPDATE cc_card_group SET description = 'This group is the default group used when you create a customer. It''s forbidden to delete it because you need at least one group but you can edit it.' WHERE id = 1 LIMIT 1 ;
UPDATE cc_card_group SET users_perms = '129022' WHERE id = 1;

ALTER TABLE cc_ticket ADD viewed_cust TINYINT NOT NULL DEFAULT '1',
ADD viewed_agent TINYINT NOT NULL DEFAULT '1',
ADD viewed_admin TINYINT NOT NULL DEFAULT '1';


ALTER TABLE cc_ticket_comment ADD viewed_cust TINYINT NOT NULL DEFAULT '1',
ADD viewed_agent TINYINT NOT NULL DEFAULT '1',
ADD viewed_admin TINYINT NOT NULL DEFAULT '1';

ALTER TABLE cc_ui_authen ADD email VARCHAR( 70 ) CHARACTER SET utf8 COLLATE utf8_bin NULL ;

ALTER TABLE cc_logrefill CHANGE id id BIGINT NOT NULL AUTO_INCREMENT  ;

-- Refill table for Agent
CREATE TABLE cc_logrefill_agent (
	id BIGINT NOT NULL auto_increment,
	date timestamp NOT NULL default CURRENT_TIMESTAMP,
	credit float NOT NULL,
	agent_id BIGINT NOT NULL,
	description mediumtext collate utf8_bin,
	refill_type tinyint NOT NULL default '0',
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- logpayment table for Agent
CREATE TABLE cc_logpayment_agent (
	id BIGINT NOT NULL auto_increment,
	date timestamp NOT NULL default CURRENT_TIMESTAMP,
	payment float NOT NULL,
	agent_id BIGINT NOT NULL,
	id_logrefill BIGINT default NULL,
	description mediumtext collate utf8_bin,
	added_refill tinyint NOT NULL default '0',
	payment_type tinyint NOT NULL default '0',
	PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- Table structure for table cc_prefix
DROP TABLE IF EXISTS cc_prefix;
CREATE TABLE IF NOT EXISTS cc_prefix (
	prefix bigint(20) NOT NULL auto_increment,
	destination varchar(60) collate utf8_bin NOT NULL,
	PRIMARY KEY (prefix),
	KEY destination (destination)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



INSERT INTO cc_config_group (group_title ,group_description) VALUES ( 'dashboard', 'This configuration group handles the dashboard configuration');

INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Enable info module about customers', 'customer_info_enabled', 'LEFT', 'If you want enabled the info module customer and place it somewhere on the home page.', '0', '13', 'NONE,LEFT,CENTER,RIGHT');
INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Enable info module about refills', 'refill_info_enabled', 'CENTER', 'If you want enabled the info module refills and place it somewhere on the home page.', '0', '13', 'NONE,LEFT,CENTER,RIGHT');
INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Enable info module about payments', 'payment_info_enabled', 'CENTER', 'If you want enabled the info module payments and place it somewhere on the home page.', '0', '13', 'NONE,LEFT,CENTER,RIGHT');
INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_group_id ,config_listvalues)
VALUES ( 'Enable info module about calls', 'call_info_enabled', 'RIGHT', 'If you want enabled the info module calls and place it somewhere on the home page.', '0', '13', 'NONE,LEFT,CENTER,RIGHT');


-- New Invoice Tables
RENAME TABLE cc_invoices  TO bkp_cc_invoices;
RENAME TABLE cc_invoice  TO bkp_cc_invoice;
RENAME TABLE cc_invoice_history  TO bkp_cc_invoice_history;
RENAME TABLE cc_invoice_items  TO bkp_cc_invoice_items;

CREATE TABLE cc_invoice (
	id BIGINT NOT NULL AUTO_INCREMENT ,
	reference VARCHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_bin NULL ,
	id_card BIGINT NOT NULL ,
	date timestamp NOT NULL default CURRENT_TIMESTAMP,
	paid_status TINYINT NOT NULL DEFAULT '0',
	status TINYINT NOT NULL DEFAULT '0',
	title VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	PRIMARY KEY ( id ) ,
	UNIQUE (reference)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE cc_invoice_item (
	id BIGINT NOT NULL AUTO_INCREMENT ,
	id_invoice BIGINT NOT NULL ,
	date timestamp NOT NULL default CURRENT_TIMESTAMP,
	price DECIMAL( 15, 5 ) NOT NULL DEFAULT '0',
	VAT DECIMAL( 4, 2 ) NOT NULL DEFAULT '0',
	description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


CREATE TABLE cc_invoice_conf (
	id INT NOT NULL AUTO_INCREMENT ,
	key_val VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	value VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	PRIMARY KEY ( id ),
	UNIQUE (key_val)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_invoice_conf (key_val ,value) 
	VALUES 	('company_name', 'My company'),
		('address', 'address'),
		('zipcode', 'xxxx'),
		('country', 'country'), 
		('city', 'city'), 
		('phone', 'xxxxxxxxxxx'), 
		('fax', 'xxxxxxxxxxx'), 
		('email', 'xxxxxxx@xxxxxxx.xxx'),
		('vat', 'xxxxxxxxxx'),
		('web', 'www.xxxxxxx.xxx');

ALTER TABLE cc_logrefill ADD added_invoice TINYINT NOT NULL DEFAULT '0';

CREATE TABLE cc_invoice_payment (
	id_invoice BIGINT NOT NULL ,
	id_payment BIGINT NOT NULL ,
	PRIMARY KEY ( id_invoice , id_payment )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;



INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) values ('Enable PlugnPay Module', 'MODULE_PAYMENT_PLUGNPAY_STATUS', 'True', 'Do you want to accept payments through PlugnPay?', 'tep_cfg_select_option(array(\'True\', \'False\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description) values ('Login Username', 'MODULE_PAYMENT_PLUGNPAY_LOGIN', 'Your Login Name', 'Enter your PlugnPay account username');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description) values ('Publisher Email', 'MODULE_PAYMENT_PLUGNPAY_PUBLISHER_EMAIL', 'Enter Your Email Address', 'The email address you want PlugnPay conformations sent to');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) values ('cURL Setup', 'MODULE_PAYMENT_PLUGNPAY_CURL', 'Not Compiled', 'Whether cURL is compiled into PHP or not.  Windows users, select not compiled.', 'tep_cfg_select_option(array(\'Not Compiled\', \'Compiled\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description) values ('cURL Path', 'MODULE_PAYMENT_PLUGNPAY_CURL_PATH', 'The Path To cURL', 'For Not Compiled mode only, input path to the cURL binary (i.e. c:/curl/curl)');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) values ('Transaction Mode', 'MODULE_PAYMENT_PLUGNPAY_TESTMODE', 'Test', 'Transaction mode used for processing orders', 'tep_cfg_select_option(array(\'Test\', \'Test And Debug\', \'Production\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) values ('Require CVV', 'MODULE_PAYMENT_PLUGNPAY_CVV', 'yes', 'Ask For CVV information', 'tep_cfg_select_option(array(\'yes\', \'no\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) values ('Transaction Method', 'MODULE_PAYMENT_PLUGNPAY_PAYMETHOD', 'credit', 'Transaction method used for processing orders.<br><b>NOTE:</b> Selecting \'onlinecheck\' assumes you\'ll offer \'credit\' as well.',  'tep_cfg_select_option(array(\'credit\', \'onlinecheck\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) values ('Authorization Type', 'MODULE_PAYMENT_PLUGNPAY_CCMODE', 'authpostauth', 'Credit card processing mode', 'tep_cfg_select_option(array(\'authpostauth\', \'authonly\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) values ('Customer Notifications', 'MODULE_PAYMENT_PLUGNPAY_DONTSNDMAIL', 'yes', 'Should PlugnPay not email a receipt to the customer?', 'tep_cfg_select_option(array(\'yes\', \'no\'), ');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function) values ('Accepted Credit Cards', 'MODULE_PAYMENT_PLUGNPAY_ACCEPTED_CC', 'Mastercard, Visa', 'The credit cards you currently accept', '_selectOptions(array(\'Amex\',\'Discover\', \'Mastercard\', \'Visa\'), ');


INSERT INTO cc_payment_methods (payment_method,payment_filename,active) VALUES ('plugnpay','plugnpay.php','t');





ALTER TABLE cc_card_archive DROP COLUMN  callback;
-- already present ALTER TABLE cc_card_archive ADD COLUMN  id_timezone int(11) default '0';
ALTER TABLE cc_card_archive ADD COLUMN  voicemail_permitted int(11) NOT NULL default '0';
ALTER TABLE cc_card_archive ADD COLUMN  voicemail_activated smallint(6) NOT NULL default '0';
ALTER TABLE cc_card_archive ADD COLUMN  last_notification timestamp NULL default NULL;
ALTER TABLE cc_card_archive ADD COLUMN  email_notification char(70) collate utf8_bin default NULL;
ALTER TABLE cc_card_archive ADD COLUMN  notify_email smallint(6) NOT NULL default '0';
ALTER TABLE cc_card_archive ADD COLUMN  credit_notification int(11) NOT NULL default '-1';
ALTER TABLE cc_card_archive ADD COLUMN  id_group int(11) NOT NULL default '1';
ALTER TABLE cc_card_archive ADD COLUMN  company_name varchar(50) collate utf8_bin default NULL;
ALTER TABLE cc_card_archive ADD COLUMN  company_website varchar(60) collate utf8_bin default NULL;
ALTER TABLE cc_card_archive ADD COLUMN  VAT_RN varchar(40) collate utf8_bin default NULL;
ALTER TABLE cc_card_archive ADD COLUMN  traffic bigint(20) default NULL;
ALTER TABLE cc_card_archive ADD COLUMN  traffic_target mediumtext collate utf8_bin;
ALTER TABLE cc_card_archive ADD COLUMN  discount decimal(5,2) NOT NULL default '0.00';
ALTER TABLE cc_card_archive ADD COLUMN  restriction tinyint(4) NOT NULL default '0';
ALTER TABLE cc_card_archive DROP COLUMN template_invoice;
ALTER TABLE cc_card_archive DROP COLUMN template_outstanding;
ALTER TABLE cc_card_archive DROP COLUMN mac_addr;
ALTER TABLE cc_card_archive ADD COLUMN mac_addr char(17) collate utf8_bin NOT NULL default '00-00-00-00-00-00';

CREATE TABLE cc_billing_customer (
	id BIGINT NOT NULL AUTO_INCREMENT,
	id_card BIGINT NOT NULL ,
	date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	id_invoice BIGINT NOT NULL ,
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- PLUGNPAY
ALTER TABLE cc_epayment_log ADD COLUMN cvv VARCHAR(4);
ALTER TABLE cc_epayment_log ADD COLUMN credit_card_type VARCHAR(20);
ALTER TABLE cc_epayment_log ADD COLUMN currency VARCHAR(4);


INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) 
VALUES ('PlugnPay Payment URL', 'plugnpay_payment_url', 'https://pay1.plugnpay.com/payment/pnpremote.cgi', 'Define here the URL of PlugnPay gateway.', 0, 5, NULL);


-- Currency handle update
UPDATE cc_configuration SET configuration_description = 'The alternative currency to use for credit card transactions if the system currency is not usable' WHERE configuration_key = 'MODULE_PAYMENT_PAYPAL_CURRENCY';
UPDATE cc_configuration SET configuration_title = 'Alternative Transaction Currency' WHERE configuration_key = 'MODULE_PAYMENT_PAYPAL_CURRENCY';
UPDATE cc_configuration SET configuration_description = 'The alternative currency to use for credit card transactions if the system currency is not usable' WHERE configuration_key = 'MODULE_PAYMENT_MONEYBOOKERS_CURRENCY';
UPDATE cc_configuration SET configuration_title = 'Alternative Transaction Currency' WHERE configuration_key = 'MODULE_PAYMENT_MONEYBOOKERS_CURRENCY';
UPDATE cc_configuration SET set_function = 'tep_cfg_select_option(array(''USD'',''CAD'',''EUR'',''GBP'',''JPY''), ' WHERE configuration_key = 'MODULE_PAYMENT_PAYPAL_CURRENCY';
UPDATE cc_configuration SET set_function = 'tep_cfg_select_option(array(''EUR'', ''USD'', ''GBP'', ''HKD'', ''SGD'', ''JPY'', ''CAD'', ''AUD'', ''CHF'', ''DKK'', ''SEK'', ''NOK'', ''ILS'', ''MYR'', ''NZD'', ''TWD'', ''THB'', ''CZK'', ''HUF'', ''SKK'', ''ISK'', ''INR''), '  WHERE configuration_key = 'MODULE_PAYMENT_MONEYBOOKERS_CURRENCY';

ALTER TABLE cc_payment_methods DROP active;


ALTER TABLE cc_epayment_log ADD transaction_detail LONGTEXT NULL;

ALTER TABLE cc_invoice_item ADD id_billing BIGINT NULL ,
ADD billing_type VARCHAR( 10 ) NULL ;



-- DIDX.NET 
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('DIDX ID', 'didx_id', '708XXX', 'DIDX parameter : ID', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('DIDX PASS', 'didx_pass', 'XXXXXXXXXX', 'DIDX parameter : Password', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('DIDX MIN RATING', 'didx_min_rating', '0', 'DIDX parameter : min rating', 0, 8, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('DIDX RING TO', 'didx_ring_to', '0', 'DIDX parameter : ring to', 0, 8, NULL);

-- Commission Agent
CREATE TABLE cc_agent_commission (
	id BIGINT NOT NULL AUTO_INCREMENT ,
	id_payment BIGINT NULL ,
	id_card BIGINT NOT NULL ,
	date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	amount DECIMAL( 15, 5 ) NOT NULL ,
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_card_group ADD id_agent INT NULL ;

DROP TABLE cc_agent_cardgroup;

ALTER TABLE cc_agent_commission ADD paid_status TINYINT NOT NULL DEFAULT '0';
ALTER TABLE cc_agent_commission ADD description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL ;





-- Card Serial Number
CREATE TABLE cc_card_seria (
	id INT NOT NULL AUTO_INCREMENT ,
	name CHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL,
	value	BIGINT NOT NULL DEFAULT 0,
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
 
ALTER TABLE cc_card ADD id_seria integer;
ALTER TABLE cc_card ADD serial BIGINT;
UPDATE cc_config SET config_description = concat(config_description,', id_seria, serial') WHERE config_key = 'card_show_field_list' ;

DELIMITER //
CREATE TRIGGER cc_card_serial_set BEFORE INSERT ON cc_card
FOR EACH ROW
BEGIN
	UPDATE cc_card_seria set value=value+1  where id=NEW.id_seria ;
	SELECT value INTO @serial from cc_card_seria where id=NEW.id_seria ;
	SET NEW.serial=@serial;
END
//
CREATE TRIGGER cc_card_serial_update BEFORE UPDATE ON cc_card
FOR EACH ROW
BEGIN
	IF NEW.id_seria<>OLD.id_seria OR OLD.id_seria IS NULL THEN
		UPDATE cc_card_seria set value=value+1  where id=NEW.id_seria ;
		SELECT value INTO @serial from cc_card_seria where id=NEW.id_seria ;
		SET NEW.serial=@serial;
	END IF;
END
//
DELIMITER ;
 

INSERT INTO  cc_config (config_title,config_key,config_value,config_description,config_valuetype,config_group_id) values('Card Serial Pad Length','card_serial_length','7','Value of zero padding for serial. If this value set to 3 serial wil looks like 001',0,8);



-- Reserve credit :
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_id, config_listvalues) VALUES ('Dial Balance reservation', 'dial_balance_reservation', '0.25', 'Credit to reserve from the balance when a call is made. This will prevent negative balance on huge peak.', 0, 11, NULL);


-- change the schema to authorize only one login
ALTER TABLE cc_agent ADD UNIQUE (login); 
ALTER TABLE cc_ui_authen ADD UNIQUE (login); 

-- update for invoice
ALTER TABLE cc_charge ADD charged_status TINYINT NOT NULL DEFAULT '0',
ADD invoiced_status TINYINT NOT NULL DEFAULT '0';
ALTER TABLE cc_did_use ADD reminded TINYINT NOT NULL DEFAULT '0';

ALTER TABLE cc_invoice_item CHANGE id_billing id_ext BIGINT( 20 ) NULL DEFAULT NULL;
ALTER TABLE cc_invoice_item CHANGE billing_type type_ext VARCHAR( 10 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;  



-- update on configuration
ALTER TABLE cc_config_group ADD UNIQUE (group_title); 
ALTER TABLE cc_config ADD config_group_title varchar(64) NOT NULL;

UPDATE cc_config SET config_group_title=(SELECT group_title FROM cc_config_group WHERE cc_config_group.id=cc_config.config_group_id);

ALTER TABLE cc_config DROP COLUMN config_group_id;


-- add receipt objects
CREATE TABLE cc_receipt (
	id BIGINT NOT NULL AUTO_INCREMENT ,
	id_card BIGINT NOT NULL ,
	date timestamp NOT NULL default CURRENT_TIMESTAMP,
	title VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	status TINYINT NOT NULL DEFAULT '0',
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE cc_receipt_item (
	id BIGINT NOT NULL AUTO_INCREMENT ,
	id_receipt BIGINT NOT NULL ,
	date timestamp NOT NULL default CURRENT_TIMESTAMP,
	price DECIMAL( 15, 5 ) NOT NULL DEFAULT '0',
	description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	id_ext BIGINT( 20 ) NULL DEFAULT NULL,
	type_ext VARCHAR( 10 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE cc_logpayment CHANGE payment payment DECIMAL( 15, 5 ) NOT NULL;
ALTER TABLE cc_logpayment_agent CHANGE payment payment DECIMAL( 15, 5 ) NOT NULL;  
ALTER TABLE cc_logrefill CHANGE credit credit DECIMAL( 15, 5 ) NOT NULL;
ALTER TABLE cc_logrefill_agent CHANGE credit credit DECIMAL( 15, 5 ) NOT NULL ;


-- changes from recurring services - bound to callplan
alter table cc_service add column operate_mode tinyint default 0;
alter table cc_service add column dialplan integer default 0;
alter table cc_service add column use_group tinyint default 0;

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('Rate Export Fields', 'rate_export_field_list', 'destination, dialprefix, rateinitial', 'Fields to export in csv format from rates table.Use dest_name from prefix name', 0, 'webui', NULL); 



-- ADD SIP REGSERVER
ALTER TABLE cc_sip_buddies ADD regserver varchar(20);


ALTER TABLE cc_logpayment ADD added_commission TINYINT NOT NULL DEFAULT '0';
-- Empty password view for OpenSips
CREATE VIEW cc_sip_buddies_empty AS SELECT
id, id_cc_card, name, accountcode, regexten, amaflags, callgroup, callerid, canreinvite, context, DEFAULTip, dtmfmode, fromuser, fromdomain, host, insecure, language, mailbox, md5secret, nat, permit, deny, mask, pickupgroup, port, qualify, restrictcid, rtptimeout, rtpholdtimeout, '' as secret, type, username, disallow, allow, musiconhold, regseconds, ipaddr, cancallforward, fullcontact, setvar
FROM cc_sip_buddies;


-- remove activatedbyuser
ALTER TABLE cc_card DROP activatedbyuser;


-- Agent epayment

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('HTTP Server Agent', 'http_server_agent', 'http://www.mydomainname.com', 'Set the Server Address of Agent Website, It should be empty for productive Servers.', 0, 'epayment_method', NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('HTTPS Server Agent', 'https_server_agent', 'https://www.mydomainname.com', 'https://localhost - Enter here your Secure Agents Server Address, should not be empty for productive servers.', 0, 'epayment_method', NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('Server Agent IP/Domain', 'http_cookie_domain_agent', '26.63.165.200', 'Enter your Domain Name or IP Address for the Agents application, eg, 26.63.165.200.', 0, 5, NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('Secure Server Agent IP/Domain', 'https_cookie_domain_agent', '26.63.165.200', 'Enter your Secure server Domain Name or IP Address for the Agents application, eg, 26.63.165.200.', 0, 'epayment_method', NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('Application Agent Path', 'http_cookie_path_agent', '/agent/Public/', 'Enter the Physical path of your Agents Application on your server.', 0, 'epayment_method', NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('Secure Application Agent Path', 'https_cookie_path_agent', '/agent/Public/', 'Enter the Physical path of your Agents Application on your Secure Server.', 0, 'epayment_method', NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('Application Agent Physical Path', 'dir_ws_http_catalog_agent', '/agent/Public/', 'Enter the Physical path of your Agents Application on your server.', 0, 'epayment_method', NULL);
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_group_title, config_listvalues) VALUES ('Secure Application Agent Physical Path', 'dir_ws_https_catalog_agent', '/agent/Public/', 'Enter the Physical path of your Agents Application on your Secure server.', 0, 'epayment_method', NULL);

CREATE TABLE cc_epayment_log_agent (
	id BIGINT NOT NULL auto_increment,
	agent_id BIGINT NOT NULL default '0',
	amount DECIMAL( 15, 5 ) NOT NULL default '0',
	vat FLOAT NOT NULL default '0',
	paymentmethod char(50) collate utf8_bin NOT NULL,
	cc_owner varchar(64) collate utf8_bin default NULL,
	cc_number varchar(32) collate utf8_bin default NULL,
	cc_expires varchar(7) collate utf8_bin default NULL,
	creationdate timestamp NOT NULL default CURRENT_TIMESTAMP,
	`status` int(11) NOT NULL default '0',
	cvv varchar(4) collate utf8_bin default NULL,
	credit_card_type varchar(20) collate utf8_bin default NULL,
	currency varchar(4) collate utf8_bin default NULL,
	transaction_detail longtext collate utf8_bin,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_epayment_log CHANGE id id BIGINT NOT NULL AUTO_INCREMENT ,
	CHANGE cardid cardid BIGINT NOT NULL DEFAULT '0',
	CHANGE amount amount DECIMAL( 15, 5 ) NOT NULL DEFAULT '0';

ALTER TABLE cc_payments CHANGE id id BIGINT NOT NULL AUTO_INCREMENT ,
	CHANGE customers_id customers_id BIGINT NOT NULL DEFAULT '0';

CREATE TABLE cc_payments_agent (
	id BIGINT NOT NULL auto_increment,
	agent_id BIGINT collate utf8_bin NOT NULL,
	agent_name varchar(200) collate utf8_bin NOT NULL,
	agent_email_address varchar(96) collate utf8_bin NOT NULL,
	item_name varchar(127) collate utf8_bin default NULL,
	item_id varchar(127) collate utf8_bin default NULL,
	item_quantity int(11) NOT NULL default '0',
	payment_method varchar(32) collate utf8_bin NOT NULL,
	cc_type varchar(20) collate utf8_bin default NULL,
	cc_owner varchar(64) collate utf8_bin default NULL,
	cc_number varchar(32) collate utf8_bin default NULL,
	cc_expires varchar(4) collate utf8_bin default NULL,
	orders_status int(5) NOT NULL,
	orders_amount decimal(14,6) default NULL,
	last_modified datetime default NULL,
	date_purchased datetime default NULL,
	orders_date_finished datetime default NULL,
	currency char(3) collate utf8_bin default NULL,
	currency_value decimal(14,6) default NULL,
	PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


ALTER TABLE cc_agent_commission ADD id_agent INT NOT NULL ;

-- remove reseller field from logpayment & log refill
ALTER TABLE cc_logpayment DROP reseller_id; 
ALTER TABLE cc_logrefill DROP reseller_id;


-- Add notification system
CREATE TABLE cc_notification (
	id 					BIGINT NOT NULL auto_increment,
	key_value 			varchar(40) collate utf8_bin default NULL,
	date 				timestamp NOT NULL default CURRENT_TIMESTAMP,
	priority 			TINYINT NOT NULL DEFAULT '0',
	from_type 			TINYINT NOT NULL ,
	from_id 			BIGINT NULL DEFAULT '0',
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE cc_notification_admin (
	id_notification BIGINT NOT NULL ,
	id_admin INT NOT NULL ,
	viewed TINYINT NOT NULL DEFAULT '0',
	PRIMARY KEY ( id_notification , id_admin )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- Add default value for support box
INSERT INTO cc_support (id ,name) VALUES (1, 'DEFAULT');
INSERT INTO cc_support_component (id ,id_support ,name ,activated) VALUES (1, 1, 'DEFAULT', 1);

DELETE FROM cc_config WHERE config_key = 'sipiaxinfo' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'cdr' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'invoice' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'voucher' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'paypal' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'speeddial' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'did' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'ratecard' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'simulator' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'callback' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'predictivedialer' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'callerid' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'webphone' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'support' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'payment' AND config_group_title = 'webcustomerui';

INSERT INTO cc_config_group (group_title ,group_description)
	VALUES ( 'webagentui', 'This configuration group handles Web Agent Interface.');
INSERT INTO cc_config (`config_title` ,`config_key` ,`config_value` ,`config_description` ,`config_valuetype` ,`config_listvalues` ,`config_group_title`)
	VALUES ( 'Personal Info', 'personalinfo', '1', 'Enable or disable the page which allow agent to modify its personal information.', '0', 'yes,no', 'webagentui');


-- Add index for SIP / IAX Friend
ALTER TABLE cc_iax_buddies ADD INDEX ( name );
ALTER TABLE cc_iax_buddies ADD INDEX ( host );
ALTER TABLE cc_iax_buddies ADD INDEX ( ipaddr );
ALTER TABLE cc_iax_buddies ADD INDEX ( port );

ALTER TABLE cc_sip_buddies ADD INDEX ( name );
ALTER TABLE cc_sip_buddies ADD INDEX ( host );
ALTER TABLE cc_sip_buddies ADD INDEX ( ipaddr );
ALTER TABLE cc_sip_buddies ADD INDEX ( port );


-- add parameters return_url_distant_login & return_url_distant_forgetpassword on webcustomerui
INSERT INTO `cc_config` (`config_title`, `config_key`, `config_value`, `config_description`, `config_valuetype`, `config_listvalues`, `config_group_title`) VALUES('Return URL distant Login', 'return_url_distant_login', '', 'URL for specific return if an error occur after login', 0, NULL, 'webcustomerui');
INSERT INTO `cc_config` (`config_title`, `config_key`, `config_value`, `config_description`, `config_valuetype`, `config_listvalues`, `config_group_title`) VALUES('Return URL distant Forget Password', 'return_url_distant_forgetpassword', '', 'URL for specific return if an error occur after forgetpassword', 0, NULL, 'webcustomerui');

CREATE TABLE cc_agent_signup (
	id BIGINT NOT NULL AUTO_INCREMENT ,
	id_agent INT NOT NULL ,
	code VARCHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL ,
	id_tariffgroup INT NOT NULL ,
	id_group INT NOT NULL ,
	PRIMARY KEY (id) ,
	UNIQUE (code)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

ALTER TABLE cc_agent DROP secret;

-- disable Authorize.net
DELETE FROM cc_payment_methods WHERE payment_method = 'Authorize.Net';
UPDATE cc_configuration SET configuration_value = 'False' WHERE configuration_key = 'MODULE_PAYMENT_AUTHORIZENET_STATUS';

ALTER TABLE cc_epayment_log CHANGE amount amount VARCHAR( 50 ) NOT NULL DEFAULT '0';
ALTER TABLE cc_epayment_log_agent CHANGE amount amount VARCHAR( 50 ) NOT NULL DEFAULT '0';

UPDATE cc_config SET config_value = 'id, username, useralias, lastname, credit, tariff, activated, language, inuse, currency, sip_buddy' WHERE config_key = 'card_export_field_list';
ALTER TABLE cc_tariffgroup CHANGE id_cc_package_offer id_cc_package_offer BIGINT( 20 ) NOT NULL DEFAULT '-1';

ALTER TABLE cc_epayment_log ADD item_type VARCHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_bin NULL ,ADD item_id BIGINT NULL ;


-- Last registration
ALTER TABLE cc_sip_buddies ADD lastms varchar(11);


-- Add new SMTP Settings
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES ('SMTP Port', 'smtp_port', '25', 'Port to connect on the SMTP server', 0, NULL, 'global');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES ('SMTP Secure', 'smtp_secure', '', 'sets the prefix to the SMTP server : tls ; ssl', 0, NULL, 'global');

ALTER TABLE cc_support_component ADD type_user TINYINT NOT NULL DEFAULT '2';


/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/

--
-- A2Billing database script - Update database for MYSQL 5.X
-- 
-- 
-- Usage:
-- mysql -u root -p"root password" < a2billing-prefix-table-v1.4.0.sql
--

-- You may need to modify the UPDATEs near the end of this file to match all your rewritten dial-strings




--
-- Dumping data for table cc_prefix
--

INSERT INTO cc_prefix VALUES(93, 'Afghanistan');
INSERT INTO cc_prefix VALUES(9370, 'Afghanistan Mobile');
INSERT INTO cc_prefix VALUES(9375, 'Afghanistan Mobile');
INSERT INTO cc_prefix VALUES(9377, 'Afghanistan Mobile');
INSERT INTO cc_prefix VALUES(9378, 'Afghanistan Mobile');
INSERT INTO cc_prefix VALUES(9379, 'Afghanistan Mobile');
INSERT INTO cc_prefix VALUES(355, 'Albania');
INSERT INTO cc_prefix VALUES(35567, 'Albania Mobile');
INSERT INTO cc_prefix VALUES(35568, 'Albania Mobile');
INSERT INTO cc_prefix VALUES(35569, 'Albania Mobile');
INSERT INTO cc_prefix VALUES(213, 'Algeria');
INSERT INTO cc_prefix VALUES(2135, 'Algeria Mobile');
INSERT INTO cc_prefix VALUES(2136, 'Algeria Mobile');
INSERT INTO cc_prefix VALUES(2137, 'Algeria Mobile');
INSERT INTO cc_prefix VALUES(2139, 'Algeria Mobile');
INSERT INTO cc_prefix VALUES(1684, 'American Samoa');
INSERT INTO cc_prefix VALUES(684, 'American Samoa');
INSERT INTO cc_prefix VALUES(1684733, 'American Samoa Mobile');
INSERT INTO cc_prefix VALUES(376, 'Andorra');
INSERT INTO cc_prefix VALUES(3763, 'Andorra Mobile');
INSERT INTO cc_prefix VALUES(3764, 'Andorra Mobile');
INSERT INTO cc_prefix VALUES(3766, 'Andorra Mobile');
INSERT INTO cc_prefix VALUES(244, 'Angola');
INSERT INTO cc_prefix VALUES(24491, 'Angola Mobile');
INSERT INTO cc_prefix VALUES(24492, 'Angola Mobile');
INSERT INTO cc_prefix VALUES(1264, 'Anguilla');
INSERT INTO cc_prefix VALUES(1264235, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264469, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264476, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264536, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264537, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264538, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264539, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264581, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264582, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264583, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264584, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264724, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264729, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(1264772, 'Anguilla Mobile');
INSERT INTO cc_prefix VALUES(67210, 'Antarctica');
INSERT INTO cc_prefix VALUES(67211, 'Antarctica');
INSERT INTO cc_prefix VALUES(67212, 'Antarctica');
INSERT INTO cc_prefix VALUES(67213, 'Antarctica');
INSERT INTO cc_prefix VALUES(1268, 'Antigua and Barbuda');
INSERT INTO cc_prefix VALUES(1268406, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268409, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268464, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268720, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268721, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268722, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268723, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268724, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268725, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268726, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268727, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268728, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268729, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268764, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268770, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268771, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268772, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268773, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268774, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268775, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268779, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268780, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268781, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268782, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268783, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268784, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268785, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268786, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(1268788, 'Antigua and Barbuda Mobile');
INSERT INTO cc_prefix VALUES(54, 'Argentina');
INSERT INTO cc_prefix VALUES(549, 'Argentina Mobile');
INSERT INTO cc_prefix VALUES(374, 'Armenia');
INSERT INTO cc_prefix VALUES(37477, 'Armenia Mobile');
INSERT INTO cc_prefix VALUES(3749, 'Armenia Mobile');
INSERT INTO cc_prefix VALUES(297, 'Aruba');
INSERT INTO cc_prefix VALUES(29756, 'Aruba Mobile');
INSERT INTO cc_prefix VALUES(29759, 'Aruba Mobile');
INSERT INTO cc_prefix VALUES(29773, 'Aruba Mobile');
INSERT INTO cc_prefix VALUES(29774, 'Aruba Mobile');
INSERT INTO cc_prefix VALUES(29796, 'Aruba Mobile');
INSERT INTO cc_prefix VALUES(29799, 'Aruba Mobile');
INSERT INTO cc_prefix VALUES(247, 'Ascension Islands');
INSERT INTO cc_prefix VALUES(61, 'Australia');
INSERT INTO cc_prefix VALUES(61145, 'Australia Mobile');
INSERT INTO cc_prefix VALUES(61147, 'Australia Mobile');
INSERT INTO cc_prefix VALUES(6116, 'Australia Mobile');
INSERT INTO cc_prefix VALUES(614, 'Australia Mobile');
INSERT INTO cc_prefix VALUES(43, 'Austria');
INSERT INTO cc_prefix VALUES(43644, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43650, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43660, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43664, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43676, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43677, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43678, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43680, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43681, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43688, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(43699, 'Austria Mobile');
INSERT INTO cc_prefix VALUES(994, 'Azerbaijan');
INSERT INTO cc_prefix VALUES(99440, 'Azerbaijan Mobile');
INSERT INTO cc_prefix VALUES(99450, 'Azerbaijan Mobile');
INSERT INTO cc_prefix VALUES(99451, 'Azerbaijan Mobile');
INSERT INTO cc_prefix VALUES(99455, 'Azerbaijan Mobile');
INSERT INTO cc_prefix VALUES(99470, 'Azerbaijan Mobile');
INSERT INTO cc_prefix VALUES(1242, 'Bahamas');
INSERT INTO cc_prefix VALUES(1242357, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242359, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242375, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242395, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242422, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242423, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242424, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242425, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242426, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242427, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242434, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242436, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242441, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242442, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242454, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242455, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242456, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242457, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242464, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242465, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242466, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242467, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242468, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242475, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242477, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242524, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242525, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242533, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242535, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242544, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242551, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242552, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242553, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242554, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242556, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242557, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242558, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242559, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242565, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242577, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242636, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242646, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(1242727, 'Bahamas Mobile');
INSERT INTO cc_prefix VALUES(973, 'Bahrain');
INSERT INTO cc_prefix VALUES(9733, 'Bahrain Mobile');
INSERT INTO cc_prefix VALUES(880, 'Bangladesh');
INSERT INTO cc_prefix VALUES(8801, 'Bangladesh Mobile');
INSERT INTO cc_prefix VALUES(1246, 'Barbados');
INSERT INTO cc_prefix VALUES(124623, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(124624, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(124625, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(124626, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246446, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246447, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246448, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246449, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(124645, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(124652, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246820, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246821, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246822, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246823, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246824, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246825, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246826, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246827, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246828, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(1246829, 'Barbados Mobile');
INSERT INTO cc_prefix VALUES(375, 'Belarus');
INSERT INTO cc_prefix VALUES(375259, 'Belarus Mobile');
INSERT INTO cc_prefix VALUES(37529, 'Belarus Mobile');
INSERT INTO cc_prefix VALUES(37533, 'Belarus Mobile');
INSERT INTO cc_prefix VALUES(37544, 'Belarus Mobile');
INSERT INTO cc_prefix VALUES(32, 'Belgium');
INSERT INTO cc_prefix VALUES(32484, 'Belgium [Base]');
INSERT INTO cc_prefix VALUES(32485, 'Belgium [Base]');
INSERT INTO cc_prefix VALUES(32486, 'Belgium [Base]');
INSERT INTO cc_prefix VALUES(32487, 'Belgium [Base]');
INSERT INTO cc_prefix VALUES(32488, 'Belgium [Base]');
INSERT INTO cc_prefix VALUES(32494, 'Belgium [Mobistar]');
INSERT INTO cc_prefix VALUES(32495, 'Belgium [Mobistar]');
INSERT INTO cc_prefix VALUES(32496, 'Belgium [Mobistar]');
INSERT INTO cc_prefix VALUES(32497, 'Belgium [Mobistar]');
INSERT INTO cc_prefix VALUES(32498, 'Belgium [Mobistar]');
INSERT INTO cc_prefix VALUES(32499, 'Belgium [Mobistar]');
INSERT INTO cc_prefix VALUES(32472, 'Belgium [Proximus]');
INSERT INTO cc_prefix VALUES(32473, 'Belgium [Proximus]');
INSERT INTO cc_prefix VALUES(32474, 'Belgium [Proximus]');
INSERT INTO cc_prefix VALUES(32475, 'Belgium [Proximus]');
INSERT INTO cc_prefix VALUES(32476, 'Belgium [Proximus]');
INSERT INTO cc_prefix VALUES(32477, 'Belgium [Proximus]');
INSERT INTO cc_prefix VALUES(32478, 'Belgium [Proximus]');
INSERT INTO cc_prefix VALUES(32479, 'Belgium [Proximus]');
INSERT INTO cc_prefix VALUES(3245, 'Belgium Mobile');
INSERT INTO cc_prefix VALUES(3247, 'Belgium Mobile');
INSERT INTO cc_prefix VALUES(3248, 'Belgium Mobile');
INSERT INTO cc_prefix VALUES(3249, 'Belgium Mobile');
INSERT INTO cc_prefix VALUES(501, 'Belize');
INSERT INTO cc_prefix VALUES(5016, 'Belize Mobile');
INSERT INTO cc_prefix VALUES(229, 'Benin');
INSERT INTO cc_prefix VALUES(22990, 'Benin Mobile');
INSERT INTO cc_prefix VALUES(22991, 'Benin Mobile');
INSERT INTO cc_prefix VALUES(22992, 'Benin Mobile');
INSERT INTO cc_prefix VALUES(22993, 'Benin Mobile');
INSERT INTO cc_prefix VALUES(22995, 'Benin Mobile');
INSERT INTO cc_prefix VALUES(22996, 'Benin Mobile');
INSERT INTO cc_prefix VALUES(22997, 'Benin Mobile');
INSERT INTO cc_prefix VALUES(1441, 'Bermuda');
INSERT INTO cc_prefix VALUES(14413, 'Bermuda Mobile');
INSERT INTO cc_prefix VALUES(144150, 'Bermuda Mobile');
INSERT INTO cc_prefix VALUES(144151, 'Bermuda Mobile');
INSERT INTO cc_prefix VALUES(144152, 'Bermuda Mobile');
INSERT INTO cc_prefix VALUES(144153, 'Bermuda Mobile');
INSERT INTO cc_prefix VALUES(1441590, 'Bermuda Mobile');
INSERT INTO cc_prefix VALUES(1441599, 'Bermuda Mobile');
INSERT INTO cc_prefix VALUES(14417, 'Bermuda Mobile');
INSERT INTO cc_prefix VALUES(975, 'Bhutan');
INSERT INTO cc_prefix VALUES(97517, 'Bhutan Mobile');
INSERT INTO cc_prefix VALUES(591, 'Bolivia');
INSERT INTO cc_prefix VALUES(5917, 'Bolivia Mobile');
INSERT INTO cc_prefix VALUES(387, 'Bosnia-Herzegovina');
INSERT INTO cc_prefix VALUES(3876, 'Bosnia-Herzegovina Mobile');
INSERT INTO cc_prefix VALUES(267, 'Botswana');
INSERT INTO cc_prefix VALUES(26771, 'Botswana Mobile');
INSERT INTO cc_prefix VALUES(26772, 'Botswana Mobile');
INSERT INTO cc_prefix VALUES(26773, 'Botswana Mobile');
INSERT INTO cc_prefix VALUES(26774, 'Botswana Mobile');
INSERT INTO cc_prefix VALUES(55, 'Brazil');
INSERT INTO cc_prefix VALUES(55117, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55118, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55119, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551276, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551278, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551281, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551282, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551283, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551284, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551285, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551286, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551287, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551289, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55129, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551376, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551378, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551381, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551382, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551383, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551384, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551385, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551386, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551387, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551389, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55139, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551476, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551478, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551481, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551482, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551483, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551484, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551485, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551486, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551487, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551489, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55149, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551576, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551578, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551581, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551582, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551583, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551584, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551585, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551586, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551587, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551589, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55159, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55167, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551681, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551682, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551683, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551684, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551685, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551686, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551687, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551689, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55169, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55177, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551781, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551782, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551783, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551784, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551785, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551786, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551787, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551789, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55179, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551876, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551878, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551881, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551882, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551883, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551884, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551885, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551886, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551887, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551889, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55189, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551976, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(551978, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55198, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55199, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55217, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55218, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55219, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552278, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55228, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55229, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552478, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55248, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55249, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552778, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55278, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55279, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552878, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552881, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552882, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552883, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552885, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552886, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552887, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(552888, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55289, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553178, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55318, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55319, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553278, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553284, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553285, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553286, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553287, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553288, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55329, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553378, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553384, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553385, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553386, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553387, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553388, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55339, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553478, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553484, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553485, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553486, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553487, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553488, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55349, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553578, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553584, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553585, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553586, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553587, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553588, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55359, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553778, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553784, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553785, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553786, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553787, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553788, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55379, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553878, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553884, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553885, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553886, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553887, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(553888, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55389, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554170, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554178, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554184, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554185, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554188, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55419, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55427, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554284, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554285, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554288, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55429, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554378, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554381, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554384, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554385, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554388, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55439, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554478, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554484, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554485, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554488, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55449, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554578, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554584, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554585, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554588, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55459, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554678, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554684, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554685, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554688, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55469, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55477, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554784, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554785, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554788, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55479, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55487, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554881, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554884, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554885, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554888, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55489, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554978, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554984, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554985, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(554988, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55499, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555178, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55518, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55519, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555378, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555381, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555382, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555384, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555385, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555389, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55539, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555478, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555481, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555482, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555484, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555485, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555489, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55549, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555578, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555581, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555582, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555584, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555585, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(555589, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55559, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556178, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556181, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556182, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556184, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556185, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556189, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55619, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55627, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55628, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55629, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556378, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556381, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556382, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556384, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556385, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556389, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55639, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556478, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556481, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556482, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556484, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556485, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556489, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55649, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556578, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55658, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55659, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556678, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556681, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556682, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556684, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556685, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556688, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556689, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55669, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556778, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556781, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556782, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556784, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556785, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556788, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556789, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55679, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556878, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55688, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55689, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556978, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556981, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556982, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556984, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556985, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556988, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(556989, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55699, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557178, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55718, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55719, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557378, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557381, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557382, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557385, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557386, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557387, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557388, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55739, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557478, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557481, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557482, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557485, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557486, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557487, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557488, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55749, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557578, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557581, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557582, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557585, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557586, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557587, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557588, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55759, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557778, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557781, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557782, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557785, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557786, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557787, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557788, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55779, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557978, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557981, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557982, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557985, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557986, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557987, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(557988, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55799, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55818, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55819, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558285, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558286, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558287, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558288, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55829, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55838, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55839, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55848, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55849, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55858, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55859, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558685, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558686, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558687, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558688, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55869, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558785, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558786, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558787, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558788, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55879, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558885, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558886, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558887, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558888, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55889, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558985, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558986, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558987, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(558988, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55899, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55918, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55919, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55928, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55929, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559381, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559382, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559383, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559385, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559386, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559387, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559388, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559389, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55939, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559481, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559482, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559483, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559485, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559486, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559487, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559488, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559489, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55949, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55958, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55959, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55968, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55969, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559781, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559782, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559783, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559785, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559786, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559787, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559788, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55979, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559881, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559882, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559883, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559885, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559886, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559887, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559888, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(559889, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55989, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55998, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(55999, 'Brazil Mobile');
INSERT INTO cc_prefix VALUES(246, 'British Indian Ocean Territory');
INSERT INTO cc_prefix VALUES(1284, 'British Virgin Islands');
INSERT INTO cc_prefix VALUES(12843, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284301, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284302, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284303, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284440, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284441, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284442, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284443, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284444, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284445, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284468, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(12844966, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(12844967, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(12844968, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(12844969, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284499, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284540, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284541, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284542, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284543, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(1284544, 'British Virgin Islands Mobile');
INSERT INTO cc_prefix VALUES(673, 'Brunei Darussalam');
INSERT INTO cc_prefix VALUES(6738, 'Brunei Darussalam Mobile');
INSERT INTO cc_prefix VALUES(359, 'Bulgaria');
INSERT INTO cc_prefix VALUES(359430, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(359437, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(359438, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(359439, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(35948, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(35987, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(35988, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(35989, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(35998, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(35999, 'Bulgaria Mobile');
INSERT INTO cc_prefix VALUES(226, 'Burkina Faso');
INSERT INTO cc_prefix VALUES(22670, 'Burkina Faso Mobile');
INSERT INTO cc_prefix VALUES(22675, 'Burkina Faso Mobile');
INSERT INTO cc_prefix VALUES(22676, 'Burkina Faso Mobile');
INSERT INTO cc_prefix VALUES(22678, 'Burkina Faso Mobile');
INSERT INTO cc_prefix VALUES(257, 'Burundi');
INSERT INTO cc_prefix VALUES(2572955, 'Burundi Mobile');
INSERT INTO cc_prefix VALUES(25776, 'Burundi Mobile');
INSERT INTO cc_prefix VALUES(25777, 'Burundi Mobile');
INSERT INTO cc_prefix VALUES(25778, 'Burundi Mobile');
INSERT INTO cc_prefix VALUES(25779, 'Burundi Mobile');
INSERT INTO cc_prefix VALUES(855, 'Cambodia');
INSERT INTO cc_prefix VALUES(8551, 'Cambodia Mobile');
INSERT INTO cc_prefix VALUES(85589, 'Cambodia Mobile');
INSERT INTO cc_prefix VALUES(8559, 'Cambodia Mobile');
INSERT INTO cc_prefix VALUES(237, 'Cameroon');
INSERT INTO cc_prefix VALUES(2377, 'Cameroon Mobile');
INSERT INTO cc_prefix VALUES(2379, 'Cameroon Mobile');
INSERT INTO cc_prefix VALUES(1204, 'Canada');
INSERT INTO cc_prefix VALUES(1226, 'Canada');
INSERT INTO cc_prefix VALUES(1250, 'Canada');
INSERT INTO cc_prefix VALUES(1289, 'Canada');
INSERT INTO cc_prefix VALUES(1306, 'Canada');
INSERT INTO cc_prefix VALUES(1403, 'Canada');
INSERT INTO cc_prefix VALUES(1416, 'Canada');
INSERT INTO cc_prefix VALUES(1418, 'Canada');
INSERT INTO cc_prefix VALUES(1438, 'Canada');
INSERT INTO cc_prefix VALUES(1450, 'Canada');
INSERT INTO cc_prefix VALUES(1506, 'Canada');
INSERT INTO cc_prefix VALUES(1514, 'Canada');
INSERT INTO cc_prefix VALUES(1519, 'Canada');
INSERT INTO cc_prefix VALUES(1581, 'Canada');
INSERT INTO cc_prefix VALUES(1587, 'Canada');
INSERT INTO cc_prefix VALUES(16, 'Canada');
INSERT INTO cc_prefix VALUES(1604, 'Canada');
INSERT INTO cc_prefix VALUES(1613, 'Canada');
INSERT INTO cc_prefix VALUES(1647, 'Canada');
INSERT INTO cc_prefix VALUES(1705, 'Canada');
INSERT INTO cc_prefix VALUES(1709, 'Canada');
INSERT INTO cc_prefix VALUES(1778, 'Canada');
INSERT INTO cc_prefix VALUES(1780, 'Canada');
INSERT INTO cc_prefix VALUES(1807, 'Canada');
INSERT INTO cc_prefix VALUES(1819, 'Canada');
INSERT INTO cc_prefix VALUES(1867, 'Canada');
INSERT INTO cc_prefix VALUES(1871, 'Canada');
INSERT INTO cc_prefix VALUES(1902, 'Canada');
INSERT INTO cc_prefix VALUES(1905, 'Canada');
INSERT INTO cc_prefix VALUES(238, 'Cape Verde');
INSERT INTO cc_prefix VALUES(23891, 'Cape Verde Mobile');
INSERT INTO cc_prefix VALUES(23897, 'Cape Verde Mobile');
INSERT INTO cc_prefix VALUES(23898, 'Cape Verde Mobile');
INSERT INTO cc_prefix VALUES(23899, 'Cape Verde Mobile');
INSERT INTO cc_prefix VALUES(1345, 'Cayman Islands');
INSERT INTO cc_prefix VALUES(1345229, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345321, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345322, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345323, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345324, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345325, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345326, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345327, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345328, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345329, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345516, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345517, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345525, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345526, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345527, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345547, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345548, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345916, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345917, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345919, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345924, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345925, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345926, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345927, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345928, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345929, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345930, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345938, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(1345939, 'Cayman Islands Mobile');
INSERT INTO cc_prefix VALUES(236, 'Central African Republic');
INSERT INTO cc_prefix VALUES(23670, 'Central African Republic Mobil');
INSERT INTO cc_prefix VALUES(23672, 'Central African Republic Mobil');
INSERT INTO cc_prefix VALUES(23675, 'Central African Republic Mobil');
INSERT INTO cc_prefix VALUES(23677, 'Central African Republic Mobil');
INSERT INTO cc_prefix VALUES(235, 'Chad');
INSERT INTO cc_prefix VALUES(2352, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(23530, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(23531, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(23532, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(23533, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(23534, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(23535, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(2356, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(2357, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(2359, 'Chad Mobile');
INSERT INTO cc_prefix VALUES(56, 'Falkland Islands Mobile');
INSERT INTO cc_prefix VALUES(568, 'Chile Mobile');
INSERT INTO cc_prefix VALUES(569, 'Chile Mobile');
INSERT INTO cc_prefix VALUES(86, 'China');
INSERT INTO cc_prefix VALUES(8613, 'China Mobile');
INSERT INTO cc_prefix VALUES(8615, 'China Mobile');
INSERT INTO cc_prefix VALUES(86189, 'China Mobile');
INSERT INTO cc_prefix VALUES(57, 'Colombia');
INSERT INTO cc_prefix VALUES(57310, 'Colombia [Comcel]');
INSERT INTO cc_prefix VALUES(57311, 'Colombia [Comcel]');
INSERT INTO cc_prefix VALUES(57312, 'Colombia [Comcel]');
INSERT INTO cc_prefix VALUES(57313, 'Colombia [Comcel]');
INSERT INTO cc_prefix VALUES(57314, 'Colombia [Comcel]');
INSERT INTO cc_prefix VALUES(57315, 'Colombia [Movistar]');
INSERT INTO cc_prefix VALUES(57316, 'Colombia [Movistar]');
INSERT INTO cc_prefix VALUES(57317, 'Colombia [Movistar]');
INSERT INTO cc_prefix VALUES(57318, 'Colombia [Movistar]');
INSERT INTO cc_prefix VALUES(573, 'Colombia Mobile');
INSERT INTO cc_prefix VALUES(57301, 'Colombia [Ola]');
INSERT INTO cc_prefix VALUES(57304, 'Colombia [Ola]');
INSERT INTO cc_prefix VALUES(269, 'Comoros');
INSERT INTO cc_prefix VALUES(2693, 'Comoros Mobile');
INSERT INTO cc_prefix VALUES(242, 'Congo');
INSERT INTO cc_prefix VALUES(243, 'Congo Democratic Republic');
INSERT INTO cc_prefix VALUES(24322, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24378, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24380, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24381, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24384, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24385, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24388, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24389, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24397, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24398, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(24399, 'Congo Democratic Republic Mobi');
INSERT INTO cc_prefix VALUES(2424, 'Congo Mobile');
INSERT INTO cc_prefix VALUES(2425, 'Congo Mobile');
INSERT INTO cc_prefix VALUES(2426, 'Congo Mobile');
INSERT INTO cc_prefix VALUES(682, 'Cook Islands');
INSERT INTO cc_prefix VALUES(68250, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(68251, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(68252, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(68253, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(68254, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(68255, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(68256, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(68258, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(6827, 'Cook Islands Mobile');
INSERT INTO cc_prefix VALUES(506, 'Costa Rica');
INSERT INTO cc_prefix VALUES(5068, 'Costa Rica Mobile');
INSERT INTO cc_prefix VALUES(385, 'Croatia');
INSERT INTO cc_prefix VALUES(38591, 'Croatia Mobile');
INSERT INTO cc_prefix VALUES(38592, 'Croatia Mobile');
INSERT INTO cc_prefix VALUES(38595, 'Croatia Mobile');
INSERT INTO cc_prefix VALUES(38597, 'Croatia Mobile');
INSERT INTO cc_prefix VALUES(38598, 'Croatia Mobile');
INSERT INTO cc_prefix VALUES(38599, 'Croatia Mobile');
INSERT INTO cc_prefix VALUES(53, 'Cuba');
INSERT INTO cc_prefix VALUES(5352, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(5358, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(537750, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(537751, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(537752, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(537753, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(537754, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(537755, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(537756, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(537758, 'Cuba Mobile');
INSERT INTO cc_prefix VALUES(357, 'Cyprus');
INSERT INTO cc_prefix VALUES(35796, 'Cyprus Mobile');
INSERT INTO cc_prefix VALUES(357976, 'Cyprus Mobile');
INSERT INTO cc_prefix VALUES(357977, 'Cyprus Mobile');
INSERT INTO cc_prefix VALUES(35799, 'Cyprus Mobile');
INSERT INTO cc_prefix VALUES(420, 'Czech Republic');
INSERT INTO cc_prefix VALUES(42060, 'Czech Republic Mobile');
INSERT INTO cc_prefix VALUES(42072, 'Czech Republic Mobile');
INSERT INTO cc_prefix VALUES(42073, 'Czech Republic Mobile');
INSERT INTO cc_prefix VALUES(42077, 'Czech Republic Mobile');
INSERT INTO cc_prefix VALUES(42079, 'Czech Republic Mobile');
INSERT INTO cc_prefix VALUES(42093, 'Czech Republic Mobile');
INSERT INTO cc_prefix VALUES(42096, 'Czech Republic Mobile');
INSERT INTO cc_prefix VALUES(45, 'Denmark');
INSERT INTO cc_prefix VALUES(452, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(4530, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(4531, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(4540, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45411, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45412, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45413, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45414, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45415, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45416, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45417, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45418, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45419, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45420, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45421, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45422, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45423, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45424, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45425, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454260, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454270, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454276, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454277, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454278, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454279, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454280, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454281, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454282, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454283, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454284, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454285, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454286, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454287, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454288, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454289, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454290, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454291, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454292, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454293, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454294, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454295, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454296, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454297, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454298, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(454299, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(4550, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(4551, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455210, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455211, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455212, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455213, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455214, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455215, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455216, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455217, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455218, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455219, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455220, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455221, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455222, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455223, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455224, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455225, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455226, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455227, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455228, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455229, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455230, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455231, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455232, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455233, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455234, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455235, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455236, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455237, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455238, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455239, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455240, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455241, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455242, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455243, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455244, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455245, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455246, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455247, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455249, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455250, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455252, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455253, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455255, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455258, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455260, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455262, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455266, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455270, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455271, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455272, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455273, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455274, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455275, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455276, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455277, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455280, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455282, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455288, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455290, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455292, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455299, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455310, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455311, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455312, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455314, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455315, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455316, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455317, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455318, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455319, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45532, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455330, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455331, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455332, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455333, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455334, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455335, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455336, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455337, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455338, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(455339, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45534, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45535, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45536, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45537, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45538, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(45539, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(4560, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(4561, 'Denmark Mobile');
INSERT INTO cc_prefix VALUES(253, 'Djibouti');
INSERT INTO cc_prefix VALUES(2536, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(25380, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(25381, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(25382, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(25383, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(25384, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(25385, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(25386, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(25387, 'Djibouti Mobile');
INSERT INTO cc_prefix VALUES(1767, 'Dominica');
INSERT INTO cc_prefix VALUES(1767225, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767235, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767245, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767265, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767275, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767276, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767277, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767315, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767316, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767317, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767611, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767612, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767613, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767614, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767615, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767616, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1767617, 'Dominica Mobile');
INSERT INTO cc_prefix VALUES(1809, 'Dominican Republic');
INSERT INTO cc_prefix VALUES(1829, 'Dominican Republic');
INSERT INTO cc_prefix VALUES(1809201, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809203, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809204, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809205, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809206, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809207, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809208, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809209, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809210, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809212, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809214, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809215, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809216, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809217, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809218, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809219, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092223, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092224, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092225, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809223, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809224, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809225, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809228, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809229, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809230, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809232, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809235, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092480, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092482, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092484, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092485, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092486, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092487, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092488, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809249, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809250, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809251, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809252, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809253, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809254, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809256, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809257, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809258, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809259, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809260, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809264, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092651, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092652, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092653, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092654, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092655, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092656, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092657, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092658, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18092659, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809266, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809267, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809268, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809269, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809270, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809271, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809272, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809280, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809281, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809282, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809283, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809284, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809292, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809293, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809297, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809298, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809299, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809301, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809302, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809303, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809304, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809305, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809306, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809307, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809308, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809309, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809310, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809313, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809315, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809316, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809317, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809318, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809319, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809321, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809322, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809323, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809324, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809325, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809326, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809327, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809330, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809340, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809341, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809342, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809343, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809344, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809345, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809348, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809350, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809351, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809352, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809353, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809354, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809355, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809356, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809357, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809358, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809359, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809360, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809361, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809366, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809370, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809371, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809374, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809376, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809377, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809383, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809386, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809387, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809389, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809390, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809391, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809392, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809393, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809394, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809395, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809396, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809397, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809398, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809399, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809401, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809402, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809403, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809404, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809405, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809406, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809407, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809408, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809409, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809410, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809413, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809415, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809416, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809417, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809418, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809419, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809420, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809421, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809423, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809424, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809425, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809426, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809427, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809428, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809429, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809430, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809431, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809432, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809433, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809434, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809436, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809437, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809438, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809439, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809440, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809441, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809442, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809443, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809444, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809445, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809446, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809447, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809448, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809449, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809451, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809452, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809453, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809454, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809456, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809457, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809458, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809459, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809460, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809461, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809462, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809463, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809464, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809465, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809467, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18094701, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18094702, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18094703, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18094704, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18094705, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18094706, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18094707, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18094708, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809474, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809475, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809477, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809478, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809479, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809481, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809484, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809485, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809486, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809488, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809490, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809491, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809492, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809493, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809494, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809495, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809496, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809497, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809498, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809499, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809501, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809502, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809504, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809505, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809506, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809507, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809509, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809510, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809512, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809513, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809514, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809515, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809516, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809517, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809519, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809520, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180954290, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180954291, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180954292, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180954293, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180954295, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180954296, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180954297, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180954298, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809543, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18095450, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18095451, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18095454, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18095456, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18095459, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809546, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809601, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809602, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809603, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809604, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809605, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809606, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809607, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809608, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809609, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809610, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809613, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809614, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809615, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809617, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809618, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809619, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809624, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809627, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809628, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809629, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809630, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809631, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809632, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809634, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809635, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809636, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809637, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809639, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809640, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809641, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809642, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809643, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809644, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809645, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809646, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809647, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809648, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809649, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809650, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809651, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809652, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809653, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809654, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809656, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809657, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809658, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809659, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809660, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809661, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809662, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809663, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809664, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809665, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809666, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809667, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809668, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809669, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809670, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809671, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809672, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809673, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809674, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809675, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809676, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809677, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809678, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809693, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809694, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809696, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809697, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809698, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809702, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809703, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809704, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809705, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809706, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809707, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809708, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809709, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809710, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809712, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809713, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809714, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809715, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809716, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809717, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809718, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809719, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809720, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809721, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809722, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809723, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809727, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809729, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18097421, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18097422, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809743, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809747, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809749, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809750, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809751, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809752, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809753, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809754, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809756, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809757, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809758, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809759, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809760, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809761, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809762, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809763, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809764, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809765, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809767, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809768, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809769, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809771, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809772, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809773, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809774, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809775, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809776, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809777, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809778, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809779, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809780, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809781, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809782, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809783, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809785, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809786, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809787, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809789, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809790, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809791, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809796, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809798, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809801, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809802, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809803, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809804, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809805, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809806, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809807, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809808, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809810, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809812, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809814, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809815, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809816, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809817, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809818, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809819, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809820, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809821, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809827, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809828, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809829, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809834, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809835, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809836, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809837, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809838, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809839, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809840, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809841, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809842, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809843, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809844, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809845, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809846, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809847, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809848, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809849, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809850, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809851, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809852, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809853, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809854, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809855, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809856, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809857, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809858, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18098597, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(18098598, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180985990, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180985991, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180985992, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180985993, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180985994, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180985995, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180985996, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(180985997, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809860, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809861, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809862, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809863, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809864, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809865, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809866, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809867, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809868, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809869, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809871, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809873, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809874, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809875, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809876, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809877, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809878, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809879, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809880, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809881, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809882, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809883, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809884, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809885, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809886, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809888, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809889, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809890, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809891, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809899, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809901, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809902, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809903, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809904, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809905, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809906, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809907, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809908, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809909, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809910, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809912, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809913, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809914, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809915, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809916, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809917, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809918, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809919, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809923, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809924, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809928, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809929, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809931, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809932, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809935, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809938, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809939, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809940, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809941, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809942, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809943, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809944, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809945, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809946, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809949, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809952, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809953, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809956, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809958, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809961, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809962, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809963, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809964, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809965, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809966, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809967, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809968, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809969, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809972, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809973, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809974, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809975, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809977, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809978, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809979, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809980, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809981, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809982, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809983, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809984, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809986, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809988, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809989, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809990, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809991, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809992, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809993, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809994, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809995, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809996, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809997, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809998, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1809999, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829201, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829202, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829203, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829204, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829205, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829206, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829207, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829208, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829209, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829210, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829212, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829214, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829215, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829221, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829222, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829230, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829232, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829233, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829248, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829250, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829252, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829255, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829257, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829258, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829259, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829260, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829261, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829262, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829263, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829264, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829265, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829266, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829267, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829268, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829269, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829270, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829271, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829272, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829273, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829274, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829275, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829276, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829277, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829278, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829279, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829280, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829281, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829282, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829283, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829284, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829285, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829286, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829287, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829288, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829290, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829296, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829297, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829298, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829299, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829301, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829303, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829304, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829305, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829306, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829307, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829308, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829309, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829313, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829314, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829315, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829316, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829317, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829318, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829319, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829320, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829321, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829322, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829323, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829328, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829329, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829330, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829331, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829332, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829333, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829334, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829335, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829336, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829337, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829338, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829339, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829340, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829341, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829342, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829343, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829344, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829345, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829346, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829347, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829348, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829349, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829350, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829351, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829352, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829353, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829354, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829355, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829356, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829357, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829358, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829359, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829360, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829361, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829362, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829363, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829364, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829365, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829366, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829367, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829368, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829369, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829370, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829371, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829372, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829373, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829375, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829376, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829377, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829379, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829380, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829383, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829386, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829387, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829388, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829389, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829390, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829392, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829393, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829394, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829395, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829396, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829397, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829398, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829399, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829401, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829402, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829403, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829404, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829405, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829406, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829407, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829408, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829409, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829410, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829412, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829413, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829414, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829415, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829416, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829417, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829422, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829424, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829425, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829426, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829427, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829428, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829429, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829430, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829432, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829440, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829441, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829442, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829443, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829444, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829445, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829446, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829447, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829448, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829449, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829450, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829451, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829452, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829453, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829454, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829456, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829465, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829470, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829471, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829472, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829474, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829543, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829601, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829602, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829603, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829604, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829605, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829610, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829613, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829616, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829630, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829633, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829640, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829644, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829646, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829650, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829653, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829654, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829655, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829657, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829660, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829661, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829662, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829663, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829664, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829665, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829667, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829668, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829669, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829676, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829677, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829678, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829686, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829696, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829697, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829699, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829701, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829702, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829703, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829704, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829705, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829706, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829707, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829709, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829710, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829712, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829713, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829714, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829715, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829716, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829717, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829718, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829719, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829720, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829721, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829722, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829723, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829725, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829726, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829727, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829728, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829729, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829730, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829731, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829740, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829744, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829747, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829750, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829754, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829755, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829757, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829760, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829766, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829770, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829777, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829779, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829780, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829787, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829788, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829790, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829797, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829799, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829801, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829802, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829803, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829804, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829805, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829806, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829807, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829808, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829810, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829815, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829816, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829817, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829818, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829819, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829820, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829826, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829830, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829838, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829845, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829846, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829847, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829848, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829849, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829850, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829851, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829852, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829853, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829854, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829855, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829856, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829857, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829858, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829859, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829860, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829861, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829862, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829863, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829864, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829865, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829866, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829867, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829868, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829869, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829870, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829873, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829875, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829876, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829877, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829878, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829879, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829880, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829881, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829882, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829883, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829884, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829885, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829886, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829887, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829889, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829890, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829891, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829892, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829898, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829899, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829901, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829902, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829903, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829904, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829905, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829906, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829907, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829908, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829909, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829910, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829912, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829913, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829914, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829915, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829916, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829917, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829918, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829919, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829920, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829921, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829922, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829923, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829924, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829925, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829926, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829929, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829930, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829931, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829933, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829935, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829939, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829958, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829961, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829962, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829963, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829964, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829965, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829966, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829967, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829968, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829969, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829970, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829972, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829973, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829974, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829975, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829977, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829978, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829979, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829980, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829981, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829982, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829983, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829984, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829986, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829990, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829991, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829993, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(1829994, 'Dominican Republic Mobile');
INSERT INTO cc_prefix VALUES(670, 'East Timor');
INSERT INTO cc_prefix VALUES(67071, 'East Timor Mobile');
INSERT INTO cc_prefix VALUES(67072, 'East Timor Mobile');
INSERT INTO cc_prefix VALUES(67073, 'East Timor Mobile');
INSERT INTO cc_prefix VALUES(67079, 'East Timor Mobile');
INSERT INTO cc_prefix VALUES(593, 'Ecuador');
INSERT INTO cc_prefix VALUES(5938, 'Ecuador Mobile');
INSERT INTO cc_prefix VALUES(5939, 'Ecuador Mobile');
INSERT INTO cc_prefix VALUES(20, 'Egypt');
INSERT INTO cc_prefix VALUES(2010, 'Egypt Mobile');
INSERT INTO cc_prefix VALUES(2011, 'Egypt Mobile');
INSERT INTO cc_prefix VALUES(2012, 'Egypt Mobile');
INSERT INTO cc_prefix VALUES(2016, 'Egypt Mobile');
INSERT INTO cc_prefix VALUES(2017, 'Egypt Mobile');
INSERT INTO cc_prefix VALUES(2018, 'Egypt Mobile');
INSERT INTO cc_prefix VALUES(2019, 'Egypt Mobile');
INSERT INTO cc_prefix VALUES(503, 'El Salvador');
INSERT INTO cc_prefix VALUES(5037, 'El Salvador Mobile');
INSERT INTO cc_prefix VALUES(5038, 'El Salvador Mobile');
INSERT INTO cc_prefix VALUES(240, 'Equatorial Guinea');
INSERT INTO cc_prefix VALUES(2402, 'Equatorial Guinea Mobile');
INSERT INTO cc_prefix VALUES(2405, 'Equatorial Guinea Mobile');
INSERT INTO cc_prefix VALUES(2406, 'Equatorial Guinea Mobile');
INSERT INTO cc_prefix VALUES(291, 'Eritrea');
INSERT INTO cc_prefix VALUES(291171, 'Eritrea Mobile');
INSERT INTO cc_prefix VALUES(291172, 'Eritrea Mobile');
INSERT INTO cc_prefix VALUES(291173, 'Eritrea Mobile');
INSERT INTO cc_prefix VALUES(2917, 'Eritrea Mobile');
INSERT INTO cc_prefix VALUES(372, 'Estonia');
INSERT INTO cc_prefix VALUES(3725, 'Estonia Mobile');
INSERT INTO cc_prefix VALUES(251, 'Ethiopia');
INSERT INTO cc_prefix VALUES(25191, 'Ethiopia Mobile');
INSERT INTO cc_prefix VALUES(251958, 'Ethiopia Mobile');
INSERT INTO cc_prefix VALUES(251959, 'Ethiopia Mobile');
INSERT INTO cc_prefix VALUES(25198, 'Ethiopia Mobile');
INSERT INTO cc_prefix VALUES(298, 'Faeroes Islands');
INSERT INTO cc_prefix VALUES(29821, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29822, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29823, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29824, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29825, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29826, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29827, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29828, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29829, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(2985, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29871, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29872, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29873, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29874, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29875, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29876, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29877, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29879, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29891, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29892, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29893, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29894, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29895, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29896, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29897, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29898, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(29899, 'Faeroes Islands Mobile');
INSERT INTO cc_prefix VALUES(5, 'Falkland Islands');
INSERT INTO cc_prefix VALUES(679, 'Fiji');
INSERT INTO cc_prefix VALUES(67970, 'Fiji Mobile');
INSERT INTO cc_prefix VALUES(67971, 'Fiji Mobile');
INSERT INTO cc_prefix VALUES(67972, 'Fiji Mobile');
INSERT INTO cc_prefix VALUES(67973, 'Fiji Mobile');
INSERT INTO cc_prefix VALUES(67974, 'Fiji Mobile');
INSERT INTO cc_prefix VALUES(67983, 'Fiji Mobile');
INSERT INTO cc_prefix VALUES(67984, 'Fiji Mobile');
INSERT INTO cc_prefix VALUES(6799, 'Fiji Mobile');
INSERT INTO cc_prefix VALUES(358, 'Finland');
INSERT INTO cc_prefix VALUES(3584, 'Finland Mobile');
INSERT INTO cc_prefix VALUES(35850, 'Finland Mobile');
INSERT INTO cc_prefix VALUES(33, 'France');
INSERT INTO cc_prefix VALUES(33650, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33653, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33659, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33660, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33661, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33662, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33663, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33664, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33665, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33666, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33667, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33668, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33669, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33698, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33699, 'France [Bouygues Telecom]');
INSERT INTO cc_prefix VALUES(33607, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33608, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33630, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33631, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33632, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33633, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33637, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33642, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33643, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33645, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33654, 'France [Orange]');
INSERT INTO cc_prefix VALUES(3367, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33670, 'France [Orange]');
INSERT INTO cc_prefix VALUES(3368, 'France [Orange]');
INSERT INTO cc_prefix VALUES(33603, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33605, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33609, 'France [SFR]');
INSERT INTO cc_prefix VALUES(3361, 'France [SFR]');
INSERT INTO cc_prefix VALUES(3362, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33620, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33621, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33622, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33623, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33624, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33625, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33626, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33627, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33628, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33629, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33634, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33635, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33636, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33641, 'France [SFR]');
INSERT INTO cc_prefix VALUES(33655, 'France [SFR]');
INSERT INTO cc_prefix VALUES(336, 'France Mobile');
INSERT INTO cc_prefix VALUES(33594, 'French Guiana');
INSERT INTO cc_prefix VALUES(594, 'French Guiana');
INSERT INTO cc_prefix VALUES(594694, 'French Guiana Mobile');
INSERT INTO cc_prefix VALUES(689, 'French Polynesia');
INSERT INTO cc_prefix VALUES(6892, 'French Polynesia Mobile');
INSERT INTO cc_prefix VALUES(68930, 'French Polynesia Mobile');
INSERT INTO cc_prefix VALUES(68931, 'French Polynesia Mobile');
INSERT INTO cc_prefix VALUES(6897, 'French Polynesia Mobile');
INSERT INTO cc_prefix VALUES(241, 'Gabon');
INSERT INTO cc_prefix VALUES(24103, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24104, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24105, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24106, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24107, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24108, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24109, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24110, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24111, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24114, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24115, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24120, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24121, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24122, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24123, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24124, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24125, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24126, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24127, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24128, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24129, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24130, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24131, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24132, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24133, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24134, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24135, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24136, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24137, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24138, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24139, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24141, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24151, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24152, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24153, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24157, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24161, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24163, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24168, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24175, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24180, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24181, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24184, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24185, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24187, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24189, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24191, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24194, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24195, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(24197, 'Gabon Mobile');
INSERT INTO cc_prefix VALUES(220, 'Gambia');
INSERT INTO cc_prefix VALUES(2206, 'Gambia Mobile');
INSERT INTO cc_prefix VALUES(2207, 'Gambia Mobile');
INSERT INTO cc_prefix VALUES(2209, 'Gambia Mobile');
INSERT INTO cc_prefix VALUES(995, 'Georgia');
INSERT INTO cc_prefix VALUES(99555, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99557, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99558, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99577, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99590, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99591, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99593, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99595, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99597, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99598, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(99599, 'Georgia Mobile');
INSERT INTO cc_prefix VALUES(49, 'Germany');
INSERT INTO cc_prefix VALUES(49150, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49151, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49152, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49155, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49156, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49157, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49159, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49160, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49162, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49163, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49170, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49171, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49172, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49173, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49174, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49175, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49176, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49177, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49178, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(49179, 'Germany Mobile');
INSERT INTO cc_prefix VALUES(233, 'Ghana');
INSERT INTO cc_prefix VALUES(23320, 'Ghana Mobile');
INSERT INTO cc_prefix VALUES(2332170, 'Ghana Mobile');
INSERT INTO cc_prefix VALUES(2332260, 'Ghana Mobile');
INSERT INTO cc_prefix VALUES(23324, 'Ghana Mobile');
INSERT INTO cc_prefix VALUES(23327, 'Ghana Mobile');
INSERT INTO cc_prefix VALUES(23328, 'Ghana Mobile');
INSERT INTO cc_prefix VALUES(350, 'Gibraltar');
INSERT INTO cc_prefix VALUES(35054, 'Gibraltar Mobile');
INSERT INTO cc_prefix VALUES(35056, 'Gibraltar Mobile');
INSERT INTO cc_prefix VALUES(35057, 'Gibraltar Mobile');
INSERT INTO cc_prefix VALUES(35058, 'Gibraltar Mobile');
INSERT INTO cc_prefix VALUES(35060, 'Gibraltar Mobile');
INSERT INTO cc_prefix VALUES(30, 'Greece');
INSERT INTO cc_prefix VALUES(3069, 'Greece Mobile');
INSERT INTO cc_prefix VALUES(299, 'Greenland');
INSERT INTO cc_prefix VALUES(2992, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29942, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29946, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29947, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29948, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29949, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29950, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29952, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29953, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29954, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29955, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29956, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29957, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29958, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(29959, 'Greenland Mobile');
INSERT INTO cc_prefix VALUES(1473, 'Grenada');
INSERT INTO cc_prefix VALUES(1473403, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473404, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473405, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473406, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473407, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473409, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473410, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473414, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473415, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473416, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473417, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473418, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473419, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473420, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473456, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473457, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473458, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473459, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473533, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473534, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473535, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473536, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473537, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(1473538, 'Grenada Mobile');
INSERT INTO cc_prefix VALUES(33590, 'Guadeloupe');
INSERT INTO cc_prefix VALUES(590, 'Guadeloupe');
INSERT INTO cc_prefix VALUES(590690, 'Guadeloupe Mobile');
INSERT INTO cc_prefix VALUES(1671, 'Guam');
INSERT INTO cc_prefix VALUES(502, 'Guatemala');
INSERT INTO cc_prefix VALUES(5024, 'Guatemala Mobile');
INSERT INTO cc_prefix VALUES(5025, 'Guatemala Mobile');
INSERT INTO cc_prefix VALUES(224, 'Guinea');
INSERT INTO cc_prefix VALUES(22460, 'Guinea Mobile');
INSERT INTO cc_prefix VALUES(22462, 'Guinea Mobile');
INSERT INTO cc_prefix VALUES(22463, 'Guinea Mobile');
INSERT INTO cc_prefix VALUES(22464, 'Guinea Mobile');
INSERT INTO cc_prefix VALUES(22465, 'Guinea Mobile');
INSERT INTO cc_prefix VALUES(22467, 'Guinea Mobile');
INSERT INTO cc_prefix VALUES(245, 'Guinea-Bissau');
INSERT INTO cc_prefix VALUES(2455, 'Guinea-Bissau Mobile');
INSERT INTO cc_prefix VALUES(2456, 'Guinea-Bissau Mobile');
INSERT INTO cc_prefix VALUES(2457, 'Guinea-Bissau Mobile');
INSERT INTO cc_prefix VALUES(592, 'Guyana');
INSERT INTO cc_prefix VALUES(592214, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592224, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592248, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592278, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592284, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592294, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592304, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592374, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592384, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592394, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(5926, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592601, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592602, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592603, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592604, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592609, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592610, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592611, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592612, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592613, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592614, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592616, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592617, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(59262, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592630, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592633, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592634, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592635, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592638, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592639, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(59264, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592650, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592651, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592652, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592653, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592654, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592655, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592656, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592657, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(592658, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(59266, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(59267, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(59268, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(59269, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(5928, 'Guyana Mobile');
INSERT INTO cc_prefix VALUES(509, 'Haiti');
INSERT INTO cc_prefix VALUES(5093, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(5094, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(509561, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(509562, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(509563, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(509564, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(509565, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(5096, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(5097, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(50981, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(50982, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(50983, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(50990, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(50991, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(50992, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(50993, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(50994, 'Haiti Mobile');
INSERT INTO cc_prefix VALUES(504, 'Honduras');
INSERT INTO cc_prefix VALUES(5043, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(5047214, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(5047215, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(5047217, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504881, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504882, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504883, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504884, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504885, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504886, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504887, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504888, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504889, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504890, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504891, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504892, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504893, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504894, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504895, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504896, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504897, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504898, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(504899, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(5049, 'Honduras Mobile');
INSERT INTO cc_prefix VALUES(852, 'Hong Kong');
INSERT INTO cc_prefix VALUES(85217, 'Hong Kong Mobile');
INSERT INTO cc_prefix VALUES(85251, 'Hong Kong Mobile');
INSERT INTO cc_prefix VALUES(85253, 'Hong Kong Mobile');
INSERT INTO cc_prefix VALUES(85254, 'Hong Kong Mobile');
INSERT INTO cc_prefix VALUES(85256, 'Hong Kong Mobile');
INSERT INTO cc_prefix VALUES(85259, 'Hong Kong Mobile');
INSERT INTO cc_prefix VALUES(8526, 'Hong Kong Mobile');
INSERT INTO cc_prefix VALUES(8529, 'Hong Kong Mobile');
INSERT INTO cc_prefix VALUES(36, 'Hungary');
INSERT INTO cc_prefix VALUES(3620, 'Hungary Mobile');
INSERT INTO cc_prefix VALUES(3630, 'Hungary Mobile');
INSERT INTO cc_prefix VALUES(3650, 'Hungary Mobile');
INSERT INTO cc_prefix VALUES(3660, 'Hungary Mobile');
INSERT INTO cc_prefix VALUES(3670, 'Hungary Mobile');
INSERT INTO cc_prefix VALUES(354, 'Iceland');
INSERT INTO cc_prefix VALUES(354373, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354374, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354380, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354388, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354389, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354610, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354615, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354616, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354617, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35462, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354630, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354631, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354632, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354637, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354638, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354639, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354640, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354641, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354642, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354649, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354650, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354652, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354655, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354659, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35466, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35467, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35468, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35469, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354770, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354771, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354772, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354773, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35482, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35483, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35484, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35485, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35486, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35487, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35488, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(35489, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354954, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(354958, 'Iceland Mobile');
INSERT INTO cc_prefix VALUES(91, 'India');
INSERT INTO cc_prefix VALUES(9190, 'India Mobile');
INSERT INTO cc_prefix VALUES(9191, 'India Mobile');
INSERT INTO cc_prefix VALUES(9192, 'India Mobile');
INSERT INTO cc_prefix VALUES(9193, 'India Mobile');
INSERT INTO cc_prefix VALUES(9194, 'India Mobile');
INSERT INTO cc_prefix VALUES(9196, 'India Mobile');
INSERT INTO cc_prefix VALUES(9197, 'India Mobile');
INSERT INTO cc_prefix VALUES(9198, 'India Mobile');
INSERT INTO cc_prefix VALUES(9199, 'India Mobile');
INSERT INTO cc_prefix VALUES(62, 'Indonesia');
INSERT INTO cc_prefix VALUES(628, 'Indonesia Mobile');
INSERT INTO cc_prefix VALUES(98, 'Iran');
INSERT INTO cc_prefix VALUES(989, 'Iran Mobile');
INSERT INTO cc_prefix VALUES(964, 'Iraq');
INSERT INTO cc_prefix VALUES(9647, 'Iraq Mobile');
INSERT INTO cc_prefix VALUES(353, 'Ireland');
INSERT INTO cc_prefix VALUES(353821, 'Ireland Mobile');
INSERT INTO cc_prefix VALUES(353822, 'Ireland Mobile');
INSERT INTO cc_prefix VALUES(35383, 'Ireland Mobile');
INSERT INTO cc_prefix VALUES(35385, 'Ireland Mobile');
INSERT INTO cc_prefix VALUES(35386, 'Ireland Mobile');
INSERT INTO cc_prefix VALUES(35387, 'Ireland Mobile');
INSERT INTO cc_prefix VALUES(35388, 'Ireland Mobile');
INSERT INTO cc_prefix VALUES(35389, 'Ireland Mobile');
INSERT INTO cc_prefix VALUES(972, 'Israel');
INSERT INTO cc_prefix VALUES(972151, 'Israel Mobile');
INSERT INTO cc_prefix VALUES(972153, 'Israel Mobile');
INSERT INTO cc_prefix VALUES(9725, 'Israel Mobile');
INSERT INTO cc_prefix VALUES(9726, 'Israel Mobile');
INSERT INTO cc_prefix VALUES(39, 'Italy');
INSERT INTO cc_prefix VALUES(393, 'Italy Mobile');
INSERT INTO cc_prefix VALUES(225, 'Ivory Coast');
INSERT INTO cc_prefix VALUES(22501, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22502, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22503, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22504, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22505, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22506, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22507, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22508, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22509, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22545, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22546, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22547, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22548, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22566, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(22567, 'Ivory Coast Mobile');
INSERT INTO cc_prefix VALUES(1876, 'Jamaica');
INSERT INTO cc_prefix VALUES(1876210, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187629, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187630, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187631, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187632, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187633, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187634, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187635, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187636, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187637, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187638, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187639, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187640, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876410, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876411, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876412, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876413, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876414, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876416, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876417, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876418, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876419, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187642, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187643, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187644, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187645, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187646, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187647, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187648, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187649, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876503, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876504, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876505, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876506, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876507, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876508, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876509, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876520, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876521, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876522, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876524, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876527, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876528, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876529, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187653, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187654, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876550, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876551, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876552, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876553, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876554, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876556, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876557, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876558, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876559, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187656, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187657, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187658, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187659, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(18767, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876707, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187677, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876781, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876782, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876783, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876784, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876787, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876788, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876789, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876790, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876791, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876792, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876793, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876796, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876797, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876798, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876799, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876801, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876802, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876803, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876804, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876805, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876806, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876807, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876808, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876809, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187681, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187682, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187683, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187684, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187685, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187686, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187687, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187688, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(187689, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876909, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876919, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876990, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876995, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876997, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(1876999, 'Jamaica Mobile');
INSERT INTO cc_prefix VALUES(81, 'Japan');
INSERT INTO cc_prefix VALUES(8170, 'Japan Mobile');
INSERT INTO cc_prefix VALUES(8180, 'Japan Mobile');
INSERT INTO cc_prefix VALUES(8190, 'Japan Mobile');
INSERT INTO cc_prefix VALUES(962, 'Jordan');
INSERT INTO cc_prefix VALUES(96274, 'Jordan Mobile');
INSERT INTO cc_prefix VALUES(96277, 'Jordan Mobile');
INSERT INTO cc_prefix VALUES(962785, 'Jordan Mobile');
INSERT INTO cc_prefix VALUES(962786, 'Jordan Mobile');
INSERT INTO cc_prefix VALUES(962788, 'Jordan Mobile');
INSERT INTO cc_prefix VALUES(96279, 'Jordan Mobile');
INSERT INTO cc_prefix VALUES(771, 'Kazakhstan');
INSERT INTO cc_prefix VALUES(772, 'Kazakhstan');
INSERT INTO cc_prefix VALUES(7760, 'Kazakhstan');
INSERT INTO cc_prefix VALUES(7761, 'Kazakhstan');
INSERT INTO cc_prefix VALUES(7762, 'Kazakhstan');
INSERT INTO cc_prefix VALUES(7763, 'Kazakhstan');
INSERT INTO cc_prefix VALUES(77, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(7701, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(7702, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(7705, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(7707, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771290, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771291, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771390, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771391, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771490, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771491, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771590, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771591, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771790, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771791, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771890, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(771891, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772190, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772191, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772390, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772391, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772490, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772491, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772590, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772591, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772690, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772691, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772790, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(772791, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(7777, 'Kazakhstan Mobile');
INSERT INTO cc_prefix VALUES(254, 'Kenya');
INSERT INTO cc_prefix VALUES(2547, 'Kenya Mobile');
INSERT INTO cc_prefix VALUES(686, 'Kiribati');
INSERT INTO cc_prefix VALUES(68630, 'Kiribati Mobile');
INSERT INTO cc_prefix VALUES(68650, 'Kiribati Mobile');
INSERT INTO cc_prefix VALUES(68689, 'Kiribati Mobile');
INSERT INTO cc_prefix VALUES(6869, 'Kiribati Mobile');
INSERT INTO cc_prefix VALUES(965, 'Kuwait');
INSERT INTO cc_prefix VALUES(96540, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96544, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965501, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965502, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965505, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965506, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965507, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965508, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965509, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96551, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965550, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965554, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965555, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965556, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965557, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965558, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965559, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965570, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965578, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965579, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96558, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96559, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(9656, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(9657, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965701, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965702, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965703, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965704, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965705, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965706, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965707, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965708, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965709, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96571, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96572, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96573, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96574, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96575, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96576, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965770, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965771, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965772, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965773, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965774, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965775, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965776, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965778, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(965779, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96578, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(96579, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(9659, 'Kuwait Mobile');
INSERT INTO cc_prefix VALUES(996, 'Kyrgyzstan');
INSERT INTO cc_prefix VALUES(99631270, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(99631272, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(99631274, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(99631275, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(99631276, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(99631277, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(99631278, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(99631279, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996502, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996503, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996515, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996517, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996543, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996545, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996550, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996555, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996575, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(996577, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(9967, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(99677, 'Kyrgyzstan Mobile');
INSERT INTO cc_prefix VALUES(856, 'Laos');
INSERT INTO cc_prefix VALUES(85620, 'Laos Mobile');
INSERT INTO cc_prefix VALUES(371, 'Latvia');
INSERT INTO cc_prefix VALUES(37120, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37121, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37122, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37123, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37124, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37125, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37126, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37127, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37128, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(37129, 'Latvia Mobile');
INSERT INTO cc_prefix VALUES(961, 'Lebanon');
INSERT INTO cc_prefix VALUES(9613, 'Lebanon Mobile');
INSERT INTO cc_prefix VALUES(96170, 'Lebanon Mobile');
INSERT INTO cc_prefix VALUES(96171, 'Lebanon Mobile');
INSERT INTO cc_prefix VALUES(266, 'Lesotho');
INSERT INTO cc_prefix VALUES(2665, 'Lesotho Mobile');
INSERT INTO cc_prefix VALUES(2666, 'Lesotho Mobile');
INSERT INTO cc_prefix VALUES(231, 'Liberia');
INSERT INTO cc_prefix VALUES(23103, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23128, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23146, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23147, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(2315, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23164, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23165, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23166, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23167, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23168, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(23169, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(2317, 'Liberia Mobile');
INSERT INTO cc_prefix VALUES(218, 'Libya');
INSERT INTO cc_prefix VALUES(21891, 'Libya Mobile');
INSERT INTO cc_prefix VALUES(21892, 'Libya Mobile');
INSERT INTO cc_prefix VALUES(21894, 'Libya Mobile');
INSERT INTO cc_prefix VALUES(423, 'Liechtenstein');
INSERT INTO cc_prefix VALUES(4236, 'Liechtenstein Mobile');
INSERT INTO cc_prefix VALUES(4237, 'Liechtenstein Mobile');
INSERT INTO cc_prefix VALUES(370, 'Lithuania');
INSERT INTO cc_prefix VALUES(370393, 'Lithuania Mobile');
INSERT INTO cc_prefix VALUES(3706, 'Lithuania Mobile');
INSERT INTO cc_prefix VALUES(352, 'Luxembourg');
INSERT INTO cc_prefix VALUES(352021, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352028, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352061, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352068, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352091, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352098, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(35221, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(35228, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(35261, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352621, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352628, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352661, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352668, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(35268, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352691, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(352698, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(35291, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(35298, 'Luxembourg Mobile');
INSERT INTO cc_prefix VALUES(853, 'Macao');
INSERT INTO cc_prefix VALUES(85360, 'Macao Mobile');
INSERT INTO cc_prefix VALUES(85361, 'Macao Mobile');
INSERT INTO cc_prefix VALUES(85362, 'Macao Mobile');
INSERT INTO cc_prefix VALUES(85363, 'Macao Mobile');
INSERT INTO cc_prefix VALUES(85365, 'Macao Mobile');
INSERT INTO cc_prefix VALUES(85366, 'Macao Mobile');
INSERT INTO cc_prefix VALUES(85368, 'Macao Mobile');
INSERT INTO cc_prefix VALUES(85369, 'Macao Mobile');
INSERT INTO cc_prefix VALUES(389, 'Macedonia');
INSERT INTO cc_prefix VALUES(38951, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38970, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38971, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38972, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38973, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38974, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38975, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38976, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38977, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38978, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(38979, 'Macedonia Mobile');
INSERT INTO cc_prefix VALUES(261, 'Madagascar');
INSERT INTO cc_prefix VALUES(26130, 'Madagascar Mobile');
INSERT INTO cc_prefix VALUES(26132, 'Madagascar Mobile');
INSERT INTO cc_prefix VALUES(26133, 'Madagascar Mobile');
INSERT INTO cc_prefix VALUES(26134, 'Madagascar Mobile');
INSERT INTO cc_prefix VALUES(265, 'Malawi');
INSERT INTO cc_prefix VALUES(2654, 'Malawi Mobile');
INSERT INTO cc_prefix VALUES(2655, 'Malawi Mobile');
INSERT INTO cc_prefix VALUES(2658, 'Malawi Mobile');
INSERT INTO cc_prefix VALUES(2659, 'Malawi Mobile');
INSERT INTO cc_prefix VALUES(60, 'Malaysia');
INSERT INTO cc_prefix VALUES(601, 'Malaysia Mobile');
INSERT INTO cc_prefix VALUES(960, 'Maldives');
INSERT INTO cc_prefix VALUES(9607, 'Maldives Mobile');
INSERT INTO cc_prefix VALUES(9609, 'Maldives Mobile');
INSERT INTO cc_prefix VALUES(223, 'Mali');
INSERT INTO cc_prefix VALUES(22330, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22331, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22332, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22333, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22334, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22340, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22341, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22344, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22345, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22346, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22347, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22350, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22351, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22352, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22353, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22354, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22355, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22356, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22357, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22358, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22359, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22360, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22361, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22362, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22363, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22364, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22365, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22366, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22367, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22368, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22369, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22385, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22386, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22387, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22388, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22389, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22390, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22391, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22392, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22393, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22394, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22395, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22396, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22397, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22398, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(22399, 'Mali Mobile');
INSERT INTO cc_prefix VALUES(356, 'Malta');
INSERT INTO cc_prefix VALUES(3567117, 'Malta Mobile');
INSERT INTO cc_prefix VALUES(35672, 'Malta Mobile');
INSERT INTO cc_prefix VALUES(356777, 'Malta Mobile');
INSERT INTO cc_prefix VALUES(35679, 'Malta Mobile');
INSERT INTO cc_prefix VALUES(35692, 'Malta Mobile');
INSERT INTO cc_prefix VALUES(35699, 'Malta Mobile');
INSERT INTO cc_prefix VALUES(692, 'Marshall Islands');
INSERT INTO cc_prefix VALUES(6922350, 'Marshall Islands Mobile');
INSERT INTO cc_prefix VALUES(6922351, 'Marshall Islands Mobile');
INSERT INTO cc_prefix VALUES(6922352, 'Marshall Islands Mobile');
INSERT INTO cc_prefix VALUES(6922353, 'Marshall Islands Mobile');
INSERT INTO cc_prefix VALUES(6922354, 'Marshall Islands Mobile');
INSERT INTO cc_prefix VALUES(692455, 'Marshall Islands Mobile');
INSERT INTO cc_prefix VALUES(6926250, 'Marshall Islands Mobile');
INSERT INTO cc_prefix VALUES(6926251, 'Marshall Islands Mobile');
INSERT INTO cc_prefix VALUES(33596, 'Martinique');
INSERT INTO cc_prefix VALUES(596, 'Martinique');
INSERT INTO cc_prefix VALUES(596696, 'Martinique Mobile');
INSERT INTO cc_prefix VALUES(222, 'Mauritania');
INSERT INTO cc_prefix VALUES(2222, 'Mauritania Mobile');
INSERT INTO cc_prefix VALUES(2226, 'Mauritania Mobile');
INSERT INTO cc_prefix VALUES(22270, 'Mauritania Mobile');
INSERT INTO cc_prefix VALUES(22273, 'Mauritania Mobile');
INSERT INTO cc_prefix VALUES(230, 'Mauritius');
INSERT INTO cc_prefix VALUES(2302189, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230219, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23022, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23025, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230421, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230422, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230423, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230428, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230429, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23049, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23070, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23071, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23072, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23073, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23074, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23075, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23076, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23077, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23078, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23079, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230871, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230875, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230876, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(230877, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23091, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23093, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23094, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23095, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23097, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(23098, 'Mauritius Mobile');
INSERT INTO cc_prefix VALUES(262269, 'Mayotte');
INSERT INTO cc_prefix VALUES(262639, 'Mayotte Mobile');
INSERT INTO cc_prefix VALUES(52, 'Mexico');
INSERT INTO cc_prefix VALUES(521, 'Mexico Mobile');
INSERT INTO cc_prefix VALUES(691, 'Micronesia');
INSERT INTO cc_prefix VALUES(373, 'Moldova');
INSERT INTO cc_prefix VALUES(373650, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373671, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373672, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373673, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373680, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373681, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373682, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373683, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373684, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373685, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373686, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373687, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373688, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(37369, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373774, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373777, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373778, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373780, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(373781, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(37379, 'Moldova Mobile');
INSERT INTO cc_prefix VALUES(377, 'Monaco');
INSERT INTO cc_prefix VALUES(3774, 'Monaco Mobile');
INSERT INTO cc_prefix VALUES(3776, 'Monaco Mobile');
INSERT INTO cc_prefix VALUES(976, 'Mongolia');
INSERT INTO cc_prefix VALUES(97688, 'Mongolia Mobile');
INSERT INTO cc_prefix VALUES(97691, 'Mongolia Mobile');
INSERT INTO cc_prefix VALUES(97695, 'Mongolia Mobile');
INSERT INTO cc_prefix VALUES(97696, 'Mongolia Mobile');
INSERT INTO cc_prefix VALUES(97699, 'Mongolia Mobile');
INSERT INTO cc_prefix VALUES(382, 'Montenegro');
INSERT INTO cc_prefix VALUES(38263, 'Montenegro Mobile');
INSERT INTO cc_prefix VALUES(38267, 'Montenegro Mobile');
INSERT INTO cc_prefix VALUES(38268, 'Montenegro Mobile');
INSERT INTO cc_prefix VALUES(38269, 'Montenegro Mobile');
INSERT INTO cc_prefix VALUES(1664, 'Montserrat');
INSERT INTO cc_prefix VALUES(1664492, 'Montserrat Mobile');
INSERT INTO cc_prefix VALUES(1664724, 'Montserrat Mobile');
INSERT INTO cc_prefix VALUES(212, 'Morocco');
INSERT INTO cc_prefix VALUES(2121, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21226, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21227, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21233, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21234, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21240, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21241, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21242, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21244, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21245, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21246, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21247, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21248, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21249, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21250, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21251, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21252, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21253, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21254, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21255, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21259, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(2126, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(2127, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(21292, 'Morocco Mobile');
INSERT INTO cc_prefix VALUES(258, 'Mozambique');
INSERT INTO cc_prefix VALUES(25882, 'Mozambique Mobile');
INSERT INTO cc_prefix VALUES(25884, 'Mozambique Mobile');
INSERT INTO cc_prefix VALUES(95, 'Myanmar');
INSERT INTO cc_prefix VALUES(959, 'Myanmar Mobile');
INSERT INTO cc_prefix VALUES(264, 'Namibia');
INSERT INTO cc_prefix VALUES(26481, 'Namibia Mobile');
INSERT INTO cc_prefix VALUES(26485, 'Namibia Mobile');
INSERT INTO cc_prefix VALUES(674, 'Nauru');
INSERT INTO cc_prefix VALUES(674555, 'Nauru Mobile');
INSERT INTO cc_prefix VALUES(977, 'Nepal');
INSERT INTO cc_prefix VALUES(97798, 'Nepal Mobile');
INSERT INTO cc_prefix VALUES(31, 'Netherlands');
INSERT INTO cc_prefix VALUES(599, 'Netherlands Antilles');
INSERT INTO cc_prefix VALUES(5993181, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5993184, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5993185, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5993186, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5994161, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5994165, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5994166, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5994167, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599510, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599520, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599521, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599522, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599523, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599524, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599526, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599527, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599550, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599551, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599552, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599553, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599554, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599555, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599556, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599557, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599558, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599559, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599580, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599581, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599586, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599587, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599588, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5997, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599701, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(59978, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(59979, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(59980, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599951, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599952, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5999530, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599954, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599955, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599956, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599961, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5999630, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(5999631, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599966, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599967, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(599969, 'Netherlands Antilles Mobile');
INSERT INTO cc_prefix VALUES(316, 'Netherlands Mobile');
INSERT INTO cc_prefix VALUES(687, 'New Caledonia');
INSERT INTO cc_prefix VALUES(68775, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68776, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68777, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68778, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68779, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68780, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68781, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68782, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68783, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68784, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68785, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68786, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68787, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(68789, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(6879, 'New Caledonia Mobile');
INSERT INTO cc_prefix VALUES(64, 'New Zealand');
INSERT INTO cc_prefix VALUES(6420, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6421, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6422, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6423, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6424, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6425, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6426, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6427, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6428, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(6429, 'New Zealand Mobile');
INSERT INTO cc_prefix VALUES(505, 'Nicaragua');
INSERT INTO cc_prefix VALUES(5054, 'Nicaragua Mobile');
INSERT INTO cc_prefix VALUES(5056, 'Nicaragua Mobile');
INSERT INTO cc_prefix VALUES(5058, 'Nicaragua Mobile');
INSERT INTO cc_prefix VALUES(5059, 'Nicaragua Mobile');
INSERT INTO cc_prefix VALUES(227, 'Niger');
INSERT INTO cc_prefix VALUES(22790, 'Niger Mobile');
INSERT INTO cc_prefix VALUES(22793, 'Niger Mobile');
INSERT INTO cc_prefix VALUES(22794, 'Niger Mobile');
INSERT INTO cc_prefix VALUES(22796, 'Niger Mobile');
INSERT INTO cc_prefix VALUES(234, 'Nigeria');
INSERT INTO cc_prefix VALUES(234702, 'Nigeria Mobile');
INSERT INTO cc_prefix VALUES(234703, 'Nigeria Mobile');
INSERT INTO cc_prefix VALUES(234705, 'Nigeria Mobile');
INSERT INTO cc_prefix VALUES(234706, 'Nigeria Mobile');
INSERT INTO cc_prefix VALUES(234708, 'Nigeria Mobile');
INSERT INTO cc_prefix VALUES(23480, 'Nigeria Mobile');
INSERT INTO cc_prefix VALUES(23490, 'Nigeria Mobile');
INSERT INTO cc_prefix VALUES(683, 'Niue');
INSERT INTO cc_prefix VALUES(6723, 'Norfolk Island');
INSERT INTO cc_prefix VALUES(67238, 'Norfolk Island Mobile');
INSERT INTO cc_prefix VALUES(850, 'North Korea');
INSERT INTO cc_prefix VALUES(1670, 'Northern Mariana Islands');
INSERT INTO cc_prefix VALUES(1670285, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670286, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670287, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670483, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670484, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670488, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670588, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670788, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670789, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670838, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670868, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670878, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670888, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670898, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(1670989, 'Northern Mariana Islands Mobil');
INSERT INTO cc_prefix VALUES(47, 'Norway');
INSERT INTO cc_prefix VALUES(474, 'Norway Mobile');
INSERT INTO cc_prefix VALUES(479, 'Norway Mobile');
INSERT INTO cc_prefix VALUES(968, 'Oman');
INSERT INTO cc_prefix VALUES(96891, 'Oman Mobile');
INSERT INTO cc_prefix VALUES(96892, 'Oman Mobile');
INSERT INTO cc_prefix VALUES(96895, 'Oman Mobile');
INSERT INTO cc_prefix VALUES(96896, 'Oman Mobile');
INSERT INTO cc_prefix VALUES(96897, 'Oman Mobile');
INSERT INTO cc_prefix VALUES(96898, 'Oman Mobile');
INSERT INTO cc_prefix VALUES(96899, 'Oman Mobile');
INSERT INTO cc_prefix VALUES(92, 'Pakistan');
INSERT INTO cc_prefix VALUES(923, 'Pakistan Mobile');
INSERT INTO cc_prefix VALUES(680, 'Palau');
INSERT INTO cc_prefix VALUES(680620, 'Palau Mobile');
INSERT INTO cc_prefix VALUES(680630, 'Palau Mobile');
INSERT INTO cc_prefix VALUES(680640, 'Palau Mobile');
INSERT INTO cc_prefix VALUES(680660, 'Palau Mobile');
INSERT INTO cc_prefix VALUES(680680, 'Palau Mobile');
INSERT INTO cc_prefix VALUES(680690, 'Palau Mobile');
INSERT INTO cc_prefix VALUES(680775, 'Palau Mobile');
INSERT INTO cc_prefix VALUES(680779, 'Palau Mobile');
INSERT INTO cc_prefix VALUES(970, 'Palestinian Territory');
INSERT INTO cc_prefix VALUES(97222, 'Palestinian Territory');
INSERT INTO cc_prefix VALUES(97232, 'Palestinian Territory');
INSERT INTO cc_prefix VALUES(97242, 'Palestinian Territory');
INSERT INTO cc_prefix VALUES(97282, 'Palestinian Territory');
INSERT INTO cc_prefix VALUES(97292, 'Palestinian Territory');
INSERT INTO cc_prefix VALUES(97059, 'Palestinian Territory Mobile');
INSERT INTO cc_prefix VALUES(97259, 'Palestinian Territory Mobile');
INSERT INTO cc_prefix VALUES(507, 'Panama');
INSERT INTO cc_prefix VALUES(507272, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(507276, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(507443, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(5076, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(507810, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(507811, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(507855, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(507872, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(507873, 'Panama Mobile');
INSERT INTO cc_prefix VALUES(675, 'Papua New Guinea');
INSERT INTO cc_prefix VALUES(67563, 'Papua New Guinea Mobile');
INSERT INTO cc_prefix VALUES(67565, 'Papua New Guinea Mobile');
INSERT INTO cc_prefix VALUES(67567, 'Papua New Guinea Mobile');
INSERT INTO cc_prefix VALUES(67568, 'Papua New Guinea Mobile');
INSERT INTO cc_prefix VALUES(67569, 'Papua New Guinea Mobile');
INSERT INTO cc_prefix VALUES(67571, 'Papua New Guinea Mobile');
INSERT INTO cc_prefix VALUES(67572, 'Papua New Guinea Mobile');
INSERT INTO cc_prefix VALUES(595, 'Paraguay');
INSERT INTO cc_prefix VALUES(595941, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595943, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595945, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595961, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595971, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595973, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595975, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595981, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595982, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595983, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595985, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595991, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595993, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(595995, 'Paraguay Mobile');
INSERT INTO cc_prefix VALUES(51, 'Peru');
INSERT INTO cc_prefix VALUES(5119, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51419, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51429, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51439, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51449, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51519, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51529, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51539, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51549, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51569, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51619, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51629, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51639, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51649, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51659, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51669, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51679, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51729, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51739, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51749, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51769, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51829, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51839, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(51849, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(519, 'Peru Mobile');
INSERT INTO cc_prefix VALUES(63, 'Philippines');
INSERT INTO cc_prefix VALUES(639, 'Philippines Mobile');
INSERT INTO cc_prefix VALUES(48, 'Poland');
INSERT INTO cc_prefix VALUES(4850, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(4851, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(4860, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48642, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(4866, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(4869, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48721, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48722, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48723, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48724, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48725, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48726, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487272, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487273, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487274, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487275, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487276, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487277, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487278, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487279, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487281, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487282, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487283, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487284, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487285, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487286, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487287, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487288, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(487289, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48729, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48780, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48781, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48782, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48783, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48784, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48785, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48786, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48787, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48788, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48789, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48790, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48791, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48792, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48793, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48794, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48795, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48796, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48797, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48798, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48799, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48880, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(488811, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(488818, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48882, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(488833, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(488838, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48884, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48885, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48886, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48887, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48888, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(48889, 'Poland Mobile');
INSERT INTO cc_prefix VALUES(351, 'Portugal');
INSERT INTO cc_prefix VALUES(3519, 'Portugal Mobile');
INSERT INTO cc_prefix VALUES(1787, 'Puerto Rico');
INSERT INTO cc_prefix VALUES(1939, 'Puerto Rico');
INSERT INTO cc_prefix VALUES(1787201, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787202, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787203, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787204, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787205, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787206, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787207, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787208, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787209, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787210, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787212, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787213, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787214, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787215, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787216, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787217, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787218, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787219, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787220, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787221, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787222, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787223, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787224, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787225, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787226, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787228, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787230, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787231, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787232, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787233, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787234, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787235, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787236, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787237, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787238, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787239, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787240, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787241, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787242, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787243, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787244, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787245, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787246, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787247, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787248, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787249, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787295, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787297, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787298, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787299, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787301, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787302, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787303, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787304, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787305, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787306, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787307, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787308, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787309, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787310, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787312, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787313, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787314, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787315, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787316, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787317, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787318, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787319, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787320, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787321, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787322, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787323, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787324, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787325, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787326, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787327, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787328, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787329, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787330, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787331, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787332, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787333, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787334, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787335, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787336, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787337, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787338, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787339, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787340, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787341, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787342, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787344, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787345, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787346, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787347, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787348, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787349, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787350, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787351, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787352, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787353, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787354, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787356, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787358, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787359, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787360, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787361, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787362, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787363, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787364, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787365, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787366, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787367, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787368, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787370, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787371, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787372, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787373, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787374, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787375, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787376, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787377, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787378, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787379, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787380, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787381, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787382, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787383, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787384, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787385, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787386, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787387, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787388, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787389, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787390, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787391, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787392, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787393, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787394, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787396, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787397, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787398, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787399, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(17874, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787401, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787402, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787403, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787404, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787405, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787406, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787407, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787408, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787409, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787410, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787412, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787413, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787414, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787415, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787416, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787417, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787418, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787419, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787420, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787421, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787422, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787423, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787424, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787425, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787426, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787427, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787428, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787429, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787430, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787431, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787432, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787433, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787435, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787436, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787438, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787439, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787440, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787441, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787442, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787443, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787444, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787445, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787446, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787447, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787448, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787449, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787450, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787451, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787452, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787453, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787454, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787455, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787456, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787457, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787458, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787459, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787460, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787461, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787462, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787463, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787464, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787466, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787467, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787469, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787470, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787472, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787473, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787475, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787477, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787478, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787479, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787481, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787484, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787485, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787486, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787487, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787488, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787489, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787490, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787491, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787492, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787493, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787494, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787495, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787496, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787497, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787498, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787499, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787501, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787502, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787503, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787504, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787505, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787506, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787507, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787508, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787509, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787510, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787512, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787514, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787515, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787516, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787517, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787518, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787519, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787525, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787526, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787527, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787528, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787529, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787530, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787531, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787532, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787533, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787536, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787538, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787539, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787540, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787541, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787542, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787543, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787546, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787547, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787548, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787549, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787550, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787552, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787553, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787554, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787556, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787557, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787559, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787560, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787562, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787564, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787565, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787566, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787567, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787568, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787570, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787571, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787572, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787573, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787574, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787575, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787576, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787577, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787578, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787579, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787581, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787582, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787583, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787584, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787585, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787586, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787587, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787590, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787593, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787594, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787595, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787596, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787597, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787598, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787599, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787601, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787602, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787603, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787604, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787605, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787606, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787607, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787608, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787610, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787612, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787613, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787614, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787615, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787616, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787617, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787618, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787619, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787627, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787628, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787629, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787630, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787631, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787632, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787633, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787634, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787635, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787636, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787637, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787638, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787639, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787640, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787642, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787643, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787644, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787645, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787646, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787647, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787648, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787649, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787661, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787662, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787664, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787667, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787668, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787669, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787671, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787672, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787673, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787674, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787675, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787676, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787677, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787678, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787685, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787688, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787689, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787690, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787691, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787692, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787696, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787697, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787698, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787702, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787709, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787717, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787718, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787810, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787901, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787902, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787903, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787904, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787905, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787906, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787907, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787908, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787909, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787910, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787914, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787918, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787920, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787922, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787923, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787925, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787929, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787930, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787932, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787934, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787938, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787940, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787941, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787942, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787943, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787944, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787946, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787948, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787949, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787951, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787955, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787960, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787962, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787963, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787964, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787967, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787969, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787972, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787974, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787975, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787979, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787983, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787985, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787988, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787990, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787994, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1787996, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939218, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939241, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939242, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939243, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939244, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939245, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939246, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939247, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939248, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939389, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939397, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939475, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939579, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939628, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939630, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939639, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939640, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939642, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939644, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939645, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939717, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939940, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(1939969, 'Puerto Rico Mobile');
INSERT INTO cc_prefix VALUES(974, 'Qatar');
INSERT INTO cc_prefix VALUES(9741245, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(9741744, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97420, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97421, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97422, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(9745, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97460, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97461, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97464, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97465, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97466, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97467, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97468, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(97469, 'Qatar Mobile');
INSERT INTO cc_prefix VALUES(262, 'Reunion');
INSERT INTO cc_prefix VALUES(33262, 'Reunion');
INSERT INTO cc_prefix VALUES(262692, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(262693, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269301, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269302, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269303, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269304, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269310, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269320, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269330, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269333, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269340, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269350, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269360, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269370, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269380, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269390, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269391, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269392, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269393, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269394, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(26269397, 'Reunion Mobile');
INSERT INTO cc_prefix VALUES(40, 'Romania');
INSERT INTO cc_prefix VALUES(4076, 'Romania [Cosmote]');
INSERT INTO cc_prefix VALUES(403, 'Romania [OLO]');
INSERT INTO cc_prefix VALUES(4074, 'Romania [Orange]');
INSERT INTO cc_prefix VALUES(4075, 'Romania [Orange]');
INSERT INTO cc_prefix VALUES(4078, 'Romania [Telemobil]');
INSERT INTO cc_prefix VALUES(4072, 'Romania [Vodafone]');
INSERT INTO cc_prefix VALUES(4073, 'Romania [Vodafone]');
INSERT INTO cc_prefix VALUES(407, 'Romania Mobile');
INSERT INTO cc_prefix VALUES(7, 'Russian Federation');
INSERT INTO cc_prefix VALUES(734922, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734932, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734934, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(7349363, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(7349364, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(73493667, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(73493668, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(73493669, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734938, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(73494, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734940, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734948, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734992, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734993, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734994, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734995, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734996, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(734997, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(73842, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738441, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738442, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738443, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738444, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738445, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738446, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738447, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738448, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738449, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738451, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738452, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738453, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738454, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738455, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738456, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738459, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738471, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738473, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738474, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738475, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738510, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738511, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738512, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738513, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738514, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738515, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738516, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738517, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738518, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738519, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738530, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738531, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738532, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738533, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738534, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738535, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738536, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738537, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738538, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738539, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738550, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738551, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738552, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738553, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738554, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738555, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738556, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738557, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738558, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738559, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738560, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738561, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738562, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738563, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738564, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738565, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738566, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738567, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738568, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738569, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738570, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738571, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738572, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738573, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738574, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738575, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738576, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738577, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738578, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738579, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738590, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738591, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738592, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738593, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738594, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738595, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738596, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738597, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738598, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(738599, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742135, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742137, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742138, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742141, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742142, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742144, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742146, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742149, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742151, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742153, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742154, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742155, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742156, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(74217, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742171, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742331, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742334, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742335, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742337, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742339, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742351, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742352, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742354, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742355, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742356, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742357, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742359, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742371, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742372, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742373, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742374, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742375, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742376, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(742377, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782130, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782131, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782132, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782133, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782134, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782135, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782136, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782137, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782138, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782139, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782140, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782141, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782142, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782144, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782145, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782146, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782147, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782149, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(782151, 'Russian Federation [FIX2]');
INSERT INTO cc_prefix VALUES(79, 'Russian Federation Mobile');
INSERT INTO cc_prefix VALUES(250, 'Rwanda');
INSERT INTO cc_prefix VALUES(255, 'Tanzania');
INSERT INTO cc_prefix VALUES(685, 'Samoa');
INSERT INTO cc_prefix VALUES(6857, 'Samoa Mobile');
INSERT INTO cc_prefix VALUES(378, 'San Marino');
INSERT INTO cc_prefix VALUES(3786, 'San Marino Mobile');
INSERT INTO cc_prefix VALUES(239, 'Sao Tome and Principe');
INSERT INTO cc_prefix VALUES(23990, 'Sao Tome and Principe Mobile');
INSERT INTO cc_prefix VALUES(966, 'Saudi Arabia');
INSERT INTO cc_prefix VALUES(9665, 'Saudi Arabia Mobile');
INSERT INTO cc_prefix VALUES(9668, 'Saudi Arabia Mobile');
INSERT INTO cc_prefix VALUES(221, 'Senegal');
INSERT INTO cc_prefix VALUES(22176, 'Senegal Mobile');
INSERT INTO cc_prefix VALUES(22177, 'Senegal Mobile');
INSERT INTO cc_prefix VALUES(381, 'Serbia and Montenegro');
INSERT INTO cc_prefix VALUES(3816, 'Serbia and Montenegro Mobile');
INSERT INTO cc_prefix VALUES(248, 'Seychelles');
INSERT INTO cc_prefix VALUES(2485, 'Seychelles Mobile');
INSERT INTO cc_prefix VALUES(2487, 'Seychelles Mobile');
INSERT INTO cc_prefix VALUES(232, 'Sierra Leone');
INSERT INTO cc_prefix VALUES(23223, 'Sierra Leone Mobile');
INSERT INTO cc_prefix VALUES(23230, 'Sierra Leone Mobile');
INSERT INTO cc_prefix VALUES(23233, 'Sierra Leone Mobile');
INSERT INTO cc_prefix VALUES(23235, 'Sierra Leone Mobile');
INSERT INTO cc_prefix VALUES(23240, 'Sierra Leone Mobile');
INSERT INTO cc_prefix VALUES(23250, 'Sierra Leone Mobile');
INSERT INTO cc_prefix VALUES(23276, 'Sierra Leone Mobile');
INSERT INTO cc_prefix VALUES(23277, 'Sierra Leone Mobile');
INSERT INTO cc_prefix VALUES(65, 'Singapore');
INSERT INTO cc_prefix VALUES(658, 'Singapore Mobile');
INSERT INTO cc_prefix VALUES(659, 'Singapore Mobile');
INSERT INTO cc_prefix VALUES(421, 'Slovak Republic');
INSERT INTO cc_prefix VALUES(42190, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421910, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421911, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421912, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421913, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421914, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421915, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421916, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421917, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421918, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421919, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421944, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421948, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(421949, 'Slovak Republic Mobile');
INSERT INTO cc_prefix VALUES(386, 'Slovenia');
INSERT INTO cc_prefix VALUES(38630, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(38631, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(38640, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(38641, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(38649, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(38650, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(38651, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(386641, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(38670, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(38671, 'Slovenia Mobile');
INSERT INTO cc_prefix VALUES(677, 'Solomon Islands');
INSERT INTO cc_prefix VALUES(67743, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67754, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67755, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67756, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67757, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67758, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67759, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67765, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67766, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67768, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(67769, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(6777, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(6778, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(6779, 'Solomon Islands Mobile');
INSERT INTO cc_prefix VALUES(252, 'Somalia');
INSERT INTO cc_prefix VALUES(25224, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(25228, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(25260, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(25262, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(25265, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(25266, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(25268, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(25290, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(25291, 'Somalia Mobile');
INSERT INTO cc_prefix VALUES(27, 'South Africa');
INSERT INTO cc_prefix VALUES(277, 'South Africa Mobile');
INSERT INTO cc_prefix VALUES(2782, 'South Africa Mobile');
INSERT INTO cc_prefix VALUES(2783, 'South Africa Mobile');
INSERT INTO cc_prefix VALUES(2784, 'South Africa Mobile');
INSERT INTO cc_prefix VALUES(2785, 'South Africa Mobile');
INSERT INTO cc_prefix VALUES(2786, 'South Africa Mobile');
INSERT INTO cc_prefix VALUES(82, 'South Korea');
INSERT INTO cc_prefix VALUES(821, 'South Korea Mobile');
INSERT INTO cc_prefix VALUES(34, 'Spain');
INSERT INTO cc_prefix VALUES(346, 'Spain Mobile');
INSERT INTO cc_prefix VALUES(94, 'Sri Lanka');
INSERT INTO cc_prefix VALUES(9471, 'Sri Lanka Mobile');
INSERT INTO cc_prefix VALUES(9472, 'Sri Lanka Mobile');
INSERT INTO cc_prefix VALUES(9477, 'Sri Lanka Mobile');
INSERT INTO cc_prefix VALUES(9478, 'Sri Lanka Mobile');
INSERT INTO cc_prefix VALUES(290, 'St Helena');
INSERT INTO cc_prefix VALUES(1869, 'St Kitts and Nevis');
INSERT INTO cc_prefix VALUES(1869556, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869557, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869558, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869565, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869566, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869567, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869662, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869663, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869664, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869665, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869667, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869668, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869669, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869762, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869763, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869764, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1869765, 'St Kitts and Nevis Mobile');
INSERT INTO cc_prefix VALUES(1758, 'St Lucia');
INSERT INTO cc_prefix VALUES(1758284, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758285, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758286, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758287, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758384, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758460, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758461, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758481, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758482, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758483, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758484, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758485, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758486, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758487, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758488, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758489, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758518, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758519, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758520, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758584, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758712, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758713, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758714, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758715, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758716, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758717, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758718, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758719, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758720, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758721, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758722, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758723, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(1758724, 'St Lucia Mobile');
INSERT INTO cc_prefix VALUES(508, 'St Pierre and Miquelon');
INSERT INTO cc_prefix VALUES(50855, 'St Pierre and Miquelon Mobile');
INSERT INTO cc_prefix VALUES(1784, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784430, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784431, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784432, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784433, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784434, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784454, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784455, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784492, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784493, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784494, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784495, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784526, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784527, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784528, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784529, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784530, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784531, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784532, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784533, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(1784593, 'St Vincent and the Grenadines');
INSERT INTO cc_prefix VALUES(249, 'Sudan');
INSERT INTO cc_prefix VALUES(24991, 'Sudan Mobile');
INSERT INTO cc_prefix VALUES(24992, 'Sudan Mobile');
INSERT INTO cc_prefix VALUES(24994, 'Sudan Mobile');
INSERT INTO cc_prefix VALUES(597, 'Suriname');
INSERT INTO cc_prefix VALUES(5978, 'Suriname Mobile');
INSERT INTO cc_prefix VALUES(268, 'Swaziland');
INSERT INTO cc_prefix VALUES(26860, 'Swaziland Mobile');
INSERT INTO cc_prefix VALUES(26861, 'Swaziland Mobile');
INSERT INTO cc_prefix VALUES(26862, 'Swaziland Mobile');
INSERT INTO cc_prefix VALUES(26863, 'Swaziland Mobile');
INSERT INTO cc_prefix VALUES(26864, 'Swaziland Mobile');
INSERT INTO cc_prefix VALUES(26865, 'Swaziland Mobile');
INSERT INTO cc_prefix VALUES(26866, 'Swaziland Mobile');
INSERT INTO cc_prefix VALUES(26867, 'Swaziland Mobile');
INSERT INTO cc_prefix VALUES(46, 'Sweden');
INSERT INTO cc_prefix VALUES(4610, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(46252, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(46376, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(46518, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(46519, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(46673, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(46674, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(46675, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(46676, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(4670, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(4673, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(4674, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(4676, 'Sweden Mobile');
INSERT INTO cc_prefix VALUES(41, 'Switzerland');
INSERT INTO cc_prefix VALUES(4174, 'Switzerland Mobile');
INSERT INTO cc_prefix VALUES(4176, 'Switzerland Mobile');
INSERT INTO cc_prefix VALUES(4177, 'Switzerland Mobile');
INSERT INTO cc_prefix VALUES(4178, 'Switzerland Mobile');
INSERT INTO cc_prefix VALUES(4179, 'Switzerland Mobile');
INSERT INTO cc_prefix VALUES(4186, 'Switzerland Mobile');
INSERT INTO cc_prefix VALUES(963, 'Syrian Arab Republic');
INSERT INTO cc_prefix VALUES(96392, 'Syrian Arab Republic Mobile');
INSERT INTO cc_prefix VALUES(96393, 'Syrian Arab Republic Mobile');
INSERT INTO cc_prefix VALUES(96394, 'Syrian Arab Republic Mobile');
INSERT INTO cc_prefix VALUES(96395, 'Syrian Arab Republic Mobile');
INSERT INTO cc_prefix VALUES(96396, 'Syrian Arab Republic Mobile');
INSERT INTO cc_prefix VALUES(96398, 'Syrian Arab Republic Mobile');
INSERT INTO cc_prefix VALUES(96399, 'Syrian Arab Republic Mobile');
INSERT INTO cc_prefix VALUES(886, 'Taiwan');
INSERT INTO cc_prefix VALUES(88690, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(88691, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(88692, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(88693, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(88694, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(88695, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(88696, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(88697, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(88698, 'Taiwan Mobile');
INSERT INTO cc_prefix VALUES(992, 'Tajikistan');
INSERT INTO cc_prefix VALUES(9929, 'Tajikistan Mobile');
INSERT INTO cc_prefix VALUES(2556, 'Tanzania Mobile');
INSERT INTO cc_prefix VALUES(2557, 'Tanzania Mobile');
INSERT INTO cc_prefix VALUES(66, 'Thailand');
INSERT INTO cc_prefix VALUES(668, 'Thailand Mobile');
INSERT INTO cc_prefix VALUES(88216, 'Thuraya');
INSERT INTO cc_prefix VALUES(228, 'Togo');
INSERT INTO cc_prefix VALUES(2289, 'Togo Mobile');
INSERT INTO cc_prefix VALUES(676, 'Tonga');
INSERT INTO cc_prefix VALUES(67611, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67612, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67613, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67614, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67615, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67616, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67617, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67618, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67619, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67645, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67646, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67647, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67648, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67649, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67652, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67653, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67654, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67655, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67656, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67657, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67658, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67659, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67662, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67663, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67664, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67665, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67666, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67667, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67668, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67675, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67676, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67677, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67678, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67681, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(67682, 'Tonga Mobile');
INSERT INTO cc_prefix VALUES(1868, 'Trinidad and Tobago');
INSERT INTO cc_prefix VALUES(186829, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868301, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868302, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868303, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868304, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868305, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868306, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868307, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868308, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868309, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868310, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868312, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868313, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868314, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868315, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868316, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868317, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868318, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868319, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186832, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186833, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186834, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186835, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186836, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186837, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186838, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186839, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868401, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868402, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868403, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868404, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868405, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868406, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868407, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868408, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868409, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868410, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868412, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868413, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868414, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868415, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868416, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868417, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868418, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868419, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868420, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868421, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186846, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186847, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186848, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186849, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868619, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868620, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868678, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186868, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868701, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868702, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868703, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868704, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868705, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868706, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868707, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868708, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868709, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868710, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868712, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868713, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868714, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868715, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868716, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868717, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868718, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(1868719, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186872, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186873, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186874, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186875, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186876, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186877, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186878, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(186879, 'Trinidad and Tobago Mobile');
INSERT INTO cc_prefix VALUES(2903, 'Tristan da Cunha');
INSERT INTO cc_prefix VALUES(216, 'Tunisia');
INSERT INTO cc_prefix VALUES(21620, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21621, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21622, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21623, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21624, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21625, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21690, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21691, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21693, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21694, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21695, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21696, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21697, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21698, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(21699, 'Tunisia Mobile');
INSERT INTO cc_prefix VALUES(90, 'Turkey');
INSERT INTO cc_prefix VALUES(905, 'Turkey Mobile');
INSERT INTO cc_prefix VALUES(993, 'Turkmenistan');
INSERT INTO cc_prefix VALUES(993122, 'Turkmenistan Mobile');
INSERT INTO cc_prefix VALUES(9932221, 'Turkmenistan Mobile');
INSERT INTO cc_prefix VALUES(9932431, 'Turkmenistan Mobile');
INSERT INTO cc_prefix VALUES(9933221, 'Turkmenistan Mobile');
INSERT INTO cc_prefix VALUES(9934221, 'Turkmenistan Mobile');
INSERT INTO cc_prefix VALUES(9935221, 'Turkmenistan Mobile');
INSERT INTO cc_prefix VALUES(9936, 'Turkmenistan Mobile');
INSERT INTO cc_prefix VALUES(1649, 'Turks and Caicos');
INSERT INTO cc_prefix VALUES(1649231, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649232, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649241, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649242, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649243, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649244, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649245, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649249, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649331, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649332, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649333, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649341, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649342, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649343, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649344, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649345, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649431, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649432, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649441, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649442, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(1649724, 'Turks and Caicos Mobile');
INSERT INTO cc_prefix VALUES(688, 'Tuvalu');
INSERT INTO cc_prefix VALUES(256, 'Uganda');
INSERT INTO cc_prefix VALUES(25639, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(2567, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(256701, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(256702, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(256703, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(256704, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(25671, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(25675, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(25677, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(25678, 'Uganda Mobile');
INSERT INTO cc_prefix VALUES(380, 'Ukraine');
INSERT INTO cc_prefix VALUES(38039, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38050, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38063, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38066, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38067, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38068, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38091, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38092, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38093, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38094, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38095, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38096, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38097, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38098, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(38099, 'Ukraine Mobile');
INSERT INTO cc_prefix VALUES(971, 'United Arab Emirates');
INSERT INTO cc_prefix VALUES(97150, 'United Arab Emirates Mobile');
INSERT INTO cc_prefix VALUES(97155, 'United Arab Emirates Mobile');
INSERT INTO cc_prefix VALUES(97156, 'United Arab Emirates Mobile');
INSERT INTO cc_prefix VALUES(44, 'United Kingdom');
INSERT INTO cc_prefix VALUES(441, 'United Kingdom Landline');
INSERT INTO cc_prefix VALUES(442, 'United Kingdom Landline');
INSERT INTO cc_prefix VALUES(443, 'United Kingdom Landline');
INSERT INTO cc_prefix VALUES(4470, 'United Kingdom Personal Number');
INSERT INTO cc_prefix VALUES(4475, 'United Kingdom Mobile');
INSERT INTO cc_prefix VALUES(4476, 'United Kingdom Pager');
INSERT INTO cc_prefix VALUES(4477, 'United Kingdom Mobile');
INSERT INTO cc_prefix VALUES(4478, 'United Kingdom Mobile');
INSERT INTO cc_prefix VALUES(4479, 'United Kingdom Mobile');
INSERT INTO cc_prefix VALUES(448, 'United Kingdom Special-Rate');
INSERT INTO cc_prefix VALUES(449, 'United Kingdom Premium-Rate');
INSERT INTO cc_prefix VALUES(1201, 'United States');
INSERT INTO cc_prefix VALUES(1202, 'United States');
INSERT INTO cc_prefix VALUES(1203, 'United States');
INSERT INTO cc_prefix VALUES(1205, 'United States');
INSERT INTO cc_prefix VALUES(1206, 'United States');
INSERT INTO cc_prefix VALUES(1207, 'United States');
INSERT INTO cc_prefix VALUES(1208, 'United States');
INSERT INTO cc_prefix VALUES(1209, 'United States');
INSERT INTO cc_prefix VALUES(1210, 'United States');
INSERT INTO cc_prefix VALUES(1212, 'United States');
INSERT INTO cc_prefix VALUES(1213, 'United States');
INSERT INTO cc_prefix VALUES(1214, 'United States');
INSERT INTO cc_prefix VALUES(1215, 'United States');
INSERT INTO cc_prefix VALUES(1216, 'United States');
INSERT INTO cc_prefix VALUES(1217, 'United States');
INSERT INTO cc_prefix VALUES(1218, 'United States');
INSERT INTO cc_prefix VALUES(1219, 'United States');
INSERT INTO cc_prefix VALUES(1224, 'United States');
INSERT INTO cc_prefix VALUES(1225, 'United States');
INSERT INTO cc_prefix VALUES(1227, 'United States');
INSERT INTO cc_prefix VALUES(1228, 'United States');
INSERT INTO cc_prefix VALUES(1229, 'United States');
INSERT INTO cc_prefix VALUES(1231, 'United States');
INSERT INTO cc_prefix VALUES(1234, 'United States');
INSERT INTO cc_prefix VALUES(1239, 'United States');
INSERT INTO cc_prefix VALUES(1240, 'United States');
INSERT INTO cc_prefix VALUES(1248, 'United States');
INSERT INTO cc_prefix VALUES(1251, 'United States');
INSERT INTO cc_prefix VALUES(1252, 'United States');
INSERT INTO cc_prefix VALUES(1253, 'United States');
INSERT INTO cc_prefix VALUES(1254, 'United States');
INSERT INTO cc_prefix VALUES(1256, 'United States');
INSERT INTO cc_prefix VALUES(1260, 'United States');
INSERT INTO cc_prefix VALUES(1262, 'United States');
INSERT INTO cc_prefix VALUES(1267, 'United States');
INSERT INTO cc_prefix VALUES(1269, 'United States');
INSERT INTO cc_prefix VALUES(1270, 'United States');
INSERT INTO cc_prefix VALUES(1276, 'United States');
INSERT INTO cc_prefix VALUES(1281, 'United States');
INSERT INTO cc_prefix VALUES(1283, 'United States');
INSERT INTO cc_prefix VALUES(1301, 'United States');
INSERT INTO cc_prefix VALUES(1302, 'United States');
INSERT INTO cc_prefix VALUES(1303, 'United States');
INSERT INTO cc_prefix VALUES(1304, 'United States');
INSERT INTO cc_prefix VALUES(1305, 'United States');
INSERT INTO cc_prefix VALUES(1307, 'United States');
INSERT INTO cc_prefix VALUES(1308, 'United States');
INSERT INTO cc_prefix VALUES(1309, 'United States');
INSERT INTO cc_prefix VALUES(1310, 'United States');
INSERT INTO cc_prefix VALUES(1312, 'United States');
INSERT INTO cc_prefix VALUES(1313, 'United States');
INSERT INTO cc_prefix VALUES(1314, 'United States');
INSERT INTO cc_prefix VALUES(1315, 'United States');
INSERT INTO cc_prefix VALUES(1316, 'United States');
INSERT INTO cc_prefix VALUES(1317, 'United States');
INSERT INTO cc_prefix VALUES(1318, 'United States');
INSERT INTO cc_prefix VALUES(1319, 'United States');
INSERT INTO cc_prefix VALUES(1320, 'United States');
INSERT INTO cc_prefix VALUES(1321, 'United States');
INSERT INTO cc_prefix VALUES(1323, 'United States');
INSERT INTO cc_prefix VALUES(1325, 'United States');
INSERT INTO cc_prefix VALUES(1330, 'United States');
INSERT INTO cc_prefix VALUES(1331, 'United States');
INSERT INTO cc_prefix VALUES(1334, 'United States');
INSERT INTO cc_prefix VALUES(1336, 'United States');
INSERT INTO cc_prefix VALUES(1337, 'United States');
INSERT INTO cc_prefix VALUES(1339, 'United States');
INSERT INTO cc_prefix VALUES(1341, 'United States');
INSERT INTO cc_prefix VALUES(1347, 'United States');
INSERT INTO cc_prefix VALUES(1351, 'United States');
INSERT INTO cc_prefix VALUES(1352, 'United States');
INSERT INTO cc_prefix VALUES(1360, 'United States');
INSERT INTO cc_prefix VALUES(1361, 'United States');
INSERT INTO cc_prefix VALUES(1369, 'United States');
INSERT INTO cc_prefix VALUES(1380, 'United States');
INSERT INTO cc_prefix VALUES(1385, 'United States');
INSERT INTO cc_prefix VALUES(1386, 'United States');
INSERT INTO cc_prefix VALUES(1401, 'United States');
INSERT INTO cc_prefix VALUES(1402, 'United States');
INSERT INTO cc_prefix VALUES(1404, 'United States');
INSERT INTO cc_prefix VALUES(1405, 'United States');
INSERT INTO cc_prefix VALUES(1406, 'United States');
INSERT INTO cc_prefix VALUES(1407, 'United States');
INSERT INTO cc_prefix VALUES(1408, 'United States');
INSERT INTO cc_prefix VALUES(1409, 'United States');
INSERT INTO cc_prefix VALUES(1410, 'United States');
INSERT INTO cc_prefix VALUES(1412, 'United States');
INSERT INTO cc_prefix VALUES(1413, 'United States');
INSERT INTO cc_prefix VALUES(1414, 'United States');
INSERT INTO cc_prefix VALUES(1415, 'United States');
INSERT INTO cc_prefix VALUES(1417, 'United States');
INSERT INTO cc_prefix VALUES(1419, 'United States');
INSERT INTO cc_prefix VALUES(1423, 'United States');
INSERT INTO cc_prefix VALUES(1424, 'United States');
INSERT INTO cc_prefix VALUES(1425, 'United States');
INSERT INTO cc_prefix VALUES(1430, 'United States');
INSERT INTO cc_prefix VALUES(1432, 'United States');
INSERT INTO cc_prefix VALUES(1434, 'United States');
INSERT INTO cc_prefix VALUES(1435, 'United States');
INSERT INTO cc_prefix VALUES(1440, 'United States');
INSERT INTO cc_prefix VALUES(1442, 'United States');
INSERT INTO cc_prefix VALUES(1443, 'United States');
INSERT INTO cc_prefix VALUES(1445, 'United States');
INSERT INTO cc_prefix VALUES(1447, 'United States');
INSERT INTO cc_prefix VALUES(1456, 'United States');
INSERT INTO cc_prefix VALUES(1464, 'United States');
INSERT INTO cc_prefix VALUES(1469, 'United States');
INSERT INTO cc_prefix VALUES(1470, 'United States');
INSERT INTO cc_prefix VALUES(1475, 'United States');
INSERT INTO cc_prefix VALUES(1478, 'United States');
INSERT INTO cc_prefix VALUES(1479, 'United States');
INSERT INTO cc_prefix VALUES(1480, 'United States');
INSERT INTO cc_prefix VALUES(1484, 'United States');
INSERT INTO cc_prefix VALUES(15, 'United States');
INSERT INTO cc_prefix VALUES(1501, 'United States');
INSERT INTO cc_prefix VALUES(1502, 'United States');
INSERT INTO cc_prefix VALUES(1503, 'United States');
INSERT INTO cc_prefix VALUES(1504, 'United States');
INSERT INTO cc_prefix VALUES(1505, 'United States');
INSERT INTO cc_prefix VALUES(1507, 'United States');
INSERT INTO cc_prefix VALUES(1508, 'United States');
INSERT INTO cc_prefix VALUES(1509, 'United States');
INSERT INTO cc_prefix VALUES(1510, 'United States');
INSERT INTO cc_prefix VALUES(1512, 'United States');
INSERT INTO cc_prefix VALUES(1513, 'United States');
INSERT INTO cc_prefix VALUES(1515, 'United States');
INSERT INTO cc_prefix VALUES(1516, 'United States');
INSERT INTO cc_prefix VALUES(1517, 'United States');
INSERT INTO cc_prefix VALUES(1518, 'United States');
INSERT INTO cc_prefix VALUES(1520, 'United States');
INSERT INTO cc_prefix VALUES(1530, 'United States');
INSERT INTO cc_prefix VALUES(1540, 'United States');
INSERT INTO cc_prefix VALUES(1541, 'United States');
INSERT INTO cc_prefix VALUES(1551, 'United States');
INSERT INTO cc_prefix VALUES(1555, 'United States');
INSERT INTO cc_prefix VALUES(1557, 'United States');
INSERT INTO cc_prefix VALUES(1559, 'United States');
INSERT INTO cc_prefix VALUES(1561, 'United States');
INSERT INTO cc_prefix VALUES(1562, 'United States');
INSERT INTO cc_prefix VALUES(1563, 'United States');
INSERT INTO cc_prefix VALUES(1564, 'United States');
INSERT INTO cc_prefix VALUES(1567, 'United States');
INSERT INTO cc_prefix VALUES(1570, 'United States');
INSERT INTO cc_prefix VALUES(1571, 'United States');
INSERT INTO cc_prefix VALUES(1573, 'United States');
INSERT INTO cc_prefix VALUES(1574, 'United States');
INSERT INTO cc_prefix VALUES(1575, 'United States');
INSERT INTO cc_prefix VALUES(1580, 'United States');
INSERT INTO cc_prefix VALUES(1585, 'United States');
INSERT INTO cc_prefix VALUES(1586, 'United States');
INSERT INTO cc_prefix VALUES(1601, 'United States');
INSERT INTO cc_prefix VALUES(1602, 'United States');
INSERT INTO cc_prefix VALUES(1603, 'United States');
INSERT INTO cc_prefix VALUES(1605, 'United States');
INSERT INTO cc_prefix VALUES(1606, 'United States');
INSERT INTO cc_prefix VALUES(1607, 'United States');
INSERT INTO cc_prefix VALUES(1608, 'United States');
INSERT INTO cc_prefix VALUES(1609, 'United States');
INSERT INTO cc_prefix VALUES(1610, 'United States');
INSERT INTO cc_prefix VALUES(1612, 'United States');
INSERT INTO cc_prefix VALUES(1614, 'United States');
INSERT INTO cc_prefix VALUES(1615, 'United States');
INSERT INTO cc_prefix VALUES(1616, 'United States');
INSERT INTO cc_prefix VALUES(1617, 'United States');
INSERT INTO cc_prefix VALUES(1618, 'United States');
INSERT INTO cc_prefix VALUES(1619, 'United States');
INSERT INTO cc_prefix VALUES(1620, 'United States');
INSERT INTO cc_prefix VALUES(1623, 'United States');
INSERT INTO cc_prefix VALUES(1626, 'United States');
INSERT INTO cc_prefix VALUES(1627, 'United States');
INSERT INTO cc_prefix VALUES(1628, 'United States');
INSERT INTO cc_prefix VALUES(1630, 'United States');
INSERT INTO cc_prefix VALUES(1631, 'United States');
INSERT INTO cc_prefix VALUES(1636, 'United States');
INSERT INTO cc_prefix VALUES(1641, 'United States');
INSERT INTO cc_prefix VALUES(1646, 'United States');
INSERT INTO cc_prefix VALUES(1650, 'United States');
INSERT INTO cc_prefix VALUES(1651, 'United States');
INSERT INTO cc_prefix VALUES(1657, 'United States');
INSERT INTO cc_prefix VALUES(1659, 'United States');
INSERT INTO cc_prefix VALUES(1660, 'United States');
INSERT INTO cc_prefix VALUES(1661, 'United States');
INSERT INTO cc_prefix VALUES(1662, 'United States');
INSERT INTO cc_prefix VALUES(1667, 'United States');
INSERT INTO cc_prefix VALUES(1669, 'United States');
INSERT INTO cc_prefix VALUES(1678, 'United States');
INSERT INTO cc_prefix VALUES(1679, 'United States');
INSERT INTO cc_prefix VALUES(1682, 'United States');
INSERT INTO cc_prefix VALUES(1689, 'United States');
INSERT INTO cc_prefix VALUES(17, 'United States');
INSERT INTO cc_prefix VALUES(1701, 'United States');
INSERT INTO cc_prefix VALUES(1702, 'United States');
INSERT INTO cc_prefix VALUES(1703, 'United States');
INSERT INTO cc_prefix VALUES(1704, 'United States');
INSERT INTO cc_prefix VALUES(1706, 'United States');
INSERT INTO cc_prefix VALUES(1707, 'United States');
INSERT INTO cc_prefix VALUES(1708, 'United States');
INSERT INTO cc_prefix VALUES(1710, 'United States');
INSERT INTO cc_prefix VALUES(1712, 'United States');
INSERT INTO cc_prefix VALUES(1713, 'United States');
INSERT INTO cc_prefix VALUES(1714, 'United States');
INSERT INTO cc_prefix VALUES(1715, 'United States');
INSERT INTO cc_prefix VALUES(1716, 'United States');
INSERT INTO cc_prefix VALUES(1717, 'United States');
INSERT INTO cc_prefix VALUES(1718, 'United States');
INSERT INTO cc_prefix VALUES(1719, 'United States');
INSERT INTO cc_prefix VALUES(1720, 'United States');
INSERT INTO cc_prefix VALUES(1724, 'United States');
INSERT INTO cc_prefix VALUES(1727, 'United States');
INSERT INTO cc_prefix VALUES(1730, 'United States');
INSERT INTO cc_prefix VALUES(1731, 'United States');
INSERT INTO cc_prefix VALUES(1732, 'United States');
INSERT INTO cc_prefix VALUES(1734, 'United States');
INSERT INTO cc_prefix VALUES(1737, 'United States');
INSERT INTO cc_prefix VALUES(1740, 'United States');
INSERT INTO cc_prefix VALUES(1747, 'United States');
INSERT INTO cc_prefix VALUES(1752, 'United States');
INSERT INTO cc_prefix VALUES(1754, 'United States');
INSERT INTO cc_prefix VALUES(1757, 'United States');
INSERT INTO cc_prefix VALUES(1760, 'United States');
INSERT INTO cc_prefix VALUES(1762, 'United States');
INSERT INTO cc_prefix VALUES(1763, 'United States');
INSERT INTO cc_prefix VALUES(1764, 'United States');
INSERT INTO cc_prefix VALUES(1765, 'United States');
INSERT INTO cc_prefix VALUES(1769, 'United States');
INSERT INTO cc_prefix VALUES(1770, 'United States');
INSERT INTO cc_prefix VALUES(1772, 'United States');
INSERT INTO cc_prefix VALUES(1773, 'United States');
INSERT INTO cc_prefix VALUES(1774, 'United States');
INSERT INTO cc_prefix VALUES(1775, 'United States');
INSERT INTO cc_prefix VALUES(1779, 'United States');
INSERT INTO cc_prefix VALUES(1781, 'United States');
INSERT INTO cc_prefix VALUES(1785, 'United States');
INSERT INTO cc_prefix VALUES(1786, 'United States');
INSERT INTO cc_prefix VALUES(1801, 'United States');
INSERT INTO cc_prefix VALUES(1802, 'United States');
INSERT INTO cc_prefix VALUES(1803, 'United States');
INSERT INTO cc_prefix VALUES(1804, 'United States');
INSERT INTO cc_prefix VALUES(1805, 'United States');
INSERT INTO cc_prefix VALUES(1806, 'United States');
INSERT INTO cc_prefix VALUES(1808, 'United States');
INSERT INTO cc_prefix VALUES(1810, 'United States');
INSERT INTO cc_prefix VALUES(1812, 'United States');
INSERT INTO cc_prefix VALUES(1813, 'United States');
INSERT INTO cc_prefix VALUES(1814, 'United States');
INSERT INTO cc_prefix VALUES(1815, 'United States');
INSERT INTO cc_prefix VALUES(1816, 'United States');
INSERT INTO cc_prefix VALUES(1817, 'United States');
INSERT INTO cc_prefix VALUES(1818, 'United States');
INSERT INTO cc_prefix VALUES(1828, 'United States');
INSERT INTO cc_prefix VALUES(1830, 'United States');
INSERT INTO cc_prefix VALUES(1831, 'United States');
INSERT INTO cc_prefix VALUES(1832, 'United States');
INSERT INTO cc_prefix VALUES(1835, 'United States');
INSERT INTO cc_prefix VALUES(1843, 'United States');
INSERT INTO cc_prefix VALUES(1845, 'United States');
INSERT INTO cc_prefix VALUES(1847, 'United States');
INSERT INTO cc_prefix VALUES(1848, 'United States');
INSERT INTO cc_prefix VALUES(1850, 'United States');
INSERT INTO cc_prefix VALUES(1856, 'United States');
INSERT INTO cc_prefix VALUES(1857, 'United States');
INSERT INTO cc_prefix VALUES(1858, 'United States');
INSERT INTO cc_prefix VALUES(1859, 'United States');
INSERT INTO cc_prefix VALUES(1860, 'United States');
INSERT INTO cc_prefix VALUES(1862, 'United States');
INSERT INTO cc_prefix VALUES(1863, 'United States');
INSERT INTO cc_prefix VALUES(1864, 'United States');
INSERT INTO cc_prefix VALUES(1865, 'United States');
INSERT INTO cc_prefix VALUES(1870, 'United States');
INSERT INTO cc_prefix VALUES(1872, 'United States');
INSERT INTO cc_prefix VALUES(1878, 'United States');
INSERT INTO cc_prefix VALUES(1901, 'United States');
INSERT INTO cc_prefix VALUES(1903, 'United States');
INSERT INTO cc_prefix VALUES(1904, 'United States');
INSERT INTO cc_prefix VALUES(1906, 'United States');
INSERT INTO cc_prefix VALUES(1908, 'United States');
INSERT INTO cc_prefix VALUES(1909, 'United States');
INSERT INTO cc_prefix VALUES(1910, 'United States');
INSERT INTO cc_prefix VALUES(1912, 'United States');
INSERT INTO cc_prefix VALUES(1913, 'United States');
INSERT INTO cc_prefix VALUES(1914, 'United States');
INSERT INTO cc_prefix VALUES(1915, 'United States');
INSERT INTO cc_prefix VALUES(1916, 'United States');
INSERT INTO cc_prefix VALUES(1917, 'United States');
INSERT INTO cc_prefix VALUES(1918, 'United States');
INSERT INTO cc_prefix VALUES(1919, 'United States');
INSERT INTO cc_prefix VALUES(1920, 'United States');
INSERT INTO cc_prefix VALUES(1925, 'United States');
INSERT INTO cc_prefix VALUES(1928, 'United States');
INSERT INTO cc_prefix VALUES(1931, 'United States');
INSERT INTO cc_prefix VALUES(1935, 'United States');
INSERT INTO cc_prefix VALUES(1936, 'United States');
INSERT INTO cc_prefix VALUES(1937, 'United States');
INSERT INTO cc_prefix VALUES(1940, 'United States');
INSERT INTO cc_prefix VALUES(1941, 'United States');
INSERT INTO cc_prefix VALUES(1947, 'United States');
INSERT INTO cc_prefix VALUES(1949, 'United States');
INSERT INTO cc_prefix VALUES(1951, 'United States');
INSERT INTO cc_prefix VALUES(1952, 'United States');
INSERT INTO cc_prefix VALUES(1954, 'United States');
INSERT INTO cc_prefix VALUES(1956, 'United States');
INSERT INTO cc_prefix VALUES(1959, 'United States');
INSERT INTO cc_prefix VALUES(1970, 'United States');
INSERT INTO cc_prefix VALUES(1971, 'United States');
INSERT INTO cc_prefix VALUES(1972, 'United States');
INSERT INTO cc_prefix VALUES(1973, 'United States');
INSERT INTO cc_prefix VALUES(1975, 'United States');
INSERT INTO cc_prefix VALUES(1978, 'United States');
INSERT INTO cc_prefix VALUES(1979, 'United States');
INSERT INTO cc_prefix VALUES(1980, 'United States');
INSERT INTO cc_prefix VALUES(1984, 'United States');
INSERT INTO cc_prefix VALUES(1985, 'United States');
INSERT INTO cc_prefix VALUES(1989, 'United States');
INSERT INTO cc_prefix VALUES(1907, 'United States [ALASKA]');
INSERT INTO cc_prefix VALUES(998722273, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998722274, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998722275, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998722276, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998722277, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998722278, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998722279, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998722295, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872325, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872326, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872327, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872328, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872329, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872360, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872361, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872362, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872363, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872364, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872365, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872366, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872570, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872575, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872577, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99872579, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873210, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873211, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873212, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873213, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873214, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873215, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873216, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873221, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873234, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873236, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873239, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873271, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873275, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873279, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873330, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873333, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998735, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873501, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873502, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873503, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873504, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873555, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873557, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873559, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873590, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873595, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873599, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873940, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873941, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873944, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873955, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873956, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99873966, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874229, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874250, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874255, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874257, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874260, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874261, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874262, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874263, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874264, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874265, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874266, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874267, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874271, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874272, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874273, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874274, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874275, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874277, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874510, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874580, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874585, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874775, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874777, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874778, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874970, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874971, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874975, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874976, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874977, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874978, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874979, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874980, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874981, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874982, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874983, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874984, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874985, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874986, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874987, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874988, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874989, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874990, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874995, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99874999, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875112, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875222, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875229, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875244, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875294, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(9987531, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875350, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875355, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875360, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875363, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875366, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875380, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875381, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875382, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875383, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875384, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875385, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875386, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875526, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875527, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875528, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99875529, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998762229, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998762246, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998762247, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998762248, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998762249, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998762257, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998762258, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998762259, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876242, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876243, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876244, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876390, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876391, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876392, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876393, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876394, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876395, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876396, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764115, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764116, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764117, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764118, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764119, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764171, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764172, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764173, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764174, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764175, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764190, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764191, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764192, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764193, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764194, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764198, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998764199, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876535, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876536, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876537, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876540, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876544, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876545, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876550, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876551, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876552, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876590, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99876595, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879221, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998792225, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998792226, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998792227, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879228, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879320, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879321, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879322, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879323, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879324, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879370, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879371, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879372, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879377, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879570, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998795726, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998795727, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998795728, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998795729, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879575, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879576, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998795790, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879725, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879727, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879740, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879744, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99879747, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99890, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99891, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99892, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99893, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99895, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99897, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(99898, 'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(678, 'Vanuatu');
INSERT INTO cc_prefix VALUES(67854, 'Vanuatu Mobile');
INSERT INTO cc_prefix VALUES(67855, 'Vanuatu Mobile');
INSERT INTO cc_prefix VALUES(67877, 'Vanuatu Mobile');
INSERT INTO cc_prefix VALUES(58, 'Venezuela');
INSERT INTO cc_prefix VALUES(584, 'Venezuela Mobile');
INSERT INTO cc_prefix VALUES(84, 'Viet Nam');
INSERT INTO cc_prefix VALUES(84122, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(84123, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(84126, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(84166, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(84168, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(84169, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8490, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8491, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8492, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8493, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8494, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8495, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8496, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8497, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8498, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(8499, 'Viet Nam Mobile');
INSERT INTO cc_prefix VALUES(681, 'Wallis and Futuna');
INSERT INTO cc_prefix VALUES(967, 'Yemen');
INSERT INTO cc_prefix VALUES(96758, 'Yemen Mobile');
INSERT INTO cc_prefix VALUES(96771, 'Yemen Mobile');
INSERT INTO cc_prefix VALUES(96773, 'Yemen Mobile');
INSERT INTO cc_prefix VALUES(96777, 'Yemen Mobile');
INSERT INTO cc_prefix VALUES(260, 'Zambia');
INSERT INTO cc_prefix VALUES(26095, 'Zambia Mobile');
INSERT INTO cc_prefix VALUES(26096, 'Zambia Mobile');
INSERT INTO cc_prefix VALUES(26097, 'Zambia Mobile');
INSERT INTO cc_prefix VALUES(26098, 'Zambia Mobile');
INSERT INTO cc_prefix VALUES(26099, 'Zambia Mobile');
INSERT INTO cc_prefix VALUES(263, 'Zimbabwe');
INSERT INTO cc_prefix VALUES(26311, 'Zimbabwe Mobile');
INSERT INTO cc_prefix VALUES(26323, 'Zimbabwe Mobile');
INSERT INTO cc_prefix VALUES(26391, 'Zimbabwe Mobile');

INSERT INTO cc_prefix VALUES(1,'USA');
INSERT INTO cc_prefix VALUES(379,'Vatican City');
INSERT INTO cc_prefix VALUES(998714,'Uzbekistan Tashkent');
INSERT INTO cc_prefix VALUES(998711,'Uzbekistan Tashkent');
INSERT INTO cc_prefix VALUES(998713,'Uzbekistan Tashkent');
INSERT INTO cc_prefix VALUES(998712,'Uzbekistan Tashkent');
INSERT INTO cc_prefix VALUES(99899,'Uzbekistan Mobile');
INSERT INTO cc_prefix VALUES(998,'Uzbekistan');




-- Add here the different exit code you use : 0, 00, 000
-- the commented example strips 1 digit and prefixes with 44
CREATE TEMPORARY TABLE t1 AS SELECT DISTINCT dialprefix FROM cc_ratecard WHERE dialprefix REGEXP '^[0-9]+';
ALTER TABLE t1 ADD COLUMN prefix_id bigint;
UPDATE t1 SET prefix_id=(SELECT prefix FROM cc_prefix AS p WHERE 
	t1.dialprefix LIKE concat(prefix,'%') 
	OR t1.dialprefix LIKE concat('00',concat(prefix,'%')) 
--	OR CONCAT('44', substring(t1.dialprefix,2)) LIKE (prefix || '%')
	ORDER BY length(prefix) DESC limit 1);

CREATE INDEX myindex_t1 ON t1( dialprefix );
UPDATE cc_ratecard SET destination=(SELECT  prefix_id FROM t1 WHERE t1.dialprefix = cc_ratecard.dialprefix ) WHERE destination=0;
UPDATE cc_ratecard SET destination=0 WHERE destination IS NULL;

DROP TEMPORARY TABLE t1;

-- And here too
UPDATE cc_call AS t1 SET destination=(SELECT prefix FROM cc_prefix AS p WHERE
	t1.calledstation LIKE CONCAT(prefix, '%')
	OR t1.calledstation LIKE CONCAT('00', CONCAT(prefix, '%'))
--	OR CONCAT('44', SUBSTRING(t1.calledstation,2)) LIKE CONCAT(prefix, '%')
	ORDER BY length(prefix) DESC limit 1)
	WHERE destination=0 OR destination IS NULL;


/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/

--
-- A2Billing database script - Update database for MYSQL 5.X
-- 
-- 
-- Usage:
-- mysql -u root -p"root password" < UPDATE-a2billing-v1.4.0-to-v1.4.1.sql
--



ALTER TABLE cc_charge DROP currency;
ALTER TABLE cc_subscription_fee DROP currency;  
ALTER TABLE cc_ui_authen ADD country VARCHAR( 40 ) CHARACTER SET utf8 COLLATE utf8_bin NULL ;
ALTER TABLE cc_ui_authen ADD city VARCHAR( 40 ) CHARACTER SET utf8 COLLATE utf8_bin NULL ;

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES('Option CallerID update', 'callerid_update', '0', 'Prompt the caller to update his callerID', 1, 'yes,no', 'agi-conf1');

DELETE FROM cc_config WHERE config_key = 'paymentmethod' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'personalinfo' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'customerinfo' AND config_group_title = 'webcustomerui';
DELETE FROM cc_config WHERE config_key = 'password' AND config_group_title = 'webcustomerui';
UPDATE cc_card_group SET users_perms = '262142' WHERE cc_card_group.id = 1;


CREATE TABLE cc_subscription_signup (
	id BIGINT NOT NULL auto_increment,
	label VARCHAR( 50 ) collate utf8_bin NOT NULL ,
	id_subscription BIGINT NULL ,
	description MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL ,
	enable TINYINT NOT NULL DEFAULT '1',
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


DELETE FROM cc_config WHERE config_key = 'currency_cents_association';
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title)
	VALUES ('Cents Currency Associated', 'currency_cents_association', 'usd:prepaid-cents,eur:prepaid-cents,gbp:prepaid-pence,all:credit', 'Define all the audio (without file extensions) that you want to play according to cents currency (use , to separate, ie "amd:lumas").By default the file used is "prepaid-cents" .Use plural to define the cents currency sound, but import two sounds but cents currency defined : ending by ''s'' and not ending by ''s'' (i.e. for lumas , add 2 files : ''lumas'' and ''luma'') ', '0', NULL, 'ivr_creditcard');
DELETE FROM cc_config WHERE config_key = 'currency_association_minor';


-- Local Dialing Normalisation
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES 
	('Option Local Dialing', 'local_dialing_addcountryprefix', '0', 'Add the countryprefix of the user in front of the dialed number if this one have only 1 leading zero', 1, 'yes,no', 'agi-conf1');


-- Remove E-Product from 1.4.1
DROP TABLE cc_ecommerce_product;

INSERT INTO cc_invoice_conf (key_val ,`value`) VALUES ('display_account', '0');

-- add missing agent field
ALTER TABLE cc_system_log ADD agent TINYINT DEFAULT 0;

DELETE FROM cc_config WHERE config_key = 'show_icon_invoice';
DELETE FROM cc_config WHERE config_key = 'show_top_frame';

-- add MXN currency on Paypal
UPDATE cc_configuration SET set_function = 'tep_cfg_select_option(array(''Selected Currency'',''USD'',''CAD'',''EUR'',''GBP'',''JPY'',''MXN''), ' WHERE configuration_key = 'MODULE_PAYMENT_PAYPAL_CURRENCY' ;


-- DID CALL AND BILLING
ALTER TABLE cc_didgroup DROP iduser;
ALTER TABLE cc_didgroup ADD connection_charge DECIMAL( 15, 5 ) NOT NULL DEFAULT '0',
ADD selling_rate DECIMAL( 15, 5 ) NOT NULL DEFAULT '0';

ALTER TABLE cc_did ADD UNIQUE (did);

INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_listvalues ,config_group_title)
VALUES ('Call to free DID Dial Command Params', 'dialcommand_param_call_2did', '|60|HiL(%timeout%:61000:30000)',  '%timeout% is the value of the paramater : ''Max time to Call a DID no billed''', '0', NULL , 'agi-conf1');
INSERT INTO cc_config (config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_listvalues ,config_group_title)
VALUES ('Max time to Call a DID no billed', 'max_call_call_2_did', '3600', 'max time to call a did of the system and not billed . this max value is in seconde and by default (3600 = 1HOUR MAX CALL).', '0', NULL , 'agi-conf1');


-- remove the Signup Link option
Delete from cc_config where config_key='signup_page_url';

-- remove the old auto create card feature
Delete from cc_config where config_key='cid_auto_create_card';
Delete from cc_config where config_key='cid_auto_create_card_len';
Delete from cc_config where config_key='cid_auto_create_card_typepaid';
Delete from cc_config where config_key='cid_auto_create_card_credit';
Delete from cc_config where config_key='cid_auto_create_card_credit_limit';
Delete from cc_config where config_key='cid_auto_create_card_tariffgroup';


-- change type in cc_config
ALTER TABLE cc_config CHANGE config_title config_title VARCHAR( 100 ); 
ALTER TABLE cc_config CHANGE config_key config_key VARCHAR( 100 ); 
ALTER TABLE cc_config CHANGE config_value config_value VARCHAR( 100 ); 
ALTER TABLE cc_config CHANGE config_listvalues config_listvalues VARCHAR( 100 ); 

-- Set Qualify at No per default
UPDATE cc_config SET config_value='no' WHERE config_key='qualify';


-- Update Paypal URL API
UPDATE cc_config SET config_value='https://www.paypal.com/cgi-bin/webscr' WHERE config_key='paypal_payment_url';

-- change type in cc_config
ALTER TABLE cc_config CHANGE config_value config_value VARCHAR( 200 ); 

ALTER TABLE cc_didgroup DROP connection_charge;
ALTER TABLE cc_didgroup DROP selling_rate;


ALTER TABLE cc_did ADD connection_charge DECIMAL( 15, 5 ) NOT NULL DEFAULT '0',
ADD selling_rate DECIMAL( 15, 5 ) NOT NULL DEFAULT '0';

ALTER TABLE cc_billing_customer ADD start_date TIMESTAMP NULL ;


/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


CREATE TABLE cc_message_agent (
    id BIGINT NOT NULL AUTO_INCREMENT ,
    id_agent INT NOT NULL ,
    message LONGTEXT CHARACTER SET utf8 COLLATE utf8_bin NULL ,
    type TINYINT NOT NULL DEFAULT '0' ,
    logo TINYINT NOT NULL DEFAULT '1',
    order_display INT NOT NULL ,
    PRIMARY KEY ( id )
) ENGINE = MYISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES( 'Auto Create Card', 'cid_auto_create_card', '0', 'if the callerID is captured on a2billing, this option will create automatically a new card and add the callerID to it.', 1, 'yes,no', 'agi-conf1');
INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES( 'Auto Create Card Length', 'cid_auto_create_card_len', '10', 'set the length of the card that will be auto create (ie, 10).', 0, NULL, 'agi-conf1');
INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES( 'Auto Create Card Type', 'cid_auto_create_card_typepaid', 'PREPAID', 'billing type of the new card( value : POSTPAID or PREPAID) .', 0, NULL, 'agi-conf1');
INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES( 'Auto Create Card Credit', 'cid_auto_create_card_credit', '0', 'amount of credit of the new card.', 0, NULL, 'agi-conf1');
INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES( 'Auto Create Card Limit', 'cid_auto_create_card_credit_limit', '0', 'if postpay, define the credit limit for the card.', 0, NULL, 'agi-conf1');
INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES( 'Auto Create Card TariffGroup', 'cid_auto_create_card_tariffgroup', '1', 'the tariffgroup to use for the new card (this is the ID that you can find on the admin web interface) .', 0, NULL, 'agi-conf1');

INSERT INTO cc_config (id ,config_title ,config_key ,config_value ,config_description ,config_valuetype ,config_listvalues ,config_group_title)
    VALUES  (NULL , 'Paypal Amount Subscription', 'paypal_subscription_amount', '10' , 'amount to billed each recurrence of payment ', '0', NULL , 'epayment_method'),
	    (NULL , 'Paypal Subscription Time period number', 'paypal_subscription_period_number', '1', 'number of time periods between each recurrence', '0', NULL , 'epayment_method'),
	    (NULL , 'Paypal Subscription Time period', 'paypal_subscription_time_period', 'M', 'time period (D=days, W=weeks, M=months, Y=years)', '0', NULL , 'epayment_method'),
	    (NULL , 'Enable PayPal subscription', 'paypal_subscription_enabled', '0', 'Enable Paypal subscription on the User home page, you need a Premier or Business account.', '1', 'yes,no', 'epayment_method'),
	    (NULL , 'Paypal Subscription account', 'paypal_subscription_account', '', 'Your PayPal ID or an email address associated with your PayPal account. Email addresses must be confirmed and bound to a Premier or Business Verified Account.', '0', NULL , 'epayment_method');


-- make sure we disabled Authorize
DELETE FROM cc_payment_methods where payment_filename = 'authorizenet.php';

ALTER TABLE cc_templatemail ADD PRIMARY KEY ( id )  ;
ALTER TABLE cc_templatemail CHANGE id id INT( 11 ) NOT NULL AUTO_INCREMENT  ;

INSERT INTO cc_templatemail (id_language, mailtype, fromemail, fromname, subject, messagetext)
    VALUES	('en', 'did_paid', 'info@mydomainname.com', 'COMPANY NAME', 'DID notification - ($did$)', 'BALANCE REMAINING $balance_remaining$ $base_currency$\n\nAn automatic taking away of : $did_cost$ $base_currency$ has been carry out of your account to pay your DID ($did$)\n\nMonthly cost for DID : $did_cost$ $base_currency$\n\n'),
		('en', 'did_unpaid', 'info@mydomainname.com', 'COMPANY NAME', 'DID notification - ($did$)', 'BALANCE REMAINING $balance_remaining$ $base_currency$\n\nYour credit is not enough to pay your DID number ($did$), the monthly cost is : $did_cost$ $base_currency$\n\nYou have $days_remaining$ days to pay the invoice (REF: $invoice_ref$ ) or the DID will be automatically released \n\n'),
		('en', 'did_released', 'info@mydomainname.com', 'COMPANY NAME', 'DID released - ($did$)', 'The DID $did$ has been automatically released!\n\n');		


DELETE FROM cc_configuration WHERE configuration_key = 'MODULE_PAYMENT_PAYPAL_CURRENCY';
DELETE FROM cc_configuration WHERE configuration_key = 'MODULE_PAYMENT_MONEYBOOKERS_CURRENCY';

ALTER TABLE cc_support ADD email VARCHAR( 70 ) CHARACTER SET utf8 COLLATE utf8_bin NULL ;
ALTER TABLE cc_support ADD language CHAR( 5 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'en';
INSERT INTO cc_templatemail (id_language, mailtype, fromemail, fromname, subject, messagetext)
    VALUES	('en', 'new_ticket', 'info@mydomainname.com', 'COMPANY NAME', 'Support Ticket #$ticket_id$', 'New Ticket Open (#$ticket_id$) From $ticket_owner$.\n Title : $ticket_title$\n Priority : $ticket_priority$ \n Status : $ticket_status$ \n Description : $ticket_description$ \n'),
		('en', 'modify_ticket', 'info@mydomainname.com', 'COMPANY NAME', 'Support Ticket #$ticket_id$', 'Ticket modified (#$ticket_id$) By $comment_creator$.\n Ticket Status -> $ticket_status$\n Description : $comment_description$ \n');
DELETE FROM cc_templatemail WHERE mailtype = 'invoice';
INSERT INTO cc_templatemail (id_language, mailtype, fromemail, fromname, subject, messagetext)
    VALUES	('en', 'invoice_to_pay', 'info@mydomainname.com', 'COMPANY NAME', 'Invoice to pay Ref: $invoice_reference$', 
    'New Invoice send with the reference : $invoice_reference$ .\n 
    Title : $invoice_title$ .\n Description : $invoice_description$\n 
    TOTAL (exclude VAT) : $invoice_total$  $base_currency$\n TOTAL (invclude VAT) : $invoice_total_vat$ $base_currency$ \n\n 
    TOTAL TO PAY : $invoice_total_vat$ $base_currency$\n\n 
    You can check and pay this invoice by your account on the web interface : http://mydomainname.com/customer/  ');




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


create index idtariffplan_index on cc_ratecard (idtariffplan);


UPDATE cc_config SET config_title='DID Billing Days to pay', config_description='Define the amount of days you want to give to the user before releasing its DIDs' WHERE config_key='didbilling_daytopay ';


-- Add new field for VT provisioning
ALTER TABLE cc_card_group ADD provisioning VARCHAR( 200 ) CHARACTER SET utf8 COLLATE utf8_bin NULL;


-- New setting for Base_country and Base_language
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES('Base Country', 'base_country', 'USA', 'Define the country code in 3 letters where you are located (ISO 3166-1 : "USA" for United States)', 0, '', 'global');
INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES('Base Language', 'base_language', 'en', 'Define your language code in 2 letters (ISO 639 : "en" for English)', 0, '', 'global');



-- Change lenght of field for provisioning system
ALTER TABLE cc_card_group CHANGE name name varchar( 50 );
ALTER TABLE cc_trunk CHANGE trunkcode trunkcode varchar( 50 );


-- change lenght on Notification
ALTER TABLE cc_notification CHANGE key_value key_value VARCHAR( 255 );



-- IAX Friends update

CREATE INDEX iax_friend_nh_index on cc_iax_buddies (name, host);
CREATE INDEX iax_friend_nip_index on cc_iax_buddies (name, ipaddr, port);
CREATE INDEX iax_friend_ip_index on cc_iax_buddies (ipaddr, port);
CREATE INDEX iax_friend_hp_index on cc_iax_buddies (host, port);


ALTER TABLE cc_iax_buddies
	DROP callgroup,
	DROP canreinvite,
	DROP dtmfmode,
	DROP fromuser,
	DROP fromdomain,
	DROP insecure,
	DROP mailbox,
	DROP md5secret,
	DROP nat,
	DROP pickupgroup,
	DROP restrictcid,
	DROP rtptimeout,
	DROP rtpholdtimeout,
	DROP musiconhold,
	DROP cancallforward;


ALTER TABLE cc_iax_buddies 
	ADD dbsecret varchar(40) NOT NULL default '',
	ADD regcontext varchar(40) NOT NULL default '',
	ADD sourceaddress varchar(20) NOT NULL default '',
	ADD mohinterpret varchar(20) NOT NULL default '', 
	ADD mohsuggest varchar(20) NOT NULL default '', 
	ADD inkeys varchar(40) NOT NULL default '', 
	ADD outkey varchar(40) NOT NULL default '', 
	ADD cid_number varchar(40) NOT NULL default '', 
	ADD sendani varchar(10) NOT NULL default '', 
	ADD fullname varchar(40) NOT NULL default '', 
	ADD auth varchar(20) NOT NULL default '', 
	ADD maxauthreq varchar(15) NOT NULL default '', 
	ADD encryption varchar(20) NOT NULL default '', 
	ADD transfer varchar(10) NOT NULL default '', 
	ADD jitterbuffer varchar(10) NOT NULL default '', 
	ADD forcejitterbuffer varchar(10) NOT NULL default '', 
	ADD codecpriority varchar(40) NOT NULL default '', 
	ADD qualifysmoothing varchar(10) NOT NULL default '', 
	ADD qualifyfreqok varchar(10) NOT NULL default '', 
	ADD qualifyfreqnotok varchar(10) NOT NULL default '', 
	ADD timezone varchar(20) NOT NULL default '', 
	ADD adsi varchar(10) NOT NULL default '', 
	ADD setvar varchar(200) NOT NULL default '';

-- Add IAX security settings / not support by realtime
ALTER TABLE cc_iax_buddies 
	ADD requirecalltoken varchar(20) NOT NULL default '',
	ADD maxcallnumbers varchar(10) NOT NULL default '',
	ADD maxcallnumbers_nonvalidated varchar(10) NOT NULL default '';


-- SIP Friends update

CREATE INDEX sip_friend_hp_index on cc_sip_buddies (host, port);
CREATE INDEX sip_friend_ip_index on cc_sip_buddies (ipaddr, port);


ALTER TABLE cc_sip_buddies
	ADD defaultuser varchar(40) NOT NULL default '',
	ADD auth varchar(10) NOT NULL default '',
	ADD subscribemwi varchar(10) NOT NULL default '', -- yes/no
	ADD vmexten varchar(20) NOT NULL default '',
	ADD cid_number varchar(40) NOT NULL default '',
	ADD callingpres varchar(20) NOT NULL default '',
	ADD usereqphone varchar(10) NOT NULL default '',
	ADD incominglimit varchar(10) NOT NULL default '',
	ADD subscribecontext varchar(40) NOT NULL default '',
	ADD musicclass varchar(20) NOT NULL default '',
	ADD mohsuggest varchar(20) NOT NULL default '',
	ADD allowtransfer varchar(20) NOT NULL default '',
	ADD autoframing varchar(10) NOT NULL default '', -- yes/no
	ADD maxcallbitrate varchar(15) NOT NULL default '',
	ADD outboundproxy varchar(40) NOT NULL default '',
--  ADD regserver varchar(20) NOT NULL default '',
	ADD rtpkeepalive varchar(15) NOT NULL default '';



-- ADD A2Billing Version into the Database 
CREATE TABLE cc_version (
    version varchar(30) NOT NULL
) ENGINE = MYISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_version (version) VALUES ('1.4.3');

UPDATE cc_version SET version = '1.4.3';

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/



CREATE VIEW cc_callplan_lcr AS
	SELECT cc_ratecard.destination, cc_ratecard.dialprefix, cc_ratecard.buyrate, cc_ratecard.rateinitial, cc_ratecard.startdate, cc_ratecard.stopdate, cc_ratecard.initblock, cc_ratecard.connectcharge, cc_ratecard.id_trunk , cc_ratecard.idtariffplan , cc_ratecard.id, cc_tariffgroup.id AS tariffgroup_id
	FROM cc_tariffgroup 
	RIGHT JOIN cc_tariffgroup_plan ON cc_tariffgroup_plan.idtariffgroup=cc_tariffgroup.id 
	INNER JOIN cc_tariffplan ON (cc_tariffplan.id=cc_tariffgroup_plan.idtariffplan ) 
	LEFT JOIN cc_ratecard ON cc_ratecard.idtariffplan=cc_tariffplan.id;


-- New Agent commission module
ALTER TABLE cc_agent ADD com_balance DECIMAL( 15, 5 ) NOT NULL;
ALTER TABLE cc_agent_commission DROP paid_status ;
ALTER TABLE cc_agent_commission ADD commission_type TINYINT NOT NULL ;
ALTER TABLE cc_agent_commission ADD commission_percent DECIMAL( 10, 4 ) NOT NULL ;
INSERT INTO cc_config ( config_title , config_key , config_value , config_description , config_valuetype , config_listvalues , config_group_title) 
VALUES ('Authorize Remittance Request', 'remittance_request', '1', 'Enable or disable the link which allow agent to submit a remittance request', '0', 'yes,no', 'webagentui');


ALTER TABLE cc_agent ADD threshold_remittance DECIMAL( 15, 5 ) NOT NULL ;
ALTER TABLE cc_agent ADD bank_info MEDIUMTEXT NULL ;

CREATE TABLE cc_remittance_request (
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
	id_agent BIGINT NOT NULL ,
	amount DECIMAL( 15, 5 ) NOT NULL ,
	type TINYINT NOT NULL,
	date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	status TINYINT NOT NULL DEFAULT '0'
) ENGINE = MYISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- notifiction link to the record
ALTER TABLE cc_notification ADD link_id BIGINT NULL ,
ADD link_type VARCHAR( 20 ) CHARACTER SET utf8 COLLATE utf8_bin NULL;



-- Improve CallPlan LCR
DROP VIEW cc_callplan_lcr;
CREATE VIEW cc_callplan_lcr AS
	SELECT cc_ratecard.id, cc_prefix.destination, cc_ratecard.dialprefix, cc_ratecard.buyrate, cc_ratecard.rateinitial, cc_ratecard.startdate, cc_ratecard.stopdate, cc_ratecard.initblock, cc_ratecard.connectcharge, cc_ratecard.id_trunk , cc_ratecard.idtariffplan , cc_ratecard.id as ratecard_id, cc_tariffgroup.id AS tariffgroup_id
	
	FROM cc_tariffgroup 
	RIGHT JOIN cc_tariffgroup_plan ON cc_tariffgroup_plan.idtariffgroup=cc_tariffgroup.id 
	INNER JOIN cc_tariffplan ON (cc_tariffplan.id=cc_tariffgroup_plan.idtariffplan ) 
	LEFT JOIN cc_ratecard ON cc_ratecard.idtariffplan=cc_tariffplan.id
	LEFT JOIN cc_prefix ON prefix=cc_ratecard.destination
	WHERE cc_ratecard.id IS NOT NULL;
	

-- Add Asterisk Version - Global for Callback
INSERT INTO cc_config ( config_title , config_key , config_value , config_description , config_valuetype , config_listvalues , config_group_title) 
VALUES ('Asterisk Version Global', 'asterisk_version', '1_4', 'Asterisk Version Information, 1_1, 1_2, 1_4, 1_6. By Default the version is 1_4.', 
'0', NULL, 'global');


-- UPDATE A2Billing Database Version
UPDATE cc_version SET version = '1.4.4';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/



ALTER TABLE cc_did_destination CHANGE destination destination VARCHAR(120) NOT NULL;


DROP TABLE IF EXISTS cc_call_archive;
CREATE TABLE IF NOT EXISTS cc_call_archive (
    id bigint(20) NOT NULL auto_increment,
    sessionid varchar(40) collate utf8_bin NOT NULL,
    uniqueid varchar(30) collate utf8_bin NOT NULL,
    card_id bigint(20) NOT NULL,
    nasipaddress varchar(30) collate utf8_bin NOT NULL,
    starttime timestamp NOT NULL default CURRENT_TIMESTAMP,
    stoptime timestamp NOT NULL default '0000-00-00 00:00:00',
    sessiontime int(11) default NULL,
    calledstation varchar(30) collate utf8_bin NOT NULL,
    sessionbill float default NULL,
    id_tariffgroup int(11) default NULL,
    id_tariffplan int(11) default NULL,
    id_ratecard int(11) default NULL,
    id_trunk int(11) default NULL,
    sipiax int(11) default '0',
    src varchar(40) collate utf8_bin NOT NULL,
    id_did int(11) default NULL,
    buycost decimal(15,5) default '0.00000',
    id_card_package_offer int(11) default '0',
    real_sessiontime int(11) default NULL,
    dnid varchar(40) collate utf8_bin NOT NULL,
    terminatecauseid int(1) default '1',
    destination int(11) default '0',
    PRIMARY KEY  (id),
    KEY starttime (starttime),
    KEY calledstation (calledstation),
    KEY terminatecauseid (terminatecauseid)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES ('Archive Calls', 'archive_call_prior_x_month', '24', 'A cront can be enabled in order to archive your CDRs, this setting allow to define prior which month it will archive', 0, NULL, 'backup');
 

ALTER TABLE cc_logpayment ADD agent_id BIGINT NULL ;
ALTER TABLE cc_logrefill ADD agent_id BIGINT NULL ;


ALTER TABLE `cc_ratecard` CHANGE `destination` `destination` BIGINT( 20 ) NULL DEFAULT '0';


UPDATE cc_version SET version = '1.4.5';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/






UPDATE cc_version SET version = '1.4.4.1';








/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


UPDATE cc_version SET version = '1.5.0';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/



UPDATE cc_version SET version = '1.5.1';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


ALTER TABLE cc_subscription_fee ADD startdate TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
ADD stopdate TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00';

RENAME TABLE cc_subscription_fee  TO cc_subscription_service ;
ALTER TABLE cc_card_subscription ADD paid_status TINYINT NOT NULL DEFAULT '0' ;
ALTER TABLE cc_card_subscription ADD last_run TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00';
ALTER TABLE cc_card_subscription ADD next_billing_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00';
UPDATE cc_card_subscription SET next_billing_date = NOW();
ALTER TABLE cc_card_subscription ADD limit_pay_date TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00';


INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) 
			VALUES ('Days to bill before month anniversary', 'subscription_bill_days_before_anniversary', '3',
					'Numbers of days to bill a subscription service before the month anniversary', 0, NULL, 'global');

ALTER TABLE cc_templatemail CHANGE subject subject VARCHAR( 130 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;

INSERT INTO cc_templatemail (id_language, mailtype, fromemail, fromname, subject, messagetext)
VALUES  ('en', 'subscription_paid', 'info@mydomainname.com', 'COMPANY NAME',
'Subscription notification - $subscription_label$ ($subscription_id$)',
'BALANCE  $credit$ $base_currency$\n\n
A decrement of: $subscription_fee$ $base_currency$ has removed from your account to pay your service. ($subscription_label$)\n\n
the monthly cost is : $subscription_fee$\n\n'),

('en', 'subscription_unpaid', 'info@mydomainname.com', 'COMPANY NAME',
'Subscription notification - $subscription_label$ ($subscription_id$)',
'BALANCE $credit$ $base_currency$\n\n
You do not have enough credit to pay your subscription,($subscription_label$), the monthly cost is : $subscription_fee$ $base_currency$\n\n
You have $days_remaining$ days to pay the invoice (REF: $invoice_ref$ ) or your service may cease \n\n'),

('en', 'subscription_disable_card', 'info@mydomainname.com', 'COMPANY NAME',
'Service deactivated - unpaid service $subscription_label$ ($subscription_id$)',
'The account has been automatically deactivated until the invoice is settled.\n\n');



ALTER TABLE cc_subscription_service CHANGE label label VARCHAR( 200 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL;
ALTER TABLE cc_subscription_service CHANGE emailreport emailreport VARCHAR( 100 ) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL;
ALTER TABLE cc_subscription_signup CHANGE description description VARCHAR( 500 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;



INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title)
VALUES ('Enable info module about system', 'system_info_enable', 'LEFT', 'Enabled this if you want to display the info module and place it somewhere on the Dashboard.', 0, 'NONE,LEFT,CENTER,RIGHT', 'dashboard');

INSERT INTO cc_config (config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title)
VALUES ('Enable news module', 'news_enabled','RIGHT','Enabled this if you want to display the news module and place it somewhere on the Dashboard.', 0, 'NONE,LEFT,CENTER,RIGHT', 'dashboard');



# update destination field to a BIGINT
ALTER TABLE cc_ratecard CHANGE destination destination BIGINT( 20 ) NULL DEFAULT '0';


# query_type : 1 SQL ; 2 for shell script
# result_type : 1 Text2Speech, 2 Date, 3 Number, 4 Digits
CREATE TABLE cc_monitor (
	id BIGINT NOT NULL auto_increment,
	label VARCHAR( 50 ) collate utf8_bin NOT NULL ,
	dial_code INT NULL ,
	description VARCHAR( 250 ) collate utf8_bin NULL,
	text_intro VARCHAR( 250 ) collate utf8_bin NULL,
	query_type TINYINT NOT NULL DEFAULT '1',
	query VARCHAR( 1000 ) collate utf8_bin NULL,
	result_type TINYINT NOT NULL DEFAULT '1',
	enable TINYINT NOT NULL DEFAULT '1',
	PRIMARY KEY ( id )
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

INSERT INTO cc_monitor (label, dial_code, description, text_intro, query_type, query, result_type, enable) VALUES
('TotalCall', 2, 'To say the total amount of calls', 'The total amount of calls on your system is', 1, 'select count(*) from cc_call;', 3, 1),
('Say Time', 1, 'just saying the current date and time', 'The current date and time is', 1, 'SELECT UNIX_TIMESTAMP( );', 2, 1),
('Test Connectivity', 3, 'Test Connectivity with Google', 'your Internet connection is', 2, 'check_connectivity.sh', 1, 1);


INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES
( 'Busy Timeout', 'busy_timeout', '1', 'Define the timeout in second when indicate the busy condition', 0, NULL, 'agi-conf1');


ALTER TABLE cc_subscription_signup ADD id_callplan BIGINT;



-- New payment Gateway
INSERT INTO `cc_payment_methods` (`id`, `payment_method`, `payment_filename`) VALUES(5, 'iridium', 'iridium.php');

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description)
VALUES ('MerchantID', 'MODULE_PAYMENT_IRIDIUM_MERCHANTID', 'yourMerchantId', 'Your Mechant Id provided by Iridium');
INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description)
VALUES ('Password', 'MODULE_PAYMENT_IRIDIUM_PASSWORD', 'Password', 'password for Iridium merchant');

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description)
VALUES ('PaymentProcessor', 'MODULE_PAYMENT_IRIDIUM_GATEWAY', 'PaymentGateway URL ', 'Enter payment gateway URL');

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description)
VALUES ('PaymentProcessorPort', 'MODULE_PAYMENT_IRIDIUM_GATEWAY_PORT', 'PaymentGateway Port ', 'Enter payment gateway port');

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function)
VALUES ('Transaction Currency', 'MODULE_PAYMENT_IRIDIUM_CURRENCY', 'Selected Currency', 'The default currency for the payment transactions', 'tep_cfg_select_option(array(\'Selected Currency\',\'EUR\', \'USD\', \'GBP\', \'HKD\', \'SGD\', \'JPY\', \'CAD\', \'AUD\', \'CHF\', \'DKK\', \'SEK\', \'NOK\', \'ILS\', \'MYR\', \'NZD\', \'TWD\', \'THB\', \'CZK\', \'HUF\', \'SKK\', \'ISK\', \'INR\'), ');

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function)
VALUES ('Transaction Language', 'MODULE_PAYMENT_IRIDIUM_LANGUAGE', 'Selected Language', 'The default language for the payment transactions', 'tep_cfg_select_option(array(\'Selected Language\',\'EN\', \'DE\', \'ES\', \'FR\'), ');

INSERT INTO cc_configuration (configuration_title, configuration_key, configuration_value, configuration_description, set_function)
VALUES ('Enable iridium Module', 'MODULE_PAYMENT_IRIDIUM_STATUS', 'False', 'Do you want to accept Iridium payments?','tep_cfg_select_option(array(\'True\', \'False\'), ');



INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES
( 'Callback Reduce Balance', 'callback_reduce_balance', '1', 'Define the amount to reduce the balance on Callback in order to make sure that the B leg wont alter the account into a negative value.', 0, NULL, 'agi-conf1');


UPDATE cc_version SET version = '1.6.0';


/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


UPDATE cc_version SET version = '1.6.1';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


UPDATE cc_version SET version = '1.6.2';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Language field', 'field_language', '1', 'Enable The Language Field -  Yes 1 - No 0.', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Currency field', 'field_currency', '1', 'Enable The Currency Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Last Name Field', 'field_lastname', '1', 'Enable The Last Name Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'First Name Field', 'field_firstname', '1', 'Enable The First Name Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Address Field', 'field_address', '1', 'Enable The Address Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'City Field', 'field_city', '1', 'Enable The City Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'State Field', 'field_state', '1', 'Enable The State Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Country Field', 'field_country', '1', 'Enable The Country Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Zipcode Field', 'field_zipcode', '1', 'Enable The Zipcode Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Timezone Field', 'field_id_timezone', '1', 'Enable The Timezone Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Phone Field', 'field_phone', '1', 'Enable The Phone Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Fax Field', 'field_fax', '1', 'Enable The Fax Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Company Name Field', 'field_company', '1', 'Enable The Company Name Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Company Website Field', 'field_company_website', '1', 'Enable The Company Website Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'VAT Registration Number Field', 'field_VAT_RN', '1', 'Enable The VAT Registration Number Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Traffic Field', 'field_traffic', '1', 'Enable The Traffic Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');

INSERT INTO cc_config (id, config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title) VALUES (NULL, 'Traffic Target Field', 'field_traffic_target', '1', 'Enable The Traffic Target Field - Yes 1 - No 0. ', '1', 'yes,no', 'signup');



-- fix Realtime Bug, Permit have to be after Deny
ALTER TABLE cc_sip_buddies MODIFY COLUMN permit varchar(95) AFTER deny;
ALTER TABLE cc_iax_buddies MODIFY COLUMN permit varchar(95) AFTER deny;


-- Locking features
ALTER TABLE cc_card ADD block TINYINT NOT NULL DEFAULT '0';
ALTER TABLE cc_card ADD lock_pin VARCHAR( 15 ) NULL DEFAULT NULL;
ALTER TABLE cc_card ADD lock_date timestamp NULL;


INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title)
VALUES( 'IVR Locking option', 'ivr_enable_locking_option', '0', 'Enable the IVR which allow the users to lock their account with an extra lock code.', 1, 'yes,no', 'agi-conf1');

INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title)
VALUES( 'IVR Account Information', 'ivr_enable_account_information', '0', 'Enable the IVR which allow the users to retrieve different information about their account.', 1, 'yes,no', 'agi-conf1');

INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title)
VALUES( 'IVR Speed Dial', 'ivr_enable_ivr_speeddial', '0', 'Enable the IVR which allow the users add speed dial.', 1, 'yes,no', 'agi-conf1');


ALTER TABLE cc_templatemail CHANGE messagetext messagetext VARCHAR( 3000 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;
ALTER TABLE cc_templatemail CHANGE messagehtml messagehtml VARCHAR( 3000 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;

ALTER TABLE cc_card_group CHANGE description description VARCHAR( 400 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;

ALTER TABLE cc_config CHANGE config_description config_description VARCHAR( 500 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;


  
UPDATE cc_version SET version = '1.7.0';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title)
VALUES( 'Play rate lower one', 'play_rate_cents_if_lower_one', '0', 'Play the initial cost even if the cents are less than one. if cost is 0.075, we will play : 7 point 5 cents per minute. (values : yes - no)', 0, 'yes,no', 'agi-conf1');  


  
UPDATE cc_version SET version = '1.7.1';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/


ALTER TABLE cc_did_destination CHANGE destination destination VARCHAR( 100 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;

ALTER TABLE cc_sip_buddies ADD COLUMN useragent VARCHAR( 80 ) DEFAULT NULL;

ALTER TABLE cc_sip_buddies ALTER disallow set DEFAULT 'ALL';
ALTER TABLE cc_sip_buddies ALTER rtpkeepalive set DEFAULT 0;
ALTER TABLE cc_sip_buddies ALTER canreinvite set DEFAULT 'YES';


ALTER TABLE  cc_callback_spool CHANGE  variable  variable VARCHAR( 2000 ) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL;
  
UPDATE cc_version SET version = '1.7.2';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/

UPDATE cc_version SET version = '1.8.0';




/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * This file is part of A2Billing (http://www.a2billing.net/)
 *
 * A2Billing, Commercial Open Source Telecom Billing platform,   
 * powered by Star2billing S.L. <http://www.star2billing.com/>
 * 
 * @copyright   Copyright (C) 2004-2009 - Star2billing S.L. 
 * @author      Belaid Arezqui <areski@gmail.com>
 * @license     http://www.fsf.org/licensing/licenses/agpl-3.0.html
 * @package     A2Billing
 *
 * Software License Agreement (GNU Affero General Public License)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 
**/

INSERT INTO cc_config ( config_title, config_key, config_value, config_description, config_valuetype, config_listvalues, config_group_title)
VALUES( 'Callback Beep for Destination ', 'callback_beep_to_enter_destination', '0', 'Set to yes, this will disable the standard prompt to enter destination and play a beep instead', 1, 'yes,no', 'agi-conf1');

UPDATE cc_version SET version = '1.8.1';



