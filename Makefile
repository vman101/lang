SRCDIR := src
COREDIR := $(SRCDIR)/core
MATHDIR := $(COREDIR)/math
VECDIR := $(COREDIR)/vector
STRDIR := $(COREDIR)/string
PRINTDIR := $(COREDIR)/print
MEMDIR := $(COREDIR)/mem
SYSCALLDIR := $(COREDIR)/syscall
FILEDIR := $(COREDIR)/file
PARSEDIR := $(SRCDIR)/parse
EXPRDIR := $(PARSEDIR)/expression
TOKDIR := $(PARSEDIR)/token
LEXDIR := $(SRCDIR)/lexer
VARDIR := $(LEXDIR)/vars
GLOBALDIR := $(SRCDIR)/global

# Define source files
MATHSRC := $(addprefix $(MATHDIR)/, $(addsuffix .s, \
            operators \
            ))
STRSRC := $(addprefix $(STRDIR)/, $(addsuffix .s, \
            strlen split strcpy substr is_num strcmp is_alpha \
            ))
MEMSRC := $(addprefix $(MEMDIR)/, $(addsuffix .s, \
            malloc memchr memcpy \
            ))
VECSRC := $(addprefix $(VECDIR)/, $(addsuffix .s, \
			vec_create vec_push vec_get\
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
TOKSRC := $(addprefix $(TOKDIR)/, $(addsuffix .s, \
            parse_tokens debug_token \
            ))
EXPRSRC := $(addprefix $(EXPRDIR)/, $(addsuffix .s, \
            create_expressions debug_expression \
            ))
LEXSRC := $(addprefix $(LEXDIR)/, $(addsuffix .s, \
            lexer lex_err lex_load lex_func \
            ))
VARSRC := $(addprefix $(VARDIR)/, $(addsuffix .s, \
            get_vars insert_var \
            ))
GLOBALSRC := $(addprefix $(GLOBALDIR)/, $(addsuffix .s, \
            function_table regs \
            ))

# Collect all source files
SRC := $(SRCDIR)/start.s $(MATHSRC) $(STRSRC) $(PRINTSRC) $(FILESRC) $(VARSRC) $(SYSCALLSRC) $(MEMSRC) $(TOKSRC) $(EXPRSRC) $(LEXSRC) $(GLOBALSRC) $(VECSRC)

# Fix: Preserve directory structure in object files
OBJDIR := obj
OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(SRC))

all: debug

# Create output directories
$(OBJDIR)/core/math $(OBJDIR)/core/string $(OBJDIR)/core/print $(OBJDIR)/core/mem $(OBJDIR)/core/syscall $(OBJDIR)/core/file $(OBJDIR)/parse/expression $(OBJDIR)/parse/token $(OBJDIR)/lexer $(OBJDIR)/lexer/vars $(OBJDIR)/global:
	mkdir -p $@

# Main target
debug: $(OBJDIR) $(OBJDIR)/core/math $(OBJDIR)/core/string $(OBJDIR)/core/print $(OBJDIR)/core/mem $(OBJDIR)/core/syscall $(OBJDIR)/core/file $(OBJDIR)/parse/expression $(OBJDIR)/parse/token $(OBJDIR)/lexer $(OBJDIR)/lexer/vars $(OBJDIR)/global $(OBJ)
	ld -g -o $@ $(OBJ) -nostdlib -static

# Fix: Use a more specific pattern rule that preserves paths
$(OBJDIR)/%.o: $(SRCDIR)/%.s
	mkdir -p $(dir $@)
	nasm -felf64 -F dwarf -g $< -o $@

$(OBJDIR):
	mkdir -p $@

clean:
	rm -rf $(OBJDIR) debug

re: clean all

.PHONY: all clean re
