// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

    function checkAll(form,name_ptr) {
       var fm = form;
       if (!fm) return;
       var len = fm.elements.length;
       for (var i=0; i<len; i++) {
        if (fm.elements[i].getAttribute("type").toLowerCase()=="checkbox" && !fm.elements[i].disabled && (fm.elements[i].name.indexOf(name_ptr)!=-1)) {
          fm.elements[i].checked = fm.allbox.checked;
	}
      } }
  
     function print_page() {
        window.print();  
      }  
      
     function check_tents_number(form,name_ptr) {
       var 
       fm = form;
     
       if (!fm) return;
       var len = fm.elements.length;
       var total = 0;
       for (var i=0; i<len; i++) {
        if (fm.elements[i].getAttribute("type").toLowerCase()=="checkbox" && fm.elements[i].checked && !fm.elements[i].disabled && (fm.elements[i].name.indexOf(name_ptr)!=-1)) {
         total+=1
	}
      } 
    return total;  
  }  
  
  function check_submit()
  {
      
    var el = document.getElementById("submit_info");
    var res = el.disabled; 
    el.disabled=true; 
    
    if (!res) { 
        document.getElementById("order_form").submit();
        el.disabled=true; 
        return true
    }
    else
    {
      return false;  
    }
   }                       


    
var gAutoPrint = true; // Tells whether to automatically call the print function

function printSpecial()
{
if (document.getElementById != null)
{
var html = '<HTML>\n<HEAD>\n';

if (document.getElementsByTagName != null)
{
var headTags = document.getElementsByTagName("head");
if (headTags.length > 0)
html += headTags[0].innerHTML;
}

html += '\n</HE>\n<BODY>\n';

var printReadyElem = document.getElementById("printReady");

if (printReadyElem != null)
{
html += printReadyElem.innerHTML;
}
else
{
alert("Could not find the printReady function");
return;
}

html += '\n</BO>\n</HT>';

var printWin = window.open("","printSpecial");
printWin.document.open();
printWin.document.write(html);
printWin.document.close();
if (gAutoPrint)
printWin.print();
}
else
{
alert("The print ready feature is only available if you are using an browser. Please update your browswer.");
}
}
