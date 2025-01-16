TOPTARGETS := all clean

SUBDIRS := $(wildcard */.)

$(TOPTARGETS): apply_patches $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGLOBALS)

update: $(SUBDIRS)

apply_patches:
	./apply-patches.sh

.PHONY: $(TOPTARGETS) $(SUBDIRS) apply_patches
