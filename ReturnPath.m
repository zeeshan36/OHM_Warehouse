function l = ReturnPath(Path,i,j)

	l = int16.empty(1,0);
	l=[l j];
    while i~=j
        j = Path(i,j);
        l=[l j];
    end
    l=fliplr(l);
end