TOPTARGETS := all clean

SUBDIRS := $(wildcard */.)

#$(TOPTARGETS): apply_patches $(SUBDIRS)
$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGLOBALS)

update: $(SUBDIRS)

apply_patches:
	./prepare-build.sh

.PHONY: $(TOPTARGETS) $(SUBDIRS) apply_patches
