#include "tests_aux.h"

class delete_TestSuite : public testing::Test { 
    void SetUp() override {
        setup_test();
    }
};

TEST_F(delete_TestSuite, delete_01) {
    INFO("Deleting a student record from a hash table with a collision");
    execute_test("delete_01");
}

TEST_F(delete_TestSuite, delete_02) {
    INFO("Deleting a non-existent student record from a hash table with collision ");
    execute_test("delete_02");
}

TEST_F(delete_TestSuite, delete_03) {
    INFO("Deleting a student record from a hash table with one record only");
    execute_test("delete_03");
}

TEST_F(delete_TestSuite, delete_04) {
    INFO("Deleting a student record from an empty hash table");
    execute_test("delete_04");
}

TEST_F(delete_TestSuite, delete_05) {
    INFO("Deleting a student record from a hash table over a tombstone value in a hash table with collision");
    execute_test("delete_05");
}

TEST_F(delete_TestSuite, delete_06) {
    INFO("Deleting a student record from a hash table of only tombstone values");
    execute_test("delete_06");
}

TEST_F(delete_TestSuite, delete_07) {
    INFO("Deleting a student record from a hash table by looping around");
    execute_test("delete_07");
}