SRCDIR := src
COREDIR := $(SRCDIR)/core
MATHDIR := $(COREDIR)/math
STRDIR := $(COREDIR)/string
PRINTDIR := $(COREDIR)/print
MEMDIR := $(COREDIR)/mem
SYSCALLDIR := $(COREDIR)/syscall
FILEDIR := $(COREDIR)/file
PARSEDIR := $(SRCDIR)/parse
VARDIR := $(PARSEDIR)/vars

# Define source files
MATHSRC := $(addprefix $(MATHDIR)/, $(addsuffix .s, \
            operators \
            ))
STRSRC := $(addprefix $(STRDIR)/, $(addsuffix .s, \
            strlen split strcpy substr is_num strcmp is_alpha \
            ))
MEMSRC := $(addprefix $(MEMDIR)/, $(addsuffix .s, \
            malloc memchr \
            ))
PRINTSRC := $(addprefix $(PRINTDIR)/, $(addsuffix .s, \
            print putnumber \
            ))
FILESRC := $(addprefix $(FILEDIR)/, $(addsuffix .s, \
            read_file get_file_content \
            ))
SYSCALLSRC := $(addprefix $(SYSCALLDIR)/, $(addsuffix .s, \
            exit file_ops syscall_err\
            ))
PARSESRC := $(addprefix $(PARSEDIR)/, $(addsuffix .s, \
            parse debug_token create_expressions debug_expression \
			lexer lex_load lex_err \
            ))

VARSRC := $(addprefix $(VARDIR)/, $(addsuffix .s, \
			get_vars insert_var \
            ))

# Collect all source files - now using the file variables, not directory variables
SRC := $(SRCDIR)/start.s $(MATHSRC) $(STRSRC) $(PRINTSRC) $(FILESRC) $(VARSRC) $(PARSESRC) $(SYSCALLSRC) $(MEMSRC)

OBJDIR := obj
OBJ := $(patsubst %.s,$(OBJDIR)/%.o,$(notdir $(SRC)))

all: debug

debug: $(OBJDIR) $(OBJ)
	ld -o $@ $(OBJ) -nostdlib -static

# Pattern rules for object files - added the missing rules for string and print
$(OBJDIR)/%.o: $(SRCDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR)/%.o: $(MATHDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR)/%.o: $(STRDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR)/%.o: $(MEMDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR)/%.o: $(SYSCALLDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR)/%.o: $(PRINTDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR)/%.o: $(FILEDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR)/%.o: $(PARSEDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR)/%.o: $(VARDIR)/%.s
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR): 
	mkdir -p $@

clean:
	rm -rf $(OBJDIR) debug

re: clean all

.PHONY: all clean re
