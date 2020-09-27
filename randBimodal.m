function variable = randBimodal(Distribution,N)
    mu1 = Distribution(1); 
    sigma1 = Distribution(2);
    mu2 = Distribution(3);
    sigma2 = Distribution(4);
    r = Distribution(5);
    lowerboundary= Distribution(6);
    upperboundary = Distribution(7);
    variable = -inf * ones(N,1);
    for count = 1:N
        while variable(count) < lowerboundary || variable(count) > upperboundary
            x = rand;
            variable(count)=(mu2+sigma2*randn)*heaviside(x-r)+(mu1+sigma1*randn)*heaviside(r-x);
        end
    end
end