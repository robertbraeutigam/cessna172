MODEL_SCADS=$(wildcard *.scad)
MODEL_MARKS=$(MODEL_SCADS:%.scad=target/%)
GITREV=$(shell git rev-parse --short HEAD)

build: $(MODEL_MARKS)

target/%: %.scad
	@mkdir -p target/
	@sed "s/{{gitrev}}/$(GITREV)/g" <$< >target/$<
	@if grep "Make module" >/dev/null $<; \
	then                                  \
		echo "Making multi module models $<"; \
		sed -i -e "s/\(.*Make module.*\)/\/\/\1/g" -e "s/\(.*Ignore module.*\)/\/\/\1/g" target/$<; \
		for m in `grep -o "Make module .*" <$< | cut -d " " -f 3`; \
		do \
			echo "Making sub-model $$m"; \
			sed "s/\/*\(.*\)Make module $$m *$$/\1/g" <target/$< >target/.model.scad; \
			$(OPENSCAD) -o $@_$$m.stl target/.model.scad;   \
		done; \
	else                                  \
		echo "Making single module model $<"; \
		$(OPENSCAD) -o $@.stl target/$<;   \
	fi;
	@touch $@

clean:
	rm -rf target


