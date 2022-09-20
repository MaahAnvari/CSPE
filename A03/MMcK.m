clear all;

D = 2;
lmin = 0.1;
lmax = 10;
K =10;

lambda = lmin + (0:50)*(lmax - lmin) /50;
rho = lambda'* ones(1,8) ./ (ones(51,1)* (1:8))*D;

Pn = {};
for i=1:51
    for c=1:8
     r = rho(i,c);
     p0 = (c*r)^c/factorial(c)*(1-r^(K-c+1))/(1-r);
     for k=0:c-1
         p0 = p0 + (c*r)^k/factorial(k);
     end
     p0 = 1/p0;
     p0out(i,c) = p0;
     
     N = 0;
     U = 0;
     
     %Pn{i, c} = [p0];
     for n=0:K
         if n<c
             Pn{i, c}(1, 1+n) = p0 / factorial(n) * (c*r)^n;
         else
             Pn{i, c}(1, 1+n) = p0 * c^c * r^n / factorial(c);
         end
         N = N + n *Pn{i, c}(1, 1+n);   
          if n<c
             U = U +n * Pn{i, c}(1, 1+n);
          else 
             U = U +c * Pn{i, c}(1, 1+n);
         end
     end
     Nout(i,c) = N;
     Uout(i,c) = U/c;
     pKout(i,c) = Pn{i,c}(1,K+1);
     Xout(i,c) = (1-pKout(i,c))*lambda(1,i);
     Rout(i,c) = N / Xout(i,c);
     Thetaout(i,c) = Rout(i,c) -D;
    end
end

%plot(lambda, Nout, "-");
%plot(lambda, Uout, "-");
%plot(lambda, pKout, "-");
%plot(lambda, Xout, "-");
%plot(lambda, Rout, "-");
plot(lambda, Thetaout, "-");
legend("K=1","K=2","K=3","K=4","K=5","K=6","K=7","K=8")