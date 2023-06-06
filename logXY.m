function Z = logXY(X,Y)
  Z = log(X)./log(Y);
  Z(~isreal(Z)) = NaN;
  Z = real(Z);
end
