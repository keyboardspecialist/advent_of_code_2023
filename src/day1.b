SECTION "TREBUCHET"

GET "u/utils.b"
 
MANIFEST { LTOR = 0; RTOL = 1 }

LET start() = VALOF
{	IF NOT set_infile("data/day1.data") DO
	{	writef("Bad file*n")
		RESULTIS 1
	}

	start_timer()
	calibrate()
	stop_timer()
	cls_infile()
	writef("Execution Time: %d ms *n", get_time_taken_ms())
	RESULTIS 0
}

AND calibrate() BE
{	LET eof, sumcal = FALSE, 0

	//part 1
	{	LET ln = fread_line()
		AND d1, d2 = 0,0
		eof := result2

		FOR i = 1 TO ln%0 IF isnumeric(ln%i) THEN { d1 := ln%i - '0'; BREAK }
		FOR i = ln%0 TO 1 BY -1 IF isnumeric(ln%i) THEN { d2 := ln%i - '0'; BREAK }

		sumcal +:= (d1 * 10) + d2
	}	REPEATUNTIL eof = TRUE

	writef("Part 1 calibration sum --> %d *n", sumcal)

	reset_infile()
	eof := FALSE

	sumcal := 0

	//Part 2
	{	LET d1,d2 = 0,0
		LET ln = fread_line()
		eof := result2

		d1 := finddigit(ln, LTOR, lr_cmp, strstr)
		d2 := finddigit(ln, RTOL, rl_cmp, strstr)

		sumcal +:= (d1 * 10) + d2
	} REPEATUNTIL eof = TRUE
	writef("Part 2 calibration sum --> %d *n", sumcal)
}

AND strstr(str, substr, sp) = VALOF
{	LET pos = -1
	LET maybefound = TRUE
	FOR i = sp TO (str%0)-(substr%0)+1 DO
	{	LET c = str%i
		IF c = substr%1 THEN
		{	LET k = 1
			FOR j = 2 TO substr%0 DO
			{	//writef("Looking for '%s'  j is  %d and len is  %d and substr%%j is  %c and str%%k is  %c  and i is  %d  *n", substr, j, substr%0, substr%j, str%(i+k), i+k)
				IF substr%j ~= str%(i+k) THEN
				{ maybefound := FALSE; BREAK }
				k +:= 1
			}
			IF maybefound = TRUE THEN pos := i 
			BREAK
		}
	}
	RESULTIS pos
}

AND lr_cmp(line, pos) = pos > line%0 -> TRUE, FALSE
AND rl_cmp(line, pos) = pos = 0 -> TRUE, FALSE

AND finddigit(line, dir, cmp_fn, srch_fn) = VALOF
{	LET p = 1
	LET one,two,three,four,five,six,seven,eight,nine = 
		"one","two","three","four","five","six","seven","eight","nine"

	IF dir = RTOL THEN p := line%0
	{	TEST isnumeric(line%p) THEN 			RESULTIS line%p - '0' 
		ELSE TEST line%p = 'o' THEN 
			IF srch_fn(line, one, p) ~= -1		RESULTIS 1 
		ELSE TEST line%p = 't' THEN
		{	IF srch_fn(line, two, p) ~= -1		RESULTIS 2
			IF srch_fn(line, three, p) ~= -1 	RESULTIS 3
		}
		ELSE TEST line%p = 'f' THEN
		{	IF srch_fn(line, four, p) ~= -1 	RESULTIS 4
			IF srch_fn(line, five, p) ~= -1 	RESULTIS 5
		}
		ELSE TEST line%p = 's' THEN
		{	IF srch_fn(line, six, p) ~= -1 		RESULTIS 6
			IF srch_fn(line, seven, p) ~= -1	RESULTIS 7
		}
		ELSE TEST line%p = 'e' THEN 
			IF srch_fn(line, eight, p) ~= -1	RESULTIS 8
		ELSE IF line%p = 'n' THEN 
			IF srch_fn(line, nine, p) ~= -1		RESULTIS 9
		TEST dir = RTOL THEN p -:= 1
		ELSE p +:= 1
	}	REPEATUNTIL cmp_fn(line, p)

	RESULTIS -1
}
