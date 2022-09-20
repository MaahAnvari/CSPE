clear all;

v = [4, 0.4, 1;	0.4, 0.4, 0.25; 6, 15, 5];
S = [0.066666667, 10, 1; 0.166666667, 10, 3; 0.052777778, 20, 3];

D = v .* S;
Lambda_A = 3;
Z_BC = [10, 5];
N_B = 20;
N_C = 10;

U_kA = D(:,1) * Lambda_A; 
% extract the first col of matrix D and the multiply by Lambda
Dp = D(:, 2:3) ./ (1 - U_kA);
% extract last two column of D

N_kc = {[0,0;0,0;0,0]}; 
N_k = {[0;0;0]} 
R_kc = {[0,0;0,0;0,0]};
R_c ={[0,0]};
X_c = {[0,0]};

for N = 1:(N_B + N_C)
    for n_B = 0:N      % total number of B = n_B
        n_C = N - n_B;
        if(n_B <= N_B) && (n_C <= N_C) && (n_B >= 1) && (n_C >= 1)
            %[n_B, n_C]  
            R_kc{n_B+1, n_C+1} = Dp .* (1+ [N_k{n_B, n_C+1}, N_k{n_B+1, n_C}]);
            R_c{n_B+1, n_C+1} = R_kc{n_B+1, n_C+1}(1,:) + R_kc{n_B+1, n_C+1}(2,:) + R_kc{n_B+1, n_C+1}(3,:);
            X_c{n_B+1, n_C+1} = [n_B, n_C] ./ ( R_c{n_B+1, n_C+1} + Z_BC);
            N_kc{n_B+1, n_C+1} = R_kc{n_B+1, n_C+1} .* X_c{n_B+1, n_C+1};
            N_k{n_B+1, n_C+1} = N_kc{n_B+1, n_C+1}(:,1) + N_kc{n_B+1, n_C+1}(:,2);
        elseif(n_B == 0) && (n_C <= N_C)
            R_kc{n_B+1, n_C+1} = Dp .* [0, 1+ N_k{n_B+1, n_C}(1,1)];
            R_c{n_B+1, n_C+1} = R_kc{n_B+1, n_C+1}(1,:) + R_kc{n_B+1, n_C+1}(2,:) + R_kc{n_B+1, n_C+1}(3,:);
            X_c{n_B+1, n_C+1} = [n_B, n_C] ./ ( R_c{n_B+1, n_C+1} + Z_BC);
            N_kc{n_B+1, n_C+1} = R_kc{n_B+1, n_C+1} .* X_c{n_B+1, n_C+1};
            N_k{n_B+1, n_C+1} = N_kc{n_B+1, n_C+1}(:,1) + N_kc{n_B+1, n_C+1}(:,2);
        elseif(n_C == 0) && (n_B <= N_B)
            R_kc{n_B+1, n_C+1} = Dp .* [1+ N_k{n_B, n_C+1}(1,1), 0];
            R_c{n_B+1, n_C+1} = R_kc{n_B+1, n_C+1}(1,:) + R_kc{n_B+1, n_C+1}(2,:) + R_kc{n_B+1, n_C+1}(3,:);
            X_c{n_B+1, n_C+1} = [n_B, n_C] ./ ( R_c{n_B+1, n_C+1} + Z_BC);
            N_kc{n_B+1, n_C+1} = R_kc{n_B+1, n_C+1} .* X_c{n_B+1, n_C+1};
            N_k{n_B+1, n_C+1} = N_kc{n_B+1, n_C+1}(:,1) + N_kc{n_B+1, n_C+1}(:,2);
        end
    end
end
%Utilization Close Class
U_kBC = D(:, 2:3) .* X_c{N_B+1, N_C+1}; 
%Utilization of each class
U_kc = [U_kA, U_kBC];
%Utilization of Rows
U_k = sum(U_kc')';

%Throughput of all classes
X_c = [Lambda_A,X_c{N_B+1, N_C+1}];
%Throughput per resourse
X_kc = X_c .*v;           % X*visits
%Thoughput for each class
X_k = sum(X_kc')';
%system throughput
X = sum(X_c);

% Residence time for A
R_kA = D(:,1) .* (1 + N_k{N_B+1, N_C+1})
%System responce time per class
R__kc = [R_kA, R_kc{N_B+1, N_C+1}];
%Residence time per resource
R__c = sum(R__kc);

R__k = sum((X_c ./ X .* R__kc)')';
%System residence time
R = sum(R__k);

%Average Responce time
Phi_kc = R__kc ./ v;
%Average Responce time for station
Phi_k = sum((X_kc ./ X_k .* Phi_kc)')';

%Average Number of Jobs
N__kc = R__kc .* X_c;
%Jobs in Class(Column)
N__k = sum(N__kc);
%Jobs in resource (row)
N__c = sum(N__kc);
%Number of jobs in the system
N = sum(N__k);

%Average Queue size
Q_kc = N__kc - U_kc;

Q_k = N__k - U_k; 
%Average time spent in the queue
O_kc = Phi_kc - S;
