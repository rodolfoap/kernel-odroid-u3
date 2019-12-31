case "$1" in
"")	./build; ;;
e)	vi build; ;;
clean)	. .k; ;;
*)	echo Invalid option.; ;;
esac
