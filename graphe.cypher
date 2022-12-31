CALL gds.graph.project(
  'Graph_1',
  ['Block', 'Transaction'],
  'inc'
)

CALL gds.pageRank.stream('Graph_1')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).hash AS hash, score
ORDER BY score DESC, hash ASC

CALL gds.pageRank.stats('Graph_1', {
  maxIterations: 20,
  dampingFactor: 0.85
})
YIELD centralityDistribution
RETURN centralityDistribution AS stats

CALL gds.graph.project(
    'Graph_2',
    ['Block', 'Transaction', 'Output', 'Address'],
    ['inc', 'out', 'locked']
)

CALL gds.graph.project(
    'Graph_2',
    ['Block', 'Transaction', 'Output', 'Address'],
    ['inc', 'out', 'locked']
)

CALL gds.labelPropagation.stream('Graph_2')
YIELD nodeId, communityId AS Community
RETURN gds.util.asNode(nodeId).hash AS Hash, Community
ORDER BY Community, Hash

// Community : 538
MATCH (n:Block{hash:'00000000000000000003a44c124ea9471869d13617c917be07eaf2e7a5a6a6f6'}) 
RETURN n 

// Community : 2
MATCH (n:Block{hash:'00000000000000000006401d01a38d79c33130bd35471e251ada15cda0031e4e'}) 
RETURN n 

