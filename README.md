opentsdb-pandas
============
Library to convert OpenTSDB data to pandas datastructures for analysis.  It also allows to name series based on metadata returned in the response.



### Support

Testing has primarily been done with the following configuration:

* RHEL/6.5, Python 2.6.6
* Ubuntu/trusty64 Python 2.7.6 ???


### Requirements

* Atleast 1GB of memory
* Preferrably more than 1 CPU/Core


    atlas-devel 
    blas-devel
    c++ compiler
    gcc
    gcc-gfortran
    libffi-devel 
    make
    
### Installation

    pip install https://github.com/metrilyx/opentsdb-pandas.git

### Usage
    
    import requests
    
    from opentsdb_pandas.response import OpenTSDBResponse

    
    tsdb_url = "http://my.opentsdb/api/query"
    resp = requests.get(tsdb_url+"?m=sum:nginx.stubstatus.request{host=*}&start=3m-ago")
    
    #
    # This can be a string, list or tuple
    #
    oResp = OpenTSDBResponse(resp.text)

    #
    # Get a DataFrame with epoch converted to pandas datetime.   
    #
    df = oResp.DataFrame(convertTime=True)

    #
    # Get a DataFrame with custom column names. In this case set it to 
    # the short hostname.
    #
    df = oResp.DataFrame("!lambda x: x['tags.host'].split('.')[0]")

    print df