#include <string.h>
#include <unistd.h>
#include "../libft/libft.h"

int main(int argc, char **argv) {
    ft_split(argv[1], *argv[2]);
    for (int i = 0; i < 2; i++)
    {
        write(1, argv[i + 1], strlen(argv[i + 1]));
    }
}
