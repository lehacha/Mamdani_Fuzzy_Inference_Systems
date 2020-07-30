clc; 
close all; 

fname='mamdani';
x=[0.2 0.8];
Na=2;
a0=0; 
an=1;
Nb=2;  
b0=0; 
bn=1;  
da = (an-a0)/(Na-1);
db = (bn-b0)/(Nb-1);
A=a0:da:an;
B=b0:db:bn;
y=[1 0 0 1]; 
Ny=2;
y0=min(min(y));
yn=max(max(y));
dy=(yn-y0)/(Ny-1);
Y=y; y=y(:); y=sort(y);
 
ai=newfis('mamdani','mamdani','prod','max','prod','max','centroid');
 
%для змінної а
ai=addvar(ai,'input','a',[a0 an]);
for i=1:Na
    if i==1; 
        a=a0-da; 
    else
        a=A(i-1);
    end
    b=A(i);
    if i==Na; 
        c=an+da; 
    else
        c=A(i+1);
    end
        ai=addmf(ai,'input',1,['a',int2str(i)],'trimf', [a b c]);    
end
 
%для змінної b
ai=addvar(ai,'input','b',[b0 bn]);
for i=1:Nb
    if i==1; 
        a=b0-db; 
    else
        a=B(i-1);
    end
    b=B(i);
    if i==Nb; 
        c=bn+db; 
    else
        c=B(i+1);
    end
        ai=addmf(ai,'input',2,['b',int2str(i)],'trimf', [a b c]);    
end
 
 
ai=addvar(ai,'output','y',[y0 yn]);
for i=1:Ny
    if i==1; 
        a=y0-dy; 
    else
        a=y(i-1);
    end
    b=y(i);
    if i==Ny; 
        c=yn+dy; 
    else
        c=y(i+1);
    end
        ai=addmf(ai,'output',1,['y',int2str(i)],'trimf', [a b c]);    
end
 
% Збереження системи нечіткого виведення у файлі 
% поточного каталогу
 %writefis(ai, fname);
 
 %база правил
rullist=ones(4,5); s=0;
rullist(2,:)=[1 1 2 1 1];
rullist(3,:)=[1 2 1 1 1];
rullist(4,:)=[2 2 2 1 1];
 ai=addrule(ai,rullist);
 
ai=setfis(ai,'defuzzmethod', 'centroid');
fuzzy(ai)
 
ai = setfis(ai,'defuzzmethod', 'centroid');
out=evalfis(x, ai);
%сума по модулю
eps=sum(abs(out-x)); 
%вивід значень
out
eps
rullist

