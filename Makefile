base:
	docker build -t parsec:base .

numactl:
	docker build -t parsec:numactl -f Dockerfile.numactl .

all:
	$(MAKE) base
	$(MAKE) numactl




