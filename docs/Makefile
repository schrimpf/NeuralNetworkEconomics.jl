BIB = ml.bib
RKNIT = Rscript make.R
PANDOC = pandoc --bibliography $(BIB) -f markdown -t markdown_mmd-citations --metadata link-citations=true 

vpath %.Rmd rmd

rmdin := $(filter-out %_slides.Rmd,$(wildcard rmd/*.Rmd))
rmdout := $(patsubst rmd/%.Rmd,build/%.md,$(rmdin))

build/figure : figure
	ln -s figure build/figure

rmd : $(rmdout) build/figure

$(rmdout) : build/%.md : %.Rmd
	$(RKNIT) $< $@  && \
	$(PANDOC) $@ -o $@

site/index.html: $(rmdout) mkdocs.yml
	mkdocs build

all: site/index.html

deploy: site/index.html
	mkdocs gh-deploy
