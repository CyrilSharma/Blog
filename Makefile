# Directories
TYP_SRC_DIR := content/article
TYP_OUT_DIR := html

# Find all .typ sources (skip the filename with parentheses which breaks mkdir)
TYP_SRC_ALL := $(wildcard $(TYP_SRC_DIR)/*.typ)
TYP_SRC := $(filter-out $(TYP_SRC_DIR)/twotm-theories-(spoilers).typ,$(TYP_SRC_ALL))
TYP_HTML := $(patsubst $(TYP_SRC_DIR)/%.typ,$(TYP_OUT_DIR)/%/index.html,$(TYP_SRC))

.PHONY: all typst clean

all: typst

typst: $(TYP_HTML)

# Compile each .typ to a per-slug index.html
$(TYP_OUT_DIR)/%/index.html: $(TYP_SRC_DIR)/%.typ
	@mkdir -p $(dir $@)
	typst compile "$<" "$@" --format html --features html --root .

# Optional: clean generated HTML
clean:
	@rm -rf $(TYP_OUT_DIR)