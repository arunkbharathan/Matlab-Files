%***************************************************************

% This program evaluates the polynomial y=x^4 + 2x^3 - x^2 + 4x - 5  at  x=5, 6

%***************************************************************

function y=PolyValue(poly,x)

poly=[1 2 -1 4 -5];

x=[5, 6];

y=polyval(poly, x)