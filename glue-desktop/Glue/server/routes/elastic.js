const router = require('express').Router()

const { getHistory, getNetwork, updateNetwork, initNetwork, filterHistory, getNodes, newData, syncData, getNetworkNodes } = require('../controllers/elastic')


router.post('/new', newData) 
router.get('/history/:network', getHistory); 
router.post('/history/filter', filterHistory)  
router.get('/network/:node', getNetwork);
router.post('/network/network_nodes', getNetworkNodes) 
router.post('/network/nodes', getNodes); 
router.post('/network/update', updateNetwork); 
router.post('/network/init/', initNetwork); 

module.exports = router;