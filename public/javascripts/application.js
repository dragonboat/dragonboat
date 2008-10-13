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
