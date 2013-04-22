$(function(){
	$("#new_person_add_new_trivia_btn").click(function(){
   	$("#new_person_trivias_input_fields").append('<input type="text" name="person[trivias][]">');
   	return false;
  });
  
  $("#new_person_add_new_public_listing_btn").click(function(){
		$("#new_person_public_listings_input_fields").append('<div class="row"><div class="small-3 columns"><span class="right inline">When</span></div>'+
			'<div class="small-9 columns"><input type="text" name="person[public_listings][][when]" class="datepicker_show_week"></div></div>'+
			'<div class="row"><div class="small-3 columns"><span class="right inline">Where/span></div>'+
			'<div class="small-9 columns"><input type="text" name="person[public_listings][][where]"></div></div>'+
			'<div class="row"><div class="small-3 columns"><span class="right inline">What</span></div>'+
			'<div class="small-9 columns"><input type="text" name="person[public_listings][][what]"></div></div><hr>');
		$(".datepicker_show_week").datepicker({showWeek: true,firstDay: 1,dateFormat: "yy-mm-dd"});
   	return false;
   });
   
});