function [epe] = epe_distribution(p_in, num_higher_p)

% This function determine the e*pe connection for a number of p cells/modules
% connected in parallel. The connection is chosen in such a way that the
% cells/modules form a uniform rectangle with no gaps.

% Example for p=6:
% e*pe = 1*6 or 2*3

% Check if p is a prime number. If so no suitable distributions will be
% found. In this case also consider p+1. We don't iterate higher here
% because we don't want to oversize the battery system.

% Do the same if there is a set num_higher_p --> more distributions will
% be found

if or(isprime(p_in), num_higher_p)
    if num_higher_p == 0    % p_in is prime and num_higher_p is 0 --> Try p_in+1
        num_higher_p = 1;
    end
    
    p_in_vec = [p_in, nan(1, num_higher_p)]; % Array with all p_in
    
    for ii = 2:1:(1 + num_higher_p)
        p_in_vec(ii) = p_in_vec(1)+ (ii-1);
    end
    
    p_in = p_in_vec;
end

% Preallocate epe-structure

epe = struct('p', cell(1,length(p_in)), ...
             'pe', cell(1,length(p_in)),  ...
             'e', cell(1,length(p_in)));  

% Write possible p-e-pe configurations in structure
         
for ii = 1:1:length(p_in)
    divisors_p = divisors(p_in(ii));
    epe(ii).p  = p_in(ii);
    epe(ii).pe = flip(divisors_p);
    epe(ii).e  = divisors_p;
end
