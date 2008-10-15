tinyMCE.importPluginLanguagePack('ts_advimage');
var TinyMCE_ThriveSmartAdvancedImagePlugin = {
 getInfo : function() {
 	return {
 		longname : 'ThriveSmart Advanced image',
 		author : 'ThriveSmart LLC',
 		authorurl : 'http://www.thrivesmart.com',
 		infourl : 'http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/advimage',
 		version : tinyMCE.majorVersion + "." + tinyMCE.minorVersion
 	};
 },
 getControlHTML : function(cn) {
 	switch (cn) {
 		case "ts_image":
 			return tinyMCE.getButtonHTML(cn, 'lang_image_desc', '{$themeurl}/images/image.gif', 'mceTSAdvImage');
 	}
 	return "";
 },
 execCommand : function(editor_id, element, command, user_interface, value) {
 	switch (command) {
 		case "mceTSAdvImage":
 			var template = new Array();
 			template['file']   = '../../plugins/ts_advimage/image.htm';
 			template['width']  = 480;
 			template['height'] = 480;
 			// Language specific width and height addons
 			template['width']  += tinyMCE.getLang('lang_advimage_delta_width', 0);
 			template['height'] += tinyMCE.getLang('lang_advimage_delta_height', 0);
 			var inst = tinyMCE.getInstanceById(editor_id);
 			var elm = inst.getFocusElement();
 			if (elm != null && tinyMCE.getAttrib(elm, 'class').indexOf('') != -1)
 				return true;
 			tinyMCE.openWindow(template, {editor_id : editor_id, inline : "yes"});
 			return true;
 	}
 	return false;
 },