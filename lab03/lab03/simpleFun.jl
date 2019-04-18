function function1()
    for  i = 1:100000
        string("Test1")
    end
end

function function2()
    for  i = 1:10000
        string("Test2")
    end
end

function prog()
    for j = 1:500
        function1()
        function2()
    end    
end

prog()
