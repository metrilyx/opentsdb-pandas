
BUILD_DIR_BASE = ./build

DEB_PANDAS_DEPS = -d 'python-dateutil' -d 'python-numpy >= 1.7' -d 'python-tz >= 2011k'

PYTHON_LIB_DIR = /opt/metrilyx/lib/python2.7/site-packages

.clean:
	rm -rf ${BUILD_DIR_BASE} dist opentsdb_pandas.egg-info numpy-*.egg
	find . -name "*.pyc" -exec rm -rf '{}' \;

.install:
	python setup.py install

.pandas_rpm:
	[ -d ${BUILD_DIR_BASE}/el ] || mkdir -p ${BUILD_DIR_BASE}/el
	cd ${BUILD_DIR_BASE}/el && fpm -s python -t rpm --no-python-fix-dependencies --python-install-lib ${PYTHON_LIB_DIR} pandas
	
.pandas_deb:
	[ -d ${BUILD_DIR_BASE}/ubuntu ] || mkdir -p ${BUILD_DIR_BASE}/ubuntu
	cd ${BUILD_DIR_BASE}/ubuntu && fpm -s python -t deb --no-python-dependencies ${DEB_PANDAS_DEPS} --python-install-lib ${PYTHON_LIB_DIR} pandas

.ujson_rpm:
	[ -d ${BUILD_DIR_BASE}/el ] || mkdir -p ${BUILD_DIR_BASE}/el
	cd ${BUILD_DIR_BASE}/el && fpm -s python -t rpm --python-install-lib ${PYTHON_LIB_DIR} ujson

.ujson_deb:
	[ -d ${BUILD_DIR_BASE}/ubuntu ] || mkdir -p ${BUILD_DIR_BASE}/ubuntu
	cd ${BUILD_DIR_BASE}/ubuntu && fpm -s python -t deb --python-install-lib ${PYTHON_LIB_DIR} ujson

.rpm: .pandas_rpm .ujson_rpm
	cd ${BUILD_DIR_BASE}/el && fpm -s python -t rpm --python-install-lib ${PYTHON_LIB_DIR} ../../setup.py

.deb: .pandas_deb .ujson_deb
	cd ${BUILD_DIR_BASE}/ubuntu && fpm -s python -t deb --python-install-lib ${PYTHON_LIB_DIR} ../../setup.py

all: .clean .install
