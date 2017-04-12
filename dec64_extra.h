#ifndef DEC64_EXTRA
#define DEC64_EXTRA

dec64 dec64_log2(dec64 x);
dec64 dec64_frexp(dec64 val, int *exp);
int dec64_sprint(char* buff, int buffLen, dec64 val);
dec64 dec64_strtod(const char* start, char** end);

#endif
