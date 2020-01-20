% Floyd_Warshall Algorithm.
function [Dist,Path] = Floyd_Warshall(Dist,Path,n)
    for k=1:n
        for i=1:n
            for j=1:n
                d1 = Dist(i,j);
                d2 = Dist(i,k)+Dist(k,j);
                if d1>d2
                    Dist(i,j) = d2;
                    Path(i,j) = Path(k,j);
                end
            end
        end
    end
end