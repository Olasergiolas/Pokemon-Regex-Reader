CC = g++
CFLAGS = -Wall
TARGET = pokemonRegexReader
FLEXTEMPLATE = pokemonRegexReader.l
FLEXFILE = lex.yy.cc
FLEX = flex++
INPUT = input

all: $(TARGET)
	./$(TARGET) $(INPUT)

$(TARGET): $(FLEXFILE) pokemonAscii.h
	$(CC) $(CFLAGS) $(FLEXFILE) -o $(TARGET)

$(FLEXFILE): $(FLEXTEMPLATE)
	$(FLEX) $(FLEXTEMPLATE)

clean:
	rm $(TARGET) $(FLEXFILE)