$(function(){
	$('.movieModalRevealer').click(function(){
		console.log($(this).data("movie-id"));
		var movieId= $(this).data("movie-id");
		$.ajax({
			url:'/movies/'+movieId,
		});
	});

	//for infinite scolling
	var movieOffset = 0;
	var moviesTotal = parseInt($('#moviesPanel').data('movies-total'));
  $(window).scroll(function(){
    if ($(window).scrollTop() >= $(document).height() - $(window).height() - 10) {
      movieOffset += 20;
      if (movieOffset < moviesTotal){
	      $('#movieLoading').html('<p style="background-color:#EEEEEE; text-align:center;"><img src="assets/loading.gif"></p>');
	      $.ajax({
	      	url: '/movies/get-more',
	      	data: { skip:movieOffset },
	      });
	      $('#movieLoading').empty();
	     }
   		}
   });
   
   //the movie rating spinner from jquery-ui
   $("#movieRatingSpinner").spinner({min: 0 , max: 10});
 
   $("#new_movie_add_new_plot_keyword_btn").click(function(){
   	$("#new_movie_plot_keywords_input_fields").append('<input type="text" name="movie[plot_keywords][]">');
   	return false;
   });
     
   $("#new_movie_add_new_filming_location_btn").click(function(){
   	$("#new_movie_filming_locations_input_fields").append('<input type="text" name="movie[filming_locations][]">');
   	return false;
   });
   
   $("#new_movie_add_new_trivia_btn").click(function(){
   	$("#new_movie_trivias_input_fields").append('<input type="text" name="movie[trivias][]">');
   	return false;
   });
   
   $("#new_movie_add_new_box_office_btn").click(function(){
		$("#new_movie_box_offices_input_fields").append('<div class="row"><div class="small-3 columns"><span class="right inline">Date</span></div>'+
			'<div class="small-9 columns"><input type="text" name="movie[box_office][][time]" class="datepicker_show_week"></div></div>'+
			'<div class="row"><div class="small-3 columns"><span class="right inline">Revenue</span></div>'+
			'<div class="small-9 columns"><input type="text" name="movie[box_office][][revenue]"></div></div>'+
			'<div class="row"><div class="small-3 columns"><span class="right inline">Rank</span></div>'+
			'<div class="small-9 columns"><input type="text" name="movie[box_office][][rank]"></div></div><hr>');
		$(".datepicker_show_week").datepicker({showWeek: true,firstDay: 1,dateFormat: "yy-mm-dd"});
   	return false;
   });
   
   //date picker for entering date
   $(".datepicker").datepicker({dateFormat: "yy-mm-dd"});
   $(".datepicker_show_week").datepicker({showWeek: true,firstDay: 1,dateFormat: "yy-mm-dd"});

	//upload to s3
	$("#posterS3Uploader").S3Uploader();	

	$('#posterS3Uploader').bind('s3_upload_complete',function(e,content){
		$("#new_movie_form").append('<input type="hidden" name="movie[poster]" value="'+content.url+'"/>');
		//$("#new_movie_form").append('<input type="hidden" name="movie[remote_photo_url]" value="'+content.url+'"/>');
		$("#new_movie_form").append('<input type="hidden" name="movie[return_url]" value="'+content.url+'"/>'); //give a shot 
		$("#new_movie_uploaded_images").append(content.filename+' is uploaded as poster.<br /> ');
	});
	
	$("#imageS3Uploader").S3Uploader();
		
	var uploaded_image_index = 0;
	
	$('#imageS3Uploader').bind('s3_upload_complete',function(e,content){
		$("#new_movie_form").append('<input type="hidden" multiple="multiple" name="movie[images_attributes]['+uploaded_image_index+'][url]" value="'+content.url+'"/>');
		$("#new_movie_form").append('<input type="hidden" multiple="multiple" name="movie[images_attributes]['+uploaded_image_index+'][size]" value="'+content.filesize+'"/>');
		//$("#new_movie_form").append('<input type="hidden" multiple="multiple" name="movie[images_attributes]['+uploaded_image_index+'][remote_photo_url]" value="'+content.url+'"/>');
		$("#new_movie_form").append('<input type="hidden" multiple="multiple" name="movie[images_attributes]['+uploaded_image_index+'][return_url]" value="'+content.url+'"/>'); //give a shot
		$("#new_movie_uploaded_images").append(content.filename+' is uploaded.<br /> ');
		$("#new_movie_uploaded_images").append('<input type="text" multiple="multiple" name="movie[images_attributes]['+uploaded_image_index+'][description]" placeholder="Enter description" />');
		uploaded_image_index ++;
	});
	
	$('#imageS3Uploader').bind('s3_uploads_start',function(e){
		//alert('start uploading');
	});	

});