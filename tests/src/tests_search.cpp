#include "tests_aux.h"

class search_TestSuite : public testing::Test { 
    void SetUp() override {
        setup_test();
    }
};

TEST_F(search_TestSuite, search_01) {
    INFO("Searching a student record in a hash table with a collision");
    execute_test("search_01");
}

TEST_F(search_TestSuite, search_02) {
    INFO("Searching a non-existent student record in a hash table with a collision");
    execute_test("search_02");
}

TEST_F(search_TestSuite, search_03) {
    INFO("Searching a student record in a hash table with one record only");
    execute_test("search_03");
}

TEST_F(search_TestSuite, search_04) {
    INFO("Searching a student record in an empty hash table");
    execute_test("search_04");
}

TEST_F(search_TestSuite, search_05) {
    INFO("Searching a student record over a tombstone value in a hash table with a collision");
    execute_test("search_05");
}

TEST_F(search_TestSuite, search_06) {
    INFO("Searching a student record in a hash table of only tombstone values");
    execute_test("search_06");
}

TEST_F(search_TestSuite, search_07) {
    INFO("Searching a student record in a hash table by looping around");
    execute_test("search_07");
}
