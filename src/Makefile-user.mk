# Custom settings for the compilation

# [Features]
ENABLE_OTA ?= 1

# [Tests And Debugging]
DEBUG ?= 1

TEST ?= 1

# Buzz on start/wake-up
TEST_BUZZ ?= 0 

# Blink on start/wake-up
TEST_BLINK ?= 0

# Test Automatic OTA
TEST_AUTO_OTA ?= 0

ASM_FLAGS=-DTEST_BUZZ=$(TEST_BUZZ) -DTEST_BLINK=$(TEST_BLINK) -DTEST_AUTO_OTA=$(TEST_AUTO_OTA)

ifeq ($(ENABLE_OTA), 1)
	ASM_FLAGS += -DENABLE_OTA=1
endif

ifeq ($(DEBUG), 1)
	ASM_FLAGS += -DDEBUG=1
endif

ifeq ($(TEST), 1)
	ASM_FLAGS += -DTEST=1
endif