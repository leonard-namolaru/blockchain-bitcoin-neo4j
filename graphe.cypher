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


