# ~~~~~~ DIRS & FILES ~~~~~~
OUTPUT_FILE ?= poster.pdf

TMP_DIR := tmp

ROOT_TEX_FILE_NAME := poster
ROOT_TEX_FILE_PATH := $(ROOT_TEX_FILE_NAME).tex

# ~~~~~~ COMMANDS ~~~~~~
RM_FORCE := rm -fv
LATEX_COMPILE := pdflatex
LATEX_COMPILE_OPTIONS := -halt-on-error -shell-escape -output-directory $(TMP_DIR)
BIB_COMPLIE := biber
GLOSSARIES_COMPLIE := makeglossaries

CLEAN_IGNORE_REGEX := "tmp|in|\.sty|\.tex|\.pdf|\.eps|makefile|.git|.gitignore|.vscode"


# ~~~~~~ PHONY ~~~~~~
.PHONY: clean open compile bib all
.DEFAULT_GOAL: compile

# ~~~~~~ PHONY RULES ~~~~~~
compile: $(OUTPUT_FILE) bib
bib: $(TMP_DIR)/$(ROOT_TEX_FILE_NAME).bbl

all: compile
	# @$(GLOSSARIES_COMPLIE) -d $(TMP_DIR) $(ROOT_TEX_FILE_NAME)
	@$(LATEX_COMPILE) $(LATEX_COMPILE_OPTIONS) $(ROOT_TEX_FILE_PATH)

clean:
	$(RM_FORCE) -r $(TMP_DIR)/*
	# ls -A | grep -vE $(CLEAN_IGNORE_REGEX) | xargs -rt RM_FORCE

open: $(OUTPUT_FILE)
	xdg-open $(OUTPUT_FILE)

# ~~~~~~ FILE RULES ~~~~~~
$(OUTPUT_FILE): $(TMP_DIR)/$(ROOT_TEX_FILE_NAME).pdf
	@mv $(TMP_DIR)/$(ROOT_TEX_FILE_NAME).pdf $(OUTPUT_FILE)

$(TMP_DIR)/$(ROOT_TEX_FILE_NAME).pdf: *.tex $(TMP_DIR)/$(ROOT_TEX_FILE_NAME).bcf
	@$(LATEX_COMPILE) $(LATEX_COMPILE_OPTIONS) $(ROOT_TEX_FILE_PATH)

$(TMP_DIR)/$(ROOT_TEX_FILE_NAME).bcf: library.bib
	@$(LATEX_COMPILE) $(LATEX_COMPILE_OPTIONS) $(ROOT_TEX_FILE_PATH)
	@$(BIB_COMPLIE) $(TMP_DIR)/$(ROOT_TEX_FILE_NAME)

$(TMP_DIR)/:
	@if [ ! -d $(TMP_DIR) ]; then mkdir $(TMP_DIR); fi