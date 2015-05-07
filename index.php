<!DOCTYPE html>
<!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">-->

<!--

Image Quality Assessment Test
Copyright (C) 2013 Steve Ward

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

-->

<html lang="en">
<!--<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">-->

<head>

<meta charset="utf-8">
<!--<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />-->

<title>Image Quality Assessment Test</title>

<link rel="stylesheet" type="text/css" href="style.css" media="screen" />

<script type="text/javascript" src="json2.js"></script>

<script type="text/javascript" src="utils.js"></script>

<script type="text/javascript" src="iqatest.js"></script>

</head>

<body>


<!--
/******************************************************************************/
-->


<noscript style="color: red; font-weight: bold; font-size: larger;">
<p><strong>JavaScript is disabled.</strong> You must <a href="https://www.google.com/search?q=enable+JavaScript">enable JavaScript</a> to participate in this experiment.</p>
</noscript>


<!--
/******************************************************************************/
-->


<div id="div_informed_consent" style="display: block;">

<h1>Image Quality Assessment Test</h1>

<h2>Informed Consent</h2>

<h3>Introduction</h3>

<p>This research survey is being conducted by graduate students in the <a href="http://www.ist.ucf.edu/grad/index.html">Modeling and Simulation</a> program at the <a href="http://www.ucf.edu/">University of Central Florida</a>.  The purpose of this research is to investigate a threshold at which a typical human visual system can perceive distortions in compressed images.</p>

<h3>Participation</h3>
<p>Participation in this survey is voluntary.  You may refuse to participate or you may withdraw at any time without consequences.  To withdraw at any time, close the browser window.  If you withdraw before completion, no results will be submitted.  You must be at least 18 years of age to participate.</p>

<h3>Procedure</h3>

<p>This survey involves the following.</p>
<ol>
<li>Completing a brief questionnaire about your demographic information.</li>
<li>Comparing many pairs of <a href="image_credits.html">images</a> side-by-side and deciding if they are identical or different.  After the final comparison is made, the results will be submitted automatically.</li>
</ol>

<h3>Time required</h3>

<p>Completing this survey takes approximately 7 to 14 minutes.  There is no time limit.</p>

<h3>Risks and discomforts</h3>

<p>There is a small risk that participants will develop eye strain or fatigue.  It sometimes happens to people who perform prolonged, continuous visual scanning.  This risk is minimized by allowing participants to work at their own pace and to take breaks at will.</p>

<h3>Confidentiality</h3>

<p>Demographic information will only be used for classification purposes.  No identifying data will be reported.</p>

<h3>How the findings will be used</h3>

<p>The results of this survey will only be used for scholarly purposes.  We intend the results to be presented in educational settings such as conferences and peer-reviewed journals.</p>

<h3>Benefits and compensation</h3>

<p>There are no benefits to participants.  No compensation, payment, or credit will be given for participation.</p>

<h3>Contact information</h3>

<?php include('question_email_message.html'); ?>

<button type="button" onclick="javascript:transition_from_to('div_informed_consent', 'form_participant_information'); iqatest.initialize();">I agree to participate</button>

</div>


<!--
/******************************************************************************/
-->


<!--
NOTE: html5 <form> can't have an empty action string
<form id="form_participant_information" style="display: none;" action="">
-->
<form id="form_participant_information" style="display: none;">

<h2>Participant Information</h2>

<p>Please complete as much of this form as you want. None of the fields are required.</p>

<ul>

<li>
	Age:
	<input id="age" name="age" type="text" value="" size="3" />
	(years)
</li>

<li>
	Sex:
	<label><input name="sex" type="radio" value="Male"   />Male  </label>&nbsp;
	<label><input name="sex" type="radio" value="Female" />Female</label>
</li>

<li>
	Is English your primary language?
	<label><input name="english_language" type="radio" value="Yes" />Yes</label>&nbsp;
	<label><input name="english_language" type="radio" value="No"  />No </label>
</li>

<li>
	Is your vision normal or corrected to normal?
	<label><input name="vision_normal" type="radio" value="Yes" />Yes</label>&nbsp;
	<label><input name="vision_normal" type="radio" value="No"  />No </label>
</li>

<li>
	Do you require vision correction such as glasses or contact lenses?
	<label><input name="vision_correction_necessary" type="radio" onclick="javascript:reset_element_style_display('optional_vision_correction_necessary');" value="Yes" />Yes</label>&nbsp;
	<label><input name="vision_correction_necessary" type="radio" onclick="javascript:set_element_style_display_none('optional_vision_correction_necessary'); reset_radio_button_checked_properties('vision_correction_used');" value="No" />No</label>&nbsp;

	<ul id="optional_vision_correction_necessary" style="display: none;">
	<li>
		Are you using them now?
		<label><input name="vision_correction_used" type="radio" value="Yes" />Yes</label>&nbsp;
		<label><input name="vision_correction_used" type="radio" value="No"  />No</label>
	</li>
	</ul>
</li>

<li>
	Do you have any experience with image processing or photo editing?
	<label><input name="image_experience" type="radio" value="Yes" />Yes</label>&nbsp;
	<label><input name="image_experience" type="radio" value="No"  />No </label>
</li>

<li>
	How many hours did you sleep in the last 24 hours?
	<input id="sleep_time" name="sleep_time" type="text" value="" size="2" />
	(hours)
</li>

<li>
	How many hours per week (on average) do you spend using a <strong>computer</strong>?
	<input id="computer_time" name="computer_time" type="text" value="" size="3" />
	(hours/week)
</li>

<li>
	How do you rate your proficiency with <strong>computers</strong>?<br />
	<label><input name="computer_proficiency" type="radio" value="1" />1 = very poor     </label>&nbsp;
	<label><input name="computer_proficiency" type="radio" value="2" />2 = poor          </label>&nbsp;
	<label><input name="computer_proficiency" type="radio" value="3" />3 = slightly poor </label>&nbsp;
	<label><input name="computer_proficiency" type="radio" value="4" />4 = average       </label>&nbsp;
	<label><input name="computer_proficiency" type="radio" value="5" />5 = slightly good </label>&nbsp;
	<label><input name="computer_proficiency" type="radio" value="6" />6 = good          </label>&nbsp;
	<label><input name="computer_proficiency" type="radio" value="7" />7 = very good     </label>
</li>

<li>
	How many hours per week (on average) do you spend playing (computer or console) <strong>video games</strong>?
	<input id="videogame_time" name="videogame_time" type="text" value="" size="3" />
	(hours/week)
</li>

<li>
	How do you rate your proficiency with <strong>video games</strong>?<br />
	<label><input name="videogame_proficiency" type="radio" value="1" />1 = very poor     </label>&nbsp;
	<label><input name="videogame_proficiency" type="radio" value="2" />2 = poor          </label>&nbsp;
	<label><input name="videogame_proficiency" type="radio" value="3" />3 = slightly poor </label>&nbsp;
	<label><input name="videogame_proficiency" type="radio" value="4" />4 = average       </label>&nbsp;
	<label><input name="videogame_proficiency" type="radio" value="5" />5 = slightly good </label>&nbsp;
	<label><input name="videogame_proficiency" type="radio" value="6" />6 = good          </label>&nbsp;
	<label><input name="videogame_proficiency" type="radio" value="7" />7 = very good     </label>
</li>

<li>
	Are you currently under the influence of any substances?
	<label><input name="substance_influence" type="radio" onclick="javascript:reset_element_style_display('optional_substance_influence');" value="Yes" />Yes</label>&nbsp;
	<label><input name="substance_influence" type="radio" onclick="javascript:set_element_style_display_none('optional_substance_influence'); reset_element_property('substances', 'value');" value="No" />No</label>

	<ul id="optional_substance_influence" style="display: none;">
	<li>
		What substances?
		<input id="substances" name="substances" type="text" value="" />
	</li>
	</ul>
</li>

<li>
	What is the highest level of school you completed or the highest degree you received?
	<select id="education" size="1">
		<option selected="selected"></option>
		<option>Less than 9th grade</option>
		<option>9th grade</option>
		<option>10th grade</option>
		<option>11th grade</option>
		<option>12th grade (but no diploma)</option>
		<option>High school diploma or the equivalent (e.g., GED)</option>
		<option>Some college (but no degree)</option>
		<option>Associate's degree (e.g., AA, AS)</option>
		<option>Bachelor's degree (e.g., BA, BS)</option>
		<option>Master's degree (e.g., MA, MS, MBA, MEd, MSW)</option>
		<option>Professional Doctoral degree (e.g., MD, JD, DDS)</option>
		<option>Research Doctoral degree (e.g., PhD, EdD)</option>
	</select>
</li>

</ul>

<div>

<button type="reset">Reset</button>

<button type="button" onclick="javascript:if (iqatest.results.participant_information.store()) {transition_from_to('form_participant_information', 'div_instructions_first');}">Continue to instructions</button>

</div>

</form>


<!--
/******************************************************************************/
-->


<div id="div_instructions_first" style="display: none;">

<h2>Instructions</h2>

<p>We are investigating how much distortion can be applied to an image before the distortion is perceived by a typical human observer.</p>

<p>Before you begin making image comparisons, there is a brief practice session to make you familiar with the process.</p>

<p>You will compare several pairs of <a href="http://en.wikipedia.org/wiki/Grayscale">grayscale</a> images side-by-side and determine if they are identical or different.  In all cases, one of the two images is a reference (i.e. non-distorted) image.  The other image is a copy of the reference image with a distortion (of varying degrees) possibly applied.  If there is a distortion applied, it may be subtle or severe.</p>

<p>When comparing the images, you should consider them to be <em>identical</em> if you <em>cannot</em> perceive a difference between them.  You should consider them to be <em>different</em> if you <em>can</em> perceive a difference between them.  Whichever conclusion you draw, click the appropriate button (i.e. "Identical" or "Different").</p>

<p>No feedback will be given after you make your comparisons.</p>

<p>After a comparison is made, there is a small period of time in which
<ol>
<li>the pair of images will disappear,</li>
<li>the buttons will be disabled,</li>
<li>a new pair of images will appear,</li>
<li>and the buttons will be enabled.</li>
</ol>
Continue making comparisons until your results are submitted.  When your results are submitted, you will be redirected to another page.</p>

<button type="button" onclick="javascript:transition_from_to_timeout('div_instructions_first', 'div_practice_image_comparison_1', iqatest.interstimulus_interval);">Begin practice image comparison</button>

</div>


<!--
/******************************************************************************/
-->


<div id="div_practice_image_comparison_1" style="display: none;">

<h2>Practice Image Comparison</h2>

<p>These images are <em>different</em>.  One of them has a severe distortion.</p>

<p>Severe distortions are noticeable by their blockiness.  A distorted image may appear on either the left side or the right side.</p>

<p>These messages will not be shown during the actual experiment.  They are only instructional.</p>

<table class="centered">

<tr>
	<th colspan="2">Are the images identical or different?</th>
</tr>

<tr>
	<td><img alt="image A" src="images/practice_set/distorted_severe.jpg" /></td>
	<td><img alt="image B" src="images/practice_set/reference.png"        /></td>
</tr>

<tr>
	<td colspan="2"><button type="button" onclick="javascript:alert('Try again. Look closer.\nNo feedback will be given during the actual experiment.');">Identical</button></td>
</tr>

<tr>
	<td colspan="2"><button type="button" onclick="javascript:transition_from_to_timeout('div_practice_image_comparison_1', 'div_practice_image_comparison_2', iqatest.interstimulus_interval);">Different</button></td>
</tr>

</table>

<?php include('perception_instructions_message.html'); ?>

<?php include('question_email_message.html'); ?>

</div>


<!--
/******************************************************************************/
-->


<div id="div_practice_image_comparison_2" style="display: none;">

<h2>Practice Image Comparison</h2>

<p>These images are <em>identical</em>.</p>

<!--<p>There is a 25% chance that both images will be identical.</p>-->

<p>These messages will not be shown during the actual experiment.  They are only instructional.</p>

<table class="centered">

<tr>
	<th colspan="2">Are the images identical or different?</th>
</tr>

<tr>
	<td><img alt="image A" src="images/practice_set/reference.png" /></td>
	<td><img alt="image B" src="images/practice_set/reference.png" /></td>
</tr>

<tr>
	<td colspan="2"><button type="button" onclick="javascript:transition_from_to_timeout('div_practice_image_comparison_2', 'div_practice_image_comparison_3', iqatest.interstimulus_interval);">Identical</button></td>
</tr>

<tr>
	<td colspan="2"><button type="button" onclick="javascript:alert('Try again. Look closer.\nNo feedback will be given during the actual experiment.');">Different</button></td>
</tr>

</table>

<?php include('perception_instructions_message.html'); ?>

<?php include('question_email_message.html'); ?>

</div>


<!--
/******************************************************************************/
-->


<div id="div_practice_image_comparison_3" style="display: none;">

<h2>Practice Image Comparison</h2>

<p>These images are <em>slightly different</em>.  One of them has a subtle distortion.</p>

<p>Subtle distortions are most noticeable in gradients and around edges.</p>

<p>These messages will not be shown during the actual experiment.  They are only instructional.</p>

<table class="centered">

<tr>
	<th colspan="2">Are the images identical or different?</th>
</tr>

<tr>
	<td><img alt="image A" src="images/practice_set/reference.png"        /></td>
	<td><img alt="image B" src="images/practice_set/distorted_subtle.jpg" /></td>
</tr>

<tr>
	<td colspan="2"><button type="button" onclick="javascript:alert('Try again. Look closer.\nNo feedback will be given during the actual experiment.');">Identical</button></td>
</tr>

<tr>
	<td colspan="2"><button type="button" onclick="javascript:transition_from_to('div_practice_image_comparison_3', 'div_practice_image_comparison_4');">Different</button></td>
</tr>

</table>

<?php include('perception_instructions_message.html'); ?>

<?php include('question_email_message.html'); ?>

</div>


<!--
/******************************************************************************/
-->


<div id="div_practice_image_comparison_4" style="display: none;">

<h2>Practice Image Comparison</h2>

<p>These images are <em>wholly different</em>.</p>

<!--<p>There is a 25% chance that both images will be wholly different.</p>-->

<p>These messages will not be shown during the actual experiment.  They are only instructional.</p>

<table class="centered">

<tr>
	<th colspan="2">Are the images identical or different?</th>
</tr>

<tr>
	<td><img alt="image A" src="images/practice_set/anti-reference.png" /></td>
	<td><img alt="image B" src="images/practice_set/reference.png"      /></td>
</tr>

<tr>
	<td colspan="2"><button type="button" onclick="javascript:alert('Try again. Look closer.\nNo feedback will be given during the actual experiment.');">Identical</button></td>
</tr>

<tr>
	<td colspan="2"><button type="button" onclick="javascript:transition_from_to('div_practice_image_comparison_4', 'div_instructions_last');">Different</button></td>
</tr>

</table>

<?php include('perception_instructions_message.html'); ?>

<?php include('question_email_message.html'); ?>

</div>


<!--
/******************************************************************************/
-->


<div id="div_instructions_last" style="display: none;">

<h2>Instructions</h2>

<p>Now that the practice is done, you're ready to make some image comparisons.</p>

<p>There are no correct or incorrect answers.</p>

<p>There is no time limit.  However, it is recommended that you don't spend too much time comparing each pair of images.</p>

<button type="button" onclick="javascript:transition_from_to('div_instructions_last', 'div_image_comparison');">Begin image comparison</button>

</div>


<!--
/******************************************************************************/
-->


<div id="div_image_comparison" style="display: none;">

<table class="centered">

<tr>
	<th colspan="2">Are the images identical or different?</th>
</tr>

<tr>
	<!--
	NOTE: html5 <img> can't have an empty src string
	<td><img id="img_A" src="" alt="image A" /></td>
	<td><img id="img_B" src="" alt="image B" /></td>
	-->
	<td><img id="img_A" alt="image A" src="#" /></td>
	<td><img id="img_B" alt="image B" src="#" /></td>
</tr>

<tr>
	<td colspan="2"><button id="button_identical" type="button" onclick="javascript:iqatest.results.image_comparisons.process(true);">Identical</button></td>
</tr>

<tr>
	<td colspan="2"><button id="button_different" type="button" onclick="javascript:iqatest.results.image_comparisons.process(false);">Different</button></td>
</tr>

</table>

<br />

<?php include('perception_instructions_message.html'); ?>

<div id="div_progress" class="centered" title="progress"></div>

<?php include('question_email_message.html'); ?>

</div>


<!--
/******************************************************************************/
-->


<!-- The images are loaded dynamically. -->
<div id="div_images" style="display: none;"></div>


<!--
/******************************************************************************/
-->


<div id="div_debug" class="centered" style="display: none; border: medium dotted blue;">

<h2>Debug</h2>

<hr />

image <span id="image_progress"></span><br />
image set <span id="image_set_progress"></span>

<hr />

<button type="button" onclick="javascript:alert(window.id('div_images').innerHTML);">window.id('div_images').innerHTML</button>

<hr />

<button type="button" onclick="javascript:alert(JSON.stringify(iqatest.results));">JSON.stringify(iqatest.results)</button>

<hr />

<button type="button" onclick="javascript:alert(JSON.stringify(iqatest.results.screen_properties));">JSON.stringify(iqatest.results.screen_properties)</button>

<hr />

<button type="button" onclick="javascript:alert(JSON.stringify(iqatest.results.participant_information));">JSON.stringify(iqatest.results.participant_information)</button>

<hr />

<button type="button" onclick="javascript:alert(JSON.stringify(iqatest.results.image_sets));">JSON.stringify(iqatest.results.image_sets)</button>
<button type="button" onclick="javascript:alert(JSON.stringify(iqatest.results.image_set_indexes));">JSON.stringify(iqatest.results.image_set_indexes)</button>

<hr />

<button type="button" onclick="javascript:alert(JSON.stringify(iqatest.results.images));">JSON.stringify(iqatest.results.images)</button>
<button type="button" onclick="javascript:alert(JSON.stringify(iqatest.results.image_indexes));">JSON.stringify(iqatest.results.image_indexes)</button>

<hr />

<button type="button" onclick="javascript:alert(JSON.stringify(iqatest.results.image_comparisons));">JSON.stringify(iqatest.results.image_comparisons)</button>

<hr />

<button type="button" onclick="javascript:iqatest.results.image_set_indexes.shuffle();">iqatest.results.image_set_indexes.shuffle();</button>
<button type="button" onclick="javascript:iqatest.results.image_indexes.shuffle();">iqatest.results.image_indexes.shuffle();</button>

<hr />

<button type="button" onclick="javascript:iqatest.results.image_comparisons.fill_zero();">iqatest.results.image_comparisons.fill_zero();</button>

<br />

<button type="button" onclick="javascript:iqatest.results.image_comparisons.fill_one();">iqatest.results.image_comparisons.fill_one();</button>

<br />

<button type="button" onclick="javascript:iqatest.results.image_comparisons.fill_random();">iqatest.results.image_comparisons.fill_random();</button>

<hr />

[<a href="http://validator.w3.org/check?uri=referer">Valid HTML5</a>]
[<a href="http://jigsaw.w3.org/css-validator/check/referer">Valid CSS</a>]

<hr />

</div>


<!--
/******************************************************************************/
-->


<form id="form_results" class="centered" style="display: none; border: medium dotted red;" action="submit-results.php" method="post" onsubmit="javascript:return iqatest.encode_results();">

<h2>Submit Results</h2>

<div>

<!-- The "name" attribute is necessary for the data to be sent. -->

<input type="hidden" id="results" name="results" value="" />

<button type="submit">Submit Results</button>

</div>

</form>


<!--
/******************************************************************************/
-->


</body>

</html>
