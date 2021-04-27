using Multivectors, Combinatorics

for comb in combinations([3, 3x̂, 3x̂ŷ, 3ı̂])
    length(comb) < 2 && continue
    println(comb)
    println("+:\t", +(comb...))
    println("-:\t", -(comb...))
end