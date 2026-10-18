type gauss = {re: int; im: int}

let g_add gauss1 gauss2 = {re = gauss1.re + gauss2.re; im = gauss1.im + gauss2.im}

let g_mul g1 g2 = {re = g1.re * g2.re - g1.im * g2.im; im = g1.re * g2.im + g2.re * g2.im}