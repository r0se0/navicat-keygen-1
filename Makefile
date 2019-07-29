CC = g++
OPENSSL_INCLUDE_PATH = /usr/local/opt/openssl/include
OPENSSL_LIB_PATH = /usr/local/opt/openssl/lib

OUTPUT_DIR = ./bin/
COMMON_DIR = ./common/
PATCHER_DIR = ./navicat-patcher/
KEYGEN_DIR = ./navicat-keygen/

COMMON_HEADER = \
$(COMMON_DIR)Exception.hpp \
$(COMMON_DIR)ExceptionOpenssl.hpp \
$(COMMON_DIR)ExceptionSystem.hpp \
$(COMMON_DIR)ResourceOwned.hpp \
$(COMMON_DIR)ResourceTraitsOpenssl.hpp \
$(COMMON_DIR)RSACipher.hpp \

PATCHER_HEADER = \
$(PATCHER_DIR)ExceptionCapstone.hpp \
$(PATCHER_DIR)ExceptionKeystone.hpp \
$(PATCHER_DIR)ResourceTraitsCapstone.hpp \
$(PATCHER_DIR)ResourceTraitsKeystone.hpp \
$(PATCHER_DIR)ResourceTraitsUnix.hpp \
$(PATCHER_DIR)CapstoneDisassembler.hpp \
$(PATCHER_DIR)KeystoneAssembler.hpp \
$(PATCHER_DIR)X64ImageInterpreter.hpp \
$(PATCHER_DIR)PatchSolutions.hpp

PATCHER_SOURCE = \
$(PATCHER_DIR)CapstoneDisassembler.cpp \
$(PATCHER_DIR)KeystoneAssembler.cpp \
$(PATCHER_DIR)X64ImageInterpreter.cpp \
$(PATCHER_DIR)HelperIsResolvedTo.cpp \
$(PATCHER_DIR)HelperPrintMemory.cpp \
$(PATCHER_DIR)PatchSolution0.cpp \
$(PATCHER_DIR)PatchSolution1.cpp \
$(PATCHER_DIR)PatchSolution2.cpp \
$(PATCHER_DIR)main.cpp

PATCHER_BINARY = $(OUTPUT_DIR)navicat-patcher

KEYGEN_HEADER = \
$(KEYGEN_DIR)DESCipher.hpp \
$(KEYGEN_DIR)NavicatKeygen.hpp

KEYGEN_SOURCE = \
$(KEYGEN_DIR)Base64.cpp \
$(KEYGEN_DIR)main.cpp

KEYGEN_BINARY = $(OUTPUT_DIR)navicat-keygen

patcher: $(PATCHER_HEADER) $(PATCHER_SOURCE)
	@if [ ! -d $(OUTPUT_DIR) ]; then mkdir -p $(OUTPUT_DIR); fi
	$(CC) -std=c++17 -O2 -I$(OPENSSL_INCLUDE_PATH) -L$(OPENSSL_LIB_PATH) -lcrypto -lcapstone -lkeystone -lplist++ $(PATCHER_SOURCE) -o $(PATCHER_BINARY)

keygen: $(KEYGEM_HEADER) $(KEYGEN_SOURCE)
	@if [ ! -d $(OUTPUT_DIR) ]; then mkdir -p $(OUTPUT_DIR); fi
	$(CC) -std=c++17 -O2 -I$(OPENSSL_INCLUDE_PATH) -L$(OPENSSL_LIB_PATH) -lcrypto $(KEYGEN_SOURCE) -o $(KEYGEN_BINARY)

all: patcher keygen
	@echo 'Done.'

.PHONY: all

clean:
ifeq ($(wildcard $(PATCHER_BINARY)), $(PATCHER_BINARY))
	rm $(PATCHER_BINARY)
endif

ifeq ($(wildcard $(KEYGEN_BINARY)), $(KEYGEN_BINARY))
	rm $(KEYGEN_BINARY)
endif

