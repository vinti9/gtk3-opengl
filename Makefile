CFLAGS  += -std=c99
LDFLAGS += -lm -lGL -lGLEW

CFLAGS_GTK  := $(shell pkg-config --cflags gtk+-3.0)
LDFLAGS_GTK := $(shell pkg-config --libs   gtk+-3.0)

PROG = gtk3-opengl
OBJS = $(patsubst %.c,%.o,$(wildcard *.c))
SHADERS = $(patsubst %.glsl,%.o,$(wildcard shaders/*/*.glsl))
TEXTURES = $(patsubst %.svg,%.o,$(wildcard textures/*.svg))

.PHONY: clean

$(PROG): $(OBJS) $(SHADERS) $(TEXTURES)
	$(CC) -o $@ $^ $(LDFLAGS) $(LDFLAGS_GTK)

$(SHADERS): %.o: %.glsl
	$(LD) --relocatable --format=binary -o $@ $^

textures/%.png: textures/%.svg
	rsvg-convert --format png --output $@ $^

textures/%.o: textures/%.png
	$(LD) --relocatable --format=binary -o $@ $^

%.o: %.c
	$(CC) -o $@ $(CFLAGS) $(CFLAGS_GTK) -c $^

clean:
	rm -f $(PROG) $(OBJS) $(SHADERS) $(TEXTURES)
