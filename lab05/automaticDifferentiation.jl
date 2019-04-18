function tests()

ex1 = :(x*x)
print("f(x): ")
print(ex1)
print("    -> f'(x): ")
ex1 = autodiff(ex1)
println(ex1)
println();
ex1 = :(x*x+x*x*x+4*x*x*x)
print("f(x): ")
print(ex1)
print("    -> f'(x): ")
ex1 = autodiff(ex1)
println(ex1)
println();
ex1 = :(x*x+2*x+1/x)
print("f(x): ")
print(ex1)
print("    -> f'(x): ")
ex1 = autodiff(ex1)
println(ex1)
println();
ex1 = :(x*x*x*x)
print("f(x): ")
print(ex1)
print("    -> f'(x): ")
ex1 = autodiff(ex1)
println(ex1)

end


function autodiff(ex::Expr)
    iteee(split(ex))
end

function split(ex::Expr) #parses into array of single symbols or another exoresions (if 'ex' nested)
    b=[]
    for i=1:length(ex.args)
        if typeof(ex.args[i]) == Symbol || typeof(ex.args[i]) == Int64
            push!(b,ex.args[i])
        else    a = split(ex.args[i])
                push!(b,a)
        end
    end
    b
end

function iteee(b) #iterates through array, runs differentiation
    args=[]
    for elem in b
        if typeof(elem) == Symbol || typeof(elem) == Int64
            push!(args,elem)
        else
            push!(args,iteeer(elem))
        end
    end
    different(args)
end

function iteeer(b) #same as above but without calling different() -> only final expression should be evaluated
    args=[]
    for elem in b
        if typeof(elem) == Symbol || typeof(elem) == Int64
            push!(args,elem)
        else
            push!(args,iteeer(elem))
        end
    end
    args
end

function different(args) #main differentiating function
    #print("Args:")
    #println(args)
    if typeof(args[1]) == Symbol
        if args[1] == :x
            return :(1)
        end
    elseif typeof(args) == Int64
        return :(0)
    elseif args[1] == 'x'
        return :(1)
    end
    newArgs = []
    for i=1:length(args)
        if i!=2
            push!(newArgs,args[i])
        end
    end
    if length(args) == 3

        a = args[2]
        b = args[3]
        if typeof(args[2]) == Symbol
            ap = different([a])
        else
            ap = different(a)
        end
        if typeof(args[3]) == Symbol
            bp = different([b])
        else
            bp = different(b)
        end
        if args[1] == :*
            return :($bp*$a + $ap*$b)
        elseif args[1] == :+
            return :($ap + $bp)
        elseif args[1] == :-
            return :($ap - $bp)
        elseif args[1] == :/
            return :(($bp*$a - $ap*$b)/($b*$b))
        end

    elseif length(args) > 3
        a = different(newArgs)
        ar = args[2]
        if typeof(args[2]) == Symbol
            b = different([ar])
        else
            b = different(ar)
        end

        if args[1] == :*
            c = parse2Expr(newArgs)
            ans = :($a*$(args[2])+ $b*$c)
        elseif args[1] == :+
            ans = :($a+$b)
        end
    end
end


function parse2Expr(args)
    if args[1] == :*
        if length(args) == 2
            return args[2]
        else
            newArgs=[]
            for i=1:length(args)
                if i!=2
                    push!(newArgs,args[i])
                end
            end
            c = parse2Expr(newArgs)
            return :($(args[2])*$c)
        end
    end
end

#how to run example:  autodiff(:(x+x))

autodiff(:(x+x))
