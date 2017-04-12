#include <string.h>
#include <stdint.h>
#include "DEC64/dec64.h"
#include "dec64_extra.h"
#include "DEC64/dec64_math.h"
#include "DEC64/dec64_string.h"

dec64 dec64_log2(dec64 x) {
    if (x <= 0 || dec64_is_any_nan(x) == DEC64_TRUE) {
        return DEC64_NAN;
    }
    if (dec64_equal(x, DEC64_ONE) == DEC64_TRUE) {
        return DEC64_ZERO;
    }
	return dec64_divide(dec64_log(x), dec64_log(dec64_new(2, 0)));
}

dec64 dec64_frexp(dec64 val, int *exp) {
	*exp = (dec64_equal(val, DEC64_ZERO) ? 0 : (int)(1 + dec64_log(val)));
	return dec64_multiply(val, dec64_raise(10, dec64_new(-(*exp), 0)));
}

int dec64_sprint(char* buff, int buffLen, dec64 val) {
	dec64_string_state state = dec64_string_begin();
	dec64_to_string(state, val, buff);
	dec64_string_end(state);
	return state->length;
}

dec64 dec64_strtod(const char* start, char** end) {
	if(end != NULL)
		*end = strchr(start, '\0');
	dec64_string_state state = dec64_string_begin();
	dec64 val = dec64_from_string(state, start);
	dec64_string_end(state);
	return val;
}
