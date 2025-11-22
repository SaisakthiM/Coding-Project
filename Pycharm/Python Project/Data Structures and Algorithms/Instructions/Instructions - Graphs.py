"""Graphs : they are similar to trees but there is no definite order of arrangement
To explain well , you can take any 2 nodes and connect in different ways in multiple paths
unlike trees where there are levels you can't backtrack and join

there are 2 important parts in graphs :
the nodes which has the value
the edge or the connector between 2 nodes

there are 3 types of graphs:
Undirected graphs : these are the graphs which has no direction and connect any 2 nodes the user needs.
Directed Graphs : graphs which use vectors with certain direction are directed graphs.
we can record which direction it is going rather than counting the least number of nodes
Weighted graphs : these are the graphs where edges has weight or simply
vector with magnitude and the shortest distance is based on magnitude

"""


class Graphs:
    def __init__(self,edges):
        self.edges = edges
        self.graph_dict = {}
        for start,end in self.edges:
            if start in self.graph_dict:
                self.graph_dict[start].append(end)
            else:
                self.graph_dict[start] = [end]
        print("Graph Dict : ",self.graph_dict)
    """
    What basically happening in this recursive function is we give start and end places.
    first we append start position. and if start == end , we return the start. if start not in graph,
    it returns empty list.
    
    if start and end in list , we start looping through start in graph_dict. so if node not in path ,
    here is the important part, we recursively again go for the function but this time, the next location.
    
    Take example mumbai to toronto, if we start with toronto , 
    we have paris there so the new path is paris to toront.
    now we append the paris to paths which we return
    next if we follow, dubai to toronto ,
    next new york to toronto
    next toronto to toronto.
    we what are we getting , the start == end, so it returns path 
    (remember , the recursion runs until the function returns something in other separate place) , 
    this time it returns end so we append it
    we get the path from start to end
    """
    def get_path(self, start, end, path=[]):
        path = path + [start]
        if start == end:
            return [path]
        if start not in self.graph_dict:
            return []
        paths = []
        for node in self.graph_dict[start]:
                if node not in path:
                    new_path = self.get_path(node,end,path)
                    for p in new_path:
                        paths.append(p)

        return paths

    def shortest_path(self,start,end,path=[]):
        path = path + [start]
        if start not in self.graph_dict:
            return None
        if start == end:
            return
        paths = []
        for node in self.graph_dict[start]:
            if node not in path:
                new_path = self.get_path(node,end,path)
                if new_path:
                    if new_path is None or len(new_path) < len(paths):
                        paths = new_path
        return paths



if __name__ == "__main__":
    routes = [
        ("Mumbai", "Paris"),
        ("Mumbai", "Dubai"),
        ("Paris", "Dubai"),
        ("Paris", "New York"),
        ("Dubai", "New York"),
        ("New York", "Toronto"),
    ]

    route_graph = Graphs(routes)

    print(route_graph.shortest_path("Mumbai","New York"))




















