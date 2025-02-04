function MCmean = MCmean(function_out,num)
    sum = 0;
    for i = 1:num
        sum = sum + function_out(:,:,i);
    end
    MCmean = sum/num;
end