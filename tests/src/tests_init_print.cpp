#include "tests_aux.h"

class init_print_TestSuite : public testing::Test { 
    void SetUp() override {
        setup_test();
    }
};

TEST_F(init_print_TestSuite, init_print_01) {
    INFO("Initializing a student record and printing it");
    execute_test("init_print_01");
}

TEST_F(init_print_TestSuite, init_print_02) {
    INFO("Initializing student with non-alphabet characters");
    execute_test("init_print_02");
}

TEST_F(init_print_TestSuite, init_print_03) {
    INFO("Initializing student with long name");
    execute_test("init_print_03");
}

TEST_F(init_print_TestSuite, init_print_04) {
    INFO("Initializing student with high credits/ID number");
    execute_test("init_print_04");
}