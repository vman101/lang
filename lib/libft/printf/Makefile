# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: victor </var/spool/mail/victor>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/14 09:21:46 by victor            #+#    #+#              #
#    Updated: 2024/11/11 11:52:05 by marvin           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

LIBDIR := lib
NAME := $(LIBDIR)/libftprintf.a
CC := gcc
CFLAGS = -Wall -Werror -Wextra -g3
SRC := ft_fprintf.c ft_printf.c ft_putascii.c ft_puthex.c ft_putptr.c ft_strlen.c ft_putfloat.c
OBJ := $(SRC:.c=.o)

ifdef RELEASE
CFLAGS -= -g3
endif

MKDIR = mkdir
ifeq ($(OS), Windows_NT)
RM = del /Q
else
RM = rm -rf
MKDIR += -p
endif

all: $(NAME)

$(NAME): $(OBJ)
	ar rsc $@ $(OBJ)

$(OBJ): $(SRC) $(LIBDIR)
	$(CC) $(CFLAGS) -c $(SRC)

$(LIBDIR):
	$(MKDIR) $@

clean:
	$(RM) $(OBJ)

fclean: clean
	$(RM) $(LIBDIR)


re: fclean all
