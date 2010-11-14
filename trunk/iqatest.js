
/*

Image Quality Assessment Test
Copyright (C) 2010  Steve Ward

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/


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


// generated by 'generate-image-paths.php' on 2010-08-17T02:08:51-0400
// phpversion(): 5.3.2-1ubuntu4.2
// phpversion('json'): 1.2.1

iqatest.image_set_path = 'images/sets/';

// the results to be submitted

iqatest.results = {};

iqatest.results.id         = "";
iqatest.results.ip_address = "";
iqatest.results.host_name  = "";
iqatest.results.user_agent = "";

iqatest.results.screen_properties = {};

iqatest.results.screen_properties.width      = screen.width     ;
iqatest.results.screen_properties.height     = screen.height    ;
iqatest.results.screen_properties.colorDepth = screen.colorDepth;

iqatest.results.participant_information = {};

iqatest.results.image_sets = ["albert_einstein","arnisee_region","bald_eagle","desiccated_sewage","red_apple","sonderho_windmill"];

iqatest.results.image_set_indexes = [0,1,2,3,4,5];

iqatest.results.images = [["reference.png","distorted_jpeg_12.jpg","distorted_jpeg_14.jpg","distorted_jpeg_17.jpg","distorted_jpeg_22.jpg","distorted_jpeg_28.jpg","distorted_jpeg_38.jpg","distorted_jpeg_57.jpg","distorted_jpeg_75.jpg","distorted_jpeg_89.jpg","distorted_jpeg_100.jpg"],["reference.png","distorted_jpeg_22.jpg","distorted_jpeg_27.jpg","distorted_jpeg_35.jpg","distorted_jpeg_45.jpg","distorted_jpeg_59.jpg","distorted_jpeg_71.jpg","distorted_jpeg_80.jpg","distorted_jpeg_87.jpg","distorted_jpeg_93.jpg","distorted_jpeg_100.jpg"],["reference.png","distorted_jpeg_8.jpg","distorted_jpeg_10.jpg","distorted_jpeg_12.jpg","distorted_jpeg_15.jpg","distorted_jpeg_20.jpg","distorted_jpeg_27.jpg","distorted_jpeg_41.jpg","distorted_jpeg_66.jpg","distorted_jpeg_87.jpg","distorted_jpeg_100.jpg"],["reference.png","distorted_jpeg_13.jpg","distorted_jpeg_16.jpg","distorted_jpeg_20.jpg","distorted_jpeg_26.jpg","distorted_jpeg_34.jpg","distorted_jpeg_45.jpg","distorted_jpeg_61.jpg","distorted_jpeg_73.jpg","distorted_jpeg_85.jpg","distorted_jpeg_100.jpg"],["reference.png","distorted_jpeg_10.jpg","distorted_jpeg_12.jpg","distorted_jpeg_14.jpg","distorted_jpeg_18.jpg","distorted_jpeg_24.jpg","distorted_jpeg_35.jpg","distorted_jpeg_54.jpg","distorted_jpeg_75.jpg","distorted_jpeg_89.jpg","distorted_jpeg_100.jpg"],["reference.png","distorted_jpeg_10.jpg","distorted_jpeg_12.jpg","distorted_jpeg_15.jpg","distorted_jpeg_20.jpg","distorted_jpeg_26.jpg","distorted_jpeg_37.jpg","distorted_jpeg_55.jpg","distorted_jpeg_73.jpg","distorted_jpeg_88.jpg","distorted_jpeg_100.jpg"]];

iqatest.results.image_indexes = [[1,2,3,4,5,6,7,8,9,10,0,0,0,0,0,0,0,0,0,0],[1,2,3,4,5,6,7,8,9,10,0,0,0,0,0,0,0,0,0,0],[1,2,3,4,5,6,7,8,9,10,0,0,0,0,0,0,0,0,0,0],[1,2,3,4,5,6,7,8,9,10,0,0,0,0,0,0,0,0,0,0],[1,2,3,4,5,6,7,8,9,10,0,0,0,0,0,0,0,0,0,0],[1,2,3,4,5,6,7,8,9,10,0,0,0,0,0,0,0,0,0,0]];

iqatest.results.image_comparisons = [[0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,0,0,0,0,0]];


//------------------------------------------------------------------------------


if (iqatest.results.image_sets.length != iqatest.results.image_set_indexes.length)
{
	throw new Error("iqatest.results.image_sets.length != iqatest.results.image_set_indexes.length");
}


if (iqatest.results.image_sets.length != iqatest.results.images.length)
{
	throw new Error("iqatest.results.image_sets.length != iqatest.results.images.length");
}


if (iqatest.results.image_sets.length != iqatest.results.image_indexes.length)
{
	throw new Error("iqatest.results.image_sets.length != iqatest.results.image_indexes.length");
}


if (iqatest.results.image_sets.length != iqatest.results.image_comparisons.length)
{
	throw new Error("iqatest.results.image_sets.length != iqatest.results.image_comparisons.length");
}


for (var i = 0; i < iqatest.results.images.length; ++i)
{
	// there are twice as many image_indexes as distorted images
	if ((iqatest.results.images[i].length - 1) * 2 != iqatest.results.image_indexes[i].length)
	{
		throw new Error("(iqatest.results.images[i].length - 1) * 2 != iqatest.results.image_indexes[i].length");
	}

	if (iqatest.results.images[i].length != iqatest.results.image_comparisons[i].length)
	{
		throw new Error("iqatest.results.images[i].length != iqatest.results.image_comparisons[i].length");
	}
}


//------------------------------------------------------------------------------


// shuffle the image set indexes
iqatest.results.image_set_indexes.shuffle = function()
{
	array_shuffle(iqatest.results.image_set_indexes);
};


// shuffle the image indexes
iqatest.results.image_indexes.shuffle = function()
{
	for (var i = 0; i < iqatest.results.image_indexes.length; ++i)
	{
		array_shuffle(iqatest.results.image_indexes[i]);
	}
};


//------------------------------------------------------------------------------


iqatest.interstimulus_interval = 500; // ms
iqatest.button_disable_period = 500; // ms


iqatest.current_image_set = 0;
iqatest.current_image = 0;


iqatest.total_image_comparisons = 0;
iqatest.current_image_comparison = 0;


for (var i = 0; i < iqatest.results.image_indexes.length; ++i)
{
	iqatest.total_image_comparisons += iqatest.results.image_indexes[i].length;
}


//------------------------------------------------------------------------------


// load the images
iqatest.load_images = function()
{
	var tmp = "";

	for (var i = 0; i < iqatest.results.image_sets.length; ++i)
	{
		var image_set = iqatest.results.image_sets[i];

		// the reference image is always at index 0
		var reference = iqatest.results.images[i][0];

		tmp += "<img alt=\"reference image\" src=\"" + iqatest.image_set_path + image_set + "/" + reference + "\" />\n";

		for (var j = 1; j < iqatest.results.images[i].length; ++j)
		{
			var distorted = iqatest.results.images[i][j];

			tmp += "<img alt=\"distorted image\" src=\"" + iqatest.image_set_path + image_set + "/" + distorted + "\" />\n";
		}
	}

	id("div_images").innerHTML = tmp;
};


//------------------------------------------------------------------------------


// get the current image set index
iqatest.get_current_image_set_index = function()
{
	var i = iqatest.current_image_set;

	return iqatest.results.image_set_indexes[i];
};


//------------------------------------------------------------------------------


// get the current array of image indexes
iqatest.get_current_image_indexes = function()
{
	var i = iqatest.get_current_image_set_index();

	return iqatest.results.image_indexes[i];
};


// get the current image index
iqatest.get_current_image_index = function()
{
	var i = iqatest.current_image;

	return iqatest.get_current_image_indexes()[i];
};


//------------------------------------------------------------------------------


// get the current image set
iqatest.get_current_image_set = function()
{
	var i = iqatest.get_current_image_set_index();

	return iqatest.results.image_sets[i];
};


//------------------------------------------------------------------------------


// get the current array of images
iqatest.get_current_images = function()
{
	var i = iqatest.get_current_image_set_index();

	return iqatest.results.images[i];
};


// get the current reference image
iqatest.get_current_reference_image = function()
{
	var i = 0;

	return iqatest.get_current_images()[i];
};


// get the current distorted image
iqatest.get_current_distorted_image = function()
{
	var i = iqatest.get_current_image_index();

	return iqatest.get_current_images()[i];
};


//------------------------------------------------------------------------------


// update the progress
iqatest.update_progress = function()
{
	// update the image progress
	id("image_progress").innerHTML = (iqatest.current_image + 1) + " of " + iqatest.get_current_image_indexes().length;

	// if the set changed
	if (iqatest.current_image === 0)
	{
		// update the image set progress
		id("image_set_progress").innerHTML = (iqatest.current_image_set + 1) + " of " + iqatest.results.image_set_indexes.length;
	}

	//--------------------------------------------------------------------------

	++iqatest.current_image_comparison;

	var percent_complete = Math.round(iqatest.current_image_comparison / iqatest.total_image_comparisons * 100.0) + "%";

	id("div_progress").innerHTML = percent_complete;

	set_element_style_property("div_progress", "width", percent_complete);
};


//------------------------------------------------------------------------------


// randomly set the sources of the images
iqatest.randomly_set_sources_of_images = function()
{
	var reference_image_src = iqatest.image_set_path + iqatest.get_current_image_set() + "/" + iqatest.get_current_reference_image();
	var distorted_image_src = iqatest.image_set_path + iqatest.get_current_image_set() + "/" + iqatest.get_current_distorted_image();

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
};


//------------------------------------------------------------------------------


iqatest.initialize = function()
{
	iqatest.load_images();

	iqatest.results.image_set_indexes.shuffle();

	iqatest.results.image_indexes.shuffle();

	iqatest.update_progress();

	iqatest.randomly_set_sources_of_images();
};


//------------------------------------------------------------------------------


// store participant information
// return true on success, false on error
iqatest.results.participant_information.store = function()
{
	// a shortcut to the form
	var form = document.forms.form_participant_information;

	// none of the fields are required
	// but some of them are validated if something was entered

	//--------------------------------------------------------------------------

	iqatest.results.participant_information.age = form.age.value;

	// if something was entered, validate it
	if (form.age.value != "")
	{
		var age = parseInt(form.age.value, 10);

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

	//iqatest.results.participant_information.english_language = form.english_language.value;
	iqatest.results.participant_information.english_language = get_radio_button_value("english_language");

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
};


//------------------------------------------------------------------------------


// make the two buttons disabled
iqatest.make_buttons_disabled = function()
{
	set_element_disabled_true("button_identical");
	set_element_disabled_true("button_different");
};


//------------------------------------------------------------------------------


// make the two buttons enabled
iqatest.make_buttons_enabled = function()
{
	set_element_disabled_false("button_identical");
	set_element_disabled_false("button_different");
};


//------------------------------------------------------------------------------


// make the two images hidden
iqatest.make_images_hidden = function()
{
	set_element_style_visibility_hidden("img_A");
	set_element_style_visibility_hidden("img_B");
};


//------------------------------------------------------------------------------


// make the two images visible
iqatest.make_images_visible = function()
{
	reset_element_style_visibility("img_A");
	reset_element_style_visibility("img_B");
};


//------------------------------------------------------------------------------


// advance the current image set
// return true on success, false on failure
iqatest.next_image_set = function()
{
	++iqatest.current_image_set;

	// if done with all sets
	if (iqatest.current_image_set >= iqatest.results.image_set_indexes.length)
	{
		iqatest.current_image_set = 0;

		return false;
	}
	else // not done with sets
	{
		return true;
	}
};


//------------------------------------------------------------------------------


// advance the current image
// return true on success, false on failure
iqatest.next_image = function()
{
	++iqatest.current_image;

	// if done with all images
	if (iqatest.current_image >= iqatest.get_current_image_indexes().length)
	{
		iqatest.current_image = 0;

		return iqatest.next_image_set();
	}
	else // not done with images
	{
		return true;
	}
};


//------------------------------------------------------------------------------


// encode the results object to JSON format
// used by the onsubmit handler in the results form
// this is used for debugging only
iqatest.encode_results = function()
{
	try
	{
		// a shortcut to the form
		var form = document.forms.form_results;

		form.results.value = JSON.stringify(iqatest.results);

		return true;
	}
	catch (e)
	{
		alert(e.name + ": " + e.message);

		return false;
	}
};


//------------------------------------------------------------------------------


// process the image comparison
iqatest.results.image_comparisons.process = function(bool_choice)
{
	if (typeof bool_choice != "boolean")
	{
		throw new Error("Function takes 1 paramenter of type boolean. The parameter type was " + (typeof bool_choice) + ".");
	}

	//--------------------------------------------------------------------------

	// record the result
	iqatest.results.image_comparisons[iqatest.get_current_image_set_index()][iqatest.get_current_image_index()] += Number(bool_choice);

	//--------------------------------------------------------------------------

	// make the two images hidden
	iqatest.make_images_hidden();

	// make the two buttons disabled
	iqatest.make_buttons_disabled();

	//--------------------------------------------------------------------------

	// make the two images visible
	var image_timeout_id = setTimeout("iqatest.make_images_visible();", iqatest.interstimulus_interval);

	// make the two buttons visible
	var button_timeout_id = setTimeout("iqatest.make_buttons_enabled();", iqatest.interstimulus_interval + iqatest.button_disable_period);

	//--------------------------------------------------------------------------

	if (iqatest.next_image())
	{
		iqatest.update_progress();

		iqatest.randomly_set_sources_of_images();
	}
	else
	{
		clearTimeout(image_timeout_id);

		clearTimeout(button_timeout_id);

		try
		{
			// a shortcut to the form
			var form = document.forms.form_results;

			form.results.value = JSON.stringify(iqatest.results);

			form.submit();
		}
		catch (e)
		{
			alert(e.name + ": " + e.message);
		}
	}
};


//------------------------------------------------------------------------------


// fill the image comparison results with zeros
// this is used for debugging only
iqatest.results.image_comparisons.fill_zero = function()
{
	for (var i = 0; i < iqatest.results.image_comparisons.length; ++i)
	{
		for (var j = 0; j < iqatest.results.image_comparisons[i].length; ++j)
		{
			// record the result
			iqatest.results.image_comparisons[i][j] = 0;
		}
	}
};


//------------------------------------------------------------------------------


// fill the image comparison results with ones
// this is used for debugging only
iqatest.results.image_comparisons.fill_one = function()
{
	// initialize
	iqatest.results.image_comparisons.fill_zero();

	for (var i = 0; i < iqatest.results.image_indexes.length; ++i)
	{
		for (var j = 0; j < iqatest.results.image_indexes[i].length; ++j)
		{
			var k = iqatest.results.image_indexes[i][j];

			// record the result
			iqatest.results.image_comparisons[i][k] += 1;
		}
	}
};


//------------------------------------------------------------------------------


// fill the image comparison results with random numbers
// this is used for debugging only
iqatest.results.image_comparisons.fill_random = function()
{
	// initialize
	iqatest.results.image_comparisons.fill_zero();

	for (var i = 0; i < iqatest.results.image_indexes.length; ++i)
	{
		for (var j = 0; j < iqatest.results.image_indexes[i].length; ++j)
		{
			var k = iqatest.results.image_indexes[i][j];

			// record the result
			iqatest.results.image_comparisons[i][k] += Number(get_random_boolean());
		}
	}
};


//------------------------------------------------------------------------------

// 1177 1298 1089 1102 750 741 763 792
