MODEL_SCADS=$(wildcard *.scad)
MODEL_MARKS=$(MODEL_SCADS:%.scad=target/%)
VIEW_MARKS=$(MODEL_SCADS:%.scad=target/%.views)
GITREV=$(shell git rev-parse --short HEAD)

# Views are rendered at twice the size, then trimmed, scaled down (that is
# the anti-aliasing) and centered with a margin, if ImageMagick is available
VIEW_SIZE=1600x1200
VIEW_FIT=1440x1080
VIEW_BACKGROUND=\#f8f8f8
VIEW_RENDER_SIZE=3200,2400
VIEW_OPTS=--preview --viewall --autocenter --projection=p --colorscheme=Tomorrow

# Comments out every marker line, the recipes then uncomment one at a time
COMMENT_MARKERS=-e "s/{{gitrev}}/$(GITREV)/g" \
	-e "s/\(.*Make module.*\)/\/\/\1/g" \
	-e "s/\(.*Ignore module.*\)/\/\/\1/g" \
	-e "s/\(.*Make view.*\)/\/\/\1/g"

build: models views

models: $(MODEL_MARKS)

views: $(VIEW_MARKS)

target/%: %.scad
	@mkdir -p target/
	@sed $(COMMENT_MARKERS) <$< >target/$<
	@if grep "Make module" >/dev/null $<; \
	then                                  \
		echo "Making multi module models $<"; \
		for m in `grep -o "Make module .*" <$< | cut -d " " -f 3`; \
		do \
			echo "Making sub-model $$m"; \
			sed "s/\/*\(.*\)Make module $$m *$$/\1/g" <target/$< >target/.model_$*.scad; \
			$(OPENSCAD) -o $@_$$m.stl target/.model_$*.scad || exit 1; \
		done; \
	else                                  \
		echo "Making single module model $<"; \
		$(OPENSCAD) -o $@.stl target/$< || exit 1; \
	fi;
	@touch $@

# Views: "<statement> // Make view <name> <rx>,<ry>,<rz>" renders the
# statement to target/<file>_<name>.png, seen from that camera rotation
target/%.views: %.scad
	@mkdir -p target/
	@sed $(COMMENT_MARKERS) <$< >target/.views_$*.scad
	@grep -o "Make view .*" <$< | while read make view name rotation rest; \
	do \
		echo "Making view $$name"; \
		sed "s/\/*\(.*\)Make view $$name .*$$/\1/g" <target/.views_$*.scad >target/.view_$*.scad; \
		$(OPENSCAD) $(VIEW_OPTS) --imgsize=$(VIEW_RENDER_SIZE) --camera=0,0,0,$$rotation,0 \
			-o target/$*_$$name.png target/.view_$*.scad || exit 1; \
		if command -v convert >/dev/null; \
		then \
			convert target/$*_$$name.png -trim +repage -resize $(VIEW_FIT) \
				-background "$(VIEW_BACKGROUND)" -gravity center -extent $(VIEW_SIZE) \
				target/$*_$$name.png; \
		fi; \
	done
	@touch $@

clean:
	rm -rf target

.PHONY: build models views clean
