# run as harmonicMean([<List>]...)

@generated function harmonicMean(values...)
    len = length(values)
    sum = :(0)
    for i = 1:len
      sum = :($sum + 1 / values[$i])
    end
    return :($len / $sum)
end


