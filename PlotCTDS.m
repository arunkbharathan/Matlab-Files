function []= PlotCTDS(S,T,Y)

for n=1:length(S)
ezplot(S(n),[T(n) T(n+1)]);hold on
Y1(n)=subs(S(n),T(n));
Y2(n)=subs(S(n),T(n+1));;
%S(n),[T(n) T(n+1)]
end
if length(Y)<2
Y(2)=max(double(Y2));
Y(1)=min(min(double(Y1)));
end
axis([T(1) T(end) Y(1) Y(2)])
end
