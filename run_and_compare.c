#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <libgen.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <test_filename>\n", argv[0]);
        return 1;
    }

    const char* test_dir = "./tests";
    const char* expected_dir = "./tests/expected_outputs";

    char test_file[512];
    snprintf(test_file, sizeof(test_file), "%s/%s", test_dir, argv[1]);

    // Check if the test file exists
    struct stat st;
    if (stat(test_file, &st) != 0) {
        printf("Test file does not exist: %s\n", test_file);
        return 1;
    }

    // Extract the base name of the test file for matching with expected output
    char *test_file_copy = strdup(test_file);
    if (test_file_copy == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    char* base_name = basename(test_file_copy);
    char* dot = strrchr(base_name, '.');
    if (dot) *dot = '\0'; // Strip extension

    // Prepare command to run the MarsFall2020 simulation
    char command[1024];
    snprintf(command, sizeof(command), "java -jar MarsFall2020.jar --noGui %s | grep -v 'MARS 5.0.2'", test_file);
    
    // Capture the output of the command
    FILE *fp = popen(command, "r");
    if (fp == NULL) {
        printf("Failed to run command\n");
        free(test_file_copy);
        return 1;
    }

    char output[16384] = {0}; 
    int index = 0;
    while (index < sizeof(output) && fgets(output + index, sizeof(output) - index, fp) != NULL) {
        index += strlen(output + index);
    }
    pclose(fp);


    char *first_output = output;
    while (*first_output == '\n') {
        first_output++; 
    }

    char *end = first_output + strlen(first_output) - 1;
    while (end > first_output && *end == '\n') {
        *end = '\0';
        end--;
    }

    char expected_output_file[512];
    snprintf(expected_output_file, sizeof(expected_output_file), "%s/%s.txt", expected_dir, base_name);

    if (stat(expected_output_file, &st) != 0) {
        printf("Expected output file does not exist: %s\n", expected_output_file);
        free(test_file_copy);
        return 1;
    }

    // Print the test case being processed
    printf("Processing %s\n", base_name);
    printf("Actual Output:\n");
    printf("%s\n",first_output);
    printf("------------------------------------------------------\n");
    printf("Expected Output:\n");

    // Read and print expected output
    FILE *expected_fp = fopen(expected_output_file, "r");
    if (!expected_fp) {
        perror("Failed to open expected output file");
        free(test_file_copy);
        return 1;
    }

    while (fgets(output, sizeof(output), expected_fp) != NULL) {
        printf("%s", output);
    }
    printf("\n");
    fclose(expected_fp);
    free(test_file_copy);

    return 0;
}
