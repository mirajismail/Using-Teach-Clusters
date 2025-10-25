all: make-exec lissajous_args

make-exec:
	chmod +x $(wildcard *.sh) $(wildcard lissajous_with_args/*.sh)

lissajous_args: lissajous_with_args/lissajous_args.cpp
	g++ -o lissajous_with_args/lissajous_args lissajous_with_args/lissajous_args.cpp -lm

