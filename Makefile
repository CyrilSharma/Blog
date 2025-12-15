# Directories
TYP_SRC_DIR := content/article
TYP_OUT_DIR := html
META_JSON := meta.json
META_SCRIPT := scripts/gen_meta.py

# Find all .typ sources (skip the filename with parentheses which breaks mkdir)
TYP_SRC_ALL := $(wildcard $(TYP_SRC_DIR)/*.typ)
TYP_SRC := $(filter-out $(TYP_SRC_DIR)/twotm-theories-(spoilers).typ,$(TYP_SRC_ALL))
TYP_HTML := $(patsubst $(TYP_SRC_DIR)/%.typ,$(TYP_OUT_DIR)/%/index.html,$(TYP_SRC))

.PHONY: all typst clean meta

all: typst meta

typst: $(TYP_HTML)

meta: $(META_JSON)

# Compile each .typ to a per-slug index.html
$(TYP_OUT_DIR)/%/index.html: $(TYP_SRC_DIR)/%.typ
	@mkdir -p $(dir $@)
	typst compile "$<" "$@" --format html --features html --root .

$(META_JSON): $(TYP_SRC) $(META_SCRIPT)
	@echo "Generating $@"
	python3 $(META_SCRIPT) --out $@ --root . --features html $(TYP_SRC)

# Optional: clean generated HTML
clean:
	@rm -rf $(TYP_OUT_DIR)