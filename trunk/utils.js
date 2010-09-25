
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


/*

JS array references/tutorials:

http://www.hunlock.com/blogs/Mastering_Javascript_Arrays

http://code.google.com/p/jslibs/wiki/JavascriptTips

*/


//------------------------------------------------------------------------------


// utility for getElementById
function id(x)
{
	if (typeof x == "string")
	{
		try
		{
			return document.getElementById(x);
		}
		catch (e)
		{
			alert(e.name + ": " + e.message);

			return x;
		}
	}
	else
	{
		return x;
	}
}


//------------------------------------------------------------------------------


// utility for getElementsByName
function name(x)
{
	if (typeof x == "string")
	{
		try
		{
			return document.getElementsByName(x);
		}
		catch (e)
		{
			alert(e.name + ": " + e.message);

			return x;
		}
	}
	else
	{
		return x;
	}
}


//------------------------------------------------------------------------------


// get the current time
/*
The current time is represented as the number of milliseconds since
1970-01-01 00:00:00.000 (GMT)
*/
function get_current_time()
{
	return new Date().getTime();
}


//------------------------------------------------------------------------------


// repeat a string a number of times
function string_repeat(str, int_n)
{
	var result = "";

	for (var i = 0; i < int_n; ++i)
	{
		result += str;
	}

	return result;
}


//------------------------------------------------------------------------------


// get the sum of all the elements in an array
function array_sum(arr)
{
	// the Array.reduce method is only available in Firefox 3+

	var sum = 0;

	for (var i = 0; i < arr.length; ++i)
	{
		sum += arr[i];
	}

	return sum;
}


//------------------------------------------------------------------------------


// get the average of all the elements in an array
function array_average(arr)
{
	if (arr.length == 0)
	{
		return 0.0;
	}

	return array_sum(arr) / arr.length;
}


//------------------------------------------------------------------------------


// get the minimum element in an array
function array_min(arr)
{
	return Math.min.apply(null, arr);
}


//------------------------------------------------------------------------------


// get the minimum element in an array
function array_max(arr)
{
	return Math.max.apply(null, arr);
}


//------------------------------------------------------------------------------


/*
//##### maybe work on this later
function array_average(a)
{
	var r = {mean : 0, variance : 0, deviation : 0};

	var t = a.length;

	for (var m, s = 0, l = t; l--; s += a[l])
	{
	}

	for (var m = r.mean = s / t, l = t, s = 0; l--; s += Math.pow(a[l] - m, 2))
	{
	}

	return r.deviation = Math.sqrt(r.variance = s / t), r;
}

/*
# mean: arithmetic mean of the elements
# variance: variance
# deviation: standard deviation
*/


//------------------------------------------------------------------------------


//##### is this used?
// create an array of 'n' elements and initialize them to 'value'
function create_array(int_n, value)
{
	var result = new Array(int_n);

	for (var i = 0; i < int_n; ++i)
	{
		result[i] = value;
		//result.push(0);
	}

	return result;
}


//------------------------------------------------------------------------------


// get a random boolean
function get_random_boolean()
{
	return !Math.round(Math.random());
}


//------------------------------------------------------------------------------


/// get a random float in the interval [0, b)
function get_random_float_1(b)
{
	// [0, 1) * b => [0, b)
	return Math.random() * b;
}


//------------------------------------------------------------------------------


/// get a random int in the interval [0, b)
function get_random_int_1(b)
{
	return Math.floor(get_random_float_1(b));
}


//------------------------------------------------------------------------------


/// get a random float in the interval [a, b)
function get_random_float_2(a, b)
{
	// [0, 1) * (b - a) => [0, b - a)
	// [0, b - a) + a => [a, b)
	return Math.random() * (b - a) + a;
}


//------------------------------------------------------------------------------


/// get a random int in the interval [a, b)
function get_random_int_2(a, b)
{
	return Math.floor(get_random_float_2(a, b));
}


//------------------------------------------------------------------------------


// power law distribution
// Math.round(Math.exp(Math.random()*Math.log(maxmimum-minimum+1)))+minimum

/*
function Shuffle(arr)
{
    for (var i = arr.length - 1; i > 0; i--)
	{
        var j = get_random_int_1(i + 1);

    }

    return arr;
}
*/

/*
function TestShuf()
{
    with (document)
	{
        write("Iterated full shuffles of A..M :");

        var Q = "ABCDEFGHIKJKLM".split("");

        write("\n   Original    ", Q);

        for (var kk = 1; kk <= 9; kk++)
		{
            Shuffle(Q);
            write("\n   Shuffle ", kk, "   ", Q);
        }
    }
}
*/

/*
function shuffle(arr)
{
	for (var i = arr.length - 1; i > 0; i--)
	{
		var j = get_random_int_1(i + 1);

		array_swap_elements(i, j);
	}
}
*/


//------------------------------------------------------------------------------


// swap the i'th and j'th elements in array 'arr'
function array_swap_elements(arr, i, j)
{
	var tmp = arr[i];
	arr[i] = arr[j];
	arr[j] = tmp;
}


//------------------------------------------------------------------------------


// shuffle the elements in the array
/*
/sa http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
*/
function array_shuffle(arr)
{
	var n = arr.length;

	if (n == 0 || n == 1)
	{
		return;
	}

	// for every element
	for (var i = 0; i < n; ++i)
	{
		// the element to swap
		var j = get_random_int_1(n);

		if (i == j)
		{
			// no need to swap
			continue;
		}

		array_swap_elements(arr, i, j);
	}
}


//------------------------------------------------------------------------------


// set all the radio button checked properties to false
function reset_radio_button_checked_properties(radio_button_group_name)
{
	//##### hopefully the radio_button_group_name is unique
	var elements = name(radio_button_group_name);

	for (var i = 0; i < elements.length; ++i)
	{
		elements[i].checked = false;
	}
}


//------------------------------------------------------------------------------


// get the value of the first checked radio button
function get_radio_button_value(radio_button_group_name)
{
	var result = "";

	//##### hopefully the radio_button_group_name is unique
	var elements = name(radio_button_group_name);

	for (var i = 0; i < elements.length; ++i)
	{
		if (elements[i].checked)
		{
			result = elements[i].value;
			break;
		}
	}

	return result;
}


//------------------------------------------------------------------------------


function set_element_property(element, property, value)
{
	try
	{
		id(element)[property] = value;
	}
	catch (e)
	{
		alert(e.name + ": " + e.message);
	}
}


function reset_element_property(element, property)
{
	set_element_property(element, property, null);
}


//------------------------------------------------------------------------------


function set_element_disabled(element, value)
{
	set_element_property(element, "disabled", value);
}


function reset_element_disabled(element)
{
	reset_element_property(element, "disabled");
}


//------------------------------------------------------------------------------


function set_element_disabled_false(element)
{
	set_element_disabled(element, false);
}


function set_element_disabled_true(element)
{
	set_element_disabled(element, true);
}


//------------------------------------------------------------------------------


function set_element_style_property(element, property, value)
{
	try
	{
		id(element).style[property] = value;
	}
	catch (e)
	{
		alert(e.name + ": " + e.message);
	}
}


function reset_element_style_property(element, property)
{
	set_element_style_property(element, property, "");
}


//------------------------------------------------------------------------------


function set_element_style_display(element, value)
{
/*
http://www.w3.org/TR/CSS1/#display
'display'
Value: block | inline | list-item | none
Initial: block

http://www.w3.org/TR/CSS21/visuren.html#propdef-display
'display'
Value: inline | block | list-item | run-in | inline-block | table | inline-table | table-row-group | table-header-group | table-footer-group | table-row | table-column-group | table-column | table-cell | table-caption | none | inherit
Initial: inline
*/
	set_element_style_property(element, "display", value);
}


function reset_element_style_display(element)
{
	reset_element_style_property(element, "display");
}


function set_element_style_display_none(element)
{
	set_element_style_display(element, "none");
}



//################ add another function for each type of display property
//##### look in CSS1 maybe


//------------------------------------------------------------------------------


function set_element_style_visibility(element, value)
{
/*
http://www.w3.org/TR/CSS21/visufx.html#visibility
'visibility'
Value: visible | hidden | collapse | inherit
Initial: visible
*/
	set_element_style_property(element, "visibility", value);
}


function reset_element_style_visibility(element)
{
	reset_element_style_property(element, "visibility");
}


function set_element_style_visibility_hidden(element)
{
	set_element_style_visibility(element, "hidden");
}


//################ add another function for each type of visibility property
//##### look in CSS1 maybe


//------------------------------------------------------------------------------
