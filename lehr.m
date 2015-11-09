function [nGroup] = lehr(x, percent, std);

shift = x * percent;
x2 = x-shift;
diff = x-x2;
denom = diff/std;
dsq = denom^2;

nGroup = 16/dsq