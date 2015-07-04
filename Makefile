
BUILD_DIR_BASE = ./build

clean:
	rm -rf ${BUILD_DIR_BASE} dist otsdb_pandas.egg-info
	find . -name "*.pyc" -exec rm -rf '{}' \;

install:
	python setup.py install

.rpm:
	[ -d ${BUILD_DIR_BASE}/el ] || mkdir -p ${BUILD_DIR_BASE}/el
	cd ${BUILD_DIR_BASE}/el && fpm -s python -t rpm ../../setup.py

.deb:
	[ -d ${BUILD_DIR_BASE}/ubuntu ] || mkdir -p ${BUILD_DIR_BASE}/ubuntu
	cd ${BUILD_DIR_BASE}/ubuntu && fpm -s python -t deb ../../setup.py
