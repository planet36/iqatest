
/*

SPDX-FileCopyrightText: Steven Ward
SPDX-License-Identifier: OSL-3.0

*/

// Get the datum by its id.  This is a utility for "getElementById".
function id(x)
{
	if (typeof x == "string")
	{
		try
		{
			return document.getElementById(x)
		}
		catch (e)
		{
			alert(e.name + ": " + e.message)

			return x
		}
	}
	else
	{
		return x
	}
}

// Get the daturm by its name.  This is a utility for "getElementsByName".
function name(x)
{
	if (typeof x == "string")
	{
		try
		{
			return document.getElementsByName(x)
		}
		catch (e)
		{
			alert(e.name + ": " + e.message)

			return x
		}
	}
	else
	{
		return x
	}
}

function set_element_property(element, property, value)
{
	try
	{
		id(element)[property] = value
	}
	catch (e)
	{
		alert(e.name + ": " + e.message)
	}
}

function reset_element_property(element, property)
{
	set_element_property(element, property, null)
}

function set_element_disabled(element, value)
{
	set_element_property(element, "disabled", value)
}

function reset_element_disabled(element)
{
	reset_element_property(element, "disabled")
}

function set_element_disabled_false(element)
{
	set_element_disabled(element, false)
}

function set_element_disabled_true(element)
{
	set_element_disabled(element, true)
}

function set_element_style_property(element, property, value)
{
	try
	{
		id(element).style[property] = value
	}
	catch (e)
	{
		alert(e.name + ": " + e.message)
	}
}

function reset_element_style_property(element, property)
{
	set_element_style_property(element, property, "")
}

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
	set_element_style_property(element, "display", value)
}

function reset_element_style_display(element)
{
	reset_element_style_property(element, "display")
}

function set_element_style_display_block(element)
{
	set_element_style_display(element, "block")
}

function set_element_style_display_inline(element)
{
	set_element_style_display(element, "inline")
}

function set_element_style_display_list_item(element)
{
	set_element_style_display(element, "list-item")
}

function set_element_style_display_none(element)
{
	set_element_style_display(element, "none")
}

function set_element_style_visibility(element, value)
{
/*
http://www.w3.org/TR/CSS21/visufx.html#visibility
'visibility'
Value: visible | hidden | collapse | inherit
Initial: visible
*/
	set_element_style_property(element, "visibility", value)
}

function reset_element_style_visibility(element)
{
	reset_element_style_property(element, "visibility")
}

function set_element_style_visibility_visible(element)
{
	set_element_style_visibility(element, "visible")
}

function set_element_style_visibility_hidden(element)
{
	set_element_style_visibility(element, "hidden")
}

function set_element_style_visibility_collapse(element)
{
	set_element_style_visibility(element, "collapse")
}

function set_element_style_visibility_inherit(element)
{
	set_element_style_visibility(element, "inherit")
}

// Transition display from one element to another element.
function transition_from_to(from_element, to_element)
{
	// Make the first element not displayed.
	set_element_style_display_none(from_element)

	// Scroll to the top of the page.
	scrollTo(0, 0)

	// Make the second element displayed.
	reset_element_style_display(to_element)
}

// Transition display from one element to another element.
function transition_from_to_timeout(from_element, to_element, delay)
{
	// Make the first element not displayed.
	set_element_style_display_none(from_element)

	// Scroll to the top of the page.
	scrollTo(0, 0)

	// Make the second element displayed after the delay.
	setTimeout(reset_element_style_display, delay, to_element)
}

// Get the current time.
/*
The current time is represented as the number of milliseconds since
1970-01-01 00:00:00.000 (GMT)
*/
function get_current_time()
{
	return new Date().getTime()
}

// Repeat a string a number of times.
function string_repeat(string, num)
{
	// TODO: in the future, use String.prototype.repeat
	// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/repeat

	return Array(num + 1).join(string)
	/*
	var result = ""

	for (var i = 0; i < num; ++i)
	{
		result += string
	}

	return result
	*/
}

// Get the sum of all the elements in an array.
function array_sum(arr)
{
	// The Array.reduce method is only available in Firefox 3+.
	// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce

	var sum = 0

	for (var i = 0; i < arr.length; ++i)
	{
		sum += arr[i]
	}

	return sum
}

// Get the average of all the elements in an array.
function array_average(arr)
{
	if (arr.length === 0)
	{
		return 0.0
	}

	return array_sum(arr) / arr.length
}

// Get the minimum element in an array.
function array_min(arr)
{
	return Math.min.apply(null, arr)
}

// Get the minimum element in an array.
function array_max(arr)
{
	return Math.max.apply(null, arr)
}

// Get a random boolean.
function get_random_boolean()
{
	return !Math.round(Math.random())
}

/// Get a random float in the interval [0, b).
function get_random_float_1(b)
{
	// [0, 1) * b => [0, b)
	return Math.random() * b
}

/// Get a random int in the interval [0, b).
function get_random_int_1(b)
{
	return Math.floor(get_random_float_1(b))
}

/// Get a random float in the interval [a, b).
function get_random_float_2(a, b)
{
	// [0, 1) * (b - a) => [0, b - a)
	// [0, b - a) + a => [a, b)
	return Math.random() * (b - a) + a
}

/// Get a random int in the interval [a, b).
function get_random_int_2(a, b)
{
	return Math.floor(get_random_float_2(a, b))
}

// Shuffle the elements in the array.
/**
\sa https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
*/
function array_shuffle(arr)
{
	var n = arr.length

	if ((n === 0) || (n === 1))
	{
		return
	}

	// for every element,
	for (var i = 0; i < n - 1; ++i)
	{
		// get the index of the element to swap
		var j = get_random_int_2(i, n)

		if (i == j)
		{
			// no need to swap
			continue
		}

		// parallel (destructuring) assignment is only available in Firefox 2+
		// [arr[i], arr[j]] = [arr[j], arr[i]]
		// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment

		// swap
		var tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp
	}
}

// Set all the radio button checked properties to false.
function reset_radio_button_checked_properties(radio_button_group_name)
{
	var elements = name(radio_button_group_name)

	for (var i = 0; i < elements.length; ++i)
	{
		elements[i].checked = false
	}
}

// Get the value of the first checked radio button.
function get_radio_button_value(radio_button_group_name)
{
	var result = ""

	var elements = name(radio_button_group_name)

	for (var i = 0; i < elements.length; ++i)
	{
		if (elements[i].checked)
		{
			result = elements[i].value
			break
		}
	}

	return result
}

// Return the result of a prompt.  If "Cancel" was chosen, the given default value is returned.
/**
\sa https://developer.mozilla.org/en-US/docs/Web/API/Window/prompt
*/
function prompt_return_default_if_cancel(message, default_value)
{
	var result = window.prompt(message, default_value)

	if (!result)
	{
		result = default_value
	}

	return result
}
