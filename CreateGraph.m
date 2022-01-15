function [n,L,Dist,Path] = CreateGraph(Nb,Na,Ns,kx,ky)

    % L -> Length of a Single Aisle.
	L = Ns*Nb + Nb + 1;
	% n ->  Number of Nodes.
	n = L*Na;
	% b -> Cross Aisle Node Location.
	b = Ns + 1;

	% Distance Matrix Initialize by Infinity.
	Dist = inf*ones(n);
	% Predecessors Matrix Initialize by -1.
	Path = -1*ones(n);
    
    for i=1:n
        Dist(i,i) = 0;
        if mod(i,L)~=0
            Dist(i,i+1) = ky;
            Path(i,i+1) = i;
        end
    end
% 
% 	for i=1:n
% 		if (i+1)%L!=0:
% 			Dist[i][i+1] = ky
% 			Path[i][i+1] = i

    for i=1:(Nb+1)
        for j=1:(Na-1)
            i1 = (i-1)*b+(j-1)*L;
            j1 = (i-1)*b+(j)*L;
            Dist(i1+1,j1+1) = kx;
            Path(i1+1,j1+1) = i1+1;
        end
    end

    for i=1:n
        for j=1:i
            Dist(i,j) = Dist(j,i);
            if Path(j,i)~=-1
                Path(i,j) = i;
            end
        end
    end
end