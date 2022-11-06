const crypto = require('crypto');

module.exports.newData = async (req, res) => {
    const { data } = req.body;
    const client = req.elasticClient;

    try {
        await Promise.any(data.map(el =>  
            client.create({
            index: "data",
            id: el.id,
            body: {
                "network": el.network,
                "message": el.data,
                "id": el.id,
                "device": el.device
            }
        })))
    } catch(err) {
        console.log(err);
    }

    res.status(200).json({err: null});
}

module.exports.deleteNodes = async (req, res) => {
    const { data, node } = req.body;
    const client = req.elasticClient;
    try {
        await Promise.any(data.map(el =>  
            client.create({
            index: "data",
            id: el.id,
            body: {
                "network": el.network,
                "message": el.data,
                "id": el.id,
                "device": el.device
            }
        })))
    } catch(err) {
        console.log(err);
    }
    client.delete({
        index: "nodes",
        query: {
            match: {
                node: node
            }
        }
    })
    .then(response => {
        console.log(response);
        res.status(200).json({err: null});
    })
    .catch(err => {
        console.log(err);
    })
}

module.exports.getHistory = (req, res) => {
    const { network } = req.params;
    const client = req.elasticClient;
    client.search({
        index: "data",
        query: {
            match: {
                network: {
                    query: network
                }
            }
        }
    })
    .then((response) => {
        console.log(response.hits);
        res.status(200).json(response.hits.hits)
    })
    .catch(err => {
        console.log(err);
        res.status(404).json({err})
    })
}

module.exports.filterHistory = (req, res) => {
    const { network, keyword } = req.body;
    const client = req.elasticClient;
    client.search({
        index: "data",
        query: {
            bool: {
                must: [
                    {
                        match: {
                            network: network
                        }
                    },
                    {
                        term: {
                            message: keyword
                        }
                    }
                ]
            }
        }
    })
    .then(response => {
        console.log(response);
        res.status(200).json(response.hits.hits)
    })
    .catch(err => {
        console.log(err);
        res.status(400).json({err});
    })
}

module.exports.getNetwork = (req, res) => {
    const { node } = req.params;    
    const client = req.elasticClient;
    client.search({
        index: "nodes",
        query: {
            match: {
                node: node
            }
        }
    })
    .then((response) => {
        console.log(response);
        res.status(200).json(response.hits.hits);
    })
    .catch(err => {
        console.log(err);
        res.status(400).json({err});
    })
}

module.exports.getNetworkNodes = async (req, res) => {
    const { node } = req.body;
    const client = req.elasticClient;
    try {
        const rs = await client.search({
            index: "nodes",
            query: {
                match: {
                    node: node
                }
            }
        })
        const dat = rs.hits.hits;
        if(dat.length <= 0) {
            res.status(400).json({err: "no network"});
        }
        const network = dat[0]._source.network;
        const resp = await client.search({
            index: "nodes",
            query: {
                match: {
                    network: network
                }
            }
        })
        res.status(200).json(resp.hits.hits)
        
    } catch(err) {
        console.log(err);
    }
}

module.exports.getNodes = (req, res) => {
    const { network } = req.body;    
    const client = req.elasticClient;
    client.search({
        index: "nodes",
        query: {
            match: {
                network: network
            }
        }
    })
    .then((response) => {
        console.log(response);
        res.status(200).json(response.hits.hits);
    })
    .catch(err => {
        console.log(err);
        res.status(400).json({err});
    })
}

module.exports.updateNetwork = (req, res) => {
    const { node, network } = req.body;
    const client = req.elasticClient;
    client.index({
        index: "nodes",
        body: {
            network: network,
            node: node
        }
    })
    .then(response => {
        console.log(response);
        res.status(200).json({err: null});
    })
    .catch(err => {
        console.log(err);
        res.status(400).json({err});
    })
}

module.exports.initNetwork = (req, res) => {
    const { node, oAuthId } = req.params;
    const client = req.elasticClient;
    const uuid = crypto.randomUUID();
    client.index({
        index: "nodes",
        body: {
            network: uuid,
            node: node,
            oAuthId: oAuthId
        }
    })
    .then(response => {
        console.log(response);
        res.status(200).json({
            network: uuid,
            node: node
        })
    })
    .catch(err => {
        console.log(err);
        res.status(400).json({err});
    })
}