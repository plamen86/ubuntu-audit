bash lunar.sh -A > out.txt 2> out_err.txt
diff out.txt ../out.txt > ../diff.txt
pluma ../diff.txt
