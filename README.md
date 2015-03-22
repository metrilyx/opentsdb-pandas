opentsdb-pandas
============
Library to convert OpenTSDB data to pandas datastructures for analysis.  


### Usage
    
    from opentsdb_pandas import OpenTSDBResponse

    tsdb_url = "http://my.opentsdb/api/query"
    
    resp = requests.get(tsdb_url+"?m=sum:nginx.stubstatus.request{host=*}&start=3m-ago")
    
    oResp = OpenTSDBResponse(resp.text)

    # Get a DataFrame    
    df = oResp.DataFrame()

    # Get a DataFrame with custom series names
    df = oResp.DataFrame("!lambda x: x['tags.host'].split('.')[0]")