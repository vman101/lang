# Basic configuration
TARGET := langc
AFLAGS = -felf64 -F dwarf -g

ifdef DEBUG
	AFLAGS += -DDEBUG_BUILD
endif

# Directory structure
SRCDIR := src
OBJDIR := obj
LIBDIR := lib

# Core directories
COREDIR := $(SRCDIR)/core
MATHDIR := $(COREDIR)/math
VECDIR := $(COREDIR)/vector
STRDIR := $(COREDIR)/string
SBDIR := $(COREDIR)/string_builder
PRINTDIR := $(COREDIR)/print
MEMDIR := $(COREDIR)/mem
SYSCALLDIR := $(COREDIR)/syscall
FILEDIR := $(COREDIR)/file

# Parser directories
PARSEDIR := $(SRCDIR)/parse
EXPRDIR := $(PARSEDIR)/expression
TOKDIR := $(PARSEDIR)/token

# Lexer directories
LEXDIR := $(SRCDIR)/lexer
VARDIR := $(LEXDIR)/vars

# Other directories
GLOBALDIR := $(SRCDIR)/global

# Object file directories (mirroring source structure)
OBJCOREDIR := $(OBJDIR)/core
OBJMATHDIR := $(OBJCOREDIR)/math
OBJVECDIR := $(OBJCOREDIR)/vector
OBJSTRDIR := $(OBJCOREDIR)/string
OBJSBDIR := $(OBJCOREDIR)/string_builder
OBJPRINTDIR := $(OBJCOREDIR)/print
OBJMEMDIR := $(OBJCOREDIR)/mem
OBJSYSCALLDIR := $(OBJCOREDIR)/syscall
OBJFILEDIR := $(OBJCOREDIR)/file
OBJPARSEDIR := $(OBJDIR)/parse
OBJEXPRDIR := $(OBJPARSEDIR)/expression
OBJTOKDIR := $(OBJPARSEDIR)/token
OBJLEXDIR := $(OBJDIR)/lexer
OBJVARDIR := $(OBJLEXDIR)/vars
OBJGLOBALDIR := $(OBJDIR)/global

# All object directories in dependency order
OBJDIRS := $(OBJDIR) \
           $(OBJCOREDIR) \
           $(OBJMATHDIR) \
           $(OBJVECDIR) \
           $(OBJSTRDIR) \
           $(OBJSBDIR) \
           $(OBJPRINTDIR) \
           $(OBJMEMDIR) \
           $(OBJSYSCALLDIR) \
           $(OBJFILEDIR) \
           $(OBJPARSEDIR) \
           $(OBJEXPRDIR) \
           $(OBJTOKDIR) \
           $(OBJLEXDIR) \
           $(OBJVARDIR) \
           $(OBJGLOBALDIR)

# Source file definitions by module
MATHSRC := $(addprefix $(MATHDIR)/, $(addsuffix .s, \
            operators \
            ))

STRSRC := $(addprefix $(STRDIR)/, $(addsuffix .s, \
            strlen split strcpy substr is_num strcmp is_alpha \
            ))

MEMSRC := $(addprefix $(MEMDIR)/, $(addsuffix .s, \
            malloc memchr memcpy memset \
            ))

VECSRC := $(addprefix $(VECDIR)/, $(addsuffix .s, \
			vec_create vec_push vec_get vec_pop \
            ))

PRINTSRC := $(addprefix $(PRINTDIR)/, $(addsuffix .s, \
            print putnumber \
            ))

FILESRC := $(addprefix $(FILEDIR)/, $(addsuffix .s, \
            read_file get_file_content \
            ))

SYSCALLSRC := $(addprefix $(SYSCALLDIR)/, $(addsuffix .s, \
            exit file_ops syscall_err fork\
            ))

TOKSRC := $(addprefix $(TOKDIR)/, $(addsuffix .s, \
            parse_tokens debug_token \
            ))

EXPRSRC := $(addprefix $(EXPRDIR)/, $(addsuffix .s, \
            create_expressions debug_expression \
            ))

LEXSRC := $(addprefix $(LEXDIR)/, $(addsuffix .s, \
            lexer lex_err lex_load lex_func program_prologue \
			func_boiler_plate \
            ))

VARSRC := $(addprefix $(VARDIR)/, $(addsuffix .s, \
            get_vars insert_var \
            ))

GLOBALSRC := $(addprefix $(GLOBALDIR)/, $(addsuffix .s, \
            function_table regs \
            ))

SBSRC := $(addprefix $(SBDIR)/, $(addsuffix .s, \
			string_builder sb_append \
            ))

# Collect all sources and objects
MAIN_SRC := $(SRCDIR)/start.s
ALL_SRC := $(MAIN_SRC) $(MATHSRC) $(STRSRC) $(SBSRC) $(PRINTSRC) $(FILESRC) $(VARSRC) $(SYSCALLSRC) $(MEMSRC) $(TOKSRC) $(EXPRSRC) $(LEXSRC) $(GLOBALSRC) $(VECSRC)

# Generate object file paths
ALL_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(ALL_SRC))

# Library settings
LIBNAME := $(LIBDIR)/core.a
LIB_OBJ := $(filter-out $(OBJDIR)/start.o, $(ALL_OBJ))

# Module-specific object files for staged compilation
MATH_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(MATHSRC))
STR_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(STRSRC))
MEM_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(MEMSRC))
VEC_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(VECSRC))
PRINT_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(PRINTSRC))
FILE_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(FILESRC))
SYSCALL_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(SYSCALLSRC))
TOK_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(TOKSRC))
EXPR_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(EXPRSRC))
LEX_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(LEXSRC))
VAR_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(VARSRC))
GLOBAL_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(GLOBALSRC))
SB_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(SBSRC))
MAIN_OBJ := $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(MAIN_SRC))

# Main targets
all: prepare-build build-core build-parser build-lexer build-global build-main link-executable create-library

# Stage 1: Prepare build environment
prepare-build: create-directories

create-directories: | $(OBJDIRS) $(LIBDIR)

$(OBJDIRS):
	mkdir -p $@

$(LIBDIR):
	mkdir -p $@

# Stage 2: Build core modules
build-core: build-math build-string build-memory build-vector build-print build-file build-syscall build-string-builder

build-math: $(MATH_OBJ)

build-string: $(STR_OBJ)

build-memory: $(MEM_OBJ)

build-vector: $(VEC_OBJ)

build-print: $(PRINT_OBJ)

build-file: $(FILE_OBJ)

build-syscall: $(SYSCALL_OBJ)

build-string-builder: $(SB_OBJ)

# Stage 3: Build parser modules
build-parser: build-tokens build-expressions

build-tokens: $(TOK_OBJ)

build-expressions: $(EXPR_OBJ)

# Stage 4: Build lexer modules
build-lexer: build-lex-core build-lex-vars

build-lex-core: $(LEX_OBJ)

build-lex-vars: $(VAR_OBJ)

# Stage 5: Build global modules
build-global: $(GLOBAL_OBJ)

# Stage 6: Build main entry point
build-main: $(MAIN_OBJ)

# Stage 7: Link executable
link-executable: $(TARGET)

$(TARGET): $(ALL_OBJ)
	ld -g -o $@ $(ALL_OBJ) -nostdlib -static

# Stage 8: Create library
create-library: $(LIBNAME)

$(LIBNAME): $(LIB_OBJ) | $(LIBDIR)
	ar rcs $@ $(LIB_OBJ)

# Individual file compilation rule
$(OBJDIR)/%.o: $(SRCDIR)/%.s | $(OBJDIRS)
	nasm $(AFLAGS) $< -o $@

# Utility targets
clean:
	rm -rf $(OBJDIR)

clean-library:
	rm -f $(LIBNAME)

clean-executable:
	rm -f $(TARGET)

fclean: clean clean-library clean-executable

re: fclean all

# Debug target to show what would be built
show-config:
	@echo "Target: $(TARGET)"
	@echo "Flags: $(AFLAGS)"
	@echo "Source files: $(words $(ALL_SRC)) files"
	@echo "Object files: $(words $(ALL_OBJ)) files"
	@echo "Object directories: $(OBJDIRS)"

