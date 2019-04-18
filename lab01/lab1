a=rand(1:100,1,100)
function insertionSort(tab)
    size=length(a)
    println("Before sort:")
    for l=1:size
        print(a[l])
        print(" ")
    end
    for i = 2:size
        key=a[i];
        j=i-1;

        while j>=1 && a[j]>key
            a[j+1]=a[j];
            j=j-1;
            a[j+1]=key;

        end
    end
    println();
    println("After sort:")
    for k=1:size
        print(a[k])
        print(" ")
    end
end
insertionSort(a);
