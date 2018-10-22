#include <stdio.h>
#include "sum.h"
#include "CUnit/Basic.h"

int init_suite1(void) {
	return 0;
}

int clean_suite1(void) {
	return 0;
}

void test_sum_function(void) {
	CU_ASSERT(3 == sum(1,2));
	CU_ASSERT(13 == sum(11,2));
	CU_ASSERT(44998 == sum(10000,34998));
}

int main()
{
   CU_pSuite pSuite = NULL;

   /* initialize the CUnit test registry */
   if (CUE_SUCCESS != CU_initialize_registry())
      return CU_get_error();

   /* add a suite to the registry */
   pSuite = CU_add_suite("Suite_1", init_suite1, clean_suite1);
   if (NULL == pSuite) {
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* add the tests to the suite */
   /* NOTE - ORDER IS IMPORTANT - MUST TEST fread() AFTER fprintf() */
   if ((NULL == CU_add_test(pSuite, "test of sum()", test_sum_function))){
      CU_cleanup_registry();
      return CU_get_error();
   }

   /* Run all tests using the CUnit Basic interface */
   CU_basic_set_mode(CU_BRM_VERBOSE);
   CU_basic_run_tests();
   CU_cleanup_registry();
   return CU_get_error();
}

