case "$1" in
"")	./build; ;;
e)	vi build; ;;
clean)	rm -r rootfs/ tools/ linux-stable/; git checkout -- tools; ;;
*)	echo Invalid option.; ;;
esac
