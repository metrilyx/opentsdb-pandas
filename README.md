opentsdb-pandas
============
Library to convert OpenTSDB data to pandas datastructures for analysis.  It also allows to name series based on metadata returned in the response.


### Usage
    
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
    # Get a DataFrame with custom series names. In this case set it to 
    # the short hostname.
    #
    df = oResp.DataFrame("!lambda x: x['tags.host'].split('.')[0]")

    print df