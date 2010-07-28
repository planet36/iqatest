
// Copyright (C) 2010 Steve Ward


//------------------------------------------------------------------------------


// declare global symbol before testing for its presence
var iqatest;

if (!iqatest)
{
	iqatest = {};
}
else if (typeof iqatest != "object")
{
	throw new Error("iqatest already exists and is not an object");
}


//------------------------------------------------------------------------------


// phpversion(): 5.2.10-2ubuntu6.4
// phpversion('json'): 1.2.1

iqatest.image_sets = ([{"reference_image":"images\/sets\/albert_einstein\/reference.png","distorted":["images\/sets\/albert_einstein\/distorted_jpeg_12.jpg","images\/sets\/albert_einstein\/distorted_jpeg_14.jpg","images\/sets\/albert_einstein\/distorted_jpeg_17.jpg","images\/sets\/albert_einstein\/distorted_jpeg_22.jpg","images\/sets\/albert_einstein\/distorted_jpeg_28.jpg","images\/sets\/albert_einstein\/distorted_jpeg_38.jpg","images\/sets\/albert_einstein\/distorted_jpeg_57.jpg","images\/sets\/albert_einstein\/distorted_jpeg_75.jpg","images\/sets\/albert_einstein\/distorted_jpeg_89.jpg","images\/sets\/albert_einstein\/distorted_jpeg_100.jpg"]},{"reference_image":"images\/sets\/arnisee_region\/reference.png","distorted":["images\/sets\/arnisee_region\/distorted_jpeg_22.jpg","images\/sets\/arnisee_region\/distorted_jpeg_27.jpg","images\/sets\/arnisee_region\/distorted_jpeg_35.jpg","images\/sets\/arnisee_region\/distorted_jpeg_45.jpg","images\/sets\/arnisee_region\/distorted_jpeg_59.jpg","images\/sets\/arnisee_region\/distorted_jpeg_71.jpg","images\/sets\/arnisee_region\/distorted_jpeg_80.jpg","images\/sets\/arnisee_region\/distorted_jpeg_87.jpg","images\/sets\/arnisee_region\/distorted_jpeg_93.jpg","images\/sets\/arnisee_region\/distorted_jpeg_100.jpg"]},{"reference_image":"images\/sets\/bald_eagle\/reference.png","distorted":["images\/sets\/bald_eagle\/distorted_jpeg_8.jpg","images\/sets\/bald_eagle\/distorted_jpeg_10.jpg","images\/sets\/bald_eagle\/distorted_jpeg_12.jpg","images\/sets\/bald_eagle\/distorted_jpeg_15.jpg","images\/sets\/bald_eagle\/distorted_jpeg_20.jpg","images\/sets\/bald_eagle\/distorted_jpeg_27.jpg","images\/sets\/bald_eagle\/distorted_jpeg_41.jpg","images\/sets\/bald_eagle\/distorted_jpeg_66.jpg","images\/sets\/bald_eagle\/distorted_jpeg_87.jpg","images\/sets\/bald_eagle\/distorted_jpeg_100.jpg"]},{"reference_image":"images\/sets\/desiccated_sewage\/reference.png","distorted":["images\/sets\/desiccated_sewage\/distorted_jpeg_13.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_16.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_20.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_26.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_34.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_45.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_61.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_73.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_85.jpg","images\/sets\/desiccated_sewage\/distorted_jpeg_100.jpg"]},{"reference_image":"images\/sets\/red_apple\/reference.png","distorted":["images\/sets\/red_apple\/distorted_jpeg_10.jpg","images\/sets\/red_apple\/distorted_jpeg_12.jpg","images\/sets\/red_apple\/distorted_jpeg_14.jpg","images\/sets\/red_apple\/distorted_jpeg_18.jpg","images\/sets\/red_apple\/distorted_jpeg_24.jpg","images\/sets\/red_apple\/distorted_jpeg_35.jpg","images\/sets\/red_apple\/distorted_jpeg_54.jpg","images\/sets\/red_apple\/distorted_jpeg_75.jpg","images\/sets\/red_apple\/distorted_jpeg_89.jpg","images\/sets\/red_apple\/distorted_jpeg_100.jpg"]},{"reference_image":"images\/sets\/sonderho_windmill\/reference.png","distorted":["images\/sets\/sonderho_windmill\/distorted_jpeg_10.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_12.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_15.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_20.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_26.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_37.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_55.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_73.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_88.jpg","images\/sets\/sonderho_windmill\/distorted_jpeg_100.jpg"]}]);


//------------------------------------------------------------------------------


iqatest.current_image_set = 0;
iqatest.current_image = 0;

iqatest.interstimulus_interval = 500; // ms
iqatest.button_disable_period = 500; // ms

/*
iqatest.image_interval_id = -1;
iqatest.button_timeout_id = -1;
*/

/*
iqatest.img_A_loaded = false;
iqatest.img_B_loaded = false;
*/

//#####
//iqatest.image_time_start = 0;
//iqatest.image_time_finish = 0;


// the results to be submitted

iqatest.results = {};

iqatest.results.screen_properties = {};

iqatest.results.screen_properties.height     = screen.height    ;
iqatest.results.screen_properties.width      = screen.width     ;
iqatest.results.screen_properties.colorDepth = screen.colorDepth;

iqatest.results.navigator_properties = {};

iqatest.results.navigator_properties.appCodeName = navigator.appCodeName;
iqatest.results.navigator_properties.appName     = navigator.appName    ;
iqatest.results.navigator_properties.appVersion  = navigator.appVersion ;
iqatest.results.navigator_properties.platform    = navigator.platform   ;
iqatest.results.navigator_properties.userAgent   = navigator.userAgent  ;


iqatest.results.participant_information = {};


iqatest.results.image_comparison = [];


//------------------------------------------------------------------------------


// load the images
/*
iqatest.load_images = function()
{
	var tmp = new Image();

	for (var i = 0; i < iqatest.image_sets.length; ++i)
	{
		tmp.src = iqatest.image_sets[i]["reference_image"];

		for (var j = 0; j < iqatest.image_sets[i]["distorted"].length; ++j)
		{
			tmp.src = iqatest.image_sets[i]["distorted"][j];
		}
	}
}
*/


//------------------------------------------------------------------------------


// add a number of copies of the reference image to the distorted image set
// the purpose of this is so the user will have to sometimes compare a reference image to itself
iqatest.add_reference_image_to_distorted_image_set = function(int_image_set, int_number_to_add)
{
	for (var i = 0; i < int_number_to_add; ++i)
	{
		iqatest.image_sets[int_image_set]["distorted"].push(iqatest.image_sets[int_image_set]["reference_image"]);
	}
}


//------------------------------------------------------------------------------


// shuffle the images
iqatest.shuffle_images = function()
{
	array_shuffle(iqatest.image_sets);

	for (var i = 0; i < iqatest.image_sets.length; ++i)
	{
		array_shuffle(iqatest.image_sets[i]["distorted"]);
	}
}


//------------------------------------------------------------------------------


//#####
iqatest.randomly_set_sources_of_images = function()
{
	var reference_image_src = iqatest.image_sets[iqatest.current_image_set]["reference_image"];
	var distorted_image_src = iqatest.image_sets[iqatest.current_image_set]["distorted"][iqatest.current_image];

	if (get_random_boolean())
	{
		id("img_A").src = reference_image_src;
		id("img_B").src = distorted_image_src;
	}
	else
	{
		id("img_A").src = distorted_image_src;
		id("img_B").src = reference_image_src;
	}

	// update the image progress
	id("image_progress").innerHTML = (iqatest.current_image + 1) + " of " + iqatest.image_sets[iqatest.current_image_set]["distorted"].length;

	// this is inefficient because the image set progress is updated every time
	// even when only the image progress needs to be updated

	// update the image set progress
	id("image_set_progress").innerHTML = (iqatest.current_image_set + 1) + " of " + iqatest.image_sets.length;
}


//------------------------------------------------------------------------------


//#####
iqatest.initialize = function()
{
	//--------------------------------------------------------------------------

	/*
	id("img_A").onload = function(){iqatest.img_A_loaded = true;};
	id("img_B").onload = function(){iqatest.img_B_loaded = true;};
	*/

	//--------------------------------------------------------------------------

	// initialize the results.image_comparison array
	for (var i = 0; i < iqatest.image_sets.length; ++i)
	{
		iqatest.results.image_comparison[i] = {};
	}

	//--------------------------------------------------------------------------

	//iqatest.load_images();

	//--------------------------------------------------------------------------

	for (var i = 0; i < iqatest.image_sets.length; ++i)
	{
		iqatest.add_reference_image_to_distorted_image_set(i, iqatest.image_sets[i]["distorted"].length);
	}

	//--------------------------------------------------------------------------

	iqatest.shuffle_images();

	//--------------------------------------------------------------------------

	iqatest.randomly_set_sources_of_images();
}


//------------------------------------------------------------------------------


//#####
//##### returns true on success, false on error
iqatest.store_participant_information = function()
{
	// a shortcut to the form
	var form = document.forms["form_participant_information"];

	// none of the fields are required
	// but some of them are validated if something was entered

	//--------------------------------------------------------------------------

	iqatest.results.participant_information.age = form.age.value;

	// if something was entered, validate it
	if (form.age.value != "")
	{
		var age = parseInt(form.age.value);

		if (isNaN(age))
		{
			alert("'Age' must be an integer.");

			form.age.focus();

			return false;
		}

		// the minimum
		if (age < 18)
		{
			alert("'Age' must be at least 18 years.");

			form.age.focus();

			return false;
		}

		// the maximum
		if (age > 120)
		{
			alert("'Age' must be at most 120 years.");

			form.age.focus();

			return false;
		}

		iqatest.results.participant_information.age = age;
	}

	//--------------------------------------------------------------------------

	//iqatest.results.participant_information.sex = form.sex.value;
	iqatest.results.participant_information.sex = get_radio_button_value("sex");

	//iqatest.results.participant_information.language = form.language.value;
	iqatest.results.participant_information.language = get_radio_button_value("language");

	//iqatest.results.participant_information.vision_normal = form.vision_normal.value;
	iqatest.results.participant_information.vision_normal = get_radio_button_value("vision_normal");

	//iqatest.results.participant_information.vision_correction_necessary = form.vision_correction_necessary.value;
	iqatest.results.participant_information.vision_correction_necessary = get_radio_button_value("vision_correction_necessary");

	//iqatest.results.participant_information.vision_correction_used = form.vision_correction_used.value;
	iqatest.results.participant_information.vision_correction_used = get_radio_button_value("vision_correction_used");

	iqatest.results.participant_information.image_experience = get_radio_button_value("image_experience");

	//--------------------------------------------------------------------------

	iqatest.results.participant_information.sleep_time = form.sleep_time.value;

	// if something was entered, validate it
	if (form.sleep_time.value != "")
	{
		var sleep_time = parseFloat(form.sleep_time.value);

		if (isNaN(sleep_time))
		{
			alert("'Sleep time' must be an number.");

			form.sleep_time.focus();

			return false;
		}

		// the minimum
		if (sleep_time < 0)
		{
			alert("'Sleep time' must be at least 0 hours.");

			form.sleep_time.focus();

			return false;
		}

		// the maximum
		if (sleep_time > 24)
		{
			alert("'Sleep time' must be at most 24 hours.");

			form.sleep_time.focus();

			return false;
		}

		iqatest.results.participant_information.sleep_time = sleep_time;
	}

	//--------------------------------------------------------------------------

	iqatest.results.participant_information.computer_time = form.computer_time.value;

	// if something was entered, validate it
	if (form.computer_time.value != "")
	{
		var computer_time = parseFloat(form.computer_time.value);

		if (isNaN(computer_time))
		{
			alert("'Computer time' must be an number.");

			form.computer_time.focus();

			return false;
		}

		// the minimum
		if (computer_time < 0)
		{
			alert("'Computer time' must be at least 0 hours.");

			form.computer_time.focus();

			return false;
		}

		// the maximum
		if (computer_time > 168)
		{
			alert("'Computer time' must be at most 168 hours.");

			form.computer_time.focus();

			return false;
		}

		iqatest.results.participant_information.computer_time = computer_time;
	}

	//--------------------------------------------------------------------------

	//iqatest.results.participant_information.computer_proficiency = form.computer_proficiency.value;
	iqatest.results.participant_information.computer_proficiency = get_radio_button_value("computer_proficiency");

	//--------------------------------------------------------------------------

	iqatest.results.participant_information.videogame_time = form.videogame_time.value;

	// if something was entered, validate it
	if (form.videogame_time.value != "")
	{
		var videogame_time = parseFloat(form.videogame_time.value);

		if (isNaN(videogame_time))
		{
			alert("'Videogame time' must be an number.");

			form.videogame_time.focus();

			return false;
		}

		// the minimum
		if (videogame_time < 0)
		{
			alert("'Videogame time' must be at least 0 hours.");

			form.videogame_time.focus();

			return false;
		}

		// the maximum
		if (videogame_time > 168)
		{
			alert("'Videogame time' must be at most 168 hours.");

			form.videogame_time.focus();

			return false;
		}

		iqatest.results.participant_information.videogame_time = videogame_time;
	}

	//--------------------------------------------------------------------------

	//iqatest.results.participant_information.videogame_proficiency = form.videogame_proficiency.value;
	iqatest.results.participant_information.videogame_proficiency = get_radio_button_value("videogame_proficiency");

	//iqatest.results.participant_information.substance_influence = form.substance_influence.value;
	iqatest.results.participant_information.substance_influence = get_radio_button_value("substance_influence");

	iqatest.results.participant_information.substances = form.substances.value;

	//--------------------------------------------------------------------------

	return true;
}


//------------------------------------------------------------------------------


// make the two buttons disabled
iqatest.make_buttons_disabled = function()
{
	set_element_disabled_true("button_identical");
	set_element_disabled_true("button_different");
}


//------------------------------------------------------------------------------


// make the two buttons enabled
iqatest.make_buttons_enabled = function()
{
	set_element_disabled_false("button_identical");
	set_element_disabled_false("button_different");
}


//------------------------------------------------------------------------------


// make the two images hidden
iqatest.make_images_hidden = function()
{
	set_element_style_visibility_hidden("img_A");
	set_element_style_visibility_hidden("img_B");
}


//------------------------------------------------------------------------------


// make the two images visible
iqatest.make_images_visible = function()
{
	reset_element_style_visibility("img_A");
	reset_element_style_visibility("img_B");
}


//------------------------------------------------------------------------------


/*
// determine if the two images are loaded
iqatest.images_are_loaded = function()
{
	return iqatest.img_A_loaded && iqatest.img_B_loaded;
}
*/


//------------------------------------------------------------------------------


/*
// possibly make the two images visible
iqatest.possibly_make_images_visible = function()
{
	// if the images are not loaded, do nothing
	if (!iqatest.images_are_loaded())
	{
		return;
	}

	// turn off the interval
	clearInterval(iqatest.image_interval_id);

	// make the two images visible
	iqatest.make_images_visible();

	// turn on timer to make the buttons enabled
	iqatest.button_timeout_id = setTimeout("iqatest.make_buttons_enabled();", iqatest.button_disable_period);
}
*/


//------------------------------------------------------------------------------


// advance the current image set
// return true on success, false on failure
iqatest.next_image_set = function()
{
	++iqatest.current_image_set;

	// if done with all image sets
	if (iqatest.current_image_set >= iqatest.image_sets.length)
	{
		iqatest.current_image_set = 0;

		return false;
	}
	else // not done with image sets
	{
		return true;
	}
}


//------------------------------------------------------------------------------


// advance the current image
// return true on success, false on failure
iqatest.next_image = function()
{
	++iqatest.current_image;

	// if done with all images
	if (iqatest.current_image >= iqatest.image_sets[iqatest.current_image_set]["distorted"].length)
	{
		iqatest.current_image = 0;

		return iqatest.next_image_set();
	}
	else // not done with images
	{
		return true;
	}
}


//------------------------------------------------------------------------------


//#####
//##### this is only used by the submit button on the results form
iqatest.encode_results = function()
{
	try
	{
		// a shortcut to the form
		var form = document.forms["form_results"];

		form.results.value = JSON.stringify(iqatest.results);

		return true;
	}
	catch (e)
	{
		alert(e.name + ": " + e.message);

		return false;
	}
}


//------------------------------------------------------------------------------


//#####
iqatest.process_image_comparison = function(bool_choice)
{
	if (typeof bool_choice != "boolean")
	{
		throw Error("Function takes 1 paramenter of type boolean. The parameter type was " + (typeof bool_choice) + ".");
	}

	//--------------------------------------------------------------------------

	/*
	if (!iqatest.results.image_comparison[iqatest.current_image_set])
	{
		iqatest.results.image_comparison[iqatest.current_image_set] = {};
	}
	*/

	//##### the result is an array of arrays

	// if the result is not initialized
	if (!iqatest.results.image_comparison[iqatest.current_image_set][iqatest.image_sets[iqatest.current_image_set]["distorted"][iqatest.current_image]])
	{
		iqatest.results.image_comparison[iqatest.current_image_set][iqatest.image_sets[iqatest.current_image_set]["distorted"][iqatest.current_image]] = 0;
	}

	// record the result
	iqatest.results.image_comparison[iqatest.current_image_set][iqatest.image_sets[iqatest.current_image_set]["distorted"][iqatest.current_image]] += Number(bool_choice);

	//--------------------------------------------------------------------------

	// make the two images hidden
	iqatest.make_images_hidden();

	// make the two buttons disabled
	iqatest.make_buttons_disabled();

	//--------------------------------------------------------------------------

	/*
	// make the images unloaded
	iqatest.img_A_loaded = false;
	iqatest.img_B_loaded = false;
	*/

	//--------------------------------------------------------------------------

	/*
	// turn on interval to possibly make the images visible
	iqatest.image_interval_id = setInterval("iqatest.possibly_make_images_visible();", iqatest.interstimulus_interval);
	*/

	// make the two images visible
	var image_timeout_id = setTimeout("iqatest.make_images_visible();", iqatest.interstimulus_interval);

	// make the two buttons visible
	var button_timeout_id = setTimeout("iqatest.make_buttons_enabled();", iqatest.interstimulus_interval + iqatest.button_disable_period);

	//--------------------------------------------------------------------------

	if (iqatest.next_image())
	{
		iqatest.randomly_set_sources_of_images();
	}
	else
	{
		clearTimeout(image_timeout_id);

		clearTimeout(button_timeout_id);
		/*
		clearInterval(iqatest.image_interval_id);

		clearTimeout(iqatest.button_timeout_id);
		*/

		try
		{
			// a shortcut to the form
			var form = document.forms["form_results"];

			form.results.value = JSON.stringify(iqatest.results);

			form.submit();
		}
		catch (e)
		{
			alert(e.name + ": " + e.message);
		}
	}
}


//------------------------------------------------------------------------------


//##### this is used for debugging
iqatest.results.image_comparison.fill = function()
{
	for (var i = 0; i < iqatest.image_sets.length; ++i)
	{
		for (var j = 0; j < iqatest.image_sets[i]["distorted"].length; ++j)
		{
			// if the result is not initialized
			if (!iqatest.results.image_comparison[i][iqatest.image_sets[i]["distorted"][j]])
			{
				iqatest.results.image_comparison[i][iqatest.image_sets[i]["distorted"][j]] = 0;
			}

			// record the result
			iqatest.results.image_comparison[i][iqatest.image_sets[i]["distorted"][j]] += Number(get_random_boolean());
		}
	}
}
