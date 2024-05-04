#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <fcntl.h>
#include "gtest/gtest.h"

#define INFO(...) fprintf(stderr, "[          ] [ INFO ] "); fprintf(stderr, __VA_ARGS__); fprintf(stderr, "\n"); fflush(stderr)
#define ERROR(...) fprintf(stderr, "[          ] [ ERR  ] "); fprintf(stderr, __VA_ARGS__); fprintf(stderr, "\n"); fflush(stderr)

extern const char* test_output_dir;
extern const char* test_exp_dir;

char *load_file(const char *filename);
void expect_outfile_matches(const char *test_name, const char *test_outfile);
void execute_test(const char *test_name);
void execute_null();
void setup_test();