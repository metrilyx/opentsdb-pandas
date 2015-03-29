
clean:
	rm -rf build dist otsdb_pandas.egg-info
	find . -name "*.pyc" -exec rm -rf '{}' \;

install:
	python setup.py install
