# Jupyter

This is a sample Notebook to test pgFaas in a Jupyter envrionment with Python.


## Requirements

* Jupyter instance
* Python 3 kernel 
* Folium (`pip install folium`)


## Installation

* Open a Jupyter instance
* Create a new notebook
* Copy and execute the following fragment in a cell:
```python
# 
# Computes the sum of two numbers using a pgFass function
#
import requests, json
par= [73, 57]
r = requests.post("http://sandbox.pgfaas.aurin.org.au//api/function/namespaces/sample/math", 
         data=json.dumps({"verb":"add","a":par[0],"b":par[1]}), 
         headers={"Content-Type":"application/json"})
out= json.loads(r.text)
print("The sum of {} and {} is {}".format(par[0], par[1], out["c"]))
```
* Copy and execute the following fragment in a cell:
```python
#
# Displays on a map the 5 closest bus stops on a location in New Caledonia
# Requirements: folium (pip install folium)
#
import folium
loc= [-22.25, 166.65]
m = folium.Map(
    location=loc,
    tiles='stamenterrain',
    zoom_start=13)

folium.Circle(
    location=loc,
    radius=200,
    color='red',
    fill_color='red'
).add_to(m)

r = requests.post("http://sandbox.pgfaas.aurin.org.au//api/function/namespaces/sample/osm", 
         data=json.dumps({"verb":"knnbusstops","k":8,"x":loc[1],"y":loc[0]}), 
         headers={"Content-Type":"application/json"})
folium.GeoJson(    
    r.text,
    name='geojson'
).add_to(m)
m
```

* Copy and execute the following fragment in a cell:
```python
# 
# Computes the shortest path between two nodes
# Requirements: folium (pip install folium)
#
import requests, json, random

c= ['green','red','yellow', 'blue', 'cyan']

m = folium.Map(
    location=loc,
    tiles='stamenterrain',
    zoom_start=9)
jj= json.loads('{"type":"FeatureCollection", "features":[]}')

for i in range(1, 6):
   r = requests.post("http://sandbox.pgfaas.aurin.org.au//api/function/namespaces/sample/osm", 
         data=json.dumps({"verb":"shortestpath","start":random.randint(1,2000),"end":random.randint(1,2000)}), 
         headers={"Content-Type":"application/json"})
   j= json.loads(r.text)
   for f in j['features']:
       f['color']= c[i % len(c)]
       jj['features'].append(f)
   print("{} route is {} edges long".format(i, len(j['features'])))
 
folium.GeoJson(    
   json.dumps(jj), 
   name='geojson',
   style_function= lambda f :{'color':f['color']}
).add_to(m)
m
```
