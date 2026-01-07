# Directories
TYP_SRC_DIR := content/article
TYP_OUT_DIR := html
META_JSON := meta.json
META_SCRIPT := scripts/gen_meta.py

# Find all .typ sources
TEMPLATE_DIR := typ/templates
TEMPLATE_SRC := $(wildcard $(TEMPLATE_DIR)/*.typ)
TEMPLATE_CFG := $(wildcard $(TEMPLATE_DIR)/*.toml)
TYP_SRC := $(wildcard $(TYP_SRC_DIR)/*.typ)
# Quote each source for safe shell passing (handles parentheses/whitespace)
TYP_SRC_ESC := $(foreach f,$(TYP_SRC),'$(f)')
TYP_HTML := $(patsubst $(TYP_SRC_DIR)/%.typ,$(TYP_OUT_DIR)/%/index.html,$(TYP_SRC))

.PHONY: all typst clean meta watch

all: typst meta

typst: $(TYP_HTML)

meta: $(META_JSON)

watch:
	@echo "Watching Typst sources and regenerating HTML/meta..."
	@find $(TYP_SRC_DIR) $(TYP_OUT_DIR) -type f \( -name '*.typ' -o -name 'index.html' \) | entr -d sh -c 'python3 $(META_SCRIPT) --out $(META_JSON) --root . --features html --html-dir $(TYP_OUT_DIR) $(TYP_SRC_ESC)' &
	@for src in $(TYP_SRC); do \
	  slug=$$(basename $$src .typ); \
	  out="$(TYP_OUT_DIR)/$$slug/index.html"; \
	  mkdir -p "$(TYP_OUT_DIR)/$$slug"; \
	  echo "Watching $$src -> $$out"; \
	  typst watch "$$src" "$$out" --format html --features html --root . & \
	done; \
	wait

# Compile each .typ to a per-slug index.html
$(TYP_OUT_DIR)/%/index.html: $(TYP_SRC_DIR)/%.typ $(TEMPLATE_SRC) $(TEMPLATE_CFG)
	@mkdir -p $(TYP_OUT_DIR)/'$*'/
	typst compile '$<' '$@' --format html --features html --root .

$(META_JSON): $(TYP_SRC) $(META_SCRIPT)
	@echo "Generating $@"
	python3 $(META_SCRIPT) --out $@ --root . --features html $(TYP_SRC_ESC)

# Optional: clean generated HTML
clean:
	@rm -rf $(TYP_OUT_DIR)