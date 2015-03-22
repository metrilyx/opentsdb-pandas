
import pandas
import ujson as json

class OpenTSDBSerie(object):
    """
        A single OpenTSDB response serie i.e 1 element of the response
        array.

        Params:
            **kwargs : OpenTSDB response serie data
    """
    def __init__(self, **kwargs):
        for k,v in kwargs.items():
            setattr(self, k, v)
    
    @property
    def id(self):
        """
            id for serie 

            Returns:
                metric{sorted=tag,key=value}
        """
        if len(self.tags.keys()) > 0:
            tags = ",".join(["%s=%s" % 
                (k, self.tags[k]) for k in sorted(self.tags.keys())])
            return "%s{%s}" % (self.metric, tags)
        else:
            return self.metric


    def alias(self, functOrStr):
        """
            User specified alias using lambda functions and string formatting.
            This function fails silently

            Params:
                functOrStr :    lambda function or python string format. When using lambda
                                functions,  they must begin with '!' e.g. !lambda x: x....
            Return:
                Formatted alias on success and id or failure.
        """
        flatData = self.__flattenedMetadata()
        # Normalized alias
        _alias = ""
        if functOrStr.startswith("!"):
            try:
                _alias = eval(functOrStr[1:])(flatData)
            except Exception, e:
                pass
        else:
            try:
                _alias = functOrStr % (flatData)
            except Exception, e:
                pass
        
        if _alias == "":
            return self.id

        return _alias


    def __flattenedMetadata(self):
        """ Flattens all metadata which is used for normalization """
        return dict([("metric", self.metric)] +
            [("tags.%s" % (k), v) for k, v in self.tags.items()])


class OpenTSDBResponse(object):
    """ Complete OpenTSDB response """

    def __init__(self, respString):        
        self._series = [ OpenTSDBSerie(**s) for s in json.loads(respString) ]

    @property
    def series(self):
        """ Use iterator for better memory management """
        for s in self._series:
            yield s

    def DataFrame(self, aliasTransform=None):
        """
            Converts an OpenTSDB array response into a DataFrame

            Params:
                aliasTransform: lambda function or string format to customize
                                serie name i.e. alias

            Return:
                OpenTSDB response DataFrame
        """
        if aliasTransform == None:
            return pandas.DataFrame(dict([
                (s.id, s.dps) for s in self.series ]))
        else:
            return pandas.DataFrame(dict([
                (s.alias(aliasTransform), s.dps) for s in self.series ]))

