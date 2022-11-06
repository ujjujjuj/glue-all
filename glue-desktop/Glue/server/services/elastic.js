const { Client } = require('@elastic/elasticsearch')

class ElasticClient {
    contructor() {
        this.client = new Client({
            cloud: {
                id: process.env.ELASTIC_DEPLOYMENT
            },
            auth: {
                username: process.env.ELASTIC_USERNAME,
                password: process.env.ELASTIC_PASSWORD
            }
        });
    }

    async newEntry(network, data) {
        try {
            const date = new Date()
            await this.client.index({
                index: "data",
                body: {
                    network: network,
                    message: data,
                    time: date.toLocaleString()
                }
            });
        }
        catch (err) {
            console.log(err);
        }
    }
}

module.exports.Init = () => {
    const client = new Client({
        cloud: {
            id: process.env.ELASTIC_DEPLOYMENT
        },
        auth: {
            username: process.env.ELASTIC_USERNAME,
            password: process.env.ELASTIC_PASSWORD
        }
    })
    return client
}
