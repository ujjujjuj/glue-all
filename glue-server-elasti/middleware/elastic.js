module.exports.attachClient = (client) => {
    return function(req, res, next) {
        req.elasticClient = client;
        next(); 
    }
}