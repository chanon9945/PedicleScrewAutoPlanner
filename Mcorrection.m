function Acm = Mcorrection(M)
    Acm = M*(inv(M'*M).^0.5);
end