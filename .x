case "$1" in
"")	./build; ;;
e)	vi build; ;;
clean)	rm -rf rootfs/ tools/ linux-stable/; git checkout -- tools; ;;
*)	echo Invalid option.; ;;
esac
