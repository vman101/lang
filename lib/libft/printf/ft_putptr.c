/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putptr.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: vvobis <marvin@42.fr>                      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/04/18 17:53:53 by vvobis            #+#    #+#             */
/*   Updated: 2025/05/14 17:13:56 by vvobis           ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "ft_printf.h"

void	ft_putptr(void *ptr, int *count, int fd)
{
	void	**to_print;

	if (!ptr)
	{
		ft_putstr("(nil)", count, fd);
		return ;
	}
	to_print = &ptr;
	*count += write(fd, "0x", 2);
	ft_puthex_lower((unsigned long long)*to_print, count, fd);
}
