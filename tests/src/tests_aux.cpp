#include "tests_aux.h"

const char* test_output_dir = "./tests/actual_outputs";
const char* test_exp_dir = "./tests/expected_outputs";
const int test_timeout = 10;
const char *mars_jar = "./MarsFall2020.jar";

char *load_file(const char *filename) {
	char *buffer = 0;
	long length;
	FILE *file = fopen(filename, "r");
	if (file == NULL) {
		ERROR("Could not open file %s", filename);
		return NULL;
	}
	(void)fseek(file, 0, SEEK_END);
	length = ftell(file);
	(void)fseek(file, 0, SEEK_SET);
	buffer = (char *)malloc(length + 1);
	if (buffer != NULL) {
		(void)fread(buffer, 1, length, file);
		(void)fclose(file);
		buffer[length] = '\0';
	}
	return buffer;
}

void setup_test() {
	char cmd[100];
	sprintf(cmd, "rm -rf %s", test_output_dir);
	system(cmd);
	mkdir(test_output_dir, 0700);
	execute_null();
}

void execute_null() {
	assert(access(mars_jar, F_OK) == 0);
	char cmd[100];
	sprintf(cmd, "java -jar %s --noGui >> /dev/null", mars_jar);
}

void execute_test(const char *test_name) {
	char test_log_outfile[100];
	char cmd[500];

    sprintf(test_log_outfile, "%s/%s.txt", test_output_dir, test_name);
    sprintf(cmd, "java -jar %s tests/%s.asm --noGui --main -q -n 500000 >> %s 2>&1", mars_jar, test_name, test_log_outfile);
    system(cmd); 
    expect_outfile_matches(test_name, test_log_outfile);
}

void expect_outfile_matches(const char *test_name, const char* test_outfile) {
    char test_exp_file[100];
    sprintf(test_exp_file, "%s/%s.txt", test_exp_dir, test_name);
    
	char *exp_output = load_file(test_exp_file);
	char *actual_output = load_file(test_outfile);

	// Remove the extra newline MARS places at the end of the file
	int act_length = strlen(actual_output);
	actual_output[act_length - 1] = 0;

    EXPECT_STREQ(exp_output, actual_output);

	free(exp_output);
	free(actual_output);
}