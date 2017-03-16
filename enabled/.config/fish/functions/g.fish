#echo -n "example: g 'def fib.*:$' py"
function g
	if type -q ag
		ag $argv
	else if type -q ack
		ack $argv
	else
		switch (count $argv);
			case 0
				echo "usage: g pattern [file extension]"
			case 1
				grep -rn --color $argv[1]
			case 2
				find . -iname \*.$argv[2] -exec grep -n --color $argv[1] \{\} \+
			case '*'
				echo "Too many arguments, should be <3"
		end
	end
end

