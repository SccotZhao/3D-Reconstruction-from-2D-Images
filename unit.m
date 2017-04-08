function u = unit(v)

n = norm(v);
if v == 0
    error('Computing unit vector for a zero input');
else
    u = v / n;
end