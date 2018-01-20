# what it does is connect to a pg and gather the html it gives us the links
from html.parser import HTMLParser
from urllib import parse

class LinkFinder(HTMLParser):
#https://stackoverflow.com/questions/2709821/what-is-the-purpose-of-self
#https://stackoverflow.com/questions/625083/python-init-and-self-what-do-they-do
#https://stackoverflow.com/questions/23302018/usefulness-of-def-init-self
    def __init__(self,base_url,page_url):
        super().__init__()
        self.base_url=base_url
        self.page_url=page_url
        self.links=set()

# When we call HTMLParser feed() this function is called when it encounters an opening tag <a>
    def handle_starttag(self, tag, attrs):
        ## print(tag)#prints tag from html inspect pages
        if tag == 'a':
            for(attribute,value) in attrs:
                if attribute=='href':#need the full url
                    url=parse.urljoin(self.base_url,value)
                    self.links.add(url)

    def page_links(self):
        return self.links

    def error(self, message):
        pass

#finder = LinkFinder()
##finder.feed('<html><head>...')#