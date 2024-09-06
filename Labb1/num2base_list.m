function bin = num2base_list(x,n,places)
bin = reshape(str2num(char(num2cell(dec2base(x,n,places)))),1,[]);
end