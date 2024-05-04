#include "tests_aux.h"

class insert_TestSuite : public testing::Test { 
    void SetUp() override {
        setup_test();
    }
};

TEST_F(insert_TestSuite, insert_01) {
    INFO("Inserting a student record into a hash table with a collision");
    execute_test("insert_01");
}

TEST_F(insert_TestSuite, insert_02) {
    INFO("Inserting into tombstone");
    execute_test("insert_02");
}

TEST_F(insert_TestSuite, insert_03) {
    INFO("Inserting into full table");
    execute_test("insert_03");
}