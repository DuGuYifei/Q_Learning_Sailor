% DO NOT CHANGE ANYTHING IN THIS FILE!

% rysowanie mapy nagrod z biezaca strategia (przedstawiona za pomoca
% strzalek) oraz stanu (na czerwono)

function a=rysuj_akwen(tablica,Q,stan)

wym = size(tablica);

mac_ramki = zeros(21,21);
mac_ramki(:,[1 21]) = 1;
mac_ramki([1 21],:) = 1;

mac_kier = mac_ramki;
mac_kier(11,8:18) = 1;           % 1 jest indeksem specjalnym (strzalki + granice)
mac_kier([10 12],17) = 1;
mac_kier([9 13],16) = 1;
mac_kier([8 14],15) = 1;



akwen = zeros([wym*21]);

% zamiana wartosci nagrod na indeksy kolorow (1 zarezerwowany dla kol. czarnego)
tab_ind = (tablica == -10)*3 + (tablica == -5)*4 + (tablica == -1)*5 + (tablica == 0)*6 + (tablica == 5)*7 + (tablica >= 10)*8; 
colormap([0 0 0; 1 0 0; 0 0 0.4; 0 0.1 0.7; 0.2 0.3 0.9; 0.4 0.6 1; 0 0.7 0; 0.6 0.6 0]);  %  kolory (RGB) dla kazdego indeksu
for i=1:wym(1) % po kolumnach
    for j=1:wym(2) % po wierszach
        if j<wym(2)
            [v, ind_max] = max(Q(i,j,:)); 
            nadruk = mac_kier*(ind_max==1)+ ...
                rot90(mac_kier)*(ind_max==2)+ fliplr(mac_kier)*(ind_max==3)+flipud(rot90(mac_kier))*(ind_max==4);
        else
            nadruk = mac_ramki;  % sama ramka, gdy pole niedecyzyjne
        end
        if nargin==3 
            if sum(abs(stan - [i j]))==0
                nadruk = nadruk*2;
            end
        end
        
        akwen(21*(i-1)+1:21*i,21*(j-1)+1:21*j) = tab_ind(i,j)*((nadruk~=1)&(nadruk~=2)) + nadruk;
    end
end

%akwen = ceil(5*rand(size(akwen)))
delete(gca);
axes('position',[0.1,0.1,min(0.8,wym(2)/wym(1)),min(0.8,wym(1)/wym(2))])
tytul = sprintf('œr. u¿ytecznoœæ strategii = %f',mean(max(Q(:,1,:),[],3)));
fig=image(akwen);
title(tytul);
%axis([0 35 0 35]);