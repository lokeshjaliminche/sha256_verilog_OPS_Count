/*********************************************************************
* Filename:   sha256.c
* Author:     Brad Conte (brad AT bradconte.com)
* Copyright:
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Performs known-answer tests on the corresponding SHA1
	          implementation. These tests do not encompass the full
	          range of available test vectors, however, if the tests
	          pass it is very, very likely that the code is correct
	          and was compiled properly. This code also serves as
	          example usage of the functions.
*********************************************************************/

/*************************** HEADER FILES ***************************/
#include <stdio.h>
#include <memory.h>
#include <string.h>
#include "sha256.h"

/*********************** FUNCTION DEFINITIONS ***********************/
int sha256_test()
{
	FILE * fp;
	char * text1 = NULL;
	size_t len = 0;
	ssize_t read;

	fp = fopen("./input.txt", "r");
    	if (fp == NULL)
		return 0;

	while ((read = getline(&text1, &len, fp)) != -1) {
        	printf("Retrieved line of length %zu:\n", read);
	        printf("%s", text1);
    	}
	//BYTE text1[] = {"abcdefg"};

	BYTE buf[SHA256_BLOCK_SIZE];

	SHA256_CTX ctx;

	sha256_init(&ctx);
	sha256_update(&ctx, text1, strlen(text1));
	sha256_final(&ctx, buf);
	for (int i = 0; i < SHA256_BLOCK_SIZE; i++)
		printf("%x:", buf[i]);
	printf("\n");	
}

int main()
{
	printf("SHA-256 tests:\n");
	sha256_test();
	return(0);
}
