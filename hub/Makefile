# *.inc.scad files are not models, the models include them. They are copied
# to target/ (models are rendered from there), and every model of the
# component depends on them. make removes the copies when it is done
# (intermediate files), so a target/ restored by the build workflow is up to
# date as long as its markers are.
INCLUDE_SCADS=$(wildcard *.inc.scad)
INCLUDE_COPIES=$(INCLUDE_SCADS:%=target/%)
MODEL_SCADS=$(filter-out $(INCLUDE_SCADS),$(wildcard *.scad))
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

# Montage: title, the "main" view, then the other views as thumbnails. The
# thumbnail tiles (380+2*10 wide) fill the 1600 width of VIEW_SIZE.
MONTAGE_TITLE_SIZE=1600x190
MONTAGE_COLUMNS=4
MONTAGE_THUMB=380x285+10+10

# Comments out every marker line, the recipes then uncomment one at a time
COMMENT_MARKERS=-e "s/{{gitrev}}/$(GITREV)/g" \
	-e "s/\(.*Make module.*\)/\/\/\1/g" \
	-e "s/\(.*Ignore module.*\)/\/\/\1/g" \
	-e "s/\(.*Make view.*\)/\/\/\1/g"

build: models views

models: $(MODEL_MARKS)

views: $(VIEW_MARKS)

target/%.inc.scad: %.inc.scad
	@mkdir -p target/
	@sed $(COMMENT_MARKERS) <$< >$@

target/%: %.scad $(INCLUDE_COPIES)
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
	elif grep "Make view" >/dev/null $<; \
	then                                  \
		echo "No models in $<, only views"; \
		$(OPENSCAD) -o target/.check_$*.echo target/$< || exit 1; \
	else                                  \
		echo "Making single module model $<"; \
		$(OPENSCAD) -o $@.stl target/$< || exit 1; \
	fi;
	@touch $@

# Views: "<statement> // Make view <name> <rx>,<ry>,<rz>" renders the
# statement to target/<file>_<name>.png, seen from that camera rotation
target/%.views: %.scad $(INCLUDE_COPIES)
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
	@if grep "Make view" >/dev/null $< && command -v montage >/dev/null; \
	then \
		echo "Making montage"; \
		views=`grep -o "Make view .*" <$< | cut -d " " -f 3`; \
		main=`echo "$$views" | head -1`; \
		if echo "$$views" | grep -x main >/dev/null; then main=main; fi; \
		set --; \
		for v in $$views; \
		do \
			[ $$v = $$main ] || set -- "$$@" -label "`echo $$v | tr _ ' '`" target/$*_$$v.png; \
		done; \
		convert -size $(MONTAGE_TITLE_SIZE) xc:"$(VIEW_BACKGROUND)" -gravity north \
			-font DejaVu-Sans-Bold -pointsize 56 -fill "#22262b" \
			-annotate +0+36 "`head -1 $< | sed 's|^// *||'`" \
			-font DejaVu-Sans -pointsize 26 -fill "#7a828c" \
			-annotate +0+116 "$(notdir $(CURDIR))/$< · $(GITREV) · `date +%Y-%m-%d`" \
			-fill "#3d7bd9" -draw "rectangle 740,166 860,170" \
			target/.title_$*.png; \
		if [ $$# -gt 0 ]; \
		then \
			montage "$$@" -tile $(MONTAGE_COLUMNS)x -geometry $(MONTAGE_THUMB) \
				-font DejaVu-Sans -pointsize 26 -fill "#4a525c" \
				-background "$(VIEW_BACKGROUND)" target/.thumbs_$*.png; \
		else \
			convert -size 1x1 xc:"$(VIEW_BACKGROUND)" target/.thumbs_$*.png; \
		fi; \
		convert target/.title_$*.png target/$*_$$main.png target/.thumbs_$*.png \
			-background "$(VIEW_BACKGROUND)" -gravity center -append \
			-bordercolor "$(VIEW_BACKGROUND)" -border 0x30 +repage -depth 8 \
			target/$*_montage.png; \
	fi
	@touch $@

clean:
	rm -rf target

.PHONY: build models views clean
