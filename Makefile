# Directories
TYP_SRC_DIR := content/article
LOCAL_SRC_DIR := local/article
TYP_OUT_DIR := html
META_JSON := meta.json
META_SCRIPT := scripts/gen_meta.py

TEMPLATE_DIR := typ/templates
TEMPLATE_SRC := $(wildcard $(TEMPLATE_DIR)/*.typ)
TEMPLATE_CFG := $(wildcard $(TEMPLATE_DIR)/*.toml)

# Sources from both dirs
TYP_SRC   := $(wildcard $(TYP_SRC_DIR)/*.typ)
LOCAL_SRC := $(wildcard $(LOCAL_SRC_DIR)/*.typ)
ALL_SRC   := $(TYP_SRC) $(LOCAL_SRC)
ALL_SRC_ESC := $(foreach f,$(ALL_SRC),'$(f)')

# Outputs (one html/<slug>/index.html per source)
TYP_HTML := \
  $(patsubst $(TYP_SRC_DIR)/%.typ,  $(TYP_OUT_DIR)/%/index.html, $(TYP_SRC)) \
  $(patsubst $(LOCAL_SRC_DIR)/%.typ, $(TYP_OUT_DIR)/%/index.html, $(LOCAL_SRC))

.PHONY: all typst clean meta

all: typst meta

typst: $(TYP_HTML)

meta: $(META_JSON)

# Generate one explicit rule per source file so multiple source dirs work correctly.
define TYP_RULE
$(TYP_OUT_DIR)/$(basename $(notdir $(1)))/index.html: $(1) $(TEMPLATE_SRC) $(TEMPLATE_CFG)
	@mkdir -p $$(dir $$@)
	typst compile '$(1)' '$$@' --format html --features html --root .
endef
$(foreach src,$(ALL_SRC),$(eval $(call TYP_RULE,$(src))))

$(META_JSON): $(ALL_SRC) $(META_SCRIPT)
	@echo "Generating $@"
	python3 $(META_SCRIPT) --out $@ --root . --features html $(ALL_SRC_ESC)

# Optional: clean generated HTML
clean:
	@rm -rf $(TYP_OUT_DIR)
