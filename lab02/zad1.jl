function inheritanceGraph(typ)
    if typ == Any
        typ|>print
    else
        inheritanceGraph(supertype(typ))
        print(" -> ")
        typ|>print

    end
end

inheritanceGraph(Int64)
