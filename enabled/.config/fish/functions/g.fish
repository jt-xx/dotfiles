function g
    if type -fq ag
        command ag $argv
    else if type -fq ack
        command ack $argv
    else
        switch (count $argv);
            case 0
                echo "usage: g pattern [file extension]"
                echo
                echo "example: g 'def fib.*:\$' py"
            case 1
                grep -rn --color $argv[1]
            case 2
                find . -iname \*.$argv[2] -exec grep -n --color $argv[1] \{\} \+
            case '*'
                echo "Too many arguments, should be <3"
        end
    end
end

