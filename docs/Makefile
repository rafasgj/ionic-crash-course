SOURCES := $(wildcard *.key)

KEYNOTES := $(subst key,pdf,$(SOURCES))

PYTHON=python3

%.pdf: %.key
	@$(PYTHON) -m keynotec $^

all: $(KEYNOTES)

clean:
	$(RM) *.pdf *.tex

PHONY: all clean

