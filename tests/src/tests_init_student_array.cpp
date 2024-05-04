#include "tests_aux.h"

class init_student_array_TestSuite : public testing::Test { 
    void SetUp() override {
        setup_test();
    }
};

TEST_F(init_student_array_TestSuite, init_student_array_01) {
    INFO("Initializing an array of students");
    execute_test("init_student_array_01");
}

TEST_F(init_student_array_TestSuite, init_student_array_02) {
    INFO("Initializing an array of one student");
    execute_test("init_student_array_02");
}

TEST_F(init_student_array_TestSuite, init_student_array_03) {
    INFO("Initializing an array of 0 students");
    execute_test("init_student_array_03");
}

TEST_F(init_student_array_TestSuite, init_student_array_04) {
    INFO("Initializing an array of 1 student with high credits/ID number");
    execute_test("init_student_array_04");
}